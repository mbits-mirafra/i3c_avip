#! /usr/bin/env python

import uvmf_gen

## The input to this call is the name of the desired interface
intf = uvmf_gen.InterfaceClass('apb_if')

## Specify parameters for this interface package.
## These parameters can be used when defining signal and variable sizes.
# addHdlParamDef(<name>,<type>,<value>)
intf.addParamDef('DATA_WIDTH','int','32')
intf.addParamDef('ADDR_WIDTH','int','32')

## Specify the clock and reset signal for the interface
intf.pclk = 'pclk'
intf.preset_n = 'preset_n'
intf.resetAssertionLevel = True

## Specify the ports associated with this interface.
## The direction is from the perspective of the test bench as an INITIATOR on the bus.
##   addPort(<name>,<width>,[input|output|inout])
intf.addPort('pselx',1,'output')
intf.addPort('penable',1,'output')
intf.addPort('pwrite',1,'output')
intf.addPort('pready',1,'input')
intf.addPort('pslverr',1,'input')
intf.addPort('pprot',1,'output')
intf.addPort('paddr','[ADDR_WIDTH-1:0]','output')
intf.addPort('pwdata','[DATA_WIDTH-1:0]','output')
intf.addPort('prdata','[DATA_WIDTH-1:0]','input')
intf.addPort('pstrb','[(DATA_WIDTH/8)-1:0]','output')
intf.addPort('rdata','DATA_WIDTH','input')

## Specify typedef for inclusion in typedefs_hdl file
# addHdlTypedef(<name>,<type>)
intf.addHdlTypedef('my_byte_t','byte')
intf.addHdlTypedef('my_word_t','bit [15:0] ')

## Specify typedef for inclusion in typedefs file
# addHvlTypedef(<name>,<type>)
intf.addHvlTypedef('my_object_t','uvm_object')

## Specify transaction variables for the interface.
##   addTransVar(<name>,<type>)
##     optionally can specify if this variable may be specified as 'rand'
##     optionally can specify if this variable may be specified as used in do_compare()
intf.addTransVar('prdata','bit [DATA_WIDTH-1:0]',isrand=False,iscompare=True)
intf.addTransVar('pwdata','bit [DATA_WIDTH-1:0]',isrand=False,iscompare=True)
intf.addTransVar('paddr','bit [ADDR_WIDTH-1:0]',isrand=True,iscompare=True)
intf.addTransVar('pprot','bit [2:0]',isrand=True,iscompare=False)
intf.addTransVar('pselx','int',isrand=False,iscompare=False)

## Specify transaction variable constraint
## addTransVarConstraint(<constraint_body_name>,<constraint_body_definition>)
# intf.addTransVarConstraint('valid_address_range_c','{ address inside {[2048:1055], [1024:555], [511:0]}; }')
intf.addTransVarConstraint('pselx_c1','{ $countones(pselx)]==1; }')
intf.addTransVarConstraint('pselx_c2','{ pselx >0 && pselx <2**1; }')
intf.addTransVarConstraint('pwdata_c3','{soft pwdata inside {[0:100]} ; }')

## Specify configuration variables for the interface.
##   addConfigVar(<name>,<type>)
##     optionally can specify if this variable may be specified as 'rand'
intf.addConfigVar('transfer_size','bit [31:0]',isrand=True)

## Specify configuration variable constraint
## addConfigVarConstraint(<constraint_body_name>,<constraint_body_definition>)
intf.addTransVarConstraint('transfer_size_c4','{ transfer_size inside {8,16,24,32}; }')
## This will prompt the creation of all interface files in their specified
##  locations
## intf.inFactReady = False
intf.create()

