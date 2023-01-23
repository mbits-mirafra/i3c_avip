#! /usr/bin/env python

import uvmf_gen


## The input to this call is the name of the desired bench and the name of the top 
## environment package
##   BenchClass(<bench_name>,<env_name>)
ben = uvmf_gen.BenchClass('ahb2wb','ahb2wb')

## Specify the agents contained in this bench
##   addAgent(<agent_handle_name>,<agent_type_name>,<clock_name>,<reset_name>,<activity>)
ben.addBfm('ahb', 'ahb', 'hclk', 'hresetn', 'ACTIVE')
ben.addBfm('wb',  'wb',  'clk',  'rst',     'ACTIVE')

## This will prompt the creation of all bench files in their specified
##  locations
ben.create()

