#! /usr/bin/env python

import uvmf_gen


## The input to this call is the name of the desired bench and the name of the top 
## environment package
##   BenchClass(<bench_name>,<env_name>)
ben = uvmf_gen.BenchClass('wb2spi','wb2spi')

## Specify the agents contained in this bench
##   addAgent(<agent_handle_name>,<agent_type_name>,<clock_name>,<reset_name>,<activity>)
ben.addBfm('wb',      'wb', 'clk', 'rst', 'ACTIVE')
ben.addBfm('spi',     'spi', 'sck', 'dummy', 'ACTIVE')

## This will prompt the creation of all bench files in their specified
##  locations
ben.create()

