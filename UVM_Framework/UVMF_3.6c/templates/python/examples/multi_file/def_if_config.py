#! /usr/bin/env python

import uvmf_gen

## The input to this call is the name of the desired interface
intf = uvmf_gen.InterfaceClass('def')

## Specify the clock and reset signal for the interface
intf.clock = 'pdClk'
intf.reset = 'pdRst'

## Specify the ports associated with this interface.
##   addPort(<name>,<width>,[input|output|inout])
intf.addPort('def_wdata',8,'input')
intf.addPort('def_addr',16,'input')
intf.addPort('def_rdata',8,'output')

## Specify transaction variables for the interface.
##   addTransVar(<name>,<type>)
##     optionally can specify if this variable may be specified as 'rand'
intf.addTransVar('def_trnVar1','byte',isrand=False)
intf.addTransVar('def_trnVar2','int',isrand=True)
intf.addTransVar('def_trnVar3','bit [15:0]',isrand=False)

## Specify configuration variables for the interface.
##   addConfigVar(<name>,<type>)
##     optionally can specify if this variable may be specified as 'rand'
intf.addConfigVar('def_cfgVar1','bit',isrand=False)
intf.addConfigVar('def_cfgVar2','int',isrand=True)
intf.addConfigVar('def_cfgVar3','bit [3:0]',isrand=False)

## Set to 'True' if you want this interface code to be Veloce ready,
##  otherwise don't set or set to 'False'
intf.veloceReady = True

## This will prompt the creation of all interface files in their specified
##  locations
intf.create()
