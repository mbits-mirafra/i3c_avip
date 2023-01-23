#! /usr/bin/env python

import uvmf_gen
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

