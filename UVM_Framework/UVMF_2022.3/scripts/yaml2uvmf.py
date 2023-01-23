#! /usr/bin/env python

##############################################################################
## Copyright 2017 Mentor Graphics
## All Rights Reserved Worldwide
##
##   Licensed under the Apache License, Version 2.0 (the "License"); you may
##   not use this file except in compliance with the License.  You may obtain
##   a copy of the License at
##
##    http://www.apache.org/license/LICENSE-2.0
##
##   Unless required by applicable law or agreed to in
##   writing, software distributed under the License is
##   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
##   CONDITIONS OF ANY KIND, either express or implied.  See
##   the License for the specific language governing
##   permissions and limitations under the License.
##
##############################################################################
##
##   Mentor Graphics Inc
##
##############################################################################
##
##   Created by :    Jon Craft & Bob Oden
##   Creation date : May 25 2017
##
##############################################################################
##
##   This script utilizes the Python-based generator API to take data structures
##   defined in YAML and convert them into UVMF code for interfaces, environments
##   and benches.   
##
##   Run 'yaml2uvmf.py --help' for more information
##
##############################################################################

import sys
import os
import time
import re
import inspect
import copy
import pprint
from optparse import OptionParser, SUPPRESS_HELP
from fnmatch import fnmatch
import shutil

# Determine addition to sys.path automatically based on script location
# This means user does not have to explicitly set PYTHONPATH in order for this
# script to work properly.

sys.path.insert(0,os.path.dirname(os.path.dirname(os.path.realpath(__file__)))+"/templates/python");
# Only need python2 packages if using python2
if sys.version_info[0] < 3:
  sys.path.insert(0,os.path.dirname(os.path.dirname(os.path.realpath(__file__)))+"/templates/python/python2");

from uvmf_yaml import  *
import uvmf_gen
from uvmf_gen import (UVMFCommandLineParser,PassThroughOptionParser,UserError,InterfaceClass,EnvironmentClass,BenchClass)
from voluptuous import Invalid, MultipleInvalid
from voluptuous.humanize import humanize_error
from uvmf_version import version

try:
  import yaml
except ImportError:
  print("ERROR : yaml package not found.  See templates.README for more information")
  print("Python version info:\n{}".format(sys.version))
  sys.exit(1)

def merge_summary(merge,verbose=False):
  block_count = sum(len(l) for l in merge.found_blocks.values())
  new_block_count = sum(len(l) for l in merge.new_blocks.values())
  if verbose:
    print("============================== Merge Details ==============================")
  print("  Parsed {0} original files finding a total of {1} \"pragma uvmf custom\" blocks".format(len(merge.rd), block_count))
  if verbose and (len(merge.found_blocks)>0):
    for f in merge.found_blocks:
      print("    File: {0}".format(f))
      for l in merge.found_blocks[f]:
        print("      \"{0}\"".format(l['name']))
  print("  Copied {0} new files from generated source".format(len(merge.copied_files)))
  if verbose and (len(merge.copied_files)>0):
    print("    Files found in new output but not in merged source. List of copied file destinations:")
    for f in merge.copied_files:
      print("     {0}".format(f))
  print("  Found {0} new \"pragma uvmf custom\" blocks in generated source".format(new_block_count))
  if verbose and (len(merge.new_blocks)>0):
    print("   Blocks found in new output but not in merged source. List of new blocks and their associated source file locations:")
    for f in merge.new_blocks:
      print("     File: {0}".format(f))
      for l in merge.new_blocks[f]:
        print("       \"{0}\"".format(l))
  if verbose:  
    print("===========================================================================")

class ConfigFileReader:
  """Reads in a .f file and builds up array of files to parse"""
  def __init__(self,fname,relative_to_file=False):
    self.fname = fname
    self.files = []
    try: 
      self.fh = open(fname,'r')
    except IOError:
      raise UserError("Unable to open -f/-F file "+fname)
    self.lines = self.fh.readlines()
    for line in self.lines:
      # Strip comments
      line = re.sub(r"(.*?)#.*",r"\1",line.rstrip()).strip()
      # Elaborate environment variables
      line = os.path.expandvars(line)
      if (line != ""):
        if relative_to_file:
          line = os.path.normpath(os.path.dirname(os.path.abspath(fname))+os.path.sep+line)
        self.files.append(line)
    self.fh.close()

class DataClass:
  def __init__(self,parser,debug=False):
    self.data = {'interfaces':{},'environments':{},'benches':{},'util_components':{},'qvip_environments':{},'qvip_library':{},'global':{}}
    self.parser = parser
    self.debug = debug
    self.validators = {}
    self.used_ac_items = []

  def parseFile(self,fname):
    try:
      fs = open(fname)
    except IOError:
      raise UserError("Unable to open config file "+fname)
    d = yaml.safe_load(fs)
    fs.close()
    try:
      if 'uvmf' not in d.keys():
        raise UserError("Contents of "+fname+" not valid UVMF info")
    except:
      raise UserError("Contents of "+fname+" not valid UVMF info")
    for k in d['uvmf'].keys():
      if k not in self.data.keys():
        raise UserError("Top-level element \""+k+"\" in "+fname+" is not valid. Allowed entries:\n  "+str(self.data.keys()))
    for elem in self.data.keys():
      try: self.data[elem].update(d['uvmf'][elem])
      except KeyError:
        pass

  ## Validate various data structures against the associated schema
  def validate(self):
    self.validators = {
      'interfaces':InterfaceValidator(),
      'util_components':ComponentValidator(),
      'qvip_environments':QVIPEnvValidator(),
      'environments':EnvironmentValidator(),
      'benches':BenchValidator(),
      'global':GlobalValidator(),
#      'qvip_library':QVIPLibValidator(),   ## Don't validate QVIP library info, for debug purposes only
    }
    ## Check for any incorrect top-level keys
    for t in self.validators.keys():
      for c in self.data[t].keys():
        if (t=='global'):
          v = self.data[t]
        else:
          v = self.data[t][c]
        try:
          self.validators[t].schema(v)
        except MultipleInvalid as e:
          resp = humanize_error(v,e).split('\n')
          raise UserError("While validating "+t+" YAML '"+c+"':\n"+pprint.pformat(resp,indent=2))

  def calculateRelativeVipLocation(self,compClass):
    ## Determine relative path to "loc" if CWD is bench's "sim" directory
    simpath = compClass.bench_location+"/bench_name/sim"
    ret = os.path.relpath(compClass.vip_location,simpath)
    ## Even on Windows, these need to be forward slashes because they'll be normalized within Tcl. Replace any backslashes with forward ones
    ## Can't use pathlib here due to Python2 back-compat, just do a global search/replace
    return ret.replace('\\','/')

  def calculateRelativeVipToCwd(self,compClass):
    ret = os.path.relpath(os.getcwd(),compClass.vip_location)
    return ret.replace('\\','/')

  def calculateRelativeBenchToCwd(self,compClass):
    ret = os.path.relpath(os.getcwd(),compClass.bench_location)
    return ret.replace('\\','/')

  def calculateRelativeInterfaceToCwd(self,compClass):
    ret = os.path.relpath(os.getcwd(),compClass.vip_location+os.path.sep+compClass.interface_location)
    return ret.replace('\\','/')

  def calculateRelativeEnvironmentToCwd(self,compClass):
    ret = os.path.relpath(os.getcwd(),compClass.vip_location+os.path.sep+compClass.environment_location)
    return ret.replace('\\','/')

  def setupGlobalVars(self,compClass):
    try:
      compClass.header = self.data['global']['header']
    except KeyError:
      compClass.header = None
      pass
    try:
      compClass.flat_output = (self.data['global']['flat_output'] == "True")
    except KeyError:
      compClass.flat_output = False
      pass
    try:
      compClass.vip_location = self.data['global']['vip_location']
    except KeyError:
      pass
    try:
      compClass.interface_location = self.data['global']['interface_location']
    except KeyError:
      pass
    try:
      compClass.environment_location = self.data['global']['environment_location']
    except KeyError:
      pass
    try:
      compClass.bench_location = self.data['global']['bench_location']
    except KeyError:
      pass
    compClass.relative_vip_from_sim = self.calculateRelativeVipLocation(compClass)
    compClass.relative_vip_from_cwd = self.calculateRelativeVipToCwd(compClass)
    compClass.relative_bench_from_cwd = self.calculateRelativeBenchToCwd(compClass)
    compClass.relative_interface_from_cwd = self.calculateRelativeInterfaceToCwd(compClass)
    compClass.relative_environment_from_cwd = self.calculateRelativeEnvironmentToCwd(compClass)
    return compClass

  ## Generate everything from the data structures
  def buildElements(self,genarray,verify=True,build_existing=False,archive_yaml=True):
    count = 0
    self.interfaceDict = {}
    try:
      arrlen = len(genarray)
    except TypeError:
      arrlen = 0
      pass
    for interface_name in self.data['interfaces']:
      if ((arrlen>0) and (interface_name in genarray)) or (arrlen==0):
        self.interfaceDict[interface_name] = self.generateInterface(interface_name,build_existing,archive_yaml)
        count = count + 1 
    self.environmentDict = {}
    for environment_name in self.data['environments']:
      if ((arrlen>0) and (environment_name in genarray)) or (arrlen==0):
        self.environmentDict[environment_name] = self.generateEnvironment(environment_name,build_existing,archive_yaml)
        count = count + 1 
    self.benchDict = {}
    for bench_name in self.data['benches']:
      if ((arrlen>0) and (bench_name in genarray)) or (arrlen==0):
        self.benchDict[bench_name] = self.generateBench(bench_name,build_existing,archive_yaml)
        count = count + 1
    ## Check to see if any utility components were defined but never instantiated, flag that as a warning
    for util_comp in self.data['util_components']:
      if util_comp not in self.used_ac_items:
        print("  WARNING : Utility component \""+util_comp+"\" was defined but never used. It will not be generated.")
    ## Verify that something was produced (possible that YAML input was empty or genarray had no matches)
    if count==0 and verify:
      raise UserError("No output was produced!")


  def recursion_print(self,recurse_list):
    r = ""
    for i,s in enumerate(recurse_list):
      r = r + s
      if i != len(recurse_list)-1:
        r = r + " -> "
    return r

  ## This method recursively searches all environments from the specified level down for QVIP subenvs, compiling
  ## a list of underlying QVIP agents, their subenvironment parent names, their import list and active/passive info
  def getQVIPAgents(self,topEnv,recurse_list=[]):
    struct = self.data['environments']
    # Check for recursion, error out if detected
    if topEnv in recurse_list:
      raise UserError("Sub-environment recursion detected within environment \""+topEnv+"\". Tree: \""+self.recursion_print(recurse_list+[topEnv])+"\"")
    try:
      env = struct[topEnv]
    except KeyError:
      raise UserError("Unable to find environment \""+topEnv+"\" in defined environments (available list is "+str(struct.keys()))
    agent_list = []
    import_list = []
    ## First look for any local QVIP subenvironments and extract those agent names
    try:
      qvip_subenv_list = env['qvip_subenvs']
    except KeyError:
      qvip_subenv_list = []
      pass
    for s in qvip_subenv_list:
      try:
        d = self.data['qvip_environments'][s['type']]
      except KeyError:
        raise UserError("Definition for QVIP subenvironment \""+s['name']+"\" of type \""+s['type']+"\" is not found")
      local_agents = d['agents']
      for a in local_agents:
        try:
          active_passive = a['active_passive']
        except KeyError:
          active_passive = None
        agent_list = agent_list + [{ 'name': a['name'], 'parent': s['type'], 'active_passive': active_passive }]
        try:
          import_list = import_list + a['imports']
        except KeyError: pass
    ## Next drill down and call getQVIPAgents on any non-QVIP subenvironments
    try:
      subenv_list = env['subenvs']
    except KeyError:
      subenv_list = []
      pass
    for s in subenv_list:
      qstruct = self.getQVIPAgents(s['type'],recurse_list+[topEnv])
      agent_list = agent_list + qstruct['alist'];
      import_list = import_list + qstruct['ilist'];
    ## Finally, uniquify the import list
    ilist = import_list
    import_list = []
    for i in ilist:
      if i not in import_list:
        import_list = import_list + [ i ]
    return {'alist':agent_list, 'ilist':import_list}

  ## This method will return a list of environments at the provided environment level or recursively.
  def getEnvironments(self,topEnv,recursive=True):
    struct = self.data['environments']
    try:
      env = struct[topEnv]
    except KeyError:
      raise UserError("Unable to find environment \""+topEnv+"\" in defined environments (available list is "+str(struct.keys()))
    envs = []
    try:
      envs = env['subenvs']
    except KeyError: pass
    if not recursive:
      return envs
    for subenv in envs:
      envs = envs + self.getEnvironments(subenv['type'],recursive=True)
    return envs

  ## This method takes a dotted component hierarchy string and returns
  ## the same but with underscores. For use in cases where a unique identifier
  ## is required. Removes final entry in component hierarchy too.
  def getUniqueID(self,val):
    l = val.split(".")
    return "uvm_test_top."+'.'.join(l[:-1])+"."

  ## This method returns an ordered list of information on ALL BFMs from a given top-level environment, down. 
  ## The list entries all have the following structure:
  ##   - BFM Name ('bfm_name')
  ##   - BFM Type ('bfm_type')
  ##   - BFM Parent Type ('parent_type')
  ##   - Environment Path ('env_path')
  ##   - VIP Library Env Variable Name ('lib_env_var_name') (only valid for non-QVIP)
  ##   - QVIP/Non-QVIP flag ('is_qvip')
  ##   - Initiator/Responder info ('initiator_responder')
  ##   - VeloceReady flag ('veloce_ready')
  def getAllAgents(self,env_type,env_inst,isQVIP,envPath):
    alist = []
    if (isQVIP==1):
      # This environment we've been given is a QVIP environment which is stored
      # in a different structure
      struct = self.data['qvip_environments']
      try:
        env = struct[env_type]
      except KeyError:
        raise UserError("Unable to find QVIP environment \""+env_type+"\" in defined QVIP environments (available list is "+str(struct.keys())+")")
      for a in env['agents']:
        ## All we have is the name of each BFM.
        alist = alist + [{ 'bfm_name': a['name'], 
                           'bfm_type': 'unknown', 
                           'parent_type': env_type, 
                           'env_path': envPath+"."+a['name'],
                           'lib_env_var_name':'unknown',
                           'is_qvip': 1 ,
                           'initiator_responder':'UNKNOWN',
                           'veloce_ready':False }]
      ## No nesting with QVIP environments so safe to just return here
      return alist  
    else:
      struct = self.data['environments']
    try:
      env = struct[env_type]
    except KeyError:
      raise UserError("Unable to find environment \""+env_type+"\" in defined environments (available list is "+str(struct.keys()))
    ## We're looking at a non-QVIP environment. This can have underlying QVIP and/or non-QVIP sub-environments as well as local agents.
    ## Look for underlying QVIP subenvs first, then non-QVIP sub-envs, then local agents.
    try:
      qvip_subenvs = env['qvip_subenvs']
      for e in qvip_subenvs:
        alist = alist + self.getAllAgents(e['type'],e['name'],1,envPath+"."+e['name'])  
    except KeyError: pass
    try:
      subenvs = env['subenvs']
      for e in subenvs:
        alist = alist + self.getAllAgents(e['type'],e['name'],0,envPath+"."+e['name'])
    except KeyError: pass
    try:
      agents = env['agents']
      for a in agents:
        try:
          env_var_name = self.data['interfaces'][a['type']]['vip_lib_env_variable']
        except KeyError:
          env_var_name = 'UVMF_VIP_LIBRARY_HOME'
          pass
        try:
          init_resp = a['initiator_responder']
        except KeyError:
          init_resp = 'INITIATOR'
          pass
        try:
          veloce_ready = (self.data['interfaces'][a['type']]['veloce_ready']=="True")
        except KeyError:
          veloce_ready = True
          pass
        infact_ready = ('infact_ready' in self.data['interfaces'][a['type']].keys() and self.data['interfaces'][a['type']]['infact_ready'])

        alist = alist + [{ 'bfm_name': a['name'], 
                           'bfm_type': a['type'], 
                           'parent_type': env_type, 
                           'env_path': envPath+"."+a['name'],
                           'lib_env_var_name':env_var_name, 
                           'is_qvip': 0, 
                           'initiator_responder':init_resp ,
                           'veloce_ready':veloce_ready,
                           'infact_ready':infact_ready }]
    except KeyError: pass
    return alist

  ## This method returns an ordered list of information on ALL BFMs from a given top-level environment, down. 
  ## The list entries all have the following structure:
  ##   - BFM Name ('bfm_name')
  ##   - BFM Type ('bfm_type')
  ##   - BFM Parent Type ('parent_type')
  ##   - Environment Path ('env_path')
  ##   - VIP Library Env Variable Name ('lib_env_var_name') (only valid for non-QVIP)
  ##   - QVIP/Non-QVIP flag ('is_qvip')
  ##   - Initiator/Responder info ('initiator_responder')
  ##   - VeloceReady flag ('veloce_ready')
  def getAllScoreboards(self,env_type,env_inst,envPath):
    sblist = []
    struct = self.data['environments']
    try:
      env = struct[env_type]
    except KeyError:
      raise UserError("Unable to find environment \""+env_type+"\" in defined environments (available list is "+str(struct.keys()))
    try:
      subenvs = env['subenvs']
      for e in subenvs:
        sblist = sblist + self.getAllScoreboards(e['type'],e['name'],envPath+"."+e['name'])
    except KeyError: pass
    try:
      sbs = env['scoreboards']
      for sb in sbs:
        sblist = sblist + [envPath+"."+sb['name']]
    except KeyError: pass
    return sblist

  ## This method can be employed to return either a list of (non-QVIP) agents at the provided environment
  ## level or recursively, searching through all sub-environments and down. 
  def getAgents(self,topEnv,recursive=True,givePath=False,parentPath=[]):
    struct = self.data['environments']
    try:
      env = struct[topEnv]
    except KeyError:
      raise UserError("Unable to find environment \""+topEnv+"\" in defined environments (available list is "+str(struct.keys()))
    agents = []
    try:
      agents = env['agents']
    except:
      agents = []
      pass
    if not givePath:
      structure = agents
    else:
      structure = []
      for agent in agents:
          try:
            vip_lib_env_variable = self.data['interfaces'][agent['type']]['vip_lib_env_variable']
          except KeyError: 
            vip_lib_env_variable = "UVMF_VIP_LIBRARY_HOME"
          structure = structure + [{ 'envpath' : parentPath, 'agent' : agent, 'vip_lib_env_variable' : vip_lib_env_variable }]
    if not recursive:
      return structure
    try:
      subEnvs = env['subenvs']
      for subEnv in subEnvs:
        structure = structure + self.getAgents(subEnv['type'],recursive=True,givePath=givePath,parentPath=parentPath+[subEnv['name']])
    except KeyError: pass
    return structure

  def dataExtract(self,keys,dictionary):
    ## Pull the specified keys out of the given structure. If the key
    ## does not exist return None for the given value
    ret = []
    for key in keys:
      try:
        ret = ret + [dictionary[key]]
      except KeyError:
        ret = ret + [None]
        pass
    return ret

  def generateEnvironment(self,name,build_existing=False,archive_yaml=True):
    env = EnvironmentClass(name)
    struct = self.data['environments'][name]
    qvip_agents_dot = []
    qvip_agents_und = []
    valid_ap_list = []
    valid_ae_list = []
    valid_qsubenv_list = []
    env_has_extdef_items = False
    env = self.setupGlobalVars(env)
    ## Extract any environment-level parameters and add them
    try:
      for param in struct['parameters']:
        pname,ptype,pval = self.dataExtract(['name','type','value'],param)
        env.addParamDef(pname,ptype,pval)
    except KeyError: pass
    try:
      for param in struct['hvl_pkg_parameters']:
        pname,ptype,pval = self.dataExtract(['name','type','value'],param)
        env.addHvlPkgParamDef(pname,ptype,pval)
    except KeyError: pass
    ## Extract any configuration variable settings and add them
    try:
      for cv_val in struct['config_variable_values']:
        cvvname,cvvval = self.dataExtract(['name','value'],cv_val)
        env.addConfigVariableValue(cvvname,cvvval)
    except KeyError: pass    
    ## Drill down into any QVIP subenvironments for import information, that'll be needed here
    qstruct = self.getQVIPAgents(name)
    ilist = qstruct['ilist']
    for i in ilist:
      env.addImport(i)
    ## Call out any locally defined imports
    try:
      for imp in struct['imports']:
        env.addImport(imp['name'])
    except KeyError: pass
    ## If imp-decl macros are needed, add them
    try:
      for impdecl in struct ['imp_decls']:
        env.addImpDecl(impdecl['name'])
    except KeyError: pass
    try:
      for nonUvmfComps in struct ['non_uvmf_components']:
        cname,ctype = self.dataExtract(['name', 'type'],nonUvmfComps)
        try:
          cextdef = ( nonUvmfComps['extdef'] == 'True' )
          env_has_extdef_items = True
        except KeyError:
          pass
        try:
          cparams_array = nonUvmfComps['parameters']
        except KeyError:
          cparams_array = {}
          pass
        cparams = {}
        for item in cparams_array:
          n,v = self.dataExtract(['name','value'],item)
          cparams[n] = v
        env.addNonUvmfComponent(cname,ctype,cparams)
    except KeyError: pass
    try:
      for qvipMemAgents in struct ['qvip_memory_agents']:
        qmaname,qmatype,qmaqenv = self.dataExtract(['name', 'type','qvip_environment'],qvipMemAgents)
        try:
          qmaparams_array = qvipMemAgents['parameters']
        except KeyError:
          qmaparams_array = {}
          pass
        qmaparams = {}
        for item in qmaparams_array:
          n,v = self.dataExtract(['name','value'],item)
          qmaparams[n] = v
        env.addQvipMemoryAgent(qmaname,qmatype,qmaqenv,qmaparams)
    except KeyError: pass
    ## The order of the following loops is important. The order in which local agents, sub-environments and QVIP
    ## sub-environments are added must match the order in which they will be added at the bench level, otherwise
    ## things will be configured out-of-order. 
    ## The order is as follows:
    ##   QVIP subenvs
    ##   Custom sub-environments
    ##   Locally defined custom interfaces
    ## Look for defined QVIP sub-environments and add those
    try:
      for subenv in struct['qvip_subenvs']:
        n,t = self.dataExtract(['name','type'],subenv)
        try:
          qvipStruct = self.data['qvip_environments'][t]
        except KeyError:
          raise UserError("QVIP environment \""+t+"\" in environment \""+name+"\" is not defined")
        alist = []
        for a in qvipStruct['agents']:
          alist = alist + [a['name']]
          qvip_agents_dot = qvip_agents_dot + [n+"."+a['name']]
          qvip_agents_und = qvip_agents_und + [n+"_"+a['name']]
        valid_qsubenv_list = valid_qsubenv_list + [n] 
        env.addQvipSubEnv(name=n,envPkg=t,agentList=alist)
    except KeyError: pass
    ## Look for defined sub-environments and add them
    try:
      for subenv in struct['subenvs']:
        ename,etype = self.dataExtract(['name','type'],subenv)
        try:
          subextdef = ( subenv['extdef'] == 'True' )
          env_has_extdef_items = True
        except KeyError:
          pass
        try:
          eparams_array = subenv['parameters']
        except KeyError:
          eparams_array = {}
          pass
        eparams = {}
        num = 0
        for item in eparams_array:
          n,v = self.dataExtract(['name','value'],item)
          eparams[n] = v
          num += 1
        ## Determine how many agents are defined in the subenvironment as that is a required argument going into 
        ## this API call.  This is a recursive count of agents.
        agents = self.getAgents(etype,recursive=True)
        ## Also find any underlying QVIP agents underneath this subenvironment (nested underneath underlying QVIP subenvs)
        qvip_agents_struct = self.getQVIPAgents(etype);
        qvip_agents = qvip_agents_struct['alist']
        if agents==None:
          raise UserError("Sub-environment type \""+etype+"\" used in environment \""+name+"\" is not found")
        self.check_parameters('environment',name,'subenv',ename,etype,eparams_array,self.data['environments'][etype])
        ## Check if subenv has a register model defined unless asked explicitly to avoid it
        try:
          v = subenv['use_register_model']=='True'
        except KeyError:
          v = True
          pass
        if v:
          try:
            rm = self.data['environments'][etype]['register_model'] 
          except KeyError:
            rm = None
            pass
        else:
          rm = None
        if not rm:
          rm_pkg = None
          rm_block_class = None
        else:
          try:
            rm_pkg = rm['reg_model_package']
          except KeyError:
            rm_pkg = etype+"_reg_pkg"
            pass
          try:
            rm_block_class = rm['reg_block_class']
          except KeyError:
            rm_block_class = etype+"_reg_model"
            pass
        env.addSubEnv(ename,etype,len(agents)+len(qvip_agents),eparams,rm_pkg,rm_block_class) 
        env_def = self.data['environments'][etype]
        try:
          env_ap_list = env_def['analysis_ports']
          for env_ap in env_ap_list:
            valid_ap_list = valid_ap_list + [ename+"."+env_ap['name']]
        except KeyError: pass
        try:
          env_ae_list = env_def['analysis_exports']
          for env_ae in env_ae_list:
            valid_ae_list = valid_ae_list + [ename+"."+env_ae['name']]
        except KeyError: pass
    except KeyError: pass    
    ## Locally defined agent instantiations
    try:
      for agent in self.getAgents(name,recursive=False):
        aname,atype = self.dataExtract(['name','type'],agent)
        try:
          aextdef = ( agent['extdef'] == 'True' )
          env_has_extdef_items = True
        except KeyError:
          pass
        try:
          aparams_list = agent['parameters']
        except KeyError:
          aparams_list = []
          pass
        aparams = {}
        for item in aparams_list:
          n,v = self.dataExtract(['name','value'],item)
          aparams[n] = v;
        try:
          intf = self.data['interfaces'][atype]
        except KeyError:
          raise UserError("Agent type \""+atype+"\" in environment \""+name+"\" is not recognized")
        try:
          initResp = agent['initiator_responder']
        except KeyError:
          initResp = 'INITIATOR'
          pass
        self.check_parameters('environment',name,'agent',agent['name'],atype,aparams_list,self.data['interfaces'][atype])
        env.addAgent(agent['name'],atype,intf['clock'],intf['reset'],aparams,initResp)
        valid_ap_list = valid_ap_list + [agent['name']+".monitored_ap"]
    except KeyError: pass    
    defined_ac_items = []
    try:
      ac_items = struct['analysis_components']
    except KeyError:
      ac_items = []
      pass
    for ac_item in ac_items:
      ac_type,ac_name = self.dataExtract(['type','name'],ac_item)
      try:
        ac_params = ac_item['parameters']
      except KeyError:
        ac_params = []
        pass
      ## Don't go through the trouble of poking at the definition of the analysis component if it was already
      ## used before.  Just instantiate it
      try:
        extdef = (ac_item['extdef'] == 'True')
        env_has_extdef_items = True
      except KeyError:
        extdef = False
        pass
      if (ac_type not in defined_ac_items) and (not extdef):
        try:
          definition = self.data['util_components'][ac_type]
        except KeyError:
          raise UserError("No definition found for component \""+ac_name+"\" of type \""+ac_type)
        ac_type_type = definition['type']
        exports = {}
        try:
          for item in definition['analysis_exports']:
            exports[item['name']] = item['type']
        except KeyError: pass
        ports = {}
        try:
          for item in definition['analysis_ports']:
            ports[item['name']] = item['type']
        except KeyError: pass
        qvip_exports = {}
        try:
          for item in definition['qvip_analysis_exports']:
            qvip_exports[item['name']] = item['type']
        except KeyError: pass
        try:
          parameters = definition['parameters']
        except KeyError:
          parameters = []
          pass
        try:
          ac_mtlb_ready = definition['mtlb_ready']==True
        except KeyError:
          ac_mtlb_ready = False
        env.defineAnalysisComponent(ac_type_type,ac_type,exports,ports,qvip_exports,parameters,mtlbReady=ac_mtlb_ready)
        defined_ac_items = defined_ac_items + [ac_type]
        if ac_type not in self.used_ac_items:
          self.used_ac_items = self.used_ac_items + [ac_type]
      if not extdef:
        self.check_parameters('environment',name,ac_type_type,ac_name,ac_type,ac_params,self.data['util_components'][ac_type])
      env.addAnalysisComponent(ac_name,ac_type,ac_params,extdef)
      try: ports
      except NameError: ports = None
      if ports is not None:
        for ap in ports:
          valid_ap_list = valid_ap_list + [ac_name+"."+ap]
      try: exports
      except NameError: exports = None
      if exports is not None:
        for ae in exports:
          valid_ae_list = valid_ae_list + [ac_name+"."+ae]
      try: qvip_exports
      except NameError: qvip_exports = None
      if qvip_exports is not None:
        for qae in qvip_exports:
          valid_ae_list = valid_ae_list + [ac_name+"."+qae]
    try:
      sb_items = struct['scoreboards']
    except KeyError:
      sb_items = []
      pass
    for sb_item in sb_items:
      sb_name,sb_type,trans_type = self.dataExtract(['name','sb_type','trans_type'],sb_item)
      try:
        sb_params_list = sb_item['parameters']
      except KeyError:
        sb_params_list = []
        pass
      sb_params = {}
      for item in sb_params_list:
        n,v = self.dataExtract(['name','value'],item)
        sb_params[n] = v
      env.addUvmfScoreboard(sb_name,sb_type,trans_type,sb_params)
      valid_ae_list = valid_ae_list + [sb_name+".expected_analysis_export"]
      valid_ae_list = valid_ae_list + [sb_name+".actual_analysis_export"]
    try:
      for item in struct['analysis_ports']:
        n,t,c = self.dataExtract(['name','trans_type','connected_to'],item)
        if c not in valid_ap_list:
          mess = "TLM connected_to entry \""+c+"\" listed in analysis_ports for environment \""+name+"\" not a valid TLM driver name. \nValid names:"
          for ap in valid_ap_list:
            mess = mess+"\n "+ap
          if env_has_extdef_items:
            mess = mess+"\nPort may be on externally defined component - Skipping check on this connnection."
            print(mess)
          else:
            raise UserError(mess)
        env.addAnalysisPort(n,t,c)
    except KeyError: pass
    try:
      for item in struct['analysis_exports']:
        n,t,c = self.dataExtract(['name','trans_type','connected_to'],item)
        if c not in valid_ae_list:
          mess = "TLM connected_to entry \""+c+"\" listed in analysis_exports for environment \""+name+"\" not a valid TLM receiver name. \nValid names:"
          for ae in valid_ae_list:
            mess = mess+"\n "+ae
          if env_has_extdef_items:
            mess = mess+"\nPort may be on externally defined component - Skipping check on this connnection."
            print(mess)
          else:
            raise UserError(mess)
        env.addAnalysisExport(n,t,c)
    except KeyError: pass
    try:
      for item in struct['qvip_connections']:
        d,r,k,v = self.dataExtract(['driver','receiver','ap_key','validate'],item)
        rlist = r.split(".")
        ## Allow the driver (QVIP) to contain regular "." hierarchy for clarity. Convert any found
        ## to underscores in order to adhere to the API
        dm = re.sub(r'\.','_',d)
        if not v:
          v = 'True'
        if v == 'True':
          if dm not in qvip_agents_und:
            mess = "QVIP TLM Driver name entry \""+d+"\" listed in qvip_connections for environment \""+name+"\" not a valid QVIP agent name. \nValid names:"
            for b in qvip_agents_dot:
              mess = mess+"\n  "+b
            mess = mess+"\nNote: Underscores are valid substitutions within YAML for dot delimeters in this list of valid names.\n"
            if env_has_extdef_items:
              mess = mess+"\nPort may be on externally defined component - Skipping check on this connnection."
              print(mess)
            else:
              raise UserError(mess)
          if r not in valid_ae_list:
            mess = "QVIP TLM Receiver name entry \""+r+"\" listed in qvip_connections for environment \""+name+"\" not a valid QVIP TLM receiver name. \nValid names:"
            for ae in valid_ae_list:
              mess = mess+"\n "+ae
            if env_has_extdef_items:
              mess = mess+"\nPort may be on externally defined component - Skipping check on this connnection."
              print(mess)
            else:
              raise UserError(mess)
        env.addQvipConnection(dm,k,'.'.join(rlist[:-1]),rlist[-1],v)
    except KeyError: pass
    try:
      for conn in struct['tlm_connections']:
        d,r,v = self.dataExtract(['driver','receiver', 'validate'],conn)
        dlist = d.split(".")
        rlist = r.split(".")
        ## The driver and receiver entries provided need to be split to work with the API in uvmf_gen
        if not v:
          v = 'True'
        if v == 'True':
          if d not in valid_ap_list:
            mess = "TLM Driver name entry \""+d+"\" listed in tlm_connections for environment \""+name+"\" not a valid TLM driver name. \nValid names:"
            for ap in valid_ap_list:
              mess = mess+"\n "+ap
            if dlist[0] not in valid_qsubenv_list:
              if env_has_extdef_items:
                mess = mess+"\nPort may be on externally defined component - Skipping check on this connnection."
                print(mess)
              else:
                raise UserError(mess)
          if r not in valid_ae_list:
            mess = "TLM Receiver name entry \""+r+"\" listed in tlm_connections for environment \""+name+"\" not a valid TLM receiver name. \nValid names:"
            for ae in valid_ae_list:
              mess = mess+"\n "+ae
            if env_has_extdef_items:
              mess = mess+"\nPort may be on externally defined component - Skipping check on this connnection."
              print(mess)
            else:
              raise UserError(mess)
        env.addConnection('.'.join(dlist[:-1]),dlist[-1],'.'.join(rlist[:-1]),rlist[-1],v)
    except KeyError: pass
    try:
      for cfg_item in struct['config_vars']:
        n,t,c = self.dataExtract(['name','type','comment'],cfg_item)
        if not c:
          c = ""
        try:
          crand = (cfg_item['isrand']=="True")
        except KeyError: 
          crand = False
          pass
        cval = ''
        try:
          cval = cfg_item['value']
        except KeyError: pass
        try:
          cvud = cfg_item['unpacked_dimension']
        except KeyError:
          cvud = ""
          pass
        env.addConfigVar(n,t,crand,cval,c,cvud)
    except KeyError: pass
    try:
      for item in struct['config_constraints']:
        n,v,c = self.dataExtract(['name','value','comment'],item)
        if not c:
          c = ""
        env.addConfigVarConstraint(n,v,c)
    except KeyError: pass
    try:
      regInfo = struct['register_model']
    except KeyError:
      regInfo = None
      pass
    if regInfo != None:
      try:
        reg_model_pkg = regInfo['reg_model_package']
      except KeyError:
        reg_model_pkg = name+"_reg_pkg"
        pass
      try:
        reg_blk_class = regInfo['reg_block_class']
      except KeyError:
        reg_blk_class = name+"_reg_model"
        pass
      try:
        maps = regInfo['maps']
      except KeyError:
        maps = None
        pass
      if maps==None:
        use_adapter = False
        use_explicit_prediction = False
        sequencer = None
        trans = None
        adapter = None
        mapName = None
        qvip_agent = False
      else:
        try:
          use_adapter = regInfo['use_adapter'] == "True"
        except KeyError:
          use_adapter = True
        try:
          use_explicit_prediction = regInfo['use_explicit_prediction'] == "True"
        except KeyError:
          use_explicit_prediction = True
        maps = regInfo['maps']
        ## Currently only support a single map - this will change in the future, hopefully
        if len(maps) != 1:
          raise UserError("Register model in environment \""+name+"\" can only have one map defined")
        ## Extract information regarding the interface we should be attaching to.
        ## First, confirm that the name of the agent is a valid instance.  This will return a list
        ## of structures, each with an 'name' key and 'type' key. The interface we're attaching to
        ## must match up with the 'name' key in this list somewhere
        try:
          qvip_agent = maps[0]['qvip_agent']
        except KeyError:
          qvip_agent  = "False"
          pass
        if qvip_agent == "False":
          agent_list = self.getAgents(name,recursive=True)
          agent_type = ""
          for a in agent_list:
            if a['name'] == maps[0]['interface']:
              ## Testing for a defined type might be thought to be needed here but if it wasn't a
              ## valid agent type the above check would never pass
              agent_type = a['type']
              try:
                agent_params = self.parameterSyntax(a['parameters'])
              except KeyError:
                agent_params = ""
                pass
              break
          if agent_type == "":
            raise UserError("For register map \""+maps[0]['name']+"\" in environment \""+name+"\" no interface \""+maps[0]['interface']+"\" was found")
          sequencer = maps[0]['interface']
          trans = agent_type+"_transaction"+agent_params
          adapter = agent_type+"2reg_adapter"+agent_params
          mapName = maps[0]['name']
        else:
          sequencer = maps[0]['interface']
          trans = "uvm_sequence_item"
          adapter = "uvm_reg_adapter"
          mapName = maps[0]['name']
      env.addRegisterModel(
        sequencer=sequencer,
        transactionType=trans,
        adapterType=adapter, 
        busMap=mapName,
        useAdapter=use_adapter,
        useExplicitPrediction=use_explicit_prediction,
        qvipAgent=qvip_agent,
        regModelPkg=reg_model_pkg,
        regBlockClass=reg_blk_class)
    try:
      dpi_def = struct['dpi_define']
      ca = ""
      la = ""
      try:
        ca = dpi_def['comp_args']
      except KeyError: pass
      try:
        la = dpi_def['link_args']
      except KeyError: pass
      env.setDPISOName(value=dpi_def['name'],compArgs=ca,linkArgs=la)
      for f in dpi_def['files']:
        env.addDPIFile(f)
      try:
        for imp in dpi_def['imports']:
          sv_args = []
          try:
            sv_args = imp['sv_args']
          except KeyError: pass
          env.addDPIImport(imp['c_return_type'],imp['sv_return_type'],imp['name'],imp['c_args'],sv_args)
      except KeyError: pass
      try:
        for exp in dpi_def['exports']:
          intf.addDPIExport(exp)
      except KeyError: pass
    except KeyError: pass
    try:
      typedefs = struct['typedefs']
      for t in typedefs:
        n,v = self.dataExtract(['name','type'],t)
        env.addTypedef(n,v)
    except KeyError: pass
    ## UVMC Stuff
    try:
      env.addUVMCflags(struct['uvmc_flags'])
    except KeyError: pass
    try:
     env.addUVMClinkArgs(struct['uvmc_link_args'])
    except KeyError: pass
    try:
      cpp_files = struct['uvmc_files']
      for f in cpp_files:
        env.addUVMCfile(f)
    except KeyError: pass
    try:
      env.mtlbReady = (struct['mtlb_ready']=="True")
    except KeyError:
      pass
    existing_component = False
    try:
      if not build_existing:
        existing_component = (struct['existing_library_component']=="True")
    except KeyError: 
      pass
    if (existing_component == True):
      print("  Skipping generation of predefined component "+str(name))
    else:
      env.create(parser=self.parser,archive_yaml=archive_yaml)
    return env

  def parameterSyntax(self,parameterList):
    ## Take the parameter list provided and return the SV syntax for a parameterized type
    ## This is expected to be of "parameterUseSchema" with 'name' and a 'value' keys
    l = []
    for p in parameterList:
      s = "."+p['name']+"("+p['value']+")"
      l = l + [ s ]
    fs = "#("+','.join(l)+")"
    return fs

  def generateBench(self,name,build_existing=False,archive_yaml=True):
    ## Isolate the YAML structure for this bench
    struct = self.data['benches'][name]
    ## Get the name of the top-level environment
    top_env = struct['top_env']
    ## Confirm top-level environment is defined
    if top_env not in self.data['environments']:
      raise UserError("Bench \"{}\" top-env of type \"{}\" is not defined".format(name,top_env))
    ## Top-level environment parameters
    try:
      env_params_list = struct['top_env_params']
    except KeyError: 
      env_params_list = []
      pass
    ## Build up simpler name/value pair dict of env params
    env_params = {}
    for p in env_params_list:
      env_params[p['name']] = p['value']
    ## Check that parameterization is valid for the top-env
    self.check_parameters('bench',name,'environment',top_env,'top_env',env_params_list,self.data['environments'][top_env])
    ## With this information we can create the bench class object
    ben = BenchClass(name,top_env,env_params)
    ben = self.setupGlobalVars(ben)
    ## Look for clock and reset control settings (all optional)
    try:
      ben.clockHalfPeriod = struct['clock_half_period']
    except KeyError: pass
    try:
      ben.clockPhaseOffset = struct['clock_phase_offset']
    except KeyError: pass
    try:
      ben.resetAssertionLevel = (struct['reset_assertion_level']=='True')
    except KeyError: pass
    try:
      ben.useDpiLink = (struct['use_dpi_link']=='True')
    except KeyError: pass
    try:
      ben.resetDuration = struct['reset_duration']
    except KeyError: pass
    try:
      ben.activePassiveDefault = struct['active_passive_default']
    except KeyError: 
      ben.activePassiveDefault = 'ACTIVE'
      pass
    ## Check for inFact ready flag
    ben.inFactEnabled = ('infact_enabled' in struct.keys() and struct['infact_enabled']=='True')

    ## Use co-emulation clk/rst generator
    try:
      ben.useCoEmuClkRstGen = (struct['use_coemu_clk_rst_gen']=='True')
    except KeyError: pass
    ## Set the veloceReady flag for the bench
    try:
      ben.veloceReady = (struct['veloce_ready'] == "True")
    except KeyError: 
      ben.veloceReady = True
      pass   
    ## Pull out bench-level parameter definitions, if any
    try:
      for param in struct['parameters']:
        pname,ptype,pval = self.dataExtract(['name','type','value'],param)
        ben.addParamDef(pname,ptype,pval)
    except KeyError: pass 
    ## Drill down into any QVIP subenvironments for import information, that'll be needed here
    qstruct = self.getQVIPAgents(top_env)
    ilist = qstruct['ilist']
    for i in ilist:
      ben.addImport(i)   
    ## Imports
    try:
      for imp in struct['imports']:
        ben.addImport(imp['name'])
    except KeyError: pass
    ## Pull out active/passive list and produce more easily parsed dict keyed by the BFM names
    try:
      ap_list = struct['active_passive']
    except KeyError:
      ap_list = []
      pass
    ap_dict = {}
    for i in ap_list:
      ap_dict[i['bfm_name']] = i['value']
    ## Do the same for interface parameters
    try:
      ifp_list = struct['interface_params']
    except KeyError:
      ifp_list = []
    ifp_dict = {}
    for entry in ifp_list:
      bfm_name = entry['bfm_name']
      param_list = entry['value']
      ifp_dict[bfm_name] = {}
      for p in param_list:
        ifp_dict[bfm_name][p['name']] = p['value']
    ## Determine if top_env has a register model associated with it
    try:
      e = self.data['environments'][top_env]
    except KeyError:
      raise UserError("Top-level env \""+top_env+"\" is not defined")
    try:
      rm = e['register_model']
      ben.topEnvHasRegisterModel = True
      try:
        rm_pkg = rm['reg_model_package']
        ben.regModelPkg = e['register_model']['reg_model_package']
      except KeyError:
        ben.regModelPkg = top_env+"_reg_pkg"
        pass
      try:
        ben.regBlockClass = e['register_model']['reg_block_class']
      except KeyError:
        ben.regBlockClass = top_env+"_reg_model"
        pass
    except KeyError:
      ben.topEnvHasRegisterModel = False
      pass
    ## Find BFMs and add those - order is important, must match how we instantiated the components
    ## within the environment. Traverse the environment topology in the order in which sub-envs were 
    ## called out in the YAML. Use getAllAgents to intelligently traverse the topology and build up a list
    ## of BFMs (may be a mix of QVIP and non-QVIP BFMs).  Each entry in the resulting list will be a structure
    ## with the following information:
    ##   - BFM Name
    ##   - BFM Type
    ##   - Environment Path
    ##   - QVIP/Non-QVIP flag
    ##   - Active/Passive flag
    ##   - Initiator/Responder flag
    ##   - Veloce Ready flag (for checking)
    alist = self.getAllAgents(top_env,'environment',0,'environment')
    ## Check for Veloce compatibility. If the bench has been flagged for veloce_ready then none of the underlying
    ## non-QVIP agents can be flagged differently. QVIP is a different story, for now.
    if ben.veloceReady:
      for a in alist:
        if a['is_qvip']==0: # Don't bother checking QVIP agents
          if not a['veloce_ready']:
            ## Fatal out if bench veloce_ready is TRUE but any agents underneath are FALSE
            raise UserError("Bench \""+name+"\" is flagged veloce_ready True but underlying agent \""+a['env_path']+"\" of type \""+a['bfm_type']+"\" is flagged veloce_ready False")
    valid_bfm_names = []
    ## Now that we have an ordered list of BFMs we can call the appropriate API call for each
    for a in alist:
      if a['env_path'].count('.')==1:
        bfm_name = a['bfm_name']
        debugpath = 'environment'
      else:
        debugpath = re.sub(r'(.*)\.\w+',r'\1',a['env_path'])
        bfm_name = re.sub(r'^environment\.','',a['env_path'])
        bfm_name = re.sub(r'\.',r'_',bfm_name)
      valid_bfm_names = valid_bfm_names + [bfm_name]
      try:
        active_passive = ap_dict[bfm_name]
      except KeyError:
        active_passive = ben.activePassiveDefault
      if a['is_qvip']==1:
        ## Add each QVIP BFM instantiation. Function API is slightly different for QVIP vs. non-QVIP
        ben.addQvipBfm(name=a['bfm_name'],ifPkg=a['parent_type'],activity=active_passive,unique_id=self.getUniqueID(a['env_path']))
      else:
        ## Name of each BFM is simplified if they live under the top-level env
        ## Determine this by inspecting the env_path entry for each item and counting
        ## the number of dots (.). If only one, means this BFM lives at the top-most
        ## level.
        try:
          agentDef = self.data['interfaces'][a['bfm_type']]
        except:
          raise UserError("Definition for interface type \""+a['bfm_type']+"\" for instance \""+a['env_path']+"\" is not found")
        try:
          aParams = ifp_dict[bfm_name]
        except KeyError:
          aParams = {}
          pass
        infact_ready = ('infact_ready' in a.keys() and a['infact_ready'])
        try:
          port_list = agentDef['ports']
        except KeyError:
          port_list = []
        ben.addBfm(name=bfm_name,ifPkg=a['bfm_type'],clk=agentDef['clock'],rst=agentDef['reset'],activity=active_passive,parametersDict=aParams,sub_env_path=debugpath,agentInstName=a['bfm_name'],vipLibEnvVariable=a['lib_env_var_name'],initResp=a['initiator_responder'],inFactReady=infact_ready,portList=port_list)
    ## Check that all keys in the ifp_dict and ap_dict match something in the valid_bfm_names list that 
    ## was based on the actual UVM component hierarchy elements. If not, it probably means we have a typo somewhere in the bench YAML
    for k in ifp_dict.keys():
      if k not in valid_bfm_names:
        mess = "BFM name entry \""+k+"\" listed in interface_params structure for bench \""+name+"\" but not a valid BFM name. Valid BFM names:"
        for b in valid_bfm_names:
          mess = mess+"\n  "+b
        raise UserError(mess)
    for k in ap_dict.keys():
      if k not in valid_bfm_names:
        mess = "BFM name entry \""+k+"\" listed in active_passive structure for bench \""+name+"\" but not a valid BFM name. Valid BFM names:"
        for b in valid_bfm_names:
          mess = mess+"\n  "+b
        raise UserError(mess)
    ## Now drill down again but this time find any DPI packages - these could be defined at any
    ## interface or environment, so getAgents isn't good enough.  Also need to call getEnvironments
    dpi_packages = []
    vinfo_interface_dpi_dependencies = []
    vinfo_environment_dpi_dependencies = []
    for agent in self.getAgents(top_env,recursive=True):
      try:
        dpi_pkg = self.data['interfaces'][agent['type']]['dpi_define']['name']
        if dpi_pkg not in dpi_packages:
          dpi_packages.append(dpi_pkg)
          #vinfo_interface_dpi_dependencies.append(self.data['interfaces'][agent['type']]['dpi_define']['name'])
          vinfo_interface_dpi_dependencies.append(agent['type'])
      except KeyError: pass
    envs = self.getEnvironments(top_env,recursive=True)
    ## Also add the top-environment to the array when searching for DPI
    for env in envs+[{'type':top_env}]:
      try:
        dpi_pkg = self.data['environments'][env['type']]['dpi_define']['name']
        if dpi_pkg not in dpi_packages:
          dpi_packages.append(dpi_pkg)
          #vinfo_environment_dpi_dependencies.append(self.data['environments'][env['type']]['dpi_define']['name'])
          vinfo_environment_dpi_dependencies.append(env['type'])
      except KeyError: pass
    for d in dpi_packages:
      ben.addDPILibName(d)
    for d in vinfo_interface_dpi_dependencies:
      ben.addVinfoDependency("comp_"+d+"_pkg_c_files")
    for d in vinfo_environment_dpi_dependencies:
      ben.addVinfoDependency("comp_"+d+"_env_pkg_c_files")
    sblist = self.getAllScoreboards(top_env,'environment','environment')  
    try: sblist
    except NameError: sblist = None
    if sblist is not None:
      for sb in sblist:
        ben.addScoreboard(sb) 
    try:
      for t in struct['additional_tops']:
        ben.addTopLevel(t)
    except KeyError: pass
    try:
      ben.mtlbReady = (struct['mtlb_ready']=="True")
    except KeyError:
      pass
    try:
      ben.useBCR = (struct['use_bcr']=="True")
    except KeyError:
      ben.useBCR = False
    existing_component = False
    try:
      if not build_existing:
        existing_component = (struct['existing_library_component']=="True")
    except KeyError: 
      pass
    if (existing_component == True):
      print("  Skipping generation of predefined component "+str(name))
    else:
      ben.create(parser=self.parser,archive_yaml=archive_yaml)
    return ben

  def generateInterface(self,name,build_existing=False,archive_yaml=True):
    intf = InterfaceClass(name)
    struct = self.data['interfaces'][name]
    intf.clock = struct['clock']
    intf.reset = struct['reset']
    intf = self.setupGlobalVars(intf)
    try:
      intf.resetAssertionLevel = (struct['reset_assertion_level'] == 'True')
    except KeyError: pass
    try:
      intf.useDpiLink = (struct['use_dpi_link']=='True')
    except KeyError: pass
    try:
      intf.genInBoundStreamingDriver = (struct['gen_inbound_streaming_driver']=='True')
    except KeyError: pass
    try:
      intf.vipLibEnvVariable = struct['vip_lib_env_variable']
    except KeyError: pass
    try:
      for imp in struct['imports']:
        intf.addImport(imp['name'])
    except KeyError: pass
    try:
      for item in struct['parameters']:
        n,t,v = self.dataExtract(['name','type','value'],item)
        intf.addParamDef(n,t,v)
    except KeyError: pass
    try:
      for item in struct['hdl_pkg_parameters']:
        n,t,v = self.dataExtract(['name','type','value'],item)
        intf.addHdlPkgParamDef(n,t,v)
    except KeyError: pass
    try:
      for item in struct['hvl_pkg_parameters']:
        n,t,v = self.dataExtract(['name','type','value'],item)
        intf.addHvlPkgParamDef(n,t,v)
    except KeyError: pass
    try:
      for item in struct['hdl_typedefs']:
        n,t = self.dataExtract(['name','type'],item)
        intf.addHdlTypedef(n,t)
    except KeyError: pass
    try:
      for item in struct['hvl_typedefs']:
        n,t = self.dataExtract(['name','type'],item)
        intf.addHvlTypedef(n,t)
    except KeyError: pass
    try:
      for port in struct['ports']:
        n,w,d = self.dataExtract(['name','width','dir'],port)
        if not re.search(r"^(input|output|inout)$",d):
          raise UserError("Direction \""+d+"\" invalid for port \""+n+"\" in interface \""+name+"\"")
        try:
          r = (port['reset_value'])
        except KeyError:
          r = "'bz"
        intf.addPort(n,w,d,r)
    except KeyError: pass
    try:
      for trans in struct['transaction_vars']:
        n,t,c = self.dataExtract(['name','type','comment'],trans)
        if not c:
          c = ""
        try:
          trand = (trans['isrand']=="True")
        except KeyError: 
          trand = False
          pass
        try:
          tcomp = (trans['iscompare']=="True")
        except KeyError: 
          tcomp = True
          pass
        try:
          ud = trans['unpacked_dimension']
        except KeyError:
          ud = ""
          pass
        intf.addTransVar(n,t,isrand=trand,iscompare=tcomp,unpackedDim=ud,comment=c)
    except KeyError: pass
    try:
      for cfg in struct['config_vars']:
        n,t,c = self.dataExtract(['name','type','comment'],cfg)
        if not c:
          c = ""
        try:
          crand = (cfg['isrand']=="True")
        except KeyError: 
          crand = False
          pass
        cval = ''
        try:
          cval = cfg['value']
        except KeyError: pass
        try:
          cvud = cfg['unpacked_dimension']
        except KeyError:
          cvud = ""
          pass
        intf.addConfigVar(n,t,crand,cval,c,cvud)
    except KeyError: pass
    try:
      for item in struct['transaction_constraints']:
        n,v,c = self.dataExtract(['name','value','comment'],item)
        if not c:
          c = ""
        intf.addTransVarConstraint(n,v,c)
    except KeyError: pass
    try:
      for item in struct['config_constraints']:
        n,v,c = self.dataExtract(['name','value','comment'],item)
        if not c:
          c = ""
        intf.addConfigVarConstraint(n,v,c)
    except KeyError: pass
    try:
      response_info = struct['response_info']
      resp_op = response_info['operation']
      intf.specifyResponseOperation(resp_op)
      resp_data = response_info['data']
      intf.specifyResponseData(resp_data)
      print("Warning: response_info YAML structure deprecated.  Slave agent response data now determined by arguments to respond_and_wait_for_next_transfer task within generated driver_bfm.")
    except KeyError: pass
    try:
      dpi_def = struct['dpi_define']
      ca = ""
      la = ""
      try:
        ca = dpi_def['comp_args']
      except KeyError: pass
      try:
        la = dpi_def['link_args']
      except KeyError: pass
      intf.setDPISOName(value=dpi_def['name'],compArgs=ca,linkArgs=la)
      for f in dpi_def['files']:
        intf.addDPIFile(f)
      try:
        for imp in dpi_def['imports']:
          sv_args = []
          try:
            sv_args = imp['sv_args']
          except KeyError: pass
          intf.addDPIImport(imp['c_return_type'],imp['sv_return_type'],imp['name'],imp['c_args'],sv_args)
      except KeyError: pass
      try:
        for exp in dpi_def['exports']:
          intf.addDPIExport(exp)
      except KeyError: pass
    except KeyError: pass
    intf.inFactReady = ('infact_ready' in struct.keys() and struct['infact_ready'])
    try:
      intf.mtlbReady = (struct['mtlb_ready']=="True")
    except KeyError:
      pass
    try:
      intf.veloceReady = (struct['veloce_ready'] == "True")
    except KeyError: 
      intf.veloceReady = True
      pass
    try:
      intf.enableFunctionalCoverage = (struct['enable_functional_coverage'] == "True")
    except KeyError: pass
    if intf.veloceReady == True:
      try:
        for trans in struct['transaction_vars']:
          try:
            if trans['unpacked_dimension'] != "":
              raise UserError("Interface \""+name+"\" flagged to be Veloce ready but transaction variable \""+trans['name']+"\" has specified an unpacked dimension")
          except KeyError: pass
      except KeyError: 
        ## If this happens it means there are no transaction variables, which is also illegal
        raise UserError("Interface \"{0}\" flagged to be Veloce ready but no transaction variables have been defined. Must define at least one".format(name))
        pass
      try:
        for cfg in struct['config_vars']:
          try:
            if cfg['unpacked_dimension'] != "":
              raise UserError("Interface \""+name+"\" flagged to be Veloce ready but configuration variable \""+cfg['name']+"\" has specified an unpacked dimension")
          except KeyError: pass
      except KeyError: pass
        ## If this happens it means there are no transaction variables, which is also illegal
#        raise UserError("Interface \"{0}\" flagged to be Veloce ready but no transaction variables have been defined. Must define at least one".format(name))
#        pass
      ## Also possible that there was a transaction variables array defined but its empty. Also illegal
      if len(struct['transaction_vars'])==0:
        raise UserError("Interface \"{0}\" flagged to be Veloce ready but no transaction variables have been defined. Must define at least one".format(name))     
    existing_component = False
    try:
      if not build_existing:
        existing_component = (struct['existing_library_component']=="True")
    except KeyError: 
      pass
    if existing_component == True:
      print("  Skipping generation of predefined component "+str(name))
    else:
      intf.create(parser=self.parser,archive_yaml=archive_yaml)
    return intf

  def check_parameters(self,parentType,parentName,instanceType,instanceName,definitionName,instanceParams,instanceDefinition):
    ## Compare the parameters in a given instance to make sure that the names match up with 
    ## something in the list of parameters given in the definition. Can be used for any component. Pass
    ## in the list of parameters for both. If problem found, display debug information
    ## including the name of the parent component, the name and type of the instance and the
    ## parameter in question.
    ## Don't bother checking anything if the instiation was not provided any parameters.
    if len(instanceParams) == 0:
      return
    try:
      definitionParams = instanceDefinition['parameters']
    except KeyError:
      raise UserError("When instantiating "+instanceType+" \""+instanceName+"\" of type \""+definitionName+"\" inside "+parentType+" \""+parentName+"\", parameters were provided but definition had no parameters")
    ipn = []
    dpn = []
    for p in definitionParams:
      dpn = dpn + [p['name']]
    for p in instanceParams:
      if p['name'] not in dpn:
        raise UserError("Unable to find parameter \""+p['name']+"\" in definition of "+instanceType+" \""+definitionName+"\" as instance \""+instanceName+"\" in "+parentType+" \""+parentName+"\"")

def run():
  ## When invoked, this script can read a series of provided YAML-based configuration files and parse them, building
  ## up a database of information on the contained components. Each component will have an associated uvmf_gen class
  ## created around it based on the contents.  

  ## User can specify that a particular element(s) be created with the -g/--generate switch but the default is to produce
  ## everything (i.e. call "<element>.create()" against all defined elements).  Any item passed in via --generate 
  ## that matches the name of a defined element will be generated (if environments/benches/interfaces are named the
  ## same the script will match all of them)
  search_paths = ['.']
  __version__ = version
  uvmf_parser = UVMFCommandLineParser(version=__version__,usage="yaml2uvmf.py [options] [yaml_file1 [yaml_fileN]]")
  uvmf_parser.parser.add_option("-f","--file",dest="configfile",action="append",help="Specify a file list of YAML configs. Relative paths relative to the invocation directory")
  uvmf_parser.parser.add_option("-F","--relfile",dest="rel_configfile",action="append",help="Specify a file list of YAML configs. Relative paths relative to the file list itself")
  uvmf_parser.parser.add_option("-g","--generate",dest="gen_name",action="append",help="Specify which elements to generate (default is everything")
  uvmf_parser.parser.add_option("--pdb",dest="enable_pdb",action="store_true",help=SUPPRESS_HELP,default=False)
  uvmf_parser.parser.add_option("-m","--merge_source",dest="merge_source",action="store",help="Enable auto-merge flow, pulling from the specified source directory")
  uvmf_parser.parser.add_option("-s","--merge_skip_missing_blocks",dest="merge_skip_missing",action="store_true",help="Continue merge if unable to locate a custom block that was defined in old source, producing a report at the end. Default behavior is to raise an error",default=False)
  uvmf_parser.parser.add_option("--merge_export_yaml",dest="merge_export_yaml",action="store",help=SUPPRESS_HELP,default=None)
  uvmf_parser.parser.add_option("--merge_import_yaml",dest="merge_import_yaml",action="store",help=SUPPRESS_HELP,default=None)
  uvmf_parser.parser.add_option("--merge_import_yaml_output",dest="merge_import_yaml_output",action="store",help=SUPPRESS_HELP,default="uvmf_template_merged")
  uvmf_parser.parser.add_option("--merge_no_backup",dest="merge_no_backup",action="store_true",help="Do not back up original merge source",default=False)
  uvmf_parser.parser.add_option("--merge_debug",dest="merge_debug",action="store_true",help="Provide intermediate unmerged output directory for debug purposes. Debug directory can be specified by --dest_dir switch.",default=False)
  uvmf_parser.parser.add_option("--merge_verbose",dest="merge_verbose",action="store_true",help="Output more verbose messages during the merge operation for debug purposes.",default=False)
  uvmf_parser.parser.add_option("--build_existing_components",dest="build_existing_components",action="store_true",help="Ignore \"existing_library_component\" flags and attempt to build anyway.",default=False)
  uvmf_parser.parser.add_option("--no_archive_yaml",dest="no_archive_yaml",action="store_true",default=False,help="Disable YAML archive creation")
  (options,args) = uvmf_parser.parser.parse_args()
  if options.enable_pdb or options.debug:
    print("Python version info:\n"+sys.version)
  if options.enable_pdb == True:
    import pdb
    pdb.set_trace()
  elif options.debug == False:
    sys.tracebacklimit = 0
  if (len(args) == 0) and (options.configfile == None) and (options.rel_configfile == None) and (options.merge_source == None):
    raise UserError("No configurations or config file specified as input. Must provide one or both")
  if (options.merge_source != None) and (options.merge_import_yaml != None):
    raise UserError("--merge_source and --merge_import_yaml options are mutually exclusive")
  dataObj = DataClass(uvmf_parser)
  configfiles = []
  if options.configfile != None:
    for cf in options.configfile:
      cfr = ConfigFileReader(cf)
      configfiles = configfiles + cfr.files
  if options.rel_configfile != None:
    for cf in options.rel_configfile:
      cfr = ConfigFileReader(cf,relative_to_file=True)
      configfiles = configfiles + cfr.files
  try:
    configfiles = configfiles + args
  except TypeError:
    pass
  if len(configfiles) == 0:
    if not ((options.merge_source != None) and (options.merge_export_yaml)):
      raise UserError("No configuration YAML specified to parse, must provide at least one")
  if options.merge_source != None:
    if os.path.abspath(os.path.normpath(options.dest_dir)) == os.path.abspath(os.path.normpath(options.merge_source)):
      raise UserError("Cannot merge changes into source directory \"{0}\" without specifying an alternate output directory with --dest_dir switch".format(os.path.abspath(os.path.normpath(options.dest_dir))))
  for cfg in configfiles:
    dataObj.parseFile(cfg)
  dataObj.validate()
  dataObj.buildElements(options.gen_name,verify=options.merge_export_yaml==None,build_existing=options.build_existing_components,archive_yaml=(not options.no_archive_yaml))
  if options.merge_source or options.merge_import_yaml:
    if not options.merge_import_yaml:
      if not (options.merge_no_backup or options.merge_export_yaml):
        ## Create a backup of the original source.
        backup_copy = backup(options.merge_source)
        if not options.quiet:
          print("Backed up original source to {0}".format(backup_copy))
      if not options.quiet:
        print("Parsing customizations from {0} ...".format(options.merge_source))
      # Parse old source for pragma blocks. Resulting object will contain data structure of this activity
      parse = Parse(quiet=options.quiet,cleanup=options.merge_import_yaml,root=os.path.abspath(os.path.normpath(options.merge_source)))
      # Need to first produce a list of directories in the new output. Only validate files in the merge source
      # that are in the equivalent directories (to do otherwise would be a waste of time)
      parse.collect_directories(new_root_dir=options.dest_dir,old_root_dir=options.merge_source)
      # Traverse through the merged source directory structure. This will only collect data on
      # directories that were just re-generated, nothing outside of that area. 
      parse.traverse_dir(options.merge_source)
      old_root = parse.root
      if options.merge_export_yaml:
        if not options.quiet:
          print("  Exporting merge data to {0}".format(options.merge_export_yaml))
          parse.dump(options.merge_export_yaml)
          sys.exit(0)
      else:
        if not options.quiet:
          print("Merging custom code in {0} with new output ...".format(options.merge_source))
    else:
      if not options.quiet:
        print("Pulling in customizations from imported YAML file {0}".format(options.merge_import_yaml))
      old_root = os.path.abspath(os.path.normpath(options.merge_import_yaml_output))
    merge = Merge(outdir=old_root,skip_missing_blocks=options.merge_skip_missing,new_root=os.path.abspath(os.path.normpath(options.dest_dir)),old_root=old_root,quiet=options.quiet)
    if options.merge_import_yaml:
      merge.load_yaml(options.merge_import_yaml)
      # If we're importing the data, copy newly generated source over to desired final location. This will be what we treat as the "original" output directory
      from shutil import copytree
      try:
        copytree(options.dest_dir,options.merge_import_yaml_output)
      except:
        pass
    else:
      merge.load_data(parse.data)
    merge.traverse_dir(options.dest_dir)
    if (not options.merge_debug):
      # Remove the intermediate directory unless asked otherwise
      if not options.quiet:
        print("Deleting intermediate directory {0} after merging data...".format(options.dest_dir))
      try:
        shutil.rmtree(options.dest_dir)
      except:
        raise UserError("Unable to remove intermediate output directory {0}. Permissions issue?".format(options.dest_dir))
    if not options.quiet:
      print("Merge complete!")
      if options.merge_verbose:
        merge_summary(merge,verbose=True)
      merge_summary(merge)
    if len(merge.missing_blocks)>0:
      print("WARNING: Found \"pragma uvmf custom\" blocks in original source that could not be mapped to new output. These require hand-edits:")
      for f in merge.missing_blocks:
        print ("  File: {0}".format(f))
        for l in merge.missing_blocks[f]:
          print("    \"{0}\"".format(l))
      print("  Use backup or revision control source to recover the original content of these blocks")

if __name__ == '__main__':
  run()
