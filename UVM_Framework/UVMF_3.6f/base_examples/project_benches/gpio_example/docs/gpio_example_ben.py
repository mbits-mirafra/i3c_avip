#! /usr/bin/env python

import uvmf_gen


## The input to this call is the name of the desired bench and the name of the top 
## environment package
##   BenchClass(<bench_name>,<env_name>,{environmentParameter:value})
ben = uvmf_gen.BenchClass('gpio_example','gpio_example',{})

## Specify the agents contained in this bench
##   addAgent(<agent_handle_name>,<agent_type_name>,<clock_name>,<reset_name>,<activity>,<{bfmParameter:value})
ben.addBfm('gpio_a',      'gpio',       'clk', 'rst','ACTIVE', {'READ_PORT_WIDTH':'16','WRITE_PORT_WIDTH':'32'})
ben.addBfm('gpio_b',     'gpio',       'clk', 'rst','ACTIVE', {'READ_PORT_WIDTH':'32','WRITE_PORT_WIDTH':'16'})

## This will prompt the creation of all bench files in their specified
##  locations
ben.create()

