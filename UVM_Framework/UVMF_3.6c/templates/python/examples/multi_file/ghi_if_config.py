#! /usr/bin/env python

import uvmf_gen

## The input to this call is the name of the desired interface
intf = uvmf_gen.InterfaceClass('ghi')

## Specify the clock and reset signal for the interface
intf.clock = 'pgClk'
intf.reset = 'pgRst'

## Specify the ports associated with this interface.
##   addPort(<name>,<width>,[input|output|inout])
intf.addPort('ghi_wdata',8,'input')
intf.addPort('ghi_addr',16,'input')
intf.addPort('ghi_rdata',8,'output')

## Specify transaction variables for the interface.
##   addTransVar(<name>,<type>)
##     optionally can specify if this variable may be specified as 'rand'
intf.addTransVar('ghi_trnVar1','byte',isrand=False)
intf.addTransVar('ghi_trnVar2','int',isrand=True)
intf.addTransVar('ghi_trnVar3','bit [15:0]',isrand=False)

## Specify configuration variables for the interface.
##   addConfigVar(<name>,<type>)
##     optionally can specify if this variable may be specified as 'rand'
intf.addConfigVar('ghi_cfgVar1','bit',isrand=False)
intf.addConfigVar('ghi_cfgVar2','int',isrand=True)
intf.addConfigVar('ghi_cfgVar3','bit [3:0]',isrand=False)

## Set to 'True' if you want this interface code to be Veloce ready,
##  otherwise don't set or set to 'False'
intf.veloceReady = True

## This will prompt the creation of all interface files in their specified
##  locations
intf.create()
