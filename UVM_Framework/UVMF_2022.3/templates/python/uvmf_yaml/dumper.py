from uvmf_gen import UserError
import re
import copy

class Dumper:

  def __init__(self,generatorObj,is_archive=False):
    if (generatorObj.gen_type == 'interface'):
      dumper = InterfaceDumper(generatorObj,is_archive)
    elif (generatorObj.gen_type == 'environment'):
      dumper = EnvironmentDumper(generatorObj,is_archive)
      ## Look for any underlying utility component definitions as well
      util_dumpers = []
      for obj in generatorObj.analysisComponentTypes:
        util_dumpers.append(ComponentDumper(obj,is_archive))
    elif (generatorObj.gen_type == 'bench'):
      dumper = BenchDumper(generatorObj,is_archive)
    else:
      raise UserError("Dumper - Unknown type "+str(generatorObj.gen_type))
    self.data = dumper.data
    self.util_data = []
    if (generatorObj.gen_type == 'environment'):
      for d in util_dumpers:
        self.util_data.append(d.data)

class BenchDumper:

  def __init__(self,benchObj,is_archive=False):
    self.obj = benchObj;
    self.data = copy.copy(dict({'uvmf':dict({'benches':dict({self.obj.name:self.parseBench(is_archive)})})}))

  def parseBench(self,is_archive=False):
    data = {}
    if (is_archive == True):
      data['existing_library_component'] = "True"
    data['top_env'] = self.obj.env_name
    data['clock_half_period'] = self.obj.clockHalfPeriod
    data['clock_phase_offset'] = self.obj.clockPhaseOffset
    data['reset_assertion_level'] = str(self.obj.resetAssertionLevel)
    data['use_dpi_link'] = str(self.obj.useDpiLink)
    data['reset_duration'] = self.obj.resetDuration
    data['active_passive_default'] = self.obj.activePassiveDefault
    if (len(self.obj.paramDefs)):
      data['parameters'] = []
      for i in self.obj.paramDefs:
        if (i.value):
          data['parameters'].append({'name':i.name,'type':i.type,'value':i.value})
        else:
          data['parameters'].append({'name':i.name,'type':i.type})         
    if (len(self.obj.envParamDefs)):
      data['top_env_params'] = []
      for i in self.obj.envParamDefs:
        data['top_env_params'].append({'name':i.name,'value':i.value})
    data['interface_params'] = []
    data['active_passive'] = []
    for i in self.obj.bfms:
      data['active_passive'].append({'bfm_name':i.name,'value':i.activity})
      if (len(i.parameters)==0):
        ## No parameters on this BFM, skip and move to the next one
        continue
      params = []
      for j in i.parameters:
        params.append({'name':j.name,'value':j.value})
      data['interface_params'].append({'bfm_name':i.name,'value':params})
    if (len(self.obj.external_imports)):
      data['imports'] = []
      for i in self.obj.external_imports:
        data['imports'].append({'name':i})
    if (self.obj.useCoEmuClkRstGen == True):
      data['use_coemu_clk_rst_gen'] = 'True'
    if (self.obj.veloceReady == False):
      data['veloce_ready'] = "False"
    if (len(self.obj.additionalTops)):
      data['additional_tops'] = self.obj.additionalTops
    return data

class EnvironmentDumper:

  def __init__(self,environmentObj,is_archive=False):
    self.obj = environmentObj
    self.data = dict({'uvmf':dict({'environments':dict({self.obj.name:self.parseEnvironment(is_archive)})})})

  def parseEnvironment(self,is_archive=False):
    data = {}
    if (is_archive == True):
      data['existing_library_component'] = "True"
    data['qvip_memory_agents'] = []
    for i in self.obj.qvipMemoryAgents:
      params = []
      for p in i.parameters:
        params.append({'name':p.name,'value':p.value})
      data['qvip_memory_agents'].append({'name':i.name,'type':i.type,'qvip_environment':i.qvipEnv,'parameters':params})
    data['non_uvmf_components'] = []
    for i in self.obj.nonUvmfComponents:
      if (len(i.parameters)>0):
        params = []
        for p in i.parameters:
          params.append({'name':p.name,'value':p.value})
        data['non_uvmf_components'].append({'name':i.name,'type':i.type,'parameters':params})
      else:
        data['non_uvmf_components'].append({'name':i.name,'type':i.type})
    data['agents'] = []
    for i in self.obj.agents:
      if (len(i.parameters)>0):
        params = []
        for p in i.parameters:
          params.append({'name':p.name,'value':p.value})
        data['agents'].append({'name':i.name,'type':i.ifPkg,'parameters':params,'initiator_responder':i.initResp})
      else:
        data['agents'].append({'name':i.name,'type':i.ifPkg,'initiator_responder':i.initResp}) 
    data['subenvs'] = []
    for i in self.obj.subEnvironments:
      params = []
      for p in i.parameters:
        params.append({'name':p.name,'value':p.value})
      data['subenvs'].append({'name':i.name,'type':i.envPkg,'parameters':params})
    data['analysis_components'] = []
    for i in self.obj.analysisComponents:
      params = []
      for p in i.parameters:
        if (p.name != "CONFIG_T"):
          params.append({'name':p.name,'value':p.value})
      data['analysis_components'].append({'name':i.name,'type':i.type,'parameters':params}) # ,'extdef':'True'})
    data['scoreboards'] = []
    for i in self.obj.scoreboards:
      if (len(i.parameters)>0):
        params = []
        for p in i.parameters:
          params.append({'name':p.name,'value':p.value})
        data['scoreboards'].append({'name':i.name,'sb_type':i.sType,'trans_type':i.tType,'parameters':params})
      else:      
        data['scoreboards'].append({'name':i.name,'sb_type':i.sType,'trans_type':i.tType})
    data['analysis_ports'] = []
    for i in self.obj.analysis_ports:
      data['analysis_ports'].append({'name':i.name,'trans_type':i.tType,'connected_to':i.connection})
    data['analysis_exports'] = []
    for i in self.obj.analysis_exports:
      data['analysis_exports'].append({'name':i.name,'trans_type':i.tType,'connected_to':i.connection})
    data['config_vars'] = []
    for i in self.obj.configVars:
      data['config_vars'].append({'name':i.name,'type':i.type,'isrand':str(i.isrand),'value':str(i.value),'comment':i.comment})
    data['config_constraints'] = []
    for i in self.obj.configVarsConstraints:
      data['config_constraints'].append({'name':i.name,'value':i.type,'comment':i.comment})
    data['parameters'] = []
    for i in self.obj.paramDefs:
      if (i.value):
        data['parameters'].append({'name':i.name,'type':i.type,'value':i.value})
      else:
        data['parameters'].append({'name':i.name,'type':i.type})        
    data['hvl_pkg_parameters'] = []
    for i in self.obj.hvlPkgParamDefs:
      if (i.value):
        data['hvl_pkg_parameters'].append({'name':i.name,'type':i.type,'value':i.value})
      else:
        data['hvl_pkg_parameters'].append({'name':i.name,'type':i.type})        
    data['tlm_connections'] = []
    for i in self.obj.connections:
      driverHier = i.name;
      driverPort = i.pName;
      receiverHier = i.subscriberName;
      receiverPort = i.aeName;
      data['tlm_connections'].append({'driver':driverHier+"."+driverPort,'receiver':receiverHier+"."+receiverPort,'validate':str(i.validate)})
    if len(self.obj.regModels)>0:
      rm = self.obj.regModels[0]
      if rm.sequencer == None:
        data['register_model'] = { 'use_adapter': str(rm.useAdapter),
                                   'use_explicit_prediction': str(rm.useExplicitPrediction),
                                   'reg_model_package': str(rm.regModelPkg),
                                   'reg_block_class': str(rm.regBlockClass)
                                 }
      else:
        match = re.match(r"(.*)",rm.sequencer)
        ifname = match.group(1)
        data['register_model'] = { 'use_adapter': str(rm.useAdapter),
                                   'use_explicit_prediction': str(rm.useExplicitPrediction),
                                   'reg_model_package': str(rm.regModelPkg),
                                   'reg_block_class': str(rm.regBlockClass),
                                   'maps': [ { 'name': rm.busMap, 'interface': ifname, 'qvip_agent': str(rm.qvipAgent)} ]
                                  }
    if self.obj.soName!="":
      data['dpi_define'] = {}
      data['dpi_define']['name'] = self.obj.soName
      data['dpi_define']['comp_args'] = self.obj.DPICompArgs
      data['dpi_define']['link_args'] = self.obj.DPILinkArgs
      data['dpi_define']['files'] = []
      for i in self.obj.DPIFiles:
        data['dpi_define']['files'].append(i)
      if len(self.obj.DPIExports):
        data['dpi_define']['exports'] = self.obj.DPIExports
      if len(self.obj.DPIImports):
        data['dpi_define']['imports'] = []
        for i in self.obj.DPIImports:
          v = {}
          v['name'] = i.name
          v['c_return_type'] = i.cType
          v['sv_return_type'] = i.svType
          v['c_args'] = i.cArgs
          v['sv_args'] = i.arguments
          data['dpi_define']['imports'].append(v)
    if len(self.obj.qvipSubEnvironments):
      data['qvip_subenvs'] = []
      for i in self.obj.qvipSubEnvironments:
        data['qvip_subenvs'].append({'name':i.name,'type':i.envPkg})
    if len(self.obj.qvipConnections):
      data['qvip_connections'] = []
      for i in self.obj.qvipConnections:
        data['qvip_connections'].append({'driver':i.output_component,'ap_key':i.output_port_name,'receiver':i.input_component+"."+i.input_component_export_name,'validate':str(i.validate)})
    if (len(self.obj.external_imports)):
      data['imports'] = []
      for i in self.obj.external_imports:
        data['imports'].append({'name':i})
    if (len(self.obj.configVariableValues)):
      data['config_variable_values'] = []
      for i in self.obj.configVariableValues:
        data['config_variable_values'].append({'name':i.name,'value':i.value})
    if (len(self.obj.typedefs)):
      data['typedefs'] = []
      for i in self.obj.typedefs:
        data['typedefs'].append({'name':i.name,'type':i.type})
    if (len(self.obj.uvmc_cpp_files)):
      data['uvmc_files'] = self.obj.uvmc_cpp_files
    if (self.obj.uvmc_cpp_flags != ""):
      data['uvmc_flags'] = self.obj.uvmc_cpp_flags
    if (self.obj.uvmc_cpp_link_args != ""):
      data['uvmc_link_args'] = self.obj.uvmc_cpp_link_args
    return data

class ComponentDumper:

  def __init__(self,obj,is_archive=False):
    self.obj = obj
    self.data = dict({'uvmf':dict({'util_components':dict({self.obj.name:self.parseComponent(is_archive)})})})

  def parseComponent(self,is_archive=False):
    data = {}
    if (is_archive == True):
      data['existing_library_component'] = "True"
    data['type'] = self.obj.keyword
    if len(self.obj.analysisExports):
      data['analysis_exports'] = []
      for i in self.obj.analysisExports:
        data['analysis_exports'].append({'name':i.name,'type':i.tType})
    if len(self.obj.analysisPorts):
      data['analysis_ports'] = []
      for i in self.obj.analysisPorts:
        data['analysis_ports'].append({'name':i.name,'type':i.tType})
    if len(self.obj.qvipAnalysisExports):
      data['qvip_analysis_exports'] = []
      for i in self.obj.qvipAnalysisExports:
        data['qvip_analysis_exports'].append({'name':i.name,'type':i.tType})
    if len(self.obj.parameters):
      data['parameters'] = []
      for i in self.obj.parameters:
        if (i.value):
          data['parameters'].append({'name':i.name,'type':i.type,'value':i.value})
        else:
          data['parameters'].append({'name':i.name,'type':i.type})
    return data
     

class InterfaceDumper:

  def __init__(self,interfaceObj,is_archive=False):
    self.obj = interfaceObj
    self.data = dict({'uvmf':dict({'interfaces':dict({self.obj.name:self.parseInterface(is_archive)})})})

  def parseInterface(self,is_archive=False):
    data = {}
    if (is_archive == True):
      data['existing_library_component'] = "True"
    data['clock'] = str(self.obj.clock)
    data['reset'] = str(self.obj.reset)
    data['reset_assertion_level'] = str(self.obj.resetAssertionLevel)
    data['use_dpi_link'] = str(self.obj.useDpiLink)
    data['gen_inbound_streaming_driver'] = str(self.obj.genInBoundStreamingDriver)
    data['hdl_typedefs'] = []
    for i in self.obj.hdlTypedefs:
      data['hdl_typedefs'].append({'name':str(i.name),'type':str(i.type)})
    data['hvl_typedefs'] = []
    for i in self.obj.hvlTypedefs:
      data['hvl_typedefs'].append({'name':str(i.name),'type':str(i.type)})
    data['parameters'] = []
    for i in self.obj.paramDefs:
      if (i.value):
        data['parameters'].append({'name':i.name,'type':i.type,'value':i.value})
      else:
        data['parameters'].append({'name':i.name,'type':i.type})        
    data['hdl_pkg_parameters'] = []
    for i in self.obj.hdlPkgParamDefs:
      if (i.value):
        data['hdl_pkg_parameters'].append({'name':i.name,'type':i.type,'value':i.value})
      else:
        data['hdl_pkg_parameters'].append({'name':i.name,'type':i.type})        
    data['hvl_pkg_parameters'] = []
    for i in self.obj.hvlPkgParamDefs:
      if (i.value):
        data['hvl_pkg_parameters'].append({'name':i.name,'type':i.type,'value':i.value})
      else:
        data['hvl_pkg_parameters'].append({'name':i.name,'type':i.type})        
    data['ports'] = []
    for i in self.obj.ports:
      data['ports'].append({'name':str(i.name),'width':str(i.width),'dir':str(i.dir),'reset_value':str(i.rstValue)})
    data['transaction_vars'] = []
    for i in self.obj.transVars:
      data['transaction_vars'].append({'name':i.name,'type':i.type,'isrand':str(i.isrand),'iscompare':str(i.iscompare),'unpacked_dimension':i.unpackedDim,'comment':i.comment})
    data['transaction_constraints'] = []
    for i in self.obj.transVarsConstraints:
      data['transaction_constraints'].append({'name':i.name,'value':i.type,'comment':i.comment})
    data['config_vars'] = []
    for i in self.obj.configVars:
      data['config_vars'].append({'name':str(i.name),'type':str(i.type),'isrand':str(i.isrand),'value':str(i.value),'comment':i.comment})
    data['config_constraints'] = []
    for i in self.obj.configVarsConstraints:
      data['config_constraints'].append({'name':i.name,'value':i.type,'comment':i.comment})
    if self.obj.soName != "":
      data['dpi_define'] = {}
      data['dpi_define']['name'] = self.obj.soName
      data['dpi_define']['comp_args'] = self.obj.DPICompArgs
      data['dpi_define']['link_args'] = self.obj.DPILinkArgs
      data['dpi_define']['files'] = []
      for i in self.obj.DPIFiles:
        data['dpi_define']['files'].append(i)
      if len(self.obj.DPIExports):
        data['dpi_define']['exports'] = self.obj.DPIExports
      if len(self.obj.DPIImports):
        data['dpi_define']['imports'] = []
        for i in self.obj.DPIImports:
          v = {}
          v['name'] = i.name
          v['sv_return_type'] = i.svType
          v['c_return_type'] = i.cType
          v['c_args'] = i.cArgs
          v['sv_args'] = i.arguments
          data['dpi_define']['imports'].append(v)
    if (len(self.obj.external_imports)):
      data['imports'] = []
      for i in self.obj.external_imports:
        data['imports'].append({'name':i})
    if (self.obj.veloceReady == False):
      data['veloce_ready'] = "False"
    return data

import sys
import os
if (sys.version_info[0] < 3):
  sys.path.insert(0,os.path.dirname(os.path.dirname(os.path.realpath(__file__)))+"/python2")
import yaml

class YAMLGenerator:
  def __init__(self,data,outfilename,default_style='"'):
    with open(outfilename,'w') as outfile:
      yaml.dump(data,outfile,default_flow_style=False,width=float('inf'))


