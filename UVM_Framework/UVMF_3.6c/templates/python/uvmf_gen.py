#! /usr/bin/env python

##############################################################################
## Copyright 2015 Mentor Graphics
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
##   Creation date : April 12 2015
##
##############################################################################
##
##   This module facilitates the creation of UVMF interface packages, 
##   environment packages and testbench packages through the use of Jinja2-
##   based template files.  
##
##   See templates.README for more information on usage
##
##############################################################################

import os
import time
import re
import inspect
import sys
from optparse import OptionParser
try:
  import jinja2
except ImportError,e:
  print "ERROR : Jinja2 package not found.  See templates.README for more information"
  sys.exit(1)

## Underlying class definitions
class UserError(Exception):
  def __init__(self,value):
    self.value = value
  def __str__(self):
    return repr(self.value)

## Base element class for use in other generators
class BaseElementClass(object):
  def __init__(self,name):
    self.name = name

## Base class for all 'interface' type classes (port, config, transaction, etc.)
class BaseElementInterfaceClass(BaseElementClass):
  def __init__(self,name,type,isrand=False):
    super(BaseElementInterfaceClass,self).__init__(name)
    self.type = type
    self.isrand = isrand

## Base class for the generator types, this is where the create method is defined.
class BaseGeneratorClass(BaseElementClass):
  def __init__(self,name):
    super(BaseGeneratorClass,self).__init__(name)

  def create(self,desired_template='all'):
    """This exists across all generator classes and will initiate the creation of all files associated
    with the given object type.  Command-line options are also availale in any script that calls this 
    function, use the -help switch for details."""
    parser = OptionParser()
    parser.add_option("-c","--clean",dest="clean",action="store_true",help="Clean up generated code instead of generate code")
    parser.add_option("-q","--quiet",dest="quiet",action="store_true",help="Suppress output while running")
    parser.add_option("-d","--dest_dir",dest="dest_dir",action="store",type="string",help="Override destination directory.  Default is \"$CWD/uvmf_template_output\"")
    parser.add_option("-t","--template_dir",dest="template_dir",action="store",type="string",help="Override which template directory to utilize.  Default is relative to location of uvmf_gen.py file")
    parser.add_option("-o","--overwrite",dest="overwrite",action="store_true",help="Overwrite existing output files (default is to skip)",default=False)
    (options,args) = parser.parse_args()
    # Use USER for Linux or USERNAME for Windows
    if (os.name == 'nt'):
      user = os.environ["USERNAME"]
    else:
      user = os.environ["USER"]
    lt = time.localtime()
    year = time.strftime("%Y",lt)
    date = time.strftime("%Y %b %d",lt)
    # Determine root.  This is where we will be placing output.
    if (options.dest_dir != None):
      if (os.path.isdir(os.path.abspath(options.dest_dir)) == False):
        raise UserError("Destination directory \""+options.dest_dir+"\" specified on command line is not valid")
      root = os.path.abspath(options.dest_dir)
    else:
      # Default location is current working directory plus 'uvmf_template_output'
      root = os.path.join(os.getcwd(),"uvmf_template_output")
    # Determine location of template files.  Can specify via command-line or relative to location of this file
    if (options.template_dir != None):
      template_path = options.template_dir
    else:
      template_path = os.path.join(os.path.dirname(inspect.getfile(self.__class__)),"template_files")
    if (os.path.isdir(template_path) == False):
      raise UserError("Specified path \""+template_path+"\" to template directory not valid")
    if (options.quiet != True):
      print "Using templates in "+template_path
    templateLoader = jinja2.FileSystemLoader(searchpath=[os.path.join(template_path,self.template_ext_dir),os.path.join(template_path,'base_templates')]) 
    templateEnv = jinja2.Environment(loader = templateLoader,trim_blocks=True)
    cleanupdirs = []
    if (desired_template == 'all'):
      templates = templateEnv.list_templates()
      if (len(templates) == 0):
        raise UserError("No templates found in "+mypath)
      try:
        templates.remove("base_template.TMPL")
      except:
        pass
    else:
      templates = [desired_template]
    for template_str in templates:
      template = templateEnv.get_template(template_str)
      fname = re.sub('\{\{name\}\}',self.name,template.module.fname)
      try:
        isExecutable = template.module.isExecutable
      except AttributeError:
        isExecutable = False
      full = os.path.abspath(os.path.join(root,fname))
      dirpath = os.path.dirname(full)
      if (options.clean == True):
        if (options.quiet != True):
          print "Removing "+full
        if (dirpath not in cleanupdirs):
          cleanupdirs.append(dirpath)
        try:
          os.remove(full)
        except OSError:
          pass
      else:
        if (os.path.exists(full) & os.path.isfile(full) & (options.overwrite == False)):
          if (options.quiet != True):
            print "Skipping "+full+", already exists"
        else:
          if (options.quiet != True):
            print "Generating "+full
          templateVars = self.initTemplateVars({ "user" : user,
                                                 "name" : self.name,
                                                 "year" : year,
                                                 "date" : date,
                                                 "root_dir" : root
                                               })
          if (os.path.exists(dirpath) == False):
            os.makedirs(dirpath)
          fh = open(full,'w')
          fh.write(template.render(templateVars))
          fh.close()
          if (isExecutable):
            st = os.stat(full)
            os.chmod(full,st.st_mode | 0111)
    if (options.clean == True):
      for dir in cleanupdirs:
        try:
          os.removedirs(dir)
        except OSError:
          pass

## Extensions from base element class for direct use in generators
class PortClockClass(BaseElementInterfaceClass):
  def __init__(self,name):
    self.name = name

## Extensions from base element class for direct use in generators
class PortResetClass(BaseElementInterfaceClass):
  def __init__(self,name):
    self.name = name

## Extensions from base element class for direct use in generators
class PortClass(BaseElementInterfaceClass):
  def __init__(self,name,width,dir,type='tri',isrand=False):
    super(PortClass,self).__init__(name,type,isrand)
    self.width = width
    if (width==1):
      self.vector = ''
    else:
      self.vector = '[{0}:0]'.format(width-1)
    if (dir not in ['input','output','inout']):
      raise UserError("Port direction ("+dir+") must be input, output or inout")
    self.dir = dir

class ConfigClass(BaseElementInterfaceClass):
  def __init__(self,name,type,isrand=False):
    super(ConfigClass,self).__init__(name,type,isrand)

class TypeClass(BaseElementClass):
  def __init__(self,name,type):
    super(TypeClass,self).__init__(name)
    self.type = type

class ParamDef(BaseElementClass):       
  def __init__(self,name,type,value): 
    super(ParamDef,self).__init__(name)  
    self.type = type              
    self.value = value 

class TransClass(BaseElementInterfaceClass):
  def __init__(self,name,type,isrand=False):
    super(TransClass,self).__init__(name,type,isrand)

class AgentClass(BaseElementClass):
  def __init__(self,name,ifPkg,clk,rst):
    super(AgentClass,self).__init__(name)
    self.ifPkg = ifPkg
    self.clk = clk
    self.rst = rst

class InterfaceClass(BaseGeneratorClass):
  """Use this class to produce files associated with a particular interface or agent package"""
  
  def __init__(self,name):
    super(InterfaceClass,self).__init__(name)
    self.template_ext_dir = 'interface_templates'
    self.ports = []
    self.clock = 'defaultClk'
    self.reset = 'defaultRst'
    self.hdlTypedefs = []
    self.hdlParamDefs = []
    self.hvlTypedefs = []
    self.transVars = []
    self.veloceReady = True
    self.configVars = []

  def initTemplateVars(self,template):
    template['sigs'] = self.ports
    template['clock'] = self.clock
    template['reset'] = self.reset
    template['inputPorts'] = self.getInputPorts()
    template['outputPorts'] = self.getOutputPorts()
    template['inoutPorts'] = self.getInoutPorts()
    template['veloceReady'] = self.veloceReady
    template['configVars'] = self.configVars
    template['hdlTypedefs'] = self.hdlTypedefs
    template['hdlParamDefs'] = self.hdlParamDefs
    template['hvlTypedefs'] = self.hvlTypedefs
    template['transVars'] = self.transVars
    return template

  def addPort(self,name,width,dir,type='tri'):
    """Add an interface port definition"""
    self.ports.append(PortClass(name,width,dir,type))

  def addHdlTypedef(self,name,type):
    """Add a typedef to the interface class's hdl typedefs file"""
    self.hdlTypedefs.append(TypeClass(name,type))

  def addHvlTypedef(self,name,type):
    """Add a typedef to the interface class's hvl typedefs file"""
    self.hvlTypedefs.append(TypeClass(name,type))

  def addHdlParamDef(self,name,type,value):
    """Add a parameter to the interface class's hdl typedefs file"""
    self.hdlParamDefs.append(ParamDef(name,type,value))

  def addTransVar(self,name,type,isrand=False):
    """Add a variable to the interface class's sequence item definition"""
    self.transVars.append(TransClass(name,type,isrand))

  def addConfigVar(self,name,type,isrand=False):
    """Add a configuration variable to the interface class's configuration object definition"""
    self.configVars.append(ConfigClass(name,type,isrand))

  def getPorts(self,type):
    p = []
    for port in self.ports:
      if port.dir == type:
        p.append(port)
    return p

  def getOutputPorts(self):
    return self.getPorts('output')

  def getInputPorts(self):
    return self.getPorts('input')

  def getInoutPorts(self):
    return self.getPorts('inout')

class EnvironmentClass(BaseGeneratorClass):
  """Use this class to generate files associated with an environment package"""
  def __init__(self,name):
    super(EnvironmentClass,self).__init__(name)
    self.template_ext_dir = 'environment_templates'
    self.agents = []
    self.agent_packages = []

  def initTemplateVars(self,template):
    template['agents'] = self.agents
    template['agent_pkgs'] = self.agent_packages
    return template

  def addAgent(self,name,ifPkg,clk,rst):
    """Add an agent instantiation to the definition of this environment class"""
    self.agents.append(AgentClass(name,ifPkg,clk,rst))
    if (ifPkg not in self.agent_packages):
      self.agent_packages.append(ifPkg)

class BenchClass(EnvironmentClass):
  """Use this class to generate files associated with a particular testbench"""

  def __init__(self,name,env_name):
    super(BenchClass,self).__init__(name)
    self.env_name = env_name
    self.template_ext_dir = 'bench_templates'
    self.veloceReady = True

  def initTemplateVars(self,template):
    template = super(BenchClass,self).initTemplateVars(template)
    template['env_name'] = self.env_name
    template['veloceReady'] = self.veloceReady
    return template
