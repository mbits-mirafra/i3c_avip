#! /usr/bin/env python

import uvmf_gen

## The input to this call is the name of the desired environment
env = uvmf_gen.EnvironmentClass('abc_prj')

## Specify the agents contained in this environment
##   addAgent(<agent_handle_name>,<agent_type_name>,<clock_name>,<reset_name>)
env.addAgent('abc_in'  ,'abc', 'paClk','paRst')
env.addAgent('abc_out' ,'abc', 'paClk','paRst')
env.addAgent('abc_ctrl','abc', 'paClk','paRst')
env.addAgent('abc_mm'  ,'abc', 'paClk','paRst')
env.addAgent('def_00'  ,'def', 'pdClk','pdRst')
env.addAgent('def_01'  ,'def', 'pdClk','pdRst')
env.addAgent('def_02'  ,'def', 'pdClk','pdRst')
env.addAgent('ghi_01'  ,'ghi', 'pgClk','pgRst')
env.addAgent('ghi_02'  ,'ghi', 'pgClk','pgRst')
env.addAgent('jkl_02'  ,'jkl', 'pjClk','pjRst')

env.create()
