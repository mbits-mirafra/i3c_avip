//----------------------------------------------------------------------
// Created with uvmf_gen version 2020.1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface contains the alu_in interface signals.
//      It is instantiated once per alu_in bus.  Bus Functional Models, 
//      BFM's named alu_in_driver_bfm, are used to drive signals on the bus.
//      BFM's named alu_in_monitor_bfm are used to monitor signals on the 
//      bus. This interface signal bundle is passed in the port list of
//      the BFM in order to give the BFM access to the signals in this
//      interface.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
// This template can be used to connect a DUT to these signals
//
// .dut_signal_port(alu_in_bus.alu_rst), // Agent output 
// .dut_signal_port(alu_in_bus.ready), // Agent input 
// .dut_signal_port(alu_in_bus.valid), // Agent output 
// .dut_signal_port(alu_in_bus.op), // Agent output 
// .dut_signal_port(alu_in_bus.a), // Agent output 
// .dut_signal_port(alu_in_bus.b), // Agent output 

import uvmf_base_pkg_hdl::*;
import alu_in_pkg_hdl::*;

interface  alu_in_if #(
  int ALU_IN_OP_WIDTH = 8
  )

  (
  input tri clk, 
  input tri rst,
  inout tri  alu_rst,
  inout tri  ready,
  inout tri  valid,
  inout tri [2:0] op,
  inout tri [ALU_IN_OP_WIDTH-1:0] a,
  inout tri [ALU_IN_OP_WIDTH-1:0] b
  );

modport monitor_port 
  (
  input clk,
  input rst,
  input alu_rst,
  input ready,
  input valid,
  input op,
  input a,
  input b
  );

modport initiator_port 
  (
  input clk,
  input rst,
  output alu_rst,
  input ready,
  output valid,
  output op,
  output a,
  output b
  );

modport responder_port 
  (
  input clk,
  input rst,  
  input alu_rst,
  output ready,
  input valid,
  input op,
  input a,
  input b
  );
  

// pragma uvmf custom interface_item_additional begin
// pragma uvmf custom interface_item_additional end

endinterface

