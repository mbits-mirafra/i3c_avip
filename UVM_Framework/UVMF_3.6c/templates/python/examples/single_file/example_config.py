#! /usr/bin/env python

## Example UVMF template configuration module
## This example will produce several new interface/agent packages, an
##   environment package and a project bench.  Note that the
##   'def','ghi' and 'jkl' interfaces are simply copies of the
##   first agent and are NOT examples of what you should actually
##   be doing.  They are included here to fill out the contents of
##   the environment example.
## 
## It is allowable to split the creation of interfaces, environments
##   and benches into separate config files to be executed
##   independently of one another, just make sure that the uvmf_gen
##   module is imported at the top of each file.

import uvmf_gen

## The input to this call is the name of the desired interface
intf = uvmf_gen.InterfaceClass('abc')

## Specify the clock and reset signal for the interface
intf.clock = 'paClk'
intf.reset = 'paRst'

## Specify the ports associated with this interface.
##   addPort(<name>,<width>,[input|output|inout])
intf.addPort('wdata',8,'input')
intf.addPort('addr',16,'input')
intf.addPort('rdata',8,'output')

intf.addHdlParamDef('NUM_FILTERS','int','20')
intf.addHdlParamDef('NUM_TAPS','int','12')

## Specify transaction variables for the interface.
##   addTransVar(<name>,<type>)
##     optionally can specify if this variable may be specified as 'rand'
intf.addTransVar('trnVar1','byte',isrand=False)
intf.addTransVar('trnVar2','int',isrand=True)
intf.addTransVar('trnVar3','bit [15:0]',isrand=False)

## Specify configuration variables for the interface.
##   addConfigVar(<name>,<type>)
##     optionally can specify if this variable may be specified as 'rand'
intf.addConfigVar('cfgVar1','bit',isrand=False)
intf.addConfigVar('cfgVar2','int',isrand=True)
intf.addConfigVar('cfgVar3','bit [3:0]',isrand=False)

## Set to True if you want this interface code to be Veloce ready,
##  otherwise don't set or set to False
intf.veloceReady = True

## This will prompt the creation of all interface files in their specified
##  locations
intf.create()

## Creating a few other interfaces for illustrative purposes...all same guts, just
## creating more package types for use in the environment.  DO NOT USE THESE
## IN A REAL ENVIRONMENT!
intf.name = 'def'
intf.clock = 'pdClk'
intf.reset = 'pdRst'
intf.create()
intf.name = 'ghi'
intf.clock = 'pgClk'
intf.reset = 'pgRst'
intf.create()
intf.name = 'jkl'
intf.clock = 'pjClk'
intf.reset = 'pjRst'
intf.create()

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

## Set to False if you do not want this bench code to be Veloce ready,
## otherwise don't set or set to True
ben.veloceReady = True

## This will prompt the creation of all bench files in their specified
##  locations
ben.create()
