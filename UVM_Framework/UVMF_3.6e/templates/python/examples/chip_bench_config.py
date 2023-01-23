#! /usr/bin/env python

import uvmf_gen


## The input to this call is the name of the desired bench and the name of the top 
## environment package
##   BenchClass(<bench_name>,<env_name>,{envParameter:value})
ben = uvmf_gen.BenchClass('chip','chip', {'CHIP_CP_IN_DATA_WIDTH':'TEST_CP_IN_DATA_WIDTH',
                                          'CHIP_CP_IN_ADDR_WIDTH':'TEST_CP_IN_ADDR_WIDTH',
                                          'CHIP_CP_OUT_ADDR_WIDTH':'TEST_CP_OUT_ADDR_WIDTH',
                                          'CHIP_UDP_DATA_WIDTH':'TEST_UDP_DATA_WIDTH'})

## Specify parameters for this interface package.
## These parameters can be used when defining signal and variable sizes.
# ben.addParamDef(<name>,<type>,<value>)
ben.addParamDef('TEST_CP_IN_DATA_WIDTH','int','28')
ben.addParamDef('TEST_CP_IN_ADDR_WIDTH','int','37')
ben.addParamDef('TEST_CP_OUT_ADDR_WIDTH','int','37')
ben.addParamDef('TEST_UDP_DATA_WIDTH','int','28')

## Specify the BFM's contained in this bench
##   addAgent(<agent_handle_name>,<agent_type_name>,<clock_name>,<reset_name>,<activity>,<{bfmParameter:value},<pathToSubEnvironmentsForTransactionViewing>)

## block a environment agents in the same order listed in block a config file
ben.addBfm('control_plane_in',      'mem', 'clock', 'reset','ACTIVE', {},'environment/block_a_env')
ben.addBfm('internal_control_plane_out',     'mem', 'clock', 'reset','PASSIVE', {},'environment/block_a_env')
ben.addBfm('secure_data_plane_in',  'pkt', 'pclk', 'prst','ACTIVE',   {},'environment/block_a_env')
ben.addBfm('secure_data_plane_out', 'pkt', 'pclk', 'prst', 'ACTIVE',{},'environment/block_a_env')

## block b environment agents in the same order listed in block b config file
ben.addBfm('internal_control_plane_in',       'mem', 'clock', 'reset','PASSIVE',{'ADDR_WIDTH':'TEST_CP_IN_ADDR_WIDTH','DATA_WIDTH':'TEST_CP_IN_DATA_WIDTH'},'environment/block_b_env')
ben.addBfm('control_plane_out',      'mem', 'clock', 'reset','ACTIVE',{'ADDR_WIDTH':'TEST_CP_OUT_ADDR_WIDTH'},'environment/block_b_env')
ben.addBfm('unsecure_data_plane_in', 'pkt', 'pclk', 'prst','ACTIVE',{'DATA_WIDTH':'TEST_UDP_DATA_WIDTH'},'environment/block_b_env')
ben.addBfm('unsecure_data_plane_out','pkt', 'pclk', 'prst','ACTIVE',{},'environment/block_b_env')

## This will prompt the creation of all bench files in their specified
##  locations
ben.create()

