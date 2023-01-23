#! /usr/bin/env python

import uvmf_gen
env = uvmf_gen.EnvironmentClass('wb2spi')

## Specify the agents contained in this environment
##   addAgent(<agent_handle_name>,<agent_package_name>,<clock_name>,<reset_name>)
# Note: the agent_package_name will have _pkg appended to it.
env.addAgent('wb',      'wb', 'clk', 'rst')
env.addAgent('spi',     'spi', 'sck', 'dummy')

## Define the predictors contained in this environment (not instantiate, yet)
## addAnalysisComponent(<keyword>,<predictor_type_name>,<dict_of_exports>,<dict_of_ports>) - 
## doing this will add the requested analysis component
## to the list, enabling the use of the given template (identified by <keyword>)
env.defineAnalysisComponent('predictor','wb2spi_predictor',{'wb_ae':'wb_transaction'},
                                                           {'wb2spi_sb_ap':'spi_transaction'})

## Instantiate the components in this environment
## addAnalysisComponent(<name>,<type>)
env.addAnalysisComponent('wb2spi_pred','wb2spi_predictor')
## Add spi mem slave coverage component which is defined in the spi_pkg.
env.addAnalysisComponent('spi_mem_slave_coverage','spi_mem_slave_transaction_coverage')
## Add spi mem slave transaction viewer component which is defined in the spi_pkg.
env.addAnalysisComponent('spi_mem_slave_viewer','spi_mem_slave_transaction_viewer')

## Specify the scoreboards contained in this environment
## addUvmfScoreboard(<scoreboard_handle_name>, <uvmf_scoreboard_type_name>, <transaction_type_name>)
env.addUvmfScoreboard('wb2spi_sb','uvmf_in_order_scoreboard','spi_transaction')

## Specify the connections in the environment
## addConnection(<output_component>, < output_port_name>, <input_component>, <input_component_export_name>)
## Connection 00
env.addConnection('wb', 'monitored_ap', 'wb2spi_pred', 'wb_ae')
## Connection 01
env.addConnection('wb2spi_pred', 'wb2spi_sb_ap', 'wb2spi_sb', 'expected_analysis_export')
## Connection 02
env.addConnection('spi', 'monitored_ap', 'wb2spi_sb', 'actual_analysis_export')
## Connection 03
env.addConnection('spi', 'monitored_ap', 'spi_mem_slave_coverage', 'analysis_export')
## Connection 04
env.addConnection('spi', 'monitored_ap', 'spi_mem_slave_viewer', 'analysis_export')

env.create() 
