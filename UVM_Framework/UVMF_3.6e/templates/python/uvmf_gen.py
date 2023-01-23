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
print "JINJA2 VERSION:"+jinja2.__version__
if (float(jinja2.__version__) < 2.8):
  print "ERROR : Jinja2 package version "+jinja2.__version__+" incorrect, must be 2.8 or later"
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

## Base class for all 'interface' Constraints type classes
class BaseElementConstraintsClass(BaseElementClass):
  def __init__(self,name,type):
    super(BaseElementConstraintsClass,self).__init__(name)
    self.type = type

## Base class for all 'Environment' type classes
class BaseElementEnvironmentClass(BaseElementClass):
  def __init__(self,name,type,isrand=False):
    super(BaseElementEnvironmentClass,self).__init__(name)
    self.type = type
    self.isrand = isrand

## Base class for the generator types, this is where the create method is defined.
class BaseGeneratorClass(BaseElementClass):
  def __init__(self,name):
    super(BaseGeneratorClass,self).__init__(name)

  def runTemplate(self,template_str,desired_conditional="",ExtraTemplateVars={}):
    """Generate a particular template.  Return early without doing anything if desired_conditional
    is non-blank and doesn't match the condidional field in the given template"""
    template = self.templateEnv.get_template(template_str)
    templateVars = self.initTemplateVars({ "user" : self.user,
                                           "name" : self.name,
                                           "year" : self.year,
                                           "date" : self.date,
                                           "root_dir" : self.root
                                         })
    templateVars.update(ExtraTemplateVars)
    fname = template.module.fname
    for key in templateVars:
      if type(templateVars[key]) is str:
        # Skip root_dir reference, it isn't supported and causes havoc on Windows
        # if passed into the regexp parser under certain conditions. Certain directory
        # names starting with certain letters can wind up looking like escape sequences
        # that the regexp parser. So far, I'm aware of "\g"
        if (key != 'root_dir'):
          fname = re.sub('\{\{'+key+'\}\}',templateVars[key],fname)
    try:
      conditional = template.module.conditional
      if (conditional != desired_conditional):
        return
    except:
      if (desired_conditional != ""):
        return
      pass
    full = os.path.abspath(os.path.join(self.root,fname))
    dirpath = os.path.dirname(full)
    try:
      symlink = os.path.abspath(os.path.expandvars(re.sub('\{\{name\}\}',self.name,template.module.symlink)))
      ## For a symbolic link, "fname" represents the symbolink link name and
      ##   "symlink" represents the source
      if (self.options.clean == True):
        if (self.options.quiet != True):
          print "Removing symbolic link "+full
        if (dirpath not in self.cleanupdirs):
          re.sub('\{\{name\}\}',self.name,template.module.symlink)
          self.cleanupdirs.append(dirpath)
        try:
          os.remove(full)
        except OSError:
          pass
      else:
        if (os.path.exists(full) & (self.options.overwrite == False)):
          if (self.options.quiet != True):
            print "Skipping symbolic link "+symlink+", already exists"
        else:
          if (self.options.quiet != True):
            print "Creating symbolic link "+full+" pointing to "+symlink
          if (os.path.exists(dirpath) == False):
            os.makedirs(dirpath)
          # os.symlink will fail if the file already exists, so delete it first.  Dangerous but the only
          # way to get here in that case is to have thrown the --overwrite switch so assume user knows
          # the risks.
          if (os.path.exists(full)):
            os.remove(full)
          os.symlink(symlink,full)
      return
    except AttributeError:
     isSymlink = False
    try:
      isExecutable = template.module.isExecutable
    except AttributeError:
      isExecutable = False
    if (self.options.clean == True):
      if (self.options.quiet != True):
        print "Removing "+full
      if (dirpath not in self.cleanupdirs):
        self.cleanupdirs.append(dirpath)
      try:
        os.remove(full)
      except OSError:
        pass
    else:
      if (os.path.exists(full) & os.path.isfile(full) & (self.options.overwrite == False)):
        if (self.options.quiet != True):
          print "Skipping "+full+", already exists"
      else:
        if (self.options.quiet != True):
          print "Generating "+full
        if (os.path.exists(dirpath) == False):
          os.makedirs(dirpath)
        fh = open(full,'w')
        fh.write(template.render(templateVars))
        fh.close()
        if (isExecutable):
          st = os.stat(full)
          os.chmod(full,st.st_mode | 0111)

  def create(self,desired_template='all'):
    """This exists across all generator classes and will initiate the creation of all files associated
    with the given object type.  Command-line are also availale in any script that calls this 
    function, use the -help switch for details."""
    parser = OptionParser()
    parser.add_option("-c","--clean",dest="clean",action="store_true",help="Clean up generated code instead of generate code")
    parser.add_option("-q","--quiet",dest="quiet",action="store_true",help="Suppress output while running")
    parser.add_option("-d","--dest_dir",dest="dest_dir",action="store",type="string",help="Override destination directory.  Default is \"$CWD/uvmf_template_output\"")
    parser.add_option("-t","--template_dir",dest="template_dir",action="store",type="string",help="Override which template directory to utilize.  Default is relative to location of uvmf_gen.py file")
    parser.add_option("-o","--overwrite",dest="overwrite",action="store_true",help="Overwrite existing output files (default is to skip)",default=False)
    parser.add_option("-b","--debug",dest="debug",action="store_true",help="Enable Python traceback for debug purposes",default=False)
    (self.options,args) = parser.parse_args()
    # Use USER for Linux or USERNAME for Windows
    if (os.name == 'nt'):
      self.user = os.environ["USERNAME"]
    else:
      self.user = os.environ["USER"]
    if (self.options.debug == False):
      sys.tracebacklimit = 0
    lt = time.localtime()
    self.year = time.strftime("%Y",lt)
    self.date = time.strftime("%Y %b %d",lt)
    # Determine root.  This is where we will be placing output.
    if (self.options.dest_dir != None):
      dest_dir = self.options.dest_dir
      if (os.path.isdir(os.path.abspath(self.options.dest_dir)) == False):
        os.makedirs(os.path.abspath(self.options.dest_dir))
      self.root = os.path.abspath(self.options.dest_dir)
    else:
      # Default location is current working directory plus 'uvmf_template_output'
      dest_dir = "uvmf_template_output"
      self.root = os.path.join(os.getcwd(),"uvmf_template_output")
    # Determine location of template files.  Can specify via command-line or relative to location of this file
    if (self.options.template_dir != None):
      template_path = self.options.template_dir
    else:
      template_path = os.path.join(os.path.dirname(inspect.getfile(self.__class__)),"template_files")
    if (os.path.isdir(template_path) == False):
      raise UserError("Specified path \""+template_path+"\" to template directory not valid")
    # Check that the only files in the path are TMPL files - die if anything else is found since
    # non-TMPL files could cause very weird Jinja2 errors that we don't want to debug
    paths = [os.path.join(template_path,self.template_ext_dir),os.path.join(template_path,'base_templates')]
    for path in paths:
      for fname in os.listdir(path):
        fn,ext = os.path.splitext(fname)
        if (ext != '.TMPL'):
          raise UserError("Found non-TMPL file \""+fname+"\" during load, exiting")
    templateLoader = jinja2.FileSystemLoader(searchpath=paths) 
    self.templateEnv = jinja2.Environment(loader = templateLoader,trim_blocks=True)
    self.cleanupdirs = []
    if (desired_template == 'all'):
      templates = self.templateEnv.list_templates()
      if (len(templates) == 0):
        raise UserError("No templates found in "+mypath)
      try:
        templates.remove("base_template.TMPL")
      except:
        pass
    else:
      templates = [desired_template]
    for template_str in templates:
      self.runTemplate(template_str)
    if (self.options.clean == True):
      cwd = os.getcwd();
      os.chdir(self.root)
      for dir in self.cleanupdirs:
        try:
          if (os.path.exists(dir)):
            (dir,num) = re.subn(self.root+"/","",dir)
            if (num > 0):
              if (self.options.quiet != True):
                print "Removing directory "+dir
              os.removedirs(dir)
        except OSError:
          pass
      os.chdir(cwd)

## Extensions from base element class for direct use in generators
class PortClockClass(BaseElementInterfaceClass):
  def __init__(self,name):
    self.name = name

class PortResetClass(BaseElementInterfaceClass):
  def __init__(self,name):
    self.name = name

class PortClass(BaseElementInterfaceClass):
  def __init__(self,name,width,dir,type='tri',isrand=False):
    super(PortClass,self).__init__(name,type,isrand)
    self.width = width
    if (width==1):
      self.vector = ''
    elif isinstance(width,int):
      self.vector = '[{0}:0]'.format(width-1)
    else:
      self.vector = '['+width+'-1:0]'
    if (dir not in ['input','output','inout']):
      raise UserError("Port direction ("+dir+") must be input, output or inout")
    self.dir = dir

class InterfaceConfigClass(BaseElementInterfaceClass):
  def __init__(self,name,type,isrand=False):
    super(InterfaceConfigClass,self).__init__(name,type,isrand)

class EnvironmentConfigClass(BaseElementEnvironmentClass):
  def __init__(self,name,type,isrand=False):
    super(EnvironmentConfigClass,self).__init__(name,type,isrand)

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
  def __init__(self,name,type,isrand=False,iscompare=True):
    super(TransClass,self).__init__(name,type,isrand)
    self.iscompare = iscompare

class ConstraintsClass(BaseElementConstraintsClass):
  def __init__(self,name,type):
    super(ConstraintsClass,self).__init__(name,type)

class ParameterValueClass(BaseElementClass):
  def __init__(self,name,value):
    super(ParameterValueClass,self).__init__(name)
    self.value = value

class AgentClass(BaseElementClass):
  def __init__(self,name,ifPkg,clk,rst,agentIndex,parametersDict):
    super(AgentClass,self).__init__(name)
    self.ifPkg = ifPkg
    self.clk = clk
    self.rst = rst
    self.agentIndex = agentIndex
    self.parameters = []
    for parameterName in parametersDict:
      self.parameters.append(ParameterValueClass(parameterName,parametersDict[parameterName]))

class analysisComponentClass(BaseElementClass):
  def __init__(self,keyword,name,aeDict,apDict):
    super(analysisComponentClass,self).__init__(name)
    self.keyword = keyword
    self.analysisExports = []
    self.analysisPorts = []
    for aeName in aeDict:
      self.analysisExports.append(AnalysisExportClass(aeName,aeDict[aeName]))
    for apName in apDict:
      self.analysisPorts.append(AnalysisPortClass(apName,apDict[apName]))

class BfmClass(BaseElementClass):
  def __init__(self,name,ifPkg,clk,rst,activity,parametersDict,sub_env_path):
    super(BfmClass,self).__init__(name)
    self.ifPkg = ifPkg
    self.clk = clk
    self.rst = rst
    self.activity = activity
    self.sub_env_path = sub_env_path
    self.parameters = []
    for parameterName in parametersDict:
      self.parameters.append(ParameterValueClass(parameterName,parametersDict[parameterName]))

class QvipAgentClass(BaseElementClass):
  def __init__(self,name,ifPkg,activity):
    super(QvipAgentClass,self).__init__(name)
    self.ifPkg = ifPkg
    self.activity = activity

class StringInterfaceNamesClass(BaseElementClass):
  def __init__(self,name,value,agent_name,ifPkg,activity):
    super(StringInterfaceNamesClass,self).__init__(name)
    self.value =value
    self.agent_name = agent_name
    self.ifPkg = ifPkg
    self.activity = activity

class SubEnvironmentClass(BaseElementClass):
  def __init__(self,name,envPkg,numAgents,agent_index,parametersDict):
    super(SubEnvironmentClass,self).__init__(name)
    self.envPkg = envPkg
    self.numAgents = numAgents
    self.agentMinIndex = agent_index
    self.agentMaxIndex = agent_index+numAgents-1
    self.parameters = []
    for parameterName in parametersDict:
      self.parameters.append(ParameterValueClass(parameterName,parametersDict[parameterName]))

class QvipSubEnvironmentClass(BaseElementClass):
  def __init__(self,name,envPkg,numAgents,agent_index,agentList):
    super(QvipSubEnvironmentClass,self).__init__(name)
    self.envPkg = envPkg
    self.numAgents = numAgents
    self.agentMinIndex = agent_index
    self.agentMaxIndex = agent_index+numAgents-1
    self.qvip_if_name = []
    for element in agentList:
      self.qvip_if_name.append(element)

class QvipConnectionClass(object):
  def __init__(self, output_component, output_port_name, input_component, input_component_export_name):
    self.output_component = output_component
    self.output_port_name = output_port_name
    self.input_component = input_component
    self.input_component_export_name = input_component_export_name

class QvipAPClass(BaseElementClass):
  def __init__(self,name,agent):
    super(QvipAPClass,self).__init__(name)
    self.agent = agent

class AnalysisExportClass(BaseElementClass):
  def __init__(self,name,tType):
    super(AnalysisExportClass,self).__init__(name)
    self.tType = tType

class AnalysisPortClass(BaseElementClass):
  def __init__(self,name,tType):
    super(AnalysisPortClass,self).__init__(name)
    self.tType = tType

class analysisComponentInstClass(BaseElementClass):
  def __init__(self,name,type):
    super(analysisComponentInstClass,self).__init__(name)
    self.type = type

class envScoreboardClass(BaseElementClass):
  def __init__(self,name,sType,tType):
    super(envScoreboardClass,self).__init__(name)
    self.sType = sType
    self.tType = tType

class connectionClass(BaseElementClass):
  def __init__(self,name,pName,subscriberName, aeName):
    super(connectionClass,self).__init__(name)
    self.pName = pName
    self.subscriberName = subscriberName
    self.aeName = aeName

class InterfaceClass(BaseGeneratorClass):
  """Use this class to produce files associated with a particular interface or agent package"""
  
  def __init__(self,name):
    super(InterfaceClass,self).__init__(name)
    self.template_ext_dir = 'interface_templates'
    self.ports = []
    self.clock = 'defaultClk'
    self.reset = 'defaultRst'
    self.hdlTypedefs = []
    self.paramDefs = []
    self.hvlTypedefs = []
    self.transVars = []
    self.transVarsConstraints = []
    self.configVarsConstraints = []
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
    template['paramDefs'] = self.paramDefs
    template['hvlTypedefs'] = self.hvlTypedefs
    template['transVars'] = self.transVars
    template['transVarsConstraints'] = self.transVarsConstraints
    template['configVarsConstraints'] = self.configVarsConstraints
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

  def addParamDef(self,name,type,value):
    """Add a parameter to the interface package"""
    self.paramDefs.append(ParamDef(name,type,value))

  def addTransVar(self,name,type,isrand=False,iscompare=True):
    """Add a variable to the interface class's sequence item definition"""
    self.transVars.append(TransClass(name,type,isrand,iscompare))

  def addTransVarConstraint(self,name,type):
    """Add a constraint to the interface class's Constraint item definition"""
    self.transVarsConstraints.append(ConstraintsClass(name,type))

  def addConfigVar(self,name,type,isrand=False):
    """Add a configuration variable to the interface class's configuration object definition"""
    self.configVars.append(InterfaceConfigClass(name,type,isrand))

  def addConfigVarConstraint(self,name,type):
    """Add a constraint to the config class's Constraint item definition"""
    self.configVarsConstraints.append(ConstraintsClass(name,type))

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
    self.qvip_agents = []
    self.external_imports = []
    self.paramDefs = []
    self.agentIndex = 0
    self.subEnvironments = []
    self.qvipSubEnvironments = []
    self.qvipConnections = []
    self.qvip_ap_names = []
    self.agent_packages = []
    self.qvip_agent_packages = []
    self.sub_env_packages = []
    self.qvip_sub_env_packages = []
    self.analysisComponents = []
    self.analysisComponentTypes = []
    self.impDecls = []
    self.scoreboards = []
    self.connections = []
    self.p2sConns = []
    self.m2sConns = []
    self.c2eConns = []
    self.acTypes = []
    self.configVars = []
    self.configVarsConstraints = []

  def initTemplateVars(self,template):
    template['agents'] = self.agents
    template['qvip_agents'] = self.qvip_agents
    template['external_imports'] = self.external_imports
    template['paramDefs'] = self.paramDefs
    template['subEnvironments'] = self.subEnvironments
    template['qvipSubEnvironments'] = self.qvipSubEnvironments
    template['qvipConnections'] = self.qvipConnections
    template['qvip_ap_names'] = self.qvip_ap_names
    template['agent_pkgs'] = self.agent_packages
    template['qvip_agent_pkgs'] = self.qvip_agent_packages
    template['env_pkgs'] = self.sub_env_packages
    template['qvip_env_pkgs'] = self.qvip_sub_env_packages
    template['analysisComponents'] = self.analysisComponents
    template['acTypes'] = self.acTypes
    template['scoreboards'] = self.scoreboards
    template['connections'] = self.connections
    template['p2sConnections'] = self.p2sConns
    template['m2sConnections'] = self.m2sConns
    template['c2eConnections'] = self.c2eConns
    template['impDecls'] = self.impDecls
    template['configVars'] = self.configVars
    template['configVarsConstraints'] = self.configVarsConstraints
    return template

  def addParamDef(self,name,type,value):
    """Add a parameter to the environment package"""
    self.paramDefs.append(ParamDef(name,type,value))

  def addImport(self,name):
    """Add an import to the environment package declaration  """
    self.external_imports.append(name)

  def addAgent(self,name,ifPkg,clk,rst,parametersDict={}):
    """Add an agent instantiation to the definition of this environment class"""
    self.agents.append(AgentClass(name,ifPkg,clk,rst,self.agentIndex,parametersDict))
    self.agentIndex = self.agentIndex + 1
    if (ifPkg not in self.agent_packages):
      self.agent_packages.append(ifPkg)

  def addSubEnv(self,name,envPkg,numAgents,parametersDict={}):
    """Add a sub environment instantiation to the definition of this environment class"""
    self.subEnvironments.append(SubEnvironmentClass(name,envPkg,numAgents,self.agentIndex,parametersDict))
    self.agentIndex = self.agentIndex+numAgents
    if (envPkg not in self.sub_env_packages):
      self.sub_env_packages.append(envPkg)

  def addQvipSubEnv(self,name,envPkg,agentList):
    """Add a sub environment instantiation to the definition of this environment class"""
    self.numAgents = agentList.__len__()
    self.qvipSubEnvironments.append(QvipSubEnvironmentClass(name,envPkg,self.numAgents,self.agentIndex,agentList))
    # line below updates agentIndex after appending info to qvip_if_name array 
    self.agentIndex = self.agentIndex+self.numAgents
    if (envPkg not in self.qvip_sub_env_packages):
      self.qvip_sub_env_packages.append(envPkg)
    for element in agentList:
      self.qvip_ap_names.append(QvipAPClass(name,element))

  def addQvipConnection(self, output_component, output_port_name, input_component, input_component_export_name):
    """Add a Qvip Connection for the environment package"""
    self.qvipConnections.append(QvipConnectionClass(output_component, output_port_name, input_component, input_component_export_name))

  def addImpDecl(self,name):
    """Add an impDecl call for this environment package"""
    if (name not in self.impDecls):
      self.impDecls.append(name)

  def addAnalysisComponentType(self,name):
    """Add an analysis component type for use in this environment package"""
    if (name not in self.acTypes):
      self.acTypes.append(name)

  def addConfigVar(self,name,type,isrand=False):
    """Add a configuration variable to the environment class's configuration object definition"""
    self.configVars.append(EnvironmentConfigClass(name,type,isrand))

  def addConfigVarConstraint(self,name,type):
    """Add a constraint to the config class's Constraint item definition"""
    self.configVarsConstraints.append(ConstraintsClass(name,type))

  def defineAnalysisComponent(self,keyword,name,exportDict,portDict):
    """Defines a type of analysis component for use later on."""
    ## Register the desired analysis component on the types array
    self.analysisComponentTypes.append(analysisComponentClass(keyword,name,exportDict,portDict))
    self.addAnalysisComponentType(name)
    ## Add any non-existent imp-decl calls based on contents of the aeDict
    for aeName in exportDict:
      self.addImpDecl(aeName)

  # addAnalysisComponent(instanceName, analysisComponentType)
  def addAnalysisComponent(self, name, pType):
    """Add an analysis component instance  to the definition of this environment class"""
    self.analysisComponents.append(analysisComponentInstClass(name,pType))

  # addUvmfScoreboard(instanceName, scoreboardType, transactionType)
  def  addUvmfScoreboard(self, name, sType, tType):
    """Add scoreboard instance to the definition of this environment class"""
    self.scoreboards.append(envScoreboardClass(name,sType,tType))

  # addConnection(outputComponentName, outputPortName, inputComponentName, inputPortName)
  def  addConnection(self, name, pName, subscriberName, aeName):
    """Add a connection between two components in the definition of this environment class"""
    self.connections.append(connectionClass(name,pName,subscriberName, aeName))

  ## Overload of the create function - add some extra loops on the end for analysis components
  def create(self,desired_template='all'):
    """Environment class specific create function - allows for the production of multiple analysis component files"""
    super(EnvironmentClass,self).create(desired_template)
    for analysisComp in self.analysisComponentTypes:
      self.runTemplate("predictor.TMPL","predictor",{"name":analysisComp.name,
                                                     "env_name":self.name,
                                                     "exports":analysisComp.analysisExports,
                                                     "ports":analysisComp.analysisPorts})

class BenchClass(BaseGeneratorClass):
  """Use this class to generate files associated with a particular testbench"""

  def __init__(self,name,env_name,parametersDict={}):
    super(BenchClass,self).__init__(name)
    self.env_name = env_name
    self.template_ext_dir = 'bench_templates'
    self.bfms = []
    self.bfm_packages = []
    self.qvip_bfms = []
    self.qvip_bfm_packages = []
    self.qvip_pkg_env_variables = []
    self.resource_parameter_names = []
    self.veloceReady = False
    self.external_imports = []
    self.paramDefs = []
    self.envParamDefs = []
    for parameterName in parametersDict:
      self.envParamDefs.append(ParameterValueClass(parameterName,parametersDict[parameterName]))

  def initTemplateVars(self,template):
    template['env_name'] = self.env_name
    template['resource_parameter_names'] = self.resource_parameter_names
    template['bfms'] = self.bfms
    template['bfm_pkgs'] = self.bfm_packages
    template['qvip_bfms'] = self.qvip_bfms
    template['qvip_bfm_pkgs'] = self.qvip_bfm_packages
    template['qvip_pkg_env_variables'] = self.qvip_pkg_env_variables
    template['veloceReady'] = self.veloceReady
    template['external_imports'] = self.external_imports
    template['paramDefs'] = self.paramDefs
    template['envParamDefs'] = self.envParamDefs
    return template

  def addImport(self,name):
    """Add an import to the environment package declaration  """
    self.external_imports.append(name)

  def addParamDef(self,name,type,value):
    """Add a parameter to the interface package"""
    self.paramDefs.append(ParamDef(name,type,value))

  def addBfm(self,name,ifPkg,clk,rst,activity,parametersDict={},sub_env_path='environment'):
    """Add a BFM instantiation to the definition of this bench class"""
    self.package_name="_pkg_"+name+"_BFM"
    self.value_name=ifPkg+"_pkg_"+name+"_BFM"
    self.resource_parameter_names.append(StringInterfaceNamesClass(self.package_name,self.value_name,name,ifPkg,activity))
    self.bfms.append(BfmClass(name,ifPkg,clk,rst,activity,parametersDict,sub_env_path))
    if (ifPkg not in self.bfm_packages):
      self.bfm_packages.append(ifPkg)

  def addQvipBfm(self,name,ifPkg,activity):
    """Instantiate the qvip BFMs to the definition of this bench class"""
    self.package_name="_pkg_"+name+"_BFM"
    self.resource_parameter_names.append(StringInterfaceNamesClass(self.package_name,name,name,ifPkg,activity))
    self.qvip_bfms.append(QvipAgentClass(name,ifPkg,activity))
    if (ifPkg not in self.qvip_bfm_packages):
      self.qvip_bfm_packages.append(ifPkg)
      self.qvip_pkg_env_variables.append(unicode(ifPkg).upper())

class PredictorClass(BaseGeneratorClass):
  """Use this class to generate a predictor"""
  def __init__(self,name):
    super(PredictorClass,self).__init__(name)
    self.template_ext_dir = 'analysis_templates'
    self.exports = []
    self.ports = []

  def initTemplateVars(self,template):
    template = super(BenchClass,self).initTemplateVars(template)
    template['exports'] = self.exports
    template['ports'] = self.ports
    return template

  def addAnalysisExport(self,name,tType):
    """Add an analysis_export instantiation to the definition of this predictor class"""
    self.exports.append(AnalysisExportClass(name,tType))

  def addAnalysisPort(self,name,tType):
    """Add an analysis_port instantiation to the definition of this predictor class"""
    self.ports.append(AnalysisPortClass(name,tType))

