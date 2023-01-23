//----------------------------------------------------------------------
// Created with uvmf_gen version 2020.1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface contains the alu_out interface signals.
//      It is instantiated once per alu_out bus.  Bus Functional Models, 
//      BFM's named alu_out_driver_bfm, are used to drive signals on the bus.
//      BFM's named alu_out_monitor_bfm are used to monitor signals on the 
//      bus. This interface signal bundle is passed in the port list of
//      the BFM in order to give the BFM access to the signals in this
//      interface.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
// This template can be used to connect a DUT to these signals
//
// .dut_signal_port(alu_out_bus.done), // Agent input 
// .dut_signal_port(alu_out_bus.result), // Agent input 

import uvmf_base_pkg_hdl::*;
import alu_out_pkg_hdl::*;

interface  alu_out_if #(
  int ALU_OUT_RESULT_WIDTH = 16
  )

  (
  input tri clk, 
  input tri rst,
  inout tri  done,
  inout tri [ALU_OUT_RESULT_WIDTH-1:0] result
  );

modport monitor_port 
  (
  input clk,
  input rst,
  input done,
  input result
  );

modport initiator_port 
  (
  input clk,
  input rst,
  input done,
  input result
  );

modport responder_port 
  (
  input clk,
  input rst,  
  output done,
  output result
  );
  

// pragma uvmf custom interface_item_additional begin
// pragma uvmf custom interface_item_additional end

endinterface

