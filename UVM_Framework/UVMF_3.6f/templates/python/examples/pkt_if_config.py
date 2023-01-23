#! /usr/bin/env python

import uvmf_gen

## The input to this call is the name of the desired interface
intf = uvmf_gen.InterfaceClass('pkt')

## Specify parameters for this interface package.
## These parameters can be used when defining signal and variable sizes.
# addHdlParamDef(<name>,<type>,<value>)
intf.addParamDef('DATA_WIDTH','int','240')
intf.addParamDef('STATUS_WIDTH','int','230')

## Specify the clock and reset signal for the interface
intf.clock = 'pclk'
intf.reset = 'prst'
intf.resetAssertionLevel = False

## Specify the ports associated with this interface.
## The direction is from the perspective of the test bench as an INITIATOR on the bus.
##   addPort(<name>,<width>,[input|output|inout])
intf.addPort('sop',1,'output')
intf.addPort('eop',1,'output')
intf.addPort('rdy',1,'input')
intf.addPort('data','DATA_WIDTH','output')
intf.addPort('status','STATUS_WIDTH','input')

## Specify transaction variables for the interface.
##   addTransVar(<name>,<type>)
##     optionally can specify if this variable may be specified as 'rand'
##     optionally can specify if this variable may be specified as used in do_compare()
intf.addTransVar('data','bit [DATA_WIDTH-1:0]',isrand=False,iscompare=True)
intf.addTransVar('dst_address','bit [DATA_WIDTH-1:0]',isrand=True,iscompare=True)
intf.addTransVar('status','bit [STATUS_WIDTH-1:0]',isrand=True,iscompare=True)

## Specify transaction variable constraint
## addTransVarConstraint(<constraint_body_name>,<constraint_body_definition>)
intf.addTransVarConstraint('valid_dst_c','{ dst_address inside {1,2,4,8,16,32,64,128,256,512,1024,2048}; }')

## Specify configuration variables for the interface.
##   addConfigVar(<name>,<type>)
##     optionally can specify if this variable may be specified as 'rand'
intf.addConfigVar('src_address','bit [DATA_WIDTH-1:0]',isrand=True)

## Specify configuration variable constraint
## addConfigVarConstraint(<constraint_body_name>,<constraint_body_definition>)
intf.addConfigVarConstraint('valid_dst_c','{ src_address inside {[63:16], 1025}; }')

## This will prompt the creation of all interface files in their specified
##  locations
intf.create()
