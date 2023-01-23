#! /usr/bin/env python

import uvmf_gen

## The input to this call is the name of the desired interface
intf = uvmf_gen.InterfaceClass('ahb')

## Specify the clock and reset signal for the interface
intf.clock = 'hclk'
intf.reset = 'hresetn'

## Specify the ports associated with this interface.
## The direction is from the perspective of the test bench.
##   addPort(<name>,<width>,[input|output|inout])
intf.addPort('haddr',32,'output')
intf.addPort('hwdata',16,'output')
intf.addPort('htrans',2,'output')
intf.addPort('hburst',3,'output')
intf.addPort('hsize',3,'output')
intf.addPort('hwrite',1,'output')
intf.addPort('hsel',1,'output')
intf.addPort('hready',1,'input')
intf.addPort('hrdata',16,'input')
intf.addPort('hresp',2,'input')

## Specify typedef for inclusion in typedefs_hdl file
# addHdlTypedef(<name>,<type>)
intf.addHdlTypedef('ahb_op_t','enum {AHB_RESET, AHB_READ, AHB_WRITE}')

## Specify parameters for inclusion in typedefs_hdl file
# addHdlParamDef(<name>,<type>,<value>)

## Specify typedef for inclusion in typedefs file
# addHvlTypedef(<name>,<type>)

## Specify transaction variables for the interface.
##   addTransVar(<name>,<type>)
##     optionally can specify if this variable may be specified as 'rand'
intf.addTransVar('op','ahb_op_t',isrand=True,iscompare=False)
intf.addTransVar('data','bit [15:0]',isrand=True,iscompare=True)
intf.addTransVar('addr','bit [31:0]',isrand=True,iscompare=True)

## Specify transaction variable constraint
## addTransVarConstraint(<constraint_body_name>,<constraint_body_definition>)


## Specify configuration variables for the interface.
##   addConfigVar(<name>,<type>)
##     optionally can specify if this variable may be specified as 'rand'


## Specify configuration variable constraint
## addConfigVarConstraint(<constraint_body_name>,<constraint_body_definition>)

## This will prompt the creation of all interface files in their specified
##  locations
intf.create()
