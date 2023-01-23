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
env.header = """// Created by: Vijay Gill
// E-mail:     vijay_gill@mentor.com
// Date:       2019/11/05"""

## The following code is used to add this qvip_configurator generated output into an
## encapsulating UVMF Generated environment.  The addQvipSubEnv function is added to
## the python configuration file used by the UVMF environment generator.
env.addQvipSubEnv('axi4_qvip_subenv', 'axi4_2x2_fabric_qvip', ['mgc_axi4_m0', 'mgc_axi4_m1', 'mgc_axi4_s0', 'mgc_axi4_s1'])

## Specify the agents contained in this environment
##   addAgent(<agent_handle_name>,<agent_package_name>,<clock_name>,<reset_name>)
# Note: the agent_package_name will have _pkg appended to it.

## Import QVIP protocol packages so that the environment can use sequence items and sequences from QVIP library.
env.addImport('mvc_pkg')
env.addImport('mgc_axi4_v1_0_pkg')
env.addImport('rw_txn_pkg')

## Define the predictors contained in this environment (not instantiate, yet)
## addAnalysisComponent(<keyword>,<predictor_type_name>,<dict_of_exports>,<dict_of_ports>) - 
## doing this will add the requested analysis component
## to the list, enabling the use of the given template (identified by <keyword>)
env.defineAnalysisComponent('predictor','axi4_master_predictor',{}, 
                                                                {'axi4_ap':'axi4_master_rw_transaction_t'},
                                                parametersList=[{'name':'axi4_master_rw_transaction_t','type':'type'}],
                                                 qvipExportDict={'axi4_ae':'axi4_master_rw_transaction_t'})

env.defineAnalysisComponent('predictor','axi4_slave_predictor',{}, 
                           {'axi4_m0_ap':'axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(mgc_axi4_m0_params::AXI4_ADDRESS_WIDTH),.AXI4_RDATA_WIDTH(mgc_axi4_m0_params::AXI4_RDATA_WIDTH),.AXI4_WDATA_WIDTH(mgc_axi4_m0_params::AXI4_WDATA_WIDTH),.AXI4_ID_WIDTH(mgc_axi4_m0_params::AXI4_ID_WIDTH),.AXI4_USER_WIDTH(mgc_axi4_m0_params::AXI4_USER_WIDTH),.AXI4_REGION_MAP_SIZE(mgc_axi4_m0_params::AXI4_REGION_MAP_SIZE))',
                            'axi4_m1_ap':'axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(mgc_axi4_m1_params::AXI4_ADDRESS_WIDTH),.AXI4_RDATA_WIDTH(mgc_axi4_m1_params::AXI4_RDATA_WIDTH),.AXI4_WDATA_WIDTH(mgc_axi4_m1_params::AXI4_WDATA_WIDTH),.AXI4_ID_WIDTH(mgc_axi4_m1_params::AXI4_ID_WIDTH),.AXI4_USER_WIDTH(mgc_axi4_m1_params::AXI4_USER_WIDTH),.AXI4_REGION_MAP_SIZE(mgc_axi4_m1_params::AXI4_REGION_MAP_SIZE))'},
  parametersList=[{'name':'AXI4_ADDRESS_WIDTH',   'type':'int', 'value':'32'},
                {'name':'AXI4_RDATA_WIDTH',     'type':'int', 'value':'32'},
                {'name':'AXI4_WDATA_WIDTH',     'type':'int', 'value':'32'},
                {'name':'AXI4_ID_WIDTH',        'type':'int', 'value':'5'},
                {'name':'AXI4_USER_WIDTH',      'type':'int', 'value':'4'},
                {'name':'AXI4_REGION_MAP_SIZE', 'type':'int', 'value':'16'}],
  qvipExportDict={'axi4_ae':"""axi4_master_rw_transaction 
      #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), 
        .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), 
        .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), 
        .AXI4_ID_WIDTH(AXI4_ID_WIDTH), 
        .AXI4_USER_WIDTH(AXI4_USER_WIDTH), 
        .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE))"""})
env.defineAnalysisComponent('predictor','axi4_slave_rw_predictor',{'axi4_s0_ae':'rw_txn',
                                                                   'axi4_s1_ae':'rw_txn'},
                                                                   {'axi4_m0_ap':'rw_txn',
                                                                    'axi4_m1_ap':'rw_txn'})

## Instantiate the components in this environment
## addAnalysisComponent(<name>,<type>)
env.addAnalysisComponent('axi4_m0_pred','axi4_master_predictor',
  parametersList=[{'name':'axi4_master_rw_transaction_t','value':"""axi4_master_rw_transaction 
   #(.AXI4_ADDRESS_WIDTH(mgc_axi4_m0_params::AXI4_ADDRESS_WIDTH), 
     .AXI4_RDATA_WIDTH(mgc_axi4_m0_params::AXI4_RDATA_WIDTH), 
     .AXI4_WDATA_WIDTH(mgc_axi4_m0_params::AXI4_WDATA_WIDTH), 
     .AXI4_ID_WIDTH(mgc_axi4_m0_params::AXI4_ID_WIDTH), 
     .AXI4_USER_WIDTH(mgc_axi4_m0_params::AXI4_USER_WIDTH), 
     .AXI4_REGION_MAP_SIZE(mgc_axi4_m0_params::AXI4_REGION_MAP_SIZE))"""}])
env.addAnalysisComponent('axi4_m1_pred','axi4_master_predictor',
  parametersList=[{'name':'axi4_master_rw_transaction_t','value':"""axi4_master_rw_transaction 
   #(.AXI4_ADDRESS_WIDTH(mgc_axi4_m1_params::AXI4_ADDRESS_WIDTH), 
     .AXI4_RDATA_WIDTH(mgc_axi4_m1_params::AXI4_RDATA_WIDTH), 
     .AXI4_WDATA_WIDTH(mgc_axi4_m1_params::AXI4_WDATA_WIDTH), 
     .AXI4_ID_WIDTH(mgc_axi4_m1_params::AXI4_ID_WIDTH), 
     .AXI4_USER_WIDTH(mgc_axi4_m1_params::AXI4_USER_WIDTH), 
     .AXI4_REGION_MAP_SIZE(mgc_axi4_m1_params::AXI4_REGION_MAP_SIZE))"""}])
env.addAnalysisComponent('axi4_s0_pred','axi4_slave_predictor',
  parametersList=[{'name':'AXI4_ADDRESS_WIDTH',   'value':'mgc_axi4_s0_params::AXI4_ADDRESS_WIDTH'},
                  {'name':'AXI4_RDATA_WIDTH',     'value':'mgc_axi4_s0_params::AXI4_RDATA_WIDTH'},
                  {'name':'AXI4_WDATA_WIDTH',     'value':'mgc_axi4_s0_params::AXI4_WDATA_WIDTH'},
                  {'name':'AXI4_ID_WIDTH',        'value':'mgc_axi4_s0_params::AXI4_ID_WIDTH'},
                  {'name':'AXI4_USER_WIDTH',      'value':'mgc_axi4_s0_params::AXI4_USER_WIDTH'},
                  {'name':'AXI4_REGION_MAP_SIZE', 'value':'mgc_axi4_s0_params::AXI4_REGION_MAP_SIZE'}])
  
env.addAnalysisComponent('axi4_s1_pred','axi4_slave_predictor',
parametersList=[{'name':'AXI4_ADDRESS_WIDTH',   'value':'mgc_axi4_s1_params::AXI4_ADDRESS_WIDTH'},
                  {'name':'AXI4_RDATA_WIDTH',     'value':'mgc_axi4_s1_params::AXI4_RDATA_WIDTH'},
                  {'name':'AXI4_WDATA_WIDTH',     'value':'mgc_axi4_s1_params::AXI4_WDATA_WIDTH'},
                  {'name':'AXI4_ID_WIDTH',        'value':'mgc_axi4_s1_params::AXI4_ID_WIDTH'},
                  {'name':'AXI4_USER_WIDTH',      'value':'mgc_axi4_s1_params::AXI4_USER_WIDTH'},
                  {'name':'AXI4_REGION_MAP_SIZE', 'value':'mgc_axi4_s1_params::AXI4_REGION_MAP_SIZE'}])
env.addAnalysisComponent('axi4_slave_rw_pred','axi4_slave_rw_predictor')

## Specify the scoreboards contained in this environment
## addUvmfScoreboard(<scoreboard_handle_name>, <uvmf_scoreboard_type_name>, <transaction_type_name>)
env.addUvmfScoreboard('axi4_m0_sb','uvmf_in_order_race_scoreboard',"axi4_master_rw_transaction \
\n            #(.AXI4_ADDRESS_WIDTH(mgc_axi4_m0_params::AXI4_ADDRESS_WIDTH), \
\n              .AXI4_RDATA_WIDTH(mgc_axi4_m0_params::AXI4_RDATA_WIDTH), \
\n              .AXI4_WDATA_WIDTH(mgc_axi4_m0_params::AXI4_WDATA_WIDTH), \
\n              .AXI4_ID_WIDTH(mgc_axi4_m0_params::AXI4_ID_WIDTH), \
\n              .AXI4_USER_WIDTH(mgc_axi4_m0_params::AXI4_USER_WIDTH), \
\n              .AXI4_REGION_MAP_SIZE(mgc_axi4_m0_params::AXI4_REGION_MAP_SIZE))")
env.addUvmfScoreboard('axi4_m1_sb','uvmf_in_order_race_scoreboard','axi4_master_rw_transaction \
\n            #(.AXI4_ADDRESS_WIDTH(mgc_axi4_m1_params::AXI4_ADDRESS_WIDTH), \
\n              .AXI4_RDATA_WIDTH(mgc_axi4_m1_params::AXI4_RDATA_WIDTH), \
\n              .AXI4_WDATA_WIDTH(mgc_axi4_m1_params::AXI4_WDATA_WIDTH), \
\n              .AXI4_ID_WIDTH(mgc_axi4_m1_params::AXI4_ID_WIDTH), \
\n              .AXI4_USER_WIDTH(mgc_axi4_m1_params::AXI4_USER_WIDTH), \
\n              .AXI4_REGION_MAP_SIZE(mgc_axi4_m1_params::AXI4_REGION_MAP_SIZE))')
env.addUvmfScoreboard('axi4_m0_rw_sb','uvmf_in_order_race_scoreboard','rw_txn')
env.addUvmfScoreboard('axi4_m1_rw_sb','uvmf_in_order_race_scoreboard','rw_txn')

## TLM Connections
env.addConnection('axi4_m0_pred','axi4_ap','axi4_m0_sb','expected_analysis_export')
env.addConnection('axi4_m1_pred','axi4_ap','axi4_m1_sb','expected_analysis_export')
env.addConnection('axi4_s0_pred','axi4_m0_ap','axi4_m0_sb','actual_analysis_export')
env.addConnection('axi4_s1_pred','axi4_m0_ap','axi4_m0_sb','actual_analysis_export')
env.addConnection('axi4_s0_pred','axi4_m1_ap','axi4_m1_sb','actual_analysis_export')
env.addConnection('axi4_s1_pred','axi4_m1_ap','axi4_m1_sb','actual_analysis_export')


env.addConnection('axi4_qvip_subenv.mgc_axi4_m0','export_rw','axi4_m0_rw_sb','expected_analysis_export')
env.addConnection('axi4_qvip_subenv.mgc_axi4_m1','export_rw','axi4_m1_rw_sb','expected_analysis_export')
env.addConnection('axi4_qvip_subenv.mgc_axi4_s0','export_rw','axi4_slave_rw_pred','axi4_s0_ae')
env.addConnection('axi4_qvip_subenv.mgc_axi4_s1','export_rw','axi4_slave_rw_pred','axi4_s1_ae')

env.addConnection('axi4_slave_rw_pred','axi4_m0_ap','axi4_m0_rw_sb','actual_analysis_export')
env.addConnection('axi4_slave_rw_pred','axi4_m1_ap','axi4_m1_rw_sb','actual_analysis_export')

env.addQvipConnection('axi4_qvip_subenv_mgc_axi4_m0','trans_ap','axi4_m0_pred','axi4_ae')
env.addQvipConnection('axi4_qvip_subenv_mgc_axi4_m1','trans_ap','axi4_m1_pred','axi4_ae')
env.addQvipConnection('axi4_qvip_subenv_mgc_axi4_s0','trans_ap','axi4_s0_pred','axi4_ae')
env.addQvipConnection('axi4_qvip_subenv_mgc_axi4_s1','trans_ap','axi4_s1_pred','axi4_ae')

#env.addConnection('axi4_m0_rw_txn_pred','port_rw','axi4_rw_txn_m0_sb','expected_analysis_export')
#env.addConnection('axi4_m1_rw_txn_pred','port_rw','axi4_rw_txn_m1_sb','expected_analysis_export')
#env.addConnection('axi4_slave_rw_txn_pred','port_rw_m0','axi4_rw_txn_m0_sb','actual_analysis_export')
#env.addConnection('axi4_slave_rw_txn_pred','port_rw_m1','axi4_rw_txn_m1_sb','actual_analysis_export')

env.create() 

## ********************************************************************
## Generate the bench for chip

## The input to this call is the name of the desired bench and the name of the top 
## environment package
##   BenchClass(<bench_name>,<env_name>)
## ben = uvmf_gen.BenchClass('chip','chip')
ben = uvmf_gen.BenchClass('axi4_2x2_fabric','axi4_2x2_fabric')
ben.header = """// Created by: Vijay Gill
// E-mail:     vijay_gill@mentor.com
// Date:       2019/11/05"""
## Specify the agents contained in this bench
##   addAgent(<agent_handle_name>,<agent_type_name>,<clock_name>,<reset_name>)

## Import QVIP protocol packages so that the test bench can use sequence items and sequences from QVIP library.
ben.addImport('mvc_pkg')
ben.addImport('mgc_axi4_v1_0_pkg')

ben.addQvipBfm('mgc_axi4_m0', 'axi4_2x2_fabric_qvip', 'ACTIVE', unique_id="uvm_test_top.environment.axi4_qvip_subenv.")
ben.addQvipBfm('mgc_axi4_m1', 'axi4_2x2_fabric_qvip', 'ACTIVE', unique_id="uvm_test_top.environment.axi4_qvip_subenv.")
ben.addQvipBfm('mgc_axi4_s0', 'axi4_2x2_fabric_qvip', 'ACTIVE', unique_id="uvm_test_top.environment.axi4_qvip_subenv.")
ben.addQvipBfm('mgc_axi4_s1', 'axi4_2x2_fabric_qvip', 'ACTIVE', unique_id="uvm_test_top.environment.axi4_qvip_subenv.")

# List scoreboards to disable during register test
ben.addScoreboard("environment.axi4_m0_sb")
ben.addScoreboard("environment.axi4_m1_sb")
ben.addScoreboard("environment.axi4_m0_rw_sb")
ben.addScoreboard("environment.axi4_m1_rw_sb")

## This will prompt the creation of all bench files in their specified
##  locations
ben.create()

