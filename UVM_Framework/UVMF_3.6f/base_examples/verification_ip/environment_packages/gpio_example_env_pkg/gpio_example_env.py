#! /usr/bin/env python

import uvmf_gen
env = uvmf_gen.EnvironmentClass('gpio_example')

## Specify parameters for this interface package.
## These parameters can be used when defining signal and variable sizes.
# addParamDef(<name>,<type>,<value>)


## Specify the agents contained in this environment
##   addAgent(<agent_handle_name>,<agent_package_name>,<clock_name>,<reset_name>,<{interfaceParameter1:value1,interfaceParameter2:value2}>)
# Note: the agent_package_name will have _pkg appended to it.
env.addAgent('gpio_a',      'gpio',       'clk', 'rst',{'READ_PORT_WIDTH':'16','WRITE_PORT_WIDTH':'32'})
env.addAgent('gpio_b',     'gpio',       'clk', 'rst',{'READ_PORT_WIDTH':'32','WRITE_PORT_WIDTH':'16'})

env.create() 
