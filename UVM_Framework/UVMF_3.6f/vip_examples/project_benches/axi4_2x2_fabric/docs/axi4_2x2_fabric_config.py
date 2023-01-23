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

## ********************************************************************
## Generate the chip environment package
env = uvmf_gen.EnvironmentClass('axi4_2x2_fabric')

## Specify parameters for this interface package.
## These parameters can be used when defining signal and variable sizes.
# addParamDef(<name>,<type>,<value>)
env.addParamDef('AXI4_ADDRESS_WIDTH','int','32')
env.addParamDef('AXI4_RDATA_WIDTH','int','32')
env.addParamDef('AXI4_WDATA_WIDTH','int','32')
env.addParamDef('AXI4_MASTER_ID_WIDTH'  ,'int','4')
env.addParamDef('AXI4_SLAVE_ID_WIDTH'  ,'int','5')
env.addParamDef('AXI4_USER_WIDTH','int','4')
env.addParamDef('AXI4_REGION_MAP_SIZE','int','16')

## The following code is used to add this qvip_configurator generated output into an
## encapsulating UVMF Generated environment.  The addQvipSubEnv function is added to
## the python configuration file used by the UVMF environment generator.
env.addQvipSubEnv('qvip_env', 'axi4_2x2_fabric_qvip', ['mgc_axi4_m0', 'mgc_axi4_m1', 'mgc_axi4_s0', 'mgc_axi4_s1'])

## Specify the agents contained in this environment
##   addAgent(<agent_handle_name>,<agent_package_name>,<clock_name>,<reset_name>)
# Note: the agent_package_name will have _pkg appended to it.

## Import QVIP protocol packages so that the environment can use sequence items and sequences from QVIP library.
env.addImport('mgc_axi4_v1_0_pkg')
env.addImport('rw_txn_pkg')

## Define the predictors contained in this environment (not instantiate, yet)
## addAnalysisComponent(<keyword>,<predictor_type_name>,<dict_of_exports>,<dict_of_ports>) - 
## doing this will add the requested analysis component
## to the list, enabling the use of the given template (identified by <keyword>)
env.defineAnalysisComponent('predictor','master_axi4_txn_adapter',{'master_axi4_txn_ae':'mvc_sequence_item_base'}, 
                                                                  {'master_axi4_txn_ap':'axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE))'})
env.defineAnalysisComponent('predictor','slave_axi4_txn_predictor',{'slave_axi4_txn_ae':'mvc_sequence_item_base'}, 
                                                                   {'slave_axi4_txn_m0_ap':'axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE))',
                                                                    'slave_axi4_txn_m1_ap':'axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE))'})

## Instantiate the components in this environment
## addAnalysisComponent(<name>,<type>)
env.addAnalysisComponent('m0_axi4_txn_pred','master_axi4_txn_adapter')
env.addAnalysisComponent('m1_axi4_txn_pred','master_axi4_txn_adapter')
env.addAnalysisComponent('slave_axi4_txn_pred','slave_axi4_txn_predictor')

## Specify the scoreboards contained in this environment
## addUvmfScoreboard(<scoreboard_handle_name>, <uvmf_scoreboard_type_name>, <transaction_type_name>)
env.addUvmfScoreboard('axi4_txn_m0_sb','uvmf_in_order_race_scoreboard','axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE))')
env.addUvmfScoreboard('axi4_txn_m1_sb','uvmf_in_order_race_scoreboard','axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE))')

## Specify the connections in the environment
## addConnection(<output_component>, < output_port_name>, <input_component>, <input_component_export_name>)
env.addQvipConnection('qvip_env_mgc_axi4_m0','trans_ap','m0_axi4_txn_pred','master_axi4_txn_ae')
env.addQvipConnection('qvip_env_mgc_axi4_m1','trans_ap','m1_axi4_txn_pred','master_axi4_txn_ae')
env.addQvipConnection('qvip_env_mgc_axi4_s0','trans_ap','slave_axi4_txn_pred','slave_axi4_txn_ae')
env.addQvipConnection('qvip_env_mgc_axi4_s1','trans_ap','slave_axi4_txn_pred','slave_axi4_txn_ae')

env.addConnection('m0_axi4_txn_pred','master_axi4_txn_ap','axi4_txn_m0_sb','expected_analysis_export')
env.addConnection('m1_axi4_txn_pred','master_axi4_txn_ap','axi4_txn_m1_sb','expected_analysis_export')
env.addConnection('slave_axi4_txn_pred','slave_axi4_txn_m0_ap','axi4_txn_m0_sb','actual_analysis_export')
env.addConnection('slave_axi4_txn_pred','slave_axi4_txn_m1_ap','axi4_txn_m1_sb','actual_analysis_export')




## Define the predictors contained in this environment (not instantiate, yet)
## addAnalysisComponent(<keyword>,<predictor_type_name>,<dict_of_exports>,<dict_of_ports>) - 
## doing this will add the requested analysis component
## to the list, enabling the use of the given template (identified by <keyword>)

## Instantiate the components in this environment
## addAnalysisComponent(<name>,<type>)
env.addAnalysisComponent('m0_rw_txn_pred','axi4_rw_adapter')
env.addAnalysisComponent('m1_rw_txn_pred','axi4_rw_adapter')
env.addAnalysisComponent('slave_rw_txn_pred','slave_axi4_rw_adapter')

## Specify the scoreboards contained in this environment
## addUvmfScoreboard(<scoreboard_handle_name>, <uvmf_scoreboard_type_name>, <transaction_type_name>)
env.addUvmfScoreboard('rw_txn_m0_sb','uvmf_in_order_race_scoreboard','rw_txn')
env.addUvmfScoreboard('rw_txn_m1_sb','uvmf_in_order_race_scoreboard','rw_txn')

## Specify the connections in the environment
## addConnection(<output_component>, < output_port_name>, <input_component>, <input_component_export_name>)
env.addQvipConnection('qvip_env_mgc_axi4_m0','trans_ap','m0_rw_txn_pred','analysis_export')
env.addQvipConnection('qvip_env_mgc_axi4_m1','trans_ap','m1_rw_txn_pred','analysis_export')
env.addQvipConnection('qvip_env_mgc_axi4_s0','trans_ap','slave_rw_txn_pred','analysis_export')
env.addQvipConnection('qvip_env_mgc_axi4_s1','trans_ap','slave_rw_txn_pred','analysis_export')

env.addConnection('m0_rw_txn_pred','port_rw','rw_txn_m0_sb','expected_analysis_export')
env.addConnection('m1_rw_txn_pred','port_rw','rw_txn_m1_sb','expected_analysis_export')
env.addConnection('slave_rw_txn_pred','port_rw_m0','rw_txn_m0_sb','actual_analysis_export')
env.addConnection('slave_rw_txn_pred','port_rw_m1','rw_txn_m1_sb','actual_analysis_export')

env.create() 

## ********************************************************************
## Generate the bench for chip

## The input to this call is the name of the desired bench and the name of the top 
## environment package
##   BenchClass(<bench_name>,<env_name>)
## ben = uvmf_gen.BenchClass('chip','chip')
ben = uvmf_gen.BenchClass('axi4_2x2_fabric','axi4_2x2_fabric')

## Specify the agents contained in this bench
##   addAgent(<agent_handle_name>,<agent_type_name>,<clock_name>,<reset_name>)

## Import QVIP protocol packages so that the test bench can use sequence items and sequences from QVIP library.
ben.addImport('mgc_axi4_v1_0_pkg')

## The following code is used to add this qvip_configurator generated output into an
## encapsulating UVMF Generated test bench.  The addQvipBfm function is added to
## the python configuration file used by the UVMF bench generator.
ben.addQvipBfm('mgc_axi4_m0', 'axi4_2x2_fabric_qvip', 'ACTIVE')
ben.addQvipBfm('mgc_axi4_m1', 'axi4_2x2_fabric_qvip', 'ACTIVE')
ben.addQvipBfm('mgc_axi4_s0', 'axi4_2x2_fabric_qvip', 'ACTIVE')
ben.addQvipBfm('mgc_axi4_s1', 'axi4_2x2_fabric_qvip', 'ACTIVE')

## This will prompt the creation of all bench files in their specified
##  locations
ben.create()

