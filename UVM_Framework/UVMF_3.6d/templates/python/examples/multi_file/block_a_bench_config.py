#! /usr/bin/env python

import uvmf_gen


## The input to this call is the name of the desired bench and the name of the top 
## environment package
##   BenchClass(<bench_name>,<env_name>)
ben = uvmf_gen.BenchClass('block_a','block_a')

## Specify the agents contained in this bench
##   addAgent(<agent_handle_name>,<agent_type_name>,<clock_name>,<reset_name>,<activity>)
ben.addBfm('control_plane_in',      'abc', 'paClk', 'paRst', 'ACTIVE')
ben.addBfm('control_plane_out',     'abc', 'paClk', 'paRst', 'ACTIVE')
ben.addBfm('secure_data_plane_in',  'def', 'pdClk', 'pdRst', 'ACTIVE')
ben.addBfm('secure_data_plane_out', 'def', 'pdClk', 'pdRst', 'ACTIVE')

## This will prompt the creation of all bench files in their specified
##  locations
ben.create()

