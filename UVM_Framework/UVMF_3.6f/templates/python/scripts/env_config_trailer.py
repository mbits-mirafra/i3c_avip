
env.create() 

## ######################################################################################################
##
## Other API's available for building environment
##
## Specify the agents contained in this environment
##   addAgent(<agent_handle_name>,<agent_package_name>,<clock_name>,<reset_name>)
# Note: the agent_package_name will have _pkg appended to it.
## env.addAgent('control_plane_in',      'abc', 'paClk', 'paRst')

## Define the predictors contained in this environment (not instantiate, yet)
## addAnalysisComponent(<keyword>,<predictor_type_name>,<dict_of_exports>,<dict_of_ports>) - 
## doing this will add the requested analysis component
## to the list, enabling the use of the given template (identified by <keyword>)
## env.defineAnalysisComponent('predictor','block_a_predictor',{'control_plane_in_ae':'abc_transaction',
##                                                            'secure_data_plane_in_ae':'def_transaction'},
##                                                           {'control_plane_sb_ap':'abc_transaction',
##                                                            'secure_data_plane_sb_ap':'def_transaction'})

## Instantiate the components in this environment
## addAnalysisComponent(<name>,<type>)
## env.addAnalysisComponent('block_a_pred','block_a_predictor')

## Specify the scoreboards contained in this environment
## addUvmfScoreboard(<scoreboard_handle_name>, <uvmf_scoreboard_type_name>, <transaction_type_name>)
## env.addUvmfScoreboard('control_plane_sb','uvmf_in_order_scoreboard','abc_transaction')

## Specify the connections in the environment
## addConnection(<output_component>, < output_port_name>, <input_component>, <input_component_export_name>)
## For connecting UVM to UVM Components
## env.addConnection('control_plane_in', 'monitored_ap', 'block_a_pred', 'control_plane_in_ae')
## For connecting QVIP to UVM Components
## env.addQvipConnection('qvip_env_axi4_master_1', 'trans_ap', 'blk_c_pred', 'axi4_master_1_ae')

