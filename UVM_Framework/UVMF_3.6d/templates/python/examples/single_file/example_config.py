#! /usr/bin/env python

import uvmf_gen

## ********************************************************************
## Example UVMF template configuration module
## This example will produce several new interface/agent packages, 
##   environment packages and project benches for both block level
##   environments (block_a, block_b) and the chip level environment.
## 
## It is allowable to split the creation of interfaces, environments
##   and benches into separate config files to be executed
##   independently of one another, just make sure that the uvmf_gen
##   module is imported at the top of each file.

## ********************************************************************
## Generate the abc interface package and BFM's

## The input to this call is the name of the desired interface
intf = uvmf_gen.InterfaceClass('abc')

## Specify the clock and reset signal for the interface
intf.clock = 'paClk'
intf.reset = 'paRst'

## Specify the ports associated with this interface.
##   addPort(<name>,<width>,[input|output|inout])
intf.addPort('abc_wdata',8,'input')
intf.addPort('abc_addr',16,'input')
intf.addPort('abc_rdata',8,'output')

## Specify typedef for inclusion in typedefs_hdl file
# addHdlTypedef(<name>,<type>)
intf.addHdlTypedef('my_byte_t','byte')
intf.addHdlTypedef('my_word_t','bit [15:0] ')
intf.addHdlTypedef('colors_t','enum { red, green, blue, yellow, white, black }')

## Specify parameters for inclusion in typedefs_hdl file
# addHdlParamDef(<name>,<type>,<value>)
intf.addHdlParamDef('NUM_FILTERS','int','20')
intf.addHdlParamDef('NUM_TAPS','int','12')

## Specify typedef for inclusion in typedefs file
# addHvlTypedef(<name>,<type>)
intf.addHvlTypedef('my_object_t','uvm_object')

## Specify transaction variables for the interface.
##   addTransVar(<name>,<type>)
##     optionally can specify if this variable may be specified as 'rand'
intf.addTransVar('abc_trnVar1','my_byte_t',isrand=False)
intf.addTransVar('abc_trnVar2','int',isrand=True)
intf.addTransVar('abc_trnVar3','bit [15:0]',isrand=False)

## Specify configuration variables for the interface.
##   addConfigVar(<name>,<type>)
##     optionally can specify if this variable may be specified as 'rand'
intf.addConfigVar('abc_cfgVar1','bit',isrand=False)
intf.addConfigVar('abc_cfgVar2','colors_t',isrand=True)
intf.addConfigVar('abc_cfgVar3','bit [3:0]',isrand=False)

## This will prompt the creation of all interface files in their specified
##  locations
intf.create()

## ********************************************************************
## Generate the def interface package and BFM's

## The input to this call is the name of the desired interface
intf = uvmf_gen.InterfaceClass('def')

## Specify the clock and reset signal for the interface
intf.clock = 'pdClk'
intf.reset = 'pdRst'

## Specify the ports associated with this interface.
##   addPort(<name>,<width>,[input|output|inout])
intf.addPort('def_wdata',8,'input')
intf.addPort('def_addr',16,'input')
intf.addPort('def_rdata',8,'output')

## Specify transaction variables for the interface.
##   addTransVar(<name>,<type>)
##     optionally can specify if this variable may be specified as 'rand'
intf.addTransVar('def_trnVar1','byte',isrand=False)
intf.addTransVar('def_trnVar2','int',isrand=True)
intf.addTransVar('def_trnVar3','bit [15:0]',isrand=False)

## Specify configuration variables for the interface.
##   addConfigVar(<name>,<type>)
##     optionally can specify if this variable may be specified as 'rand'
intf.addConfigVar('def_cfgVar1','bit',isrand=False)
intf.addConfigVar('def_cfgVar2','int',isrand=True)
intf.addConfigVar('def_cfgVar3','bit [3:0]',isrand=False)

## This will prompt the creation of all interface files in their specified
##  locations
intf.create()

## ********************************************************************
## Generate the block_a environment package
env = uvmf_gen.EnvironmentClass('block_a')

## Specify the agents contained in this environment
##   addAgent(<agent_handle_name>,<agent_package_name>,<clock_name>,<reset_name>)
# Note: the agent_package_name will have _pkg appended to it.
env.addAgent('control_plane_in',      'abc', 'paClk', 'paRst')
env.addAgent('control_plane_out',     'abc', 'paClk', 'paRst')
env.addAgent('secure_data_plane_in',  'def', 'pdClk', 'pdRst')
env.addAgent('secure_data_plane_out', 'def', 'pdClk', 'pdRst')

## Define the predictors contained in this environment (not instantiate, yet)
## addAnalysisComponent(<keyword>,<predictor_type_name>,<dict_of_exports>,<dict_of_ports>) - 
## doing this will add the requested analysis component
## to the list, enabling the use of the given template (identified by <keyword>)
env.defineAnalysisComponent('predictor','block_a_predictor',{'control_plane_in_ae':'abc_transaction',
                                                            'secure_data_plane_in_ae':'def_transaction'},
                                                           {'control_plane_sb_ap':'abc_transaction',
                                                            'secure_data_plane_sb_ap':'def_transaction'})

## Instantiate the components in this environment
## addAnalysisComponent(<name>,<type>)
env.addAnalysisComponent('block_a_pred','block_a_predictor')

## Specify the scoreboards contained in this environment
## addUvmfScoreboard(<scoreboard_handle_name>, <uvmf_scoreboard_type_name>, <transaction_type_name>)
env.addUvmfScoreboard('control_plane_sb','uvmf_in_order_scoreboard','abc_transaction')
env.addUvmfScoreboard('secure_data_plane_sb', 'uvmf_in_order_scoreboard','def_transaction')

## Specify the connections in the environment
## addConnection(<output_component>, < output_port_name>, <input_component>, <input_component_export_name>)
## Connection 00
env.addConnection('control_plane_in', 'monitored_ap', 'block_a_pred', 'control_plane_in_ae')
## Connection 01
env.addConnection('secure_data_plane_in', 'monitored_ap', 'block_a_pred', 'secure_data_plane_in_ae')
## Connection 02
env.addConnection('block_a_pred', 'control_plane_sb_ap', 'control_plane_sb', 'expected_analysis_export')
## Connection 03
env.addConnection('block_a_pred', 'secure_data_plane_sb_ap', 'secure_data_plane_sb', 'expected_analysis_export')
## Connection 04
env.addConnection('control_plane_out', 'monitored_ap', 'control_plane_sb', 'actual_analysis_export')
## Connection 05
env.addConnection('secure_data_plane_out','monitored_ap',  'secure_data_plane_sb', 'actual_analysis_export')

env.create() 

## ********************************************************************
## Generate the block_b environment package
env = uvmf_gen.EnvironmentClass('block_b')

## Specify the agents contained in this environment
##   addAgent(<agent_handle_name>,<agent_package_name>,<clock_name>,<reset_name>)
# Note: the agent_package_name will have _pkg appended to it.
env.addAgent('control_plane_in',       'abc', 'paClk', 'paRst')
env.addAgent('control_plane_out',      'abc', 'paClk', 'paRst')
env.addAgent('unsecure_data_plane_in', 'def', 'pdClk', 'pdRst')
env.addAgent('unsecure_data_plane_out','def', 'pdClk', 'pdRst')

## Define the predictors contained in this environment (not instantiate, yet)
## addAnalysisComponent(<keyword>,<predictor_type_name>,<dict_of_exports>,<dict_of_ports>) - 
## doing this will add the requested analysis component
## to the list, enabling the use of the given template (identified by <keyword>)
env.defineAnalysisComponent('predictor','control_plane_predictor',{'control_plane_in_ae':'abc_transaction'},
                                                                  {'control_plane_sb_ap':'abc_transaction'})
env.defineAnalysisComponent('predictor','unsecure_data_plane_predictor',{'control_plane_in_ae':'abc_transaction',
                                                                         'unsecure_data_plane_in_ae':'def_transaction'},
                                                                        {'unsecure_data_plane_sb_ap':'def_transaction'})

## Instantiate the components in this environment
## addAnalysisComponent(<name>,<type>)
env.addAnalysisComponent('control_plane_pred','control_plane_predictor')
env.addAnalysisComponent('unsecure_data_plane_pred','unsecure_data_plane_predictor')

## Specify the scoreboards contained in this environment
## addUvmfScoreboard(<scoreboard_handle_name>, <uvmf_scoreboard_type_name>, <transaction_type_name>)
env.addUvmfScoreboard('control_plane_sb','uvmf_in_order_scoreboard','abc_transaction')
env.addUvmfScoreboard('unsecure_data_plane_sb', 'uvmf_in_order_scoreboard','def_transaction')

## Specify the connections in the environment
## addConnection(<output_component>, < output_port_name>, <input_component>, <input_component_export_name>)
## Connection 00
env.addConnection('control_plane_in', 'monitored_ap', 'control_plane_pred', 'control_plane_in_ae')
## Connection 01
env.addConnection('control_plane_in', 'monitored_ap', 'unsecure_data_plane_pred', 'control_plane_in_ae')
## Connection 02
env.addConnection('unsecure_data_plane_in', 'monitored_ap', 'unsecure_data_plane_pred', 'unsecure_data_plane_in_ae')
## Connection 03
env.addConnection('control_plane_pred', 'control_plane_sb_ap', 'control_plane_sb', 'expected_analysis_export')
## Connection 04
env.addConnection('unsecure_data_plane_pred', 'unsecure_data_plane_sb_ap', 'unsecure_data_plane_sb', 'expected_analysis_export')
## Connection 05
env.addConnection('control_plane_out','monitored_ap',  'control_plane_sb', 'actual_analysis_export')
## Connection 06
env.addConnection('unsecure_data_plane_out', 'monitored_ap', 'unsecure_data_plane_sb', 'actual_analysis_export')

env.create() 

## ********************************************************************
## Generate the chip environment package
env = uvmf_gen.EnvironmentClass('chip')

env.addSubEnv('block_a_env', 'block_a', 4)
env.addSubEnv('block_b_env', 'block_b', 4)

env.create() 

## ********************************************************************
## Generate the bench for block_a


## The input to this call is the name of the desired bench and the name of the top 
## environment package
##   BenchClass(<bench_name>,<env_name>)
ben = uvmf_gen.BenchClass('block_a','block_a')

## Specify the agents contained in this bench
##   addAgent(<agent_handle_name>,<agent_type_name>,<clock_name>,<reset_name>)
ben.addBfm('control_plane_in',      'abc', 'paClk', 'paRst', 'ACTIVE')
ben.addBfm('control_plane_out',     'abc', 'paClk', 'paRst', 'ACTIVE')
ben.addBfm('secure_data_plane_in',  'def', 'pdClk', 'pdRst', 'ACTIVE')
ben.addBfm('secure_data_plane_out', 'def', 'pdClk', 'pdRst', 'ACTIVE')

## This will prompt the creation of all bench files in their specified
##  locations
ben.create()

## ********************************************************************
## Generate the bench for block_b


## The input to this call is the name of the desired bench and the name of the top 
## environment package
##   BenchClass(<bench_name>,<env_name>)
ben = uvmf_gen.BenchClass('block_b','block_b')

## Specify the agents contained in this bench
##   addAgent(<agent_handle_name>,<agent_type_name>,<clock_name>,<reset_name>)
ben.addBfm('control_plane_in',       'abc', 'paClk', 'paRst','ACTIVE')
ben.addBfm('control_plane_out',      'abc', 'paClk', 'paRst','ACTIVE')
ben.addBfm('unsecure_data_plane_in', 'def', 'pdClk', 'pdRst','ACTIVE')
ben.addBfm('unsecure_data_plane_out','def', 'pdClk', 'pdRst','ACTIVE')

## This will prompt the creation of all bench files in their specified
##  locations
ben.create()

## ********************************************************************
## Generate the bench for chip


## The input to this call is the name of the desired bench and the name of the top 
## environment package
##   BenchClass(<bench_name>,<env_name>)
ben = uvmf_gen.BenchClass('chip','chip')

## Specify the agents contained in this bench
##   addAgent(<agent_handle_name>,<agent_type_name>,<clock_name>,<reset_name>)

## block a environment agents in the same order listed in block a config file
ben.addBfm('control_plane_in',           'abc', 'paClk', 'paRst', 'ACTIVE', 'environment/block_a_env')
ben.addBfm('internal_control_plane_out', 'abc', 'paClk', 'paRst', 'PASSIVE', 'environment/block_a_env')
ben.addBfm('secure_data_plane_in',       'def', 'pdClk', 'pdRst', 'ACTIVE', 'environment/block_a_env')
ben.addBfm('secure_data_plane_out',      'def', 'pdClk', 'pdRst', 'ACTIVE', 'environment/block_a_env')

## block b environment agents in the same order listed in block b config file
ben.addBfm('internal_control_plane_in',  'abc', 'paClk', 'paRst','PASSIVE', 'environment/block_b_env')
ben.addBfm('control_plane_out',          'abc', 'paClk', 'paRst','ACTIVE', 'environment/block_b_env')
ben.addBfm('unsecure_data_plane_in',     'def', 'pdClk', 'pdRst','ACTIVE', 'environment/block_b_env')
ben.addBfm('unsecure_data_plane_out',    'def', 'pdClk', 'pdRst','ACTIVE', 'environment/block_b_env')

## This will prompt the creation of all bench files in their specified
##  locations
ben.create()

