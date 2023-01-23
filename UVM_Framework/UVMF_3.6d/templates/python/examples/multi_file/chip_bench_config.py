#! /usr/bin/env python

import uvmf_gen


## The input to this call is the name of the desired bench and the name of the top 
## environment package
##   BenchClass(<bench_name>,<env_name>)
ben = uvmf_gen.BenchClass('chip','chip')

## Specify the agents contained in this bench
##   addAgent(<agent_handle_name>,<agent_type_name>,<clock_name>,<reset_name>)

## block a environment agents in the same order listed in block a config file
ben.addBfm('control_plane_in',           'abc', 'paClk', 'paRst', 'ACTIVE', 'environment/block_a_env')
ben.addBfm('internal_control_plane_out', 'abc', 'paClk', 'paRst', 'PASSIVE', 'environment/block_a_env')
ben.addBfm('secure_data_plane_in',       'def', 'pdClk', 'pdRst', 'ACTIVE', 'environment/block_a_env')
ben.addBfm('secure_data_plane_out',      'def', 'pdClk', 'pdRst', 'ACTIVE', 'environment/block_a_env')

## block b environment agents in the same order listed in block b config file
ben.addBfm('internal_control_plane_in',  'abc', 'paClk', 'paRst','PASSIVE', 'environment/block_b_env')
ben.addBfm('control_plane_out',          'abc', 'paClk', 'paRst','ACTIVE', 'environment/block_b_env')
ben.addBfm('unsecure_data_plane_in',     'def', 'pdClk', 'pdRst','ACTIVE', 'environment/block_b_env')
ben.addBfm('unsecure_data_plane_out',    'def', 'pdClk', 'pdRst','ACTIVE', 'environment/block_b_env')

## This will prompt the creation of all bench files in their specified
##  locations
ben.create()

