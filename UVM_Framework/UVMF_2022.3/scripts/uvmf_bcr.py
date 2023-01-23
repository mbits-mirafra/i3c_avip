#! /usr/bin/env python

import sys
import os
import time
import re
import fnmatch

sys.path.insert(0,os.path.dirname(os.path.dirname(os.path.realpath(__file__)))+"/templates/python")
sys.path.insert(0,os.path.dirname(os.path.dirname(os.path.realpath(__file__)))+"/scripts/bcr_mods")
if sys.version_info[0] < 3:
  sys.path.insert(0,os.path.dirname(os.path.dirname(os.path.realpath(__file__)))+"/templates/python/python2")

try:
  import yaml
  from voluptuous import Required,Optional,Any,In,Schema,MultipleInvalid
  from voluptuous.humanize import humanize_error
  import argparse
  import traceback
  import pprint
  import textwrap
  import logging
  from bcr_mods import *
  import subprocess
  import collections
except ImportError as ie:
  print("ERROR:Missing library: %s" % str(ie))
  print("path: "+str(sys.path))
  sys.exit(1)

class OptionOverrideAction(argparse.Action):
  def __init__(self,**kwargs):
    super(OptionOverrideAction,self).__init__(**kwargs)

def print_flows(logger,flow):
  l = []
  for k,v in sorted(flow.data['flows'].items(),key=lambda e:e[1]['order']):  ## e is a (k,v) tuple so v is e[1]
    if (v['order'] > 0):   # This will prevent the display of virtual flows that cannot be chosen
      l.append(textwrap.fill("\033[1m{:>12}\033[0m - {}".format(k,v['description']),width=100))
  logger.info("Available flows:\n  {}".format('\n  '.join(map(str,l))))

def print_steps(args,flow,logger):
  l = []
  vlist = []
  def_step_num = 1
  # If there are defaults, list default steps first (with indication of that)
  if 'default_steps' in flow.data['flows'][args.flow]:
    slist = flow.data['flows'][args.flow]['default_steps']
    dformat = ' [Default step #{}]'
  else:
    slist = flow.data['flows'][args.flow]['steps']
    dformat = ''
  for s in slist:
    dstring = dformat.format(str(def_step_num))
    l.append(textwrap.fill("\033[1m{:>12}\033[0m - {} {}".format(s,flow.data['flows'][args.flow]['steps'][s]['description'],dstring),width=100))
    vlist.append(s)
    def_step_num = def_step_num + 1
  # If there were default steps there may be additional steps (like 'clean') that were not in that list.
  # Add those to the end of the output now in a consistent (sorted) way
  for k,v in sorted(flow.data['flows'][args.flow]['steps'].items()):
    if k not in vlist:
      l.append("\033[1m{:>12}\033[0m - {}".format(k,v['description']))
  logger.info("Available steps for flow \"{}\":\n  {}".format(args.flow,'\n  '.join(map(str,l))))

def print_variables(args,flow,logger,filter=[]):
  l = []
  ## Test filter input for validity (only accept glob format)
  try:
    globstr = filter[0]
    globstr = '*'+globstr+'*'
  except IndexError:
    globstr = None
    pass
  ## Information requested - describe all the variables (flow and step-level variables)
  if 'variable_descriptions' in flow.data['flows'][args.flow]:
    for variable_name, variable_description in flow.data['flows'][args.flow]['variable_descriptions'].items():
      if variable_description: 
        if (not globstr) or (fnmatch.fnmatch(variable_name,globstr) or fnmatch.fnmatch(variable_description,globstr)):
          l.append(textwrap.fill("\033[1m{:>16}\033[0m: {} (Defaults to \"{}\")".format(variable_name,variable_description,flow.data['flows'][args.flow]['variables'][variable_name]),width=100,subsequent_indent='                    '))
    logger.info("Variables for flow '{}':\n  {}".format(args.flow,'\n  '.join(map(str,l))))
  l = []
  for step_name,step_value in flow.data['flows'][args.flow]['steps'].items():
    if 'variable_descriptions' not in step_value:
      continue
    for variable_name,variable_description in sorted(step_value['variable_descriptions'].items()):
      if variable_description: 
        l.append(textwrap.fill("\033[1m{}\033[0m: {} (Defaults to \"{}\")".format(variable_name,variable_description,step_value['variables'][variable_name]),width=85,subsequent_indent='    '))
    logger.info("Variables for step '{}' of flow '{}':\n  {}".format(step_name,args.flow,'\n  '.join(map(str,l))))

def run():
  logger = logging.getLogger("logger")
  # Clean up command-line arguments (remove entries that are all white space or empty, strip whitespace off non-empty arguments)
  # This can happen if BCR is invoked from within another script that can pass in empty arguments
  new_argv = []
  for a in sys.argv:
    a = a.strip()
    if a != '':
      new_argv.append(a)
  sys.argv = new_argv
  parser = argparse.ArgumentParser(epilog="additional position arguments:\n  Specify variable overrides using <NAME>:<VALUE> syntax on command line.",description="Build and run a UVMF simulation",parents=[parent_parser],formatter_class=argparse.RawDescriptionHelpFormatter)
  parser.add_argument("flow",metavar="FLOW",help="Required. Specify desired flow. Use --list_flows to see available flows",default="UNSPECIFIED",nargs="?")
  parser.add_argument("--flow_file","--flow-file",help="Specify flow configuration file. Default is 'mentor.flows' located in same directory as this script", default=None)
  parser.add_argument("--flow_file_overlay",help="Specify flow configuration overlays as a colon-separated list", default=None)
  parser.add_argument("--steps","-s",help="Specify steps to run in given flow. Default is to run all steps. Will run steps in provided order", default=None,type=str)
  parser.add_argument("--dry_run","-n","--dry-run",help="Produce and print commands, do not run anything",action='store_true',default=False)
  parser.add_argument("--list_flows","--list-flows",help="List out all available flows",action='store_true',default=False)
  parser.add_argument("--list_steps","--list-steps",help="List out all available steps",action='store_true',default=False)
  parser.add_argument("--list_variables","--list-variables",help="List out all available variables for the given flow. May specify an optional filter string (glob style) to reduce output",action='store_true',default=False)
  parser.add_argument("--filelists_only","-l","--filelists-only",help="Only produce file lists ahead of a build step",action='store_true',default=False)
  parser.add_argument("--clean","-c",help="Runs the clean step",action='store_true',default=False)
  parser.add_argument("--skip_filelist_build","--skip-filelist-build",help="Disables automatic creation of filelists for build step",action='store_true',default=False)
  parser.add_argument("--sim_dir","--sim-dir",help="Specify location of \"sim\" directory",default=None)
  parser.add_argument("--verbose_filelist","--verbose-filelist",help="Print more detail in generated file lists",action='store_true',default=False)
  args,option_overrides = parser.parse_known_args()
  # Check the option overrides array for any unknown arguments. Anything starting with a dash (-) is an unknown switch, not 
  # an override
  for o in option_overrides:
    if re.match(r'^-',o):
      logger.error("Unknown command line argument \"{}\"".format(o))
      parser.print_help()
      sys.exit(1)
  if args.pdb:
    import pdb
    pdb.set_trace()
  if not args.dry_run:
    logger.info("uvmf_bcr version %s" % version)
  logger.debug("Python version info:\n"+sys.version)
  ## Determine values for arguments if they have not been overridden
  ## Command-line takes precedence over environment variable
  if not args.flow_file:
    if 'UVMF_BCR_FLOW_FILE' in os.environ:
      if os.path.exists(os.environ['UVMF_BCR_FLOW_FILE']):
        args.flow_file = os.environ['UVMF_BCR_FLOW_FILE']
      else:
        logger.error("Env var UVMF_BCR_FLOW_FILE pointing to invalid location '{}'".format(os.environ['UVMF_BCR_FLOW_FILE']))
        sys.exit(1)
    else:
      args.flow_file = os.path.dirname(__file__) + os.path.sep + 'mentor.flows'
  ## Produce flow data
  flow = Flow(args.flow_file)
  ## Create an options area if it doesn't already exist
  if 'options' not in flow.data:
    flow.data['options'] = {}
  ## Determine sim_dir (default is "." but can be overridden with flow data['options']['sim_dir'] and with command-line variable)
  if args.sim_dir:
    flow.data['options']['sim_dir'] = args.sim_dir
  elif 'sim_dir' not in flow.data['options']:
    flow.data['options']['sim_dir'] = '.'
  ## Pull in any extra flow-file overlays (command-line or ENV var)
  ## Command-line takes precedence over environment variable
  ## Environment variable takes precdcence over local 'bcr_overlay.flow' file
  if not args.flow_file_overlay:
    if ('UVMF_BCR_FLOW_FILE_OVERLAY' in os.environ):
      args.flow_file_overlay = os.environ['UVMF_BCR_FLOW_FILE_OVERLAY']
    elif os.path.isfile(flow.data['options']['sim_dir']+os.path.sep+'bcr_overlay.flow'):
      args.flow_file_overlay = flow.data['options']['sim_dir']+os.path.sep+'bcr_overlay.flow'
  ## Apply overlay overrides
  flow.apply_overlay(args.flow_file_overlay,args.flow,args.steps)
  ## Resolve inheritance
  flow.resolve_inheritance()
  ## List flows if requested
  if args.list_flows:
    print_flows(logger,flow)
    sys.exit(0)
  ## Check that flow was provided
  if (args.flow == 'UNSPECIFIED'):
    logger.error("No flow given on command line. Must be provided as first positional argument. Available flows:")
    print_flows(logger,flow)
    sys.exit(1)
  ## Confirm that the desired flow is valid
  if args.flow not in flow.data['flows']:
    logger.error("Flow \"{}\" is not a defined flow".format(args.flow))
    print_flows(logger,flow)
    sys.exit(1)
  if not flow.data['flows'][args.flow]['order']:
    logger.error("Flow \"{}\" is tagged as virtual and cannot be directly used".format(args.flow))
    print_flows(logger,flow)
    sys.exit(1)
    ## List available steps for the given flow
  if args.list_steps:
    if 'default_steps' not in flow.data['flows'][args.flow]:
      logger.info("NOTE: Flow \"{}\" does not have default steps. Use of --steps is required".format(args.flow))
    print_steps(args,flow,logger)
    sys.exit(0)
  ## Confirm that the desired flow has default stek,v in sorted(flow.data['flows'].items()ps defined
  if ('default_steps' not in flow.data['flows'][args.flow]) and (not args.steps):
    logger.error("Flow \"{}\" does not have a set of default steps. Use of --steps is required".format(args.flow))
    print_steps(args,flow,logger)
    sys.exit(1)
  ## Determine desired steps
  if args.clean:
    ## If --clean was specified then we're asking to run the 'clean' step. 
    args.steps = ['clean']
    ## Check to make sure 'clean' is a valid step. If not, bomb out
    if 'clean' not in flow.data['flows'][args.flow]['steps']:
      logger.error("The '{}' flow does not define a 'clean' step, --clean will not work".format(args.flow))
      sys.exit(1)
  elif not args.steps:
    ## No steps were specified, use the default steps of the flow
    args.steps = flow.data['flows'][args.flow]['default_steps']
  else:
    ## Steps were specified, put them in the list
    args.steps = args.steps.split(" ")
  ## Display variables if requested
  if args.list_variables:
    print_variables(args,flow,logger,option_overrides)
    sys.exit(0)
  ## Apply command-line variable overrides
  flow.apply_overrides(args.flow,option_overrides,args.steps)
  ## Determine sim_dir (default is "." but can be overridden with flow data['options']['sim_dir'] and with command-line variable)
  if args.sim_dir:
    flow.data['options']['sim_dir'] = args.sim_dir
  elif ('options' not in flow.data) or ('sim_dir' not in flow.data['options']):
    flow.data['options']['sim_dir'] = '.'
  ## Resolve sim_dir to a full path
  flow.data['options']['sim_dir'] = resolve_path(flow.data['options']['sim_dir'],'.')
  ## Set up the exported BCR_SIM_DIR environment variable based on sim_dir value (unless already set)
  if 'BCR_SIM_DIR' not in os.environ:
    os.environ['BCR_SIM_DIR'] = flow.data['options']['sim_dir']
  else:
    logger.warning("Unable to set BCR_SIM_DIR environment variable, was already set")
  ## Elaborate all variables
  flow.elaborate_variables(args.flow,flow.data['options'],listing=(args.list_flows or args.list_variables or args.list_steps))
  for step in args.steps:
    ## Check to see if all of the requested steps exists. Error if any don't
    if step not in flow.data['flows'][args.flow]['steps']:
      logger.error("Flow \"{}\" does not define a step named \"{}\"".format(args.flow,step))
      print_steps()
      sys.exit(1)
  ## Determine if we're using file associations or not
  if 'use_fileassoc' in flow.data['flows'][args.flow]: 
    use_fileassoc = flow.data['flows'][args.flow]['use_fileassoc']
    if use_fileassoc:
      fileassoc = flow.data['flows'][args.flow]['fileassoc']
      incassoc = flow.data['flows'][args.flow]['incassoc']
    else:
      fileassoc = {}
      incassoc = {}
  else:
    use_fileassoc = False
    fileassoc = {}
    incassoc = {}
  ## Set up any requested environment variables as per the flow file & overlays
  if 'options' in flow.data and 'env_vars' in flow.data['options']:
    for k,v in flow.data['options']['env_vars'].items():
      override = False
      if isinstance(v,str):
        envvar = v
      elif isinstance(v,collections.Mapping):
        if 'value' not in v or type(v['value']) != str:
          logger.error("Dictionary format for environment variable \"{}\" in flow file is invalid".format(k))
          sys.exit(1)
        envvar = v['value']
        if 'resolve_path' in v and v['resolve_path']:
          envvar = resolve_path(envvar,flow.data['options']['sim_dir'])
        if 'override' in v and v['override']:
          override = True
      if (k not in os.environ) or override:
        # Only set environment variables that are not already set unless override==True
        logger.info("Setting environment variable \"{}\" to \"{}\"".format(k,envvar))
        os.environ[k] = envvar
      else:
        logger.info("Not setting flow file environment variable \"{}\" to \"{}\", already set to \"{}\"".format(k,envvar,os.environ[k]))
  ## Determine if any file lists need to be created. Triggered by searching for a variable 'compile_files' defined for a given step
  all_filelists = []
  filelist_data = None
  for step in args.steps:
    step_s = flow.data['flows'][args.flow]['steps'][step]
    if 'variables' in step_s and 'compile_files' in step_s['variables']:
      filelist_data = FilelistBuilder(step_s['variables'])
      #filelist_names = []
      if 'libassoc' in flow.data['options']:
        filelist_data.libassoc = flow.data['options']['libassoc']
      if 'filelist_build_defines' in flow.data['options']:
        filelist_data.build_defines = flow.data['options']['filelist_build_defines']
      ## Value of 'compile_files' variable must be a space-delimted list of .compile files. Prepend the flow.data['options']['sim_dir'] value to the front of each file
      ## Error out if compile_files isn't defined
      if not step_s['variables']['compile_files']:
        logger.error("Flow \"{}\" step \"{}\" has an undefined 'compile_files' variable".format(args.flow,step))
        sys.exit(1)
      firstiter = True
      for file in step_s['variables']['compile_files'].split(' '):
        file = flow.data['options']['sim_dir'] + os.path.sep + file
        filelist_data.clear()
        ## Each file passed in will produce one or more .qf output file (replace .compile with .qf and add file association data) and reuslts will be placed in $CWD
        qf_file_prefix = os.path.join(os.path.abspath(os.getcwd()),os.path.splitext(os.path.split(file)[1])[0])
        ## Pull out all data from a given top-level file list
        filelist_data.read_file(file)
        ## This will produce all of the .qf files stemming from the file read in previous step. If file association and/or library associations
        ## are in effect the result will be more than just one .qf file. Each create() call could produce a .qf file for each file association
        ## along with .qf files for each associated library. Naming scheme is <compile_file_name>_<libassoc>_<fileassoc_ext>.qf where <libassoc>
        ## and <fileassoc> could be left out if none are specified or needed for a given compile file.  The file associations are requested
        ## as input to create(), but library associations are pulled from the 'libassoc' data structure set up prior to reading compile files
        ## and this will prompt the file list data structure to be more complex (lib_data will be populated) and the 'results' return value
        ## here will also be more complex (a dict of lists of strings instead of a simple list of strings)
        results = filelist_data.create(qf_file_prefix=qf_file_prefix,use_fileassoc=use_fileassoc,fileassoc=fileassoc,incassoc=incassoc,nobuild=args.skip_filelist_build,printfullnodes=args.verbose_filelist)
        if isinstance(results,list):
          if firstiter:
            firstiter = False
            filelist_names = []
          filelist_names = filelist_names + results
          for r in results: 
            if r[1] not in all_filelists:
              all_filelists.append(r[1])
        else:
          if firstiter:
            firstiter = False
            filelist_names = {}
          for k,v in results.items():
            if k not in filelist_names:
              filelist_names[k] = []
            filelist_names[k] = filelist_names[k] + v
            for r in v:
              if r[1] not in all_filelists:
                all_filelists.append(r[1])
      ## Dump the list of filenames for this step into the data structure
      step_s['variables']['filelists'] = filelist_names
      ## Set up library order information if needed
      if isinstance(filelist_names,dict):
        liborder = []
        for l in flow.data['options']['libassoc']:
          k = l.keys()[0]
          if k in filelist_names:
            liborder.append(k)
        step_s['variables']['liborder'] = liborder
  ## Stop here if we were asked to only build file lists
  if args.filelists_only:
    logger.info("Created file lists for requested steps:\n  {}".format('\n  '.join(map(str,all_filelists))))
    sys.exit(0)
  ## Check for any extra paths to search for imports before we start building up commands
  if 'command_package_paths' in flow.data['options']:
    for p in flow.data['options']['command_package_paths']:
      sys.path.insert(0,os.path.realpath(os.path.expandvars(p)))
  ## Create set of commands for all of the requested steps
  if filelist_data:
    options_tuple = filelist_data.options_tuple
  else:
    options_tuple = None
  commands = flow.build_commands(args.flow,args.steps,options_tuple)
  ## Process each command in order. The commands come back as an assoc array with elements 'c', 'f', and 's'.  
  ##    f:  Flow name
  ##    s:  Step name
  ##    c:  The acutal command string or list of strings for this flow and step set
  for command in commands:
    if type(command['c']) is str:
      cl = [ command['c'] ]
    elif type(command['c']) is not list:
      logger.error("Flow \"{}\" step \"{}\" is returning unsupported format of type {}. Only str and list allowed.".format(command['f'],command['s'],type(command['c'])))
      sys.exit(1)
    else:
      cl = command['c']
    if args.dry_run:
      print('\n'.join(map(str,cl)))
    elif cl:
      logger.info("Executing flow \"{}\" step \"{}\" commands:\n  {}".format(command['f'],command['s'],'\n  '.join(map(str,cl))))
      ret = None
      for c in cl:
        ret = subprocess.call(c,shell=True)
        logger.debug("Last command returned status {}".format(ret))
        if ret:
          ## Bomb out if the command we just ran returned a non-zero status, pass that status on through exit()
          logger.error("Error detected in last command (code {}), exiting".format(ret))
          sys.exit(ret)

if __name__ == '__main__':
  run()

