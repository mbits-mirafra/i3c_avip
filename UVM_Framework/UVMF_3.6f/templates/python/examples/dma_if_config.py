#! /usr/bin/env python

import uvmf_gen

## The input to this call is the name of the desired interface
intf = uvmf_gen.InterfaceClass('dma')

## Specify parameters for this interface package.
## These parameters can be used when defining signal and variable sizes.
# addHdlParamDef(<name>,<type>,<value>)
intf.addParamDef('DATA_WIDTH','int','16')
intf.addParamDef('ADDR_WIDTH','int','8')

## Specify the clock and reset signal for the interface
intf.clock = 'clock'
intf.reset = 'reset'

## Specify the ports associated with this interface
## The direction is from the perspective of the test bench as an INITIATOR on the bus.  
##   addPort(<name>,<width>,[input|output|inout])
intf.addPort('rd_en',1,'output')
intf.addPort('wr_en',1,'output')
intf.addPort('addr','ADDR_WIDTH','output')
intf.addPort('wdata','DATA_WIDTH','output')
intf.addPort('rdata','DATA_WIDTH','input')

## Specify transaction variables for the interface.
##   addTransVar(<name>,<type>)
##     optionally can specify if this variable may be specified as 'rand'
##     optionally can specify if this variable may be specified as used in do_compare()
intf.addTransVar('addr','bit [ADDR_WIDTH-1:0]',isrand=True,iscompare=True)
intf.addTransVar('data','bit [DATA_WIDTH-1:0]',isrand=True,iscompare=True)
intf.addTransVar('wr','bit',isrand=True,iscompare=True)

## For a responder, need to provide information about what denotes a transaction
## that requires a response (i.e. a 'read' operation) and what parts of the transaction
## need to be passed back as that response.  This doesn't have to be comprehensive,
## as one will likely have to hand-edit the appropriate output code later on.
intf.specifyResponseOperation('~txn.wr')
intf.specifyResponseData(['data'])

## This will prompt the creation of all interface files in their specified
##  locations
intf.create()
