#! /usr/bin/env python

import uvmf_gen

## The input to this call is the name of the desired interface
intf = uvmf_gen.InterfaceClass('abc')

## Specify the clock and reset signal for the interface
intf.clock = 'paClk'
intf.reset = 'paRst'

## Specify the ports associated with this interface.
##   addPort(<name>,<width>,[input|output|inout])
intf.addPort('abc_wdata',8,'input')
intf.addPort('abc_addr',16,'input')
intf.addPort('abc_rdata',8,'output')

## Specify typedef for inclusion in typedefs_hdl file
# addHdlTypedef(<name>,<type>)
intf.addHdlTypedef('my_byte_t','byte')
intf.addHdlTypedef('my_word_t','bit [15:0] ')
intf.addHdlTypedef('colors_t','enum { red, green, blue, yellow, white, black }')

## Specify parameters for inclusion in typedefs_hdl file
# addHdlParamDef(<name>,<type>,<value>)
intf.addHdlParamDef('NUM_FILTERS','int','20')
intf.addHdlParamDef('NUM_TAPS','int','12')

## Specify typedef for inclusion in typedefs file
# addHvlTypedef(<name>,<type>)
intf.addHvlTypedef('my_object_t','uvm_object')

## Specify transaction variables for the interface.
##   addTransVar(<name>,<type>)
##     optionally can specify if this variable may be specified as 'rand'
intf.addTransVar('abc_trnVar1','my_byte_t',isrand=False)
intf.addTransVar('abc_trnVar2','int',isrand=True)
intf.addTransVar('abc_trnVar3','bit [15:0]',isrand=False)

## Specify configuration variables for the interface.
##   addConfigVar(<name>,<type>)
##     optionally can specify if this variable may be specified as 'rand'
intf.addConfigVar('abc_cfgVar1','bit',isrand=False)
intf.addConfigVar('abc_cfgVar2','colors_t',isrand=True)
intf.addConfigVar('abc_cfgVar3','bit [3:0]',isrand=False)

## This will prompt the creation of all interface files in their specified
##  locations
intf.create()
