#! /usr/bin/env python

import uvmf_gen
env = uvmf_gen.EnvironmentClass('ahb2wb')

## Specify the agents contained in this environment
##   addAgent(<agent_handle_name>,<agent_package_name>,<clock_name>,<reset_name>)
# Note: the agent_package_name will have _pkg appended to it.
env.addAgent('ahb', 'ahb', 'hclk', 'hresetn')
env.addAgent('wb',  'wb', 'clk', 'rst')

## Define the predictors contained in this environment (not instantiate, yet)
## addAnalysisComponent(<keyword>,<predictor_type_name>,<dict_of_exports>,<dict_of_ports>) - 
## doing this will add the requested analysis component
## to the list, enabling the use of the given template (identified by <keyword>)
env.defineAnalysisComponent('predictor','ahb2wb_predictor',{'ahb_ae':'ahb_transaction'},
                                                           {'wb_ap':'wb_transaction', 'ahb_ap':'ahb_transaction' })
env.defineAnalysisComponent('predictor','wb2ahb_predictor',{'wb_ae':'wb_transaction'},
                                                           {'wb_ap':'wb_transaction', 'ahb_ap':'ahb_transaction' })

## Instantiate the components in this environment
## addAnalysisComponent(<name>,<type>)
env.addAnalysisComponent('ahb2wb_pred','ahb2wb_predictor')
env.addAnalysisComponent('wb2ahb_pred','wb2ahb_predictor')

## Specify the scoreboards contained in this environment
## addUvmfScoreboard(<scoreboard_handle_name>, <uvmf_scoreboard_type_name>, <transaction_type_name>)
env.addUvmfScoreboard('ahb2wb_sb','uvmf_in_order_scoreboard','wb_transaction')
env.addUvmfScoreboard('wb2ahb_sb', 'uvmf_in_order_scoreboard','ahb_transaction')

## Specify the connections in the environment
## addConnection(<output_component>, < output_port_name>, <input_component>, <input_component_export_name>)
## Connection 00 ahb agent to ahb2wb predictor
env.addConnection('ahb', 'monitored_ap', 'ahb2wb_pred', 'ahb_ae')
## Connection 01 ahb2wb predictor to ahb2wb scoreboard for AHB write operations
env.addConnection('ahb2wb_pred', 'wb_ap', 'ahb2wb_sb', 'expected_analysis_export')
## Connection 02 ahb2wb predictor to wb2ahb scoreboard for AHB read operations
env.addConnection('ahb2wb_pred', 'ahb_ap', 'wb2ahb_sb', 'actual_analysis_export')
## Connection 03 wb agent to wb2ahb predictor
env.addConnection('wb', 'monitored_ap', 'wb2ahb_pred', 'wb_ae')
## Connection 04 wb2ahb predictor to ahb2wb scoreboard for AHB write operations
env.addConnection('wb2ahb_pred', 'wb_ap', 'ahb2wb_sb', 'actual_analysis_export')
## Connection 05 wb2ahb predictor to wb2ahb scoreboard for AHB read operations
env.addConnection('wb2ahb_pred', 'ahb_ap', 'wb2ahb_sb', 'expected_analysis_export')


env.create() 
