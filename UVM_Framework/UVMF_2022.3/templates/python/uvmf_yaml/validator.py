import sys

try:
  from voluptuous import Required,Optional,Any,In,Schema
  from voluptuous.humanize import humanize_error
except ImportError:
  print("ERROR : voluptuous package not found. See templates.README for more information")
  sys.exit(1)

class BaseValidator(object):

  def __init__(self):
    self.dpiArgumentSchema = {
      Required('name'): str,
      Required('type'): str,
      Optional('unpacked_dimension'): str,
      Required('dir'): Any('input','output','inout','')
    }
    self.dpiImportSchema = {
      Required('sv_return_type'): str,
      Required('c_return_type'): str,
      Required('name'): str,
      Required('c_args'): str,
      Required('sv_args'): [ self.dpiArgumentSchema ]
    }
    self.dpiDefSchema = {
      Required('name'): str ,
      Required('files'): [ str ],
      Optional('comp_args'): str,
      Optional('link_args'): str,
      Optional('exports'): [ str ],
      Optional('imports'): [ self.dpiImportSchema ]
    }
    self.configVarSchema = {
      Required('name'): str,
      Required('type'): str,
      Optional('value'): str,
      Optional('isrand'): Any("True","False"),
      Optional('unpacked_dimension'): str,
      Optional('comment'): str
    }
    self.constraintSchema = {
      Required('name'): str,
      Required('value'): str,
      Optional('comment'): str
    }
    self.parameterDefSchema = { 
      Required('name'): str, 
      Required('type'): str, 
      Optional('value'): Any(str,None)
    }
    self.typedefSchema = { 
      Required('name'): str, 
      Required('type'): str 
    }
    self.parameterUseSchema = {
      Required('name'): str,
      Required('value'): str
    }
    self.componentSchema = {
      Required('name'): str,
      Required('type'): str,
      Optional('extdef'): Any('True','False'),
      Optional('parameters'): [ self.parameterUseSchema ]
    }
    self.TLMPortSchema = {
      Required('name'): str,
      Required('trans_type'): str,
      Required('connected_to'): str
    }
    self.importSchema = {
      Required('name'): str
    }
    self.schema = None

class RegenValidator(BaseValidator):

  def __init__(self):
    super(RegenValidator,self).__init__()
    self.initializeSchema()

  def initializeSchema(self):
    blockSchema = {
      Required('content'): str,
      Optional('begin_line'): int,
      Optional('end_line'): int,
      Optional('extra_blanklines'): int,
    }
    mainSchema = { str : { str : blockSchema } }
    self.schema = Schema(mainSchema)

class GlobalValidator(BaseValidator):

  def __init__(self):
    super(GlobalValidator,self).__init__()
    self.initializeSchema()

  def initializeSchema(self):
    mainSchema = {
      Optional('header'): str,
      Optional('flat_output'): Any('True','False'),
      Optional('vip_location'): str,
      Optional('interface_location'): str,
      Optional('environment_location'): str,
      Optional('bench_location'): str,
    }
    self.schema = Schema(mainSchema)

class BenchValidator(BaseValidator):

  def __init__(self):
    super(BenchValidator,self).__init__()
    self.initializeSchema()

  def initializeSchema(self):
    activePassiveSchema = {
      Required('bfm_name'): str,
      Required('value') : Any('ACTIVE','PASSIVE')
    }
    interfaceParamSchema = {
      Required('bfm_name'): str,
      Required('value'): [ self.parameterUseSchema ]
    }
    mainSchema = {
      Required('top_env'): str,
      Optional('veloce_ready'): Any('True','False'),
      Optional('existing_library_component'): Any('True','False'),
      Optional('catapult_ready'): Any('True','False'),
      Optional('infact_enabled'): Any('True','False'),
      Optional('mtlb_ready'): Any('True','False'),
      Optional('clock_half_period'): str,
      Optional('use_coemu_clk_rst_gen'): Any('True','False'),
      Optional('clock_phase_offset'): str,
      Optional('reset_assertion_level'): str,
      Optional('use_dpi_link'): str,
      Optional('reset_duration'): str,
      Optional('active_passive'): [ activePassiveSchema ],
      Optional('active_passive_default'): Any('ACTIVE','PASSIVE'),
      Optional('parameters'): [ self.parameterDefSchema ],
      Optional('top_env_params'):  [ self.parameterUseSchema ],
      Optional('interface_params'): [ interfaceParamSchema ],
      Optional('imports'): [ self.importSchema ],
      Optional('additional_tops'): [ str ],
      Optional('use_bcr'): Any('True','False'),
    }
    self.schema = Schema(mainSchema)

class ComponentValidator(BaseValidator):

  def __init__(self):
    super(ComponentValidator,self).__init__()
    self.initializeSchema()

  def initializeSchema(self):
    analysisSchema = {
      Required('name'): str,
      Required('type'): str,
    }
    mainSchema = {
      Required('type'): Any("predictor","coverage", "tlm2_sysc_predictor", "scoreboard", "predictor_mtlb"),
      Optional('parameters'): [ self.parameterDefSchema ],
      Optional('analysis_exports'):  [ analysisSchema ],
      Optional('analysis_ports'): [ analysisSchema ],
      Optional('mtlb_ready'): Any('True','False'),
      Optional('qvip_analysis_exports'): [ analysisSchema ],
      Optional('existing_library_component'): Any('True','False'),
    }
    self.schema = Schema(mainSchema)

class QVIPEnvValidator(BaseValidator):

  def __init__(self):
    super(QVIPEnvValidator,self).__init__()
    self.initializeSchema()

  def initializeSchema(self):
    apInfoSchema = {
      Required('port_name'): str,
      Required('key'): str,
      Required('type'): str
    }
    directoryVariableSchema = {
      Required('name'): str,
      Required('value'): str
    }
    agentsSchema = {
      Required('name'): str,
      Optional('active_passive'): Any("ACTIVE","PASSIVE"),
      Optional('initial_sequence'): str,
      Optional('imports'): [ str ],
      Optional('ap_info'): [ apInfoSchema ],
      Optional('emulation_vip_libs'): [ str ],
      Optional('directory_variables'): [ directoryVariableSchema ]

    }
    mainSchema = {
      Required('agents'): [ agentsSchema ],
      Optional('type'): Any("qvip","cvip"),
      Optional('location'): str
    }
    self.schema = Schema(mainSchema)

class QVIPLibValidator(BaseValidator):

  def __init__(self):
    super(QVIPLibValidator,self).__init__()
    self.initializeSchema()

  def initializeSchema(self):
    mainSchema = {
      Required('version'): str,
      Required('date'): str,
    }
    self.schema = Schema(mainSchema)

class EnvironmentValidator(BaseValidator):

  def __init__(self):
    super(EnvironmentValidator,self).__init__()
    self.initializeSchema()

  def initializeSchema(self):
    regModelMapSchema = {
      Required('name'): str,
      Required('interface'): str,
      Optional('qvip_agent'): Any("True","False")
    }
    regModelSchema = {
      Optional('use_adapter'): Any("True","False"),
      Optional('use_explicit_prediction'): Any("True","False"),
      Optional('maps'): [ regModelMapSchema ],
      Optional('reg_model_package'): str,
      Optional('reg_block_class'): str
    }
    scoreboardSchema = {
      Required('name'): str,
      Required('sb_type'): str,
      Required('trans_type'): str,
      Optional('parameters'): [ self.parameterUseSchema ]
    }
    tlmSchema = {
      Required('driver'): str,
      Required('receiver'): str,
      Optional('validate'): str
    }
    qvipTlmSchema = {
      Required('driver'): str,
      Required('ap_key'): str,
      Required('receiver'): str,
      Optional('validate'): str
    }
    subenvSchema = {
      Required('name'): str,
      Required('type'): str,
      Optional('extdef'): Any('True','False'),
      Optional('parameters'): [ self.parameterUseSchema ],
      Optional('use_register_model'): Any("True","False")
    }
    qvipSubenvSchema = {
      Required('name'): str,
      Required('type'): str
    }
    agentSchema = {
      Required('name'): str,
      Required('type'): str,
      Optional('extdef'): Any('True','False'),
      Optional('parameters'): [ self.parameterUseSchema ],
      Optional('initiator_responder'): Any('INITIATOR','RESPONDER')
    }
    nonUvmfComponentSchema = {
      Required('name'): str,
      Required('type'): str,
      Optional('parameters'): [ self.parameterUseSchema ],
      Optional('extdef'): Any('True','False')
    }
    qvipMemoryAgentComponentSchema = {
      Required('name'): str,
      Required('type'): str,
      Required('parameters'): [ self.parameterUseSchema ],
      Required('qvip_environment'): str
    }
    configVariableValueSchema = {
      Required('name'): str,
      Required('value'): str
    }
    mainSchema = {
      Optional('agents'): [ agentSchema ],
      Optional('non_uvmf_components'): [ nonUvmfComponentSchema ],
      Optional('existing_library_component'): Any('True','False'),
      Optional('mtlb_ready'): Any('True','False'),
      Optional('qvip_memory_agents'): [ qvipMemoryAgentComponentSchema ],
      Optional('analysis_components'): [ self.componentSchema ],
      Optional('scoreboards'): [ scoreboardSchema ],
      Optional('subenvs'): [ subenvSchema ],
      Optional('analysis_ports'): [ self.TLMPortSchema ],
      Optional('analysis_exports'): [ self.TLMPortSchema ],
      Optional('tlm_connections'): [ tlmSchema ],
      Optional('qvip_connections'): [ qvipTlmSchema ],
      Optional('config_vars'): [ self.configVarSchema ],
      Optional('config_constraints'): [ self.constraintSchema ],
      Optional('parameters'): [ self.parameterDefSchema ],
      Optional('hvl_pkg_parameters'): [ self.parameterDefSchema ],
      Optional('imports'): [ self.importSchema ],
      Optional('config_variable_values'): [ configVariableValueSchema ],
      Optional('qvip_subenvs'): [ qvipSubenvSchema ],
      Optional('imp_decls'): [ { Required('name'): str } ],
      Optional('register_model'): regModelSchema,
      Optional('dpi_define'): self.dpiDefSchema,
      Optional('typedefs'): [ self.typedefSchema ],
      Optional('uvmc_flags'): str,
      Optional('uvmc_files'): [ str ],
      Optional('uvmc_link_args'): str,
    }
    self.schema = Schema(mainSchema)

class InterfaceValidator(BaseValidator):

  def __init__(self):
    super(InterfaceValidator,self).__init__()
    self.initializeSchema()

  def initializeSchema(self):
    portSchema = { 
      Required('name'): str,
      Required('width'): Any(str,list),
      Required('dir'): str ,
      Optional('reset_value'): str 
    }
    transactionSchema = { 
      Required('name'): str, 
      Required('type'): str, 
      Optional('isrand'): Any("True","False"),
      Optional('iscompare'): Any("True","False"),
      Optional('unpacked_dimension'): str,
      Optional('comment'): str
    }
    responseSchema = {
      Required('operation'): str,
      Required('data'): [ str ]
    }
    mainSchema = {
      Required('clock'): str,
      Required('reset'): str,
      Optional('reset_assertion_level'): str,
      Optional('use_dpi_link'): str,
      Optional('existing_library_component'): Any('True','False'),
      Optional('mtlb_ready'): Any('True','False'),
      Optional('gen_inbound_streaming_driver'): str,
      Optional('vip_lib_env_variable'): str,
      Optional('parameters'): [ self.parameterDefSchema ],
      Optional('hvl_pkg_parameters'): [ self.parameterDefSchema ],
      Optional('hdl_pkg_parameters'): [ self.parameterDefSchema ],
      Optional('hdl_typedefs'): [ self.typedefSchema ],
      Optional('hvl_typedefs'): [ self.typedefSchema ],
      Optional('ports'): [ portSchema ],
      Optional('transaction_vars'): [ transactionSchema ],
      Optional('transaction_constraints'): [ self.constraintSchema ],
      Optional('response_info'): responseSchema,
      Optional('config_vars'): [ self.configVarSchema ],
      Optional('config_constraints'): [ self.constraintSchema ],
      Optional('imports'): [ self.importSchema ],
      Optional('veloce_ready'): Any("True","False"),
      Optional('infact_ready'): Any("True","False"),
      Optional('dpi_define'): self.dpiDefSchema,
      Optional('enable_functional_coverage'): Any("True","False"),
    }
    self.schema = Schema(mainSchema)
