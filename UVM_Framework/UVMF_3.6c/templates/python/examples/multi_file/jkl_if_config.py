#! /usr/bin/env python

import uvmf_gen

## The input to this call is the name of the desired interface
intf = uvmf_gen.InterfaceClass('jkl')

## Specify the clock and reset signal for the interface
intf.clock = 'pjClk'
intf.reset = 'pjRst'

## Specify the ports associated with this interface.
##   addPort(<name>,<width>,[input|output|inout])
intf.addPort('jkl_wdata',8,'input')
intf.addPort('jkl_addr',16,'input')
intf.addPort('jkl_rdata',8,'output')

## Specify transaction variables for the interface.
##   addTransVar(<name>,<type>)
##     optionally can specify if this variable may be specified as 'rand'
intf.addTransVar('jkl_trnVar1','byte',isrand=False)
intf.addTransVar('jkl_trnVar2','int',isrand=True)
intf.addTransVar('jkl_trnVar3','bit [15:0]',isrand=False)

## Specify configuration variables for the interface.
##   addConfigVar(<name>,<type>)
##     optionally can specify if this variable may be specified as 'rand'
intf.addConfigVar('jkl_cfgVar1','bit',isrand=False)
intf.addConfigVar('jkl_cfgVar2','int',isrand=True)
intf.addConfigVar('jkl_cfgVar3','bit [3:0]',isrand=False)

## Set to 'True' if you want this interface code to be Veloce ready,
##  otherwise don't set or set to 'False'
intf.veloceReady = True

## This will prompt the creation of all interface files in their specified
##  locations
intf.create()
