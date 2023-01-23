//----------------------------------------------------------------------
// Created with uvmf_gen version 2021.1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface contains the ccs interface signals.
//      It is instantiated once per ccs bus.  Bus Functional Models, 
//      BFM's named ccs_driver_bfm, are used to drive signals on the bus.
//      BFM's named ccs_monitor_bfm are used to monitor signals on the 
//      bus. This interface signal bundle is passed in the port list of
//      the BFM in order to give the BFM access to the signals in this
//      interface.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
// This template can be used to connect a DUT to these signals
//
// .dut_signal_port(ccs_bus.rdy), // Agent input 
// .dut_signal_port(ccs_bus.vld), // Agent output 
// .dut_signal_port(ccs_bus.dat), // Agent output 

import uvmf_base_pkg_hdl::*;
import ccs_pkg_hdl::*;

interface  ccs_if #(
  int WIDTH = 32
  )

  (
  input tri clk, 
  input tri rst,
  inout tri  rdy,
  inout tri  vld,
  inout tri [WIDTH-1:0] dat
  );

modport monitor_port 
  (
  input clk,
  input rst,
  input rdy,
  input vld,
  input dat
  );

modport initiator_port 
  (
  input clk,
  input rst,
  input rdy,
  output vld,
  output dat
  );

modport responder_port 
  (
  input clk,
  input rst,  
  output rdy,
  input vld,
  input dat
  );
  

// pragma uvmf custom interface_item_additional begin
// pragma uvmf custom interface_item_additional end

endinterface

