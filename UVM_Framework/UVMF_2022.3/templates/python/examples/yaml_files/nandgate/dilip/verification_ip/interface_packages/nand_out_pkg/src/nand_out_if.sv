//----------------------------------------------------------------------
// Created with uvmf_gen version 2022.3
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface contains the nand_out interface signals.
//      It is instantiated once per nand_out bus.  Bus Functional Models, 
//      BFM's named nand_out_driver_bfm, are used to drive signals on the bus.
//      BFM's named nand_out_monitor_bfm are used to monitor signals on the 
//      bus. This interface signal bundle is passed in the port list of
//      the BFM in order to give the BFM access to the signals in this
//      interface.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
// This template can be used to connect a DUT to these signals
//
// .dut_signal_port(nand_out_bus.y), // Agent input 

import uvmf_base_pkg_hdl::*;
import nand_out_pkg_hdl::*;

interface  nand_out_if 

  (
  input tri clk, 
  input tri rst,
  inout tri  y
  );

modport monitor_port 
  (
  input clk,
  input rst,
  input y
  );

modport initiator_port 
  (
  input clk,
  input rst,
  input y
  );

modport responder_port 
  (
  input clk,
  input rst,  
  output y
  );
  

// pragma uvmf custom interface_item_additional begin
// pragma uvmf custom interface_item_additional end

endinterface

// pragma uvmf custom external begin
// pragma uvmf custom external end

