//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
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
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
// This template can be used to connect a DUT to these signals
//
// .dut_signal_port(wb_bus.inta), // Agent output 
// .dut_signal_port(wb_bus.cyc), // Agent output 
// .dut_signal_port(wb_bus.stb), // Agent output 
// .dut_signal_port(wb_bus.adr), // Agent output 
// .dut_signal_port(wb_bus.we), // Agent output 
// .dut_signal_port(wb_bus.dout), // Agent output 
// .dut_signal_port(wb_bus.din), // Agent input 
// .dut_signal_port(wb_bus.err), // Agent output 
// .dut_signal_port(wb_bus.rty), // Agent output 
// .dut_signal_port(wb_bus.sel), // Agent input 
// .dut_signal_port(wb_bus.q), // Agent input 
// .dut_signal_port(wb_bus.ack), // Agent input 

import uvmf_base_pkg_hdl::*;
import wb_pkg_hdl::*;

interface  wb_if #(
  int WB_ADDR_WIDTH = 32,
  int WB_DATA_WIDTH = 16
  )

  (
  input tri clk, 
  input tri rst,
  inout tri  inta,
  inout tri  cyc,
  inout tri  stb,
  inout tri [WB_ADDR_WIDTH-1:0] adr,
  inout tri  we,
  inout tri [WB_DATA_WIDTH-1:0] dout,
  inout tri [WB_DATA_WIDTH-1:0] din,
  inout tri  err,
  inout tri  rty,
  inout tri [WB_DATA_WIDTH/8-1:0] sel,
  inout tri [WB_DATA_WIDTH-1:0] q,
  inout tri  ack
  );

modport monitor_port 
  (
  input clk,
  input rst,
  input inta,
  input cyc,
  input stb,
  input adr,
  input we,
  input dout,
  input din,
  input err,
  input rty,
  input sel,
  input q,
  input ack
  );

modport initiator_port 
  (
  input clk,
  input rst,
  output inta,
  output cyc,
  output stb,
  output adr,
  output we,
  output dout,
  input din,
  output err,
  output rty,
  input sel,
  input q,
  input ack
  );

modport responder_port 
  (
  input clk,
  input rst,  
  input inta,
  input cyc,
  input stb,
  input adr,
  input we,
  input dout,
  output din,
  input err,
  input rty,
  output sel,
  output q,
  output ack
  );
  

// pragma uvmf custom interface_item_additional begin
// pragma uvmf custom interface_item_additional end

endinterface

