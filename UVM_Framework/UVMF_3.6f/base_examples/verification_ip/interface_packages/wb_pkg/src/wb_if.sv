//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : jcraft
// Creation Date   : 2016 Nov 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : wb interface agent
// Unit            : Interface Signal Bundle
// File            : wb_if.sv
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface contains the wb interface signals.
//      It is instantiated once per wb bus.  Bus Functional Models, 
//      BFM's named wb_driver_bfm, are used to drive signals on the bus.
//      BFM's named wb_monitor_bfm are used to monitor signals on the 
//      bus. This interface signal bundle is passed in the port list of
//      the BFM in order to give the BFM access to the signals in this
//      interface.
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
// This template can be used to connect a DUT to these signals
//
// .dut_signal_port(wb_bus.inta), // Agent inout 
// .dut_signal_port(wb_bus.cyc), // Agent inout 
// .dut_signal_port(wb_bus.stb), // Agent inout 
// .dut_signal_port(wb_bus.adr), // Agent inout 
// .dut_signal_port(wb_bus.we), // Agent inout 
// .dut_signal_port(wb_bus.dout), // Agent inout 
// .dut_signal_port(wb_bus.din), // Agent inout 
// .dut_signal_port(wb_bus.err), // Agent inout 
// .dut_signal_port(wb_bus.rty), // Agent inout 
// .dut_signal_port(wb_bus.sel), // Agent inout 
// .dut_signal_port(wb_bus.q), // Agent inout 

import uvmf_base_pkg_hdl::*;
import wb_pkg_hdl::*;

interface  wb_if       #(
      int WB_ADDR_WIDTH = 32,                                
      int WB_DATA_WIDTH = 16                                
      )
 ( 
  input tri clk, 
  input tri rst
  ,inout tri  inta
  ,inout tri  cyc
  ,inout tri  stb
  ,inout tri [WB_ADDR_WIDTH-1:0] adr
  ,inout tri  we
  ,inout tri [WB_DATA_WIDTH-1:0] dout
  ,inout tri [WB_DATA_WIDTH-1:0] din
  ,inout tri  err
  ,inout tri  rty
  ,inout tri [(WB_DATA_WIDTH/8)-1:0] sel
  ,inout tri [WB_DATA_WIDTH-1:0] q
  ,inout tri ack
);

endinterface

