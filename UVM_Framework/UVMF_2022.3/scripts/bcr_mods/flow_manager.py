__all__ = ['Flow']

import sys
import os
import time
import re
import importlib
from distutils.util import strtobool

sys.path.insert(0,os.path.dirname(os.path.realpath(__file__)))
sys.path.insert(0,os.path.dirname(os.path.dirname(os.path.realpath(__file__)))+"/templates/python")
if sys.version_info[0] < 3:
  sys.path.insert(0,os.path.dirname(os.path.dirname(os.path.realpath(__file__)))+"/templates/python/python2")

from uvmf_version import version
__version__ = version

try:
  import yaml
  import argparse
  import logging
  import traceback
  import pprint
  from bcr_mods.common import *
  from voluptuous import Required, Optional, Any, In, Schema, MultipleInvalid
  from voluptuous.humanize import humanize_error
except ImportError as ie:
  print("ERROR:Missing library: %s" % str(ie))
  sys.exit(1)

class Flow(object):

  def __init__(self,fname):
    self.logger = logging.getLogger("logger")
    self.parsing_stack = []
    self.inheritance_stack = []
    self.variable_stack = []
    self.variable_pattern = re.compile("^(.*?)(\${(.+?)})(.*?)$")
    command_schema = {
      Optional('description'): str,
      Optional('variables'): dict,
      Optional('variable_descriptions'): dict,
      Optional('command_strings'): [ str ],
      Optional('command_module'): str,
      Optional('command_package'): str,
    }
    command_schema_overlay = {
      Optional('description'): str,
      Optional('variables'): dict,
      Optional('variable_descriptions'): dict,
      Optional('command_strings'): [ str ],
      Optional('command_module'): str,
      Optional('command_package'): str,
    }      
    flow_schema = {
      Required('order'): int,
      Required('description'): str,
      Optional('default_steps'): [ str ],
      Required('steps'): { str : command_schema },
      Optional('variables'): dict,
      Optional('variable_descriptions'): dict,
      Optional('inherit'): str,
      Optional('fileassoc'): { str : [str] },
      Optional('incassoc'): { str : str },
      Optional('use_fileassoc'): Any(True,False),
    }
    flow_schema_overlay = {
      Optional('order'): int,
      Optional('description'): str,
      Optional('default_steps'): [ str ],
      Optional('steps'): { str : command_schema },
      Optional('variables'): dict,
      Optional('variable_descriptions'): dict,
      Optional('inherit'): str,
      Optional('fileassoc'): { str : [str] },
      Optional('incassoc'): { str : str },
      Optional('use_fileassoc'): Any(True,False),
    }
    top_schema = {
      Optional('options'): {
        Optional('sim_dir'): str,
        Optional('env_vars'): dict,
        Optional('libassoc'): list,
        Optional('filelist_build_defines'): { str : Any(True,False) },
        Optional('command_package_paths'): [ str ],
      },
      Required('flows'): { str : flow_schema },
      Optional('include'): [str],
    }
    overlay_schema = {
      Optional('options'): {
        Optional('sim_dir'): str,
        Optional('env_vars'): dict,
        Optional('libassoc'): list,
        Optional('filelist_build_defines'): { str : Any(True,False) },
        Optional('command_package_paths'): [ str ],
      },
      Optional('flows'): { str : flow_schema_overlay },
      Optional('include'): [str],
    }
    self.top_schema = Schema(top_schema)
    self.overlay_schema = Schema(overlay_schema)
    self.data = self.read_file(fname)
    self.logger.debug("Base flow setup read from "+fname)
    self.validate(fname)

  def validate_schema(self,schema,fname,data_structure):
    try:
      schema(data_structure)
    except MultipleInvalid as e:
      resp = humanize_error(data_structure,e).split('\n')
      self.logger.error("While validating flows file \"{}\":\n{}".format(fname,pprint.pformat(resp, indent=2)))
      sys.exit(1)

  def apply_overlay(self,overlay_str,flow_name,step_names):
    # Split input by ":"
    if not overlay_str:
      return
    self.overlay = overlay_str.split(':')
    for o in self.overlay:
      if not os.path.isfile(o):
        self.logger.error("Overlay file path \"{}\" is invalid".format(o))
        sys.exit(1)
      self.logger.info("Applying overlay data from file \"{}\"".format(o))
      overlay_data = self.read_file(o)
      self.validate_schema(self.overlay_schema,o,overlay_data)
      # Create union of the overlay data and the original data structure. If there are conflicts,
      # use the overlay_data
      self.merge_data(self.data,overlay_data,source_wins=True)

  def validate(self,fname):
    self.validate_schema(self.top_schema,fname,self.data)

  def inherit(self,inheriting_flow_name,inherited_flow_name):
    ## Inherit a flow on top of another
    self.logger.debug("Flow.inherit: Inheriting flow \"{}\" for \"{}\"".format(inherited_flow_name,inheriting_flow_name))
    if not 'flows' in self.data:
      self.logger.error("No flows defined in configuration")
      sys.exit(1)
    ## Check that inheriting and inherited flows are not the same
    if inheriting_flow_name == inherited_flow_name:
      self.logger.error("Flow \"{}\" is attempting to inherit itself".format(inheriting_flow_name))
      sys.exit(1)
    ## Check for recursion of inheritance
    if inheriting_flow_name in self.inheritance_stack:
      self.logger.error("Flow inheritance recursion detected when processing flow \"{}\". Recursion stack:\n  {}".format(inheriting_flow_name,'\n  '.join(map(str,self.inheritance_stack))))
      sys.exit(1)
    self.inheritance_stack.append(inheriting_flow_name)
    try:
      inheriting_flow = self.data['flows'][inheriting_flow_name]
      ## Remove the inheriting flag
      try:
        del(inheriting_flow['inherit'])
      except KeyError:
        self.logger.critical("Flow \"{}\" processed to inherit flow \"{}\" but inherit attribute not set".format(inheriting_flow_name,inherited_flow_name))
        sys.exit(1)
    except KeyError:
      self.logger.error("Inheriting flow \"{}\" is undefined".format(inheriting_flow_name))
      sys.exit(1)
    try:
      inherited_flow = self.data['flows'][inherited_flow_name]
    except KeyError:
      self.logger.error("Inherited flow \"{}\" called out by flow \"{}\" is undefined".format(inherited_flow_name,inheriting_flow_name))
      sys.exit(1)
    new_flow = self.merge_data(inheriting_flow,inherited_flow)
    self.data['flows'][inheriting_flow_name] = new_flow
    ## Check if the updated flow inherits something underneath and recurse down if necessary
    if 'inherit' in new_flow:
      self.inherit(inherited_flow_name,new_flow['inherit'])
    ## Remove flow from recursion stack
    self.inheritance_stack.pop()

  def merge_data(self,destination,source,source_wins=False,path=None):
    """Merge data from source structure into destination. Conflicts take destination values"""
    if path is None: path = []
    for key in source:
      if key in destination:
        if isinstance(source[key],dict) and isinstance(destination[key],dict):
          self.merge_data(destination[key],source[key],source_wins,path+[str(key)])
        elif source[key] == destination[key]:
          pass  ## Same value in both
        else:
          # Values are different. Who wins?
          if not source_wins:
            pass  ## Keep destination value
          else:
            destination[key] = source[key]  ## Keep source value
      else:
        destination[key] = source[key]  ## New value, move source value into destination
    return destination

  def resolve_inheritance(self):
    for k,ds in self.data['flows'].items():
      if 'inherit' in ds:
        self.inherit(k,ds['inherit'])

  def elaborate_variable(self,flow_name,step_name,var_name,container_dict,listing=False):
    self.logger.debug("In flow \"{}\" step \"{}\", attempting to elaborate variable \"{}\"".format(flow_name,step_name,var_name))
    top_vars = self.data['flows'][flow_name]['steps'][step_name]['variables']
    self.variable_stack.append(var_name)
    while True:
      m = self.variable_pattern.search(str(container_dict[var_name]))
      if not m:
        ## No references to other variables within this one, exit the call
        self.logger.debug("Elaborated {}:{}:{} to \"{}\"".format(flow_name,step_name,var_name,container_dict[var_name]))
        if not container_dict[var_name]:
          pass
        self.variable_stack.pop()
        return
      ## Otherwise, we have references to other variables that must be elaborated. 
      begin = m.group(1)
      end = m.group(4)
      var = m.group(3)
      self.logger.debug("In flow \"{}\" step \"{}\", attempting to resolve reference to \"{}\" within variable \"{}\"".format(flow_name,step_name,var,var_name))
      ## Check to see if variable reference is defined in the step's top-level variables dictionary
      if var not in top_vars:
        ## It isn't there but it could be an environment variable reference
        if var in os.environ:
          self.logger.debug("Elaborated {}:{}:{} to environment variable with value \"{}\"".format(flow_name,step_name,var,os.environ[var]))
          container_dict[var_name] = begin+os.environ[var]+end
          continue
        else:
          ## Error, we cannot resolve this variable reference
          self.logger.error("In flow \"{}\" step \"{}\", while evaluating \"{}\", unable to resolve variable \"{}\"".format(flow_name,step_name,var_name,var))
          sys.exit(1)
      ## Check for recursion
      if var in self.variable_stack:
        self.logger.error("In flow \"{}\" step \"{}\", circular references detected when trying to elaborate \"{}\". Stack:\n  {}".format(flow_name,step_name,var,'\n  '.join(map(str,self.variable_stack))))
        sys.exit(1)
      ## Attempt to elaborate the underlying variable. These all must be defined in the top_vars dict so pass
      ## that in as the top-level container (mutable object)
      self.elaborate_variable(flow_name,step_name,var,top_vars)
      # Check for validity of underlying variable. If 'NoneType' or boolean this won't work and means
      # there is a bug in the flows file or something was uninitialized
      if (top_vars[var]==None) or isinstance(top_vars[var],bool):
        ## Only produce an error if we're trying to run (not just producing a list of options)
        if not listing:
          self.logger.error("In flow \"{}\" step \"{}\", variable \"{}\" references variable \"{}\" with an illegal value \"{}\"".format(flow_name,step_name,var_name,var,top_vars[var]))
          sys.exit(1)
        else:
          return
      ## Successful elaboration, replace and repeat
      try:
        container_dict[var_name] = begin+top_vars[var]+end
      except:
        pass

  def drill_dict(self,flow_name,step_name,var_name,var_value):
    self.logger.debug("For flow \"{}\", step \"{}\", drilling down into dictionary under \"{}\"...".format(flow_name,step_name,var_name))
    for n,v in var_value.items():
      if isinstance(v,dict):
        self.drill_dict(flow_name,step_name,n,v)
      elif isinstance(v,list):
        self.drill_list(flow_name,step_name,n,v)
      else:
        self.elaborate_variable(flow_name,step_name,n,var_value)

  def drill_list(self,flow_name,step_name,var_name,var_value):
    self.logger.debug("For flow \"{}\", step \"{}\", drilling down into list under \"{}\"".format(flow_name,step_name,var_name))
    for v in var_value:
      if isinstance(v,dict):
        self.drill_dict(flow_name,step_name,'_undefined_',v)
      elif isinstance(v,list):
        self.drill_list(flow_name,step_name,'_undefined_',v)
      else:
        ## This is illegal - leaf nodes must be a dict (need name/value pairs)
        self.logger.error("Raw values found inside nested list within variables dict for flow \"{}\", step \"{}\"".format(flow_name,step_name))
        sys.exit(1)

  def elaborate_variables(self,flow_name,options,listing=False):
    flow = self.data['flows'][flow_name]
    if 'variables' not in flow:
      flow['variables'] = {}
    ## Set sim_dir variable if not already set
    if 'sim_dir' not in flow['variables']:
      flow['variables']['sim_dir'] = options['sim_dir']
    ## Loop through each step in the desired flow
    for step_name, step in flow['steps'].items():
      if 'variables' not in step:
        step['variables'] = {};
      ## Pull in flow-level variables first, if they exist.
      for var_name,var in flow['variables'].items():
        ## Only pull them in if we're not overriding the same for the step (step takes precedence)
        if var_name not in step['variables']:
          step['variables'][var_name] = flow['variables'][var_name]
      ## Elaborate each variable for the step
      for var_name,var_value in step['variables'].items():
        ## Check first for variable type.  Drill down further if a dict or list, otherwise have the variable elaborated
        if isinstance(var_value,dict):
          self.drill_dict(flow_name,step_name,var_name,var_value)
        elif isinstance(var_value,list):
          self.drill_list(flow_name,step_name,var_name,var_value)
        else:
          self.elaborate_variable(flow_name,step_name,var_name,step['variables'],listing=listing)     

  def build_commands(self,flow_name,step_names,options_tuple):
    """
    Build up command-lines for the given steps of the given flow by extracting the data from the specified command class
    """
    commands = []
    num = 0
    ## Check that the given flow is valid. Error out if not found.
    if flow_name not in self.data['flows']:
      self.logger.error("Flow \"{}\" specified when building commands is invalid".format(flow_name))
      sys.exit(1)
    steps = self.data['flows'][flow_name]['steps']
    ## Iterate through each step
    for step_name in step_names:
      try:
        step = steps[step_name]
      except KeyError:
        self.logger.error("Flow \"{}\" does not contain specified step \"{}\"".format(flow_name,step_name))
        sys.exit(1)
      try:
        command_module = importlib.import_module('.'+step['command_module'],step['command_package'])
      except ImportError:
        self.logger.error("Flow \"{}\" step \"{}\" was unable to import the command module \"{}\" from package \"{}\"\n       Consider adding a path entry in your flow's 'option':'command_package_paths' array (see documentation for details)".format(flow_name,step_name,step['command_module'],step['command_package']))
        sys.exit(1)
      num = num + 1
      if (options_tuple):
        # If any options were pulled from the file lists, these need to be incorporated into the variables list
        # so that the command modules can find them. Build this up now and add it.
        compile_file_options = {}
        for ot in options_tuple:
          ## entry[0] is the compile file origin, entry[1] is the option set
          o = ot[1]
          ## the option might be a simple string, or it might be a key/value pair where key=command name, value=options for that command
          ## If the option is a simple string, append this to the "__all__" entry
          if (isinstance(o,str)):
            if '__all__' not in compile_file_options:
              compile_file_options['__all__'] = ''
            compile_file_options['__all__'] = compile_file_options['__all__']+' '+o
          ## option is a list, meaning entry[0] is the command to modify, entry[1] is the option
          if (isinstance(o,list)):
            if o[0] not in compile_file_options:
              compile_file_options[o[0]] = ''
            compile_file_options[o[0]] = compile_file_options[o[0]] +' '+o[1]
        step['variables']['compile_file_options'] = compile_file_options
      commands.append({'f':flow_name,
                       's':step_name,
                       'n':num,
                       'c':command_module.generate_command(v=step['variables'])})
    return commands

  def apply_overrides(self,flow,overrides,step_names=None):
    """
    Apply any variable overrides. These are passed in as a list of strings in a 'name:value' format."""
    override_dict = {}
    ## Make sure flow is valid
    if flow not in self.data['flows']:
      self.logger.error("Variable override: Specified flow \"{}\" is invalid".format(flow))
      sys.exit(1)
    if not step_names:
      steps = self.data['flows'][flow]['steps']
    else:
      ## Specific steps listed. Check for existence first, if valid only apply overrides to these steps
      steps = {}
      for n in step_names:
        if n not in self.data['flows'][flow]['steps']:
          self.logger.error("Variable override: Specified step name \"{}\" in flow \"{}\" is invalid".format(n,flow))
          sys.exit(1)
        steps[n] = self.data['flows'][flow]['steps'][n]
    for override in overrides:
      if override.isspace():
        ## An override can come in as just an empty string.  Ignore this and move on
        continue
      m = re.match(r"(?P<override_name>\w+):(?P<override_value>.*)",override)
      if not m:
        self.logger.error("Option override error: \"{}\" not in expected name:value format".format(override))
        sys.exit(1)
      name = m.group('override_name')
      value = m.group('override_value')
      if name in override_dict:
        self.logger.error("Option \"{}\" overridden twice on command-line".format(name))
        sys.exit(1)
      # Convert "True" and "False" keywords into boolean equivalents
      if value == 'True':
        value = True
      if value == 'False':
        value = False
      override_dict[name] = value
      self.logger.debug("Overriding option \"{}\" with value \"{}\"".format(name,value))
    for variable_name, override_value in override_dict.items():
      ## First search for defines in the filelist_build_defines structure (if it exists)
      if 'filelist_build_defines' in self.data['options'] and variable_name in self.data['options']['filelist_build_defines']:
        self.data['options']['filelist_build_defines'][variable_name] = override_value
        self.logger.debug("Setting build define \"{}\" to \"{}\"".format(variable_name,override_value))
        continue
      ## Search for variable name across all steps. 
      if 'variables' in self.data['flows'][flow] and variable_name in self.data['flows'][flow]['variables']:
        ## Found the override in the flow-level variable list. Try to override across all steps
        self.data['flows'][flow]['variables'][variable_name] = override_value
        for sn,step in steps.items():
          if 'variables' in self.data['flows'][flow]['steps'][sn]:
            self.data['flows'][flow]['steps'][sn]['variables'][variable_name] = override_value
      else:
        ## Not a flow-level variable, need to find a specific reference
        step_name = None
        for sn, step in steps.items():
          if 'variables' in step:
            if variable_name in step['variables']:
              step_name = sn
        if not step_name:
          ## No step was found to contain the specified variable. Flag as error
          self.logger.error("Override \"{}:{}\" cannot be matched to any variable in any step for flow \"{}\"".format(variable_name,override_value,flow))
          sys.exit(1)
        ## We should now have an explicit and validated step name, variable name and associated override value. Still need to definitively validate
        ## the variable name so use 'try' to apply the override. If it fails it means the variable isn't valid
        try:
          self.data['flows'][flow]['steps'][step_name]['variables'][variable_name] = override_value
          self.logger.debug("Applying flow \"{}\" variable {}:{} to \"{}\"".format(flow,step_name,variable_name,override_value))
        except KeyError:
          self.logger.error("Override \"{}:{}\" cannot be applied - invalid variable name in flow \"{}\"".format(variable_name,override_value,flow))
          sys.exit(1)

  def read_file(self,fname):
    self.logger.debug("Flow.read_file:Opening file {}".format(fname))
    ## Resolve full path to file
    full_fname = resolve_path(fname,os.getcwd())
    ## Check for recursion
    if full_fname in self.parsing_stack:
      self.logger.fatal("Circular reference to flows file \"{}\" detected. Stack:\n  {}".format(full_fname,'\n  '.join(map(str,self.parsing_stack))))
      sys.exit(1)
    self.parsing_stack.append(full_fname)
    try:
      fs = open(full_fname)
    except IOError:
      self.logger.error("Unable to open flows file \"{}\"".format(full_fname))
      sys.exit(1)
    try:
      data = ordered_load(self,fs)
    except yaml.scanner.ScannerError as e:
      self.logger.error("Error in file \"{}\": {}".format(full_fname,e))
      sys.exit(1)
    fs.close()
    # It is possible for the YAML read to pass against an empty file. Check for that.
    if not data:
      self.logger.error("Error in file \"{}\": File contains no data".format(full_fname))
      sys.exit(1)
    ## Check for include files and jump into them if present.
    if 'include' in data and isinstance(data['include'],list):
      for fn in data['include']:
        included_data = self.read_file(fn)
        data = self.merge_data(data,included_data)
    self.parsing_stack.pop()
    return data
