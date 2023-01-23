#! /usr/bin/env python

import uvmf_gen
env = uvmf_gen.EnvironmentClass('block_c')

##  The addQvipSubEnv() line below was copied from the comments in the QVIP configurator generated package named qvip_agents_pkg.sv.  
##  Only the environment instance name was changed to qvip_env.
##  env.addQvipSubEnv(<qvip_sub_env_handle_name>,<qvip_sub_env_package_name>,<list of protocol agent names>)
env.addQvipSubEnv('qvip_env', 'qvip_agents', ['pcie_ep', 'axi4_master_0', 'axi4_master_1', 'axi4_slave', 'apb3_config_master'])

## Specify the agents contained in this environment
## addAgent(<agent_handle_name>,<agent_package_name>,<clock_name>,<reset_name>)
# Note: the agent_package_name will have _pkg appended to it.
env.addAgent('mem_in',  'mem', 'clock', 'reset')
env.addAgent('mem_out', 'mem', 'clock', 'reset')
env.addAgent('pkt_out', 'pkt', 'pclk', 'prst')

## Import QVIP protocol packages so that the environment can use sequence items and sequences from QVIP library.
env.addImport('mgc_apb3_v1_0_pkg')
env.addImport('mgc_pcie_v2_0_pkg')
env.addImport('mgc_axi4_v1_0_pkg')

## Define the predictors contained in this environment (not instantiate, yet)
## addAnalysisComponent(<keyword>,<predictor_type_name>,<dict_of_exports>,<dict_of_ports>) - 
## doing this will add the requested analysis component
## to the list, enabling the use of the given template (identified by <keyword>)
env.defineAnalysisComponent('predictor','block_c_predictor',
		{'mem_in_ae':'mem_transaction #()', 
		'axi4_master_0_ae':'mvc_sequence_item_base', 
		'axi4_master_1_ae':'mvc_sequence_item_base'},
                {'mem_sb_ap':'mem_transaction #()', 
		'pkt_sb_ap':'pkt_transaction #()', 
		'axi4_slave_ap':'mvc_sequence_item_base', 
		'apb3_config_master_ap':'mvc_sequence_item_base'})

## Instantiate the components in this environment
## addAnalysisComponent(<name>,<type>)
env.addAnalysisComponent('blk_c_pred','block_c_predictor')

## Specify the scoreboards contained in this environment
## addUvmfScoreboard(<scoreboard_handle_name>, <uvmf_scoreboard_type_name>, <transaction_type_name>)
env.addUvmfScoreboard('mem_sb','uvmf_in_order_scoreboard','mem_transaction')
env.addUvmfScoreboard('pkt_sb','uvmf_in_order_scoreboard','pkt_transaction')
env.addUvmfScoreboard('axi4_slave_sb','uvmf_in_order_scoreboard','mvc_sequence_item_base')
env.addUvmfScoreboard('apb3_cfg_sb','uvmf_in_order_scoreboard','mvc_sequence_item_base')

## Specify the connections in the environment
## addConnection(<output_component>, < output_port_name>, <input_component>, <input_component_export_name>)
## Connection 00
env.addConnection('mem_in','monitored_ap','blk_c_pred','mem_in_ae')
## Connection 01
env.addQvipConnection('qvip_env_axi4_master_0','trans_ap','blk_c_pred','axi4_master_0_ae')
## Connection 02
env.addQvipConnection('qvip_env_axi4_master_1', 'trans_ap', 'blk_c_pred', 'axi4_master_1_ae')
## Connection 03
env.addConnection('blk_c_pred','mem_sb_ap','mem_sb','expected_analysis_export')
## Connection 04
env.addConnection('blk_c_pred','pkt_sb_ap','pkt_sb','expected_analysis_export')
## Connection 05
env.addConnection('blk_c_pred','axi4_slave_ap','axi4_slave_sb','expected_analysis_export')
## Connection 06
env.addConnection('blk_c_pred','apb3_config_master_ap','apb3_cfg_sb','expected_analysis_export')
## Connection 07
env.addConnection('mem_out','monitored_ap','mem_sb','actual_analysis_export')
## Connection 08
env.addConnection('pkt_out','monitored_ap','pkt_sb','actual_analysis_export')
## Connection 09
env.addQvipConnection('qvip_env_axi4_slave','trans_ap','axi4_slave_sb','actual_analysis_export')
## Connection 10
env.addQvipConnection('qvip_env_apb3_config_master','trans_ap','apb3_cfg_sb','actual_analysis_export')

env.create() 

