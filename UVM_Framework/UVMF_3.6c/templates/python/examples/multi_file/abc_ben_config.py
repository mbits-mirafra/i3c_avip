#! /usr/bin/env python

import uvmf_gen


## The input to this call is the name of the desired bench and the name of the top 
## environment package
##   BenchClass(<bench_name>,<env_name>)
ben = uvmf_gen.BenchClass('abc_ben','abc_prj')

## Specify the agents contained in this bench
##   addAgent(<agent_handle_name>,<agent_type_name>,<clock_name>,<reset_name>)
ben.addAgent('abc_in'  ,'abc', 'paClk','paRst')
ben.addAgent('abc_out' ,'abc', 'paClk','paRst')
ben.addAgent('abc_ctrl','abc', 'paClk','paRst')
ben.addAgent('abc_mm'  ,'abc', 'paClk','paRst')
ben.addAgent('def_00'  ,'def', 'pdClk','pdRst')
ben.addAgent('def_01'  ,'def', 'pdClk','pdRst')
ben.addAgent('def_02'  ,'def', 'pdClk','pdRst')
ben.addAgent('ghi_01'  ,'ghi', 'pgClk','pgRst')
ben.addAgent('ghi_02'  ,'ghi', 'pgClk','pgRst')
ben.addAgent('jkl_02'  ,'jkl', 'pjClk','pjRst')

# Set to False if you do not want this bench code to be Veloce ready,
#  otherwise don't set or set to True
# ben.veloceReady = False


## This will prompt the creation of all bench files in their specified
##  locations
ben.create()
