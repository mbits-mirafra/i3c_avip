//----------------------------------------------------------------------
// Created with uvmf_gen version 2020.2
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface contains the ALU_out interface signals.
//      It is instantiated once per ALU_out bus.  Bus Functional Models, 
//      BFM's named ALU_out_driver_bfm, are used to drive signals on the bus.
//      BFM's named ALU_out_monitor_bfm are used to monitor signals on the 
//      bus. This interface signal bundle is passed in the port list of
//      the BFM in order to give the BFM access to the signals in this
//      interface.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
// This template can be used to connect a DUT to these signals
//
// .dut_signal_port(ALU_out_bus.done), // Agent input 
// .dut_signal_port(ALU_out_bus.result), // Agent input 

import uvmf_base_pkg_hdl::*;
import ALU_out_pkg_hdl::*;

interface  ALU_out_if #(
  int ALU_OUT_RESULT_WIDTH = 16
  )(
  input tri clk, 
  input tri rst,
  inout tri  done,
  inout tri [ALU_OUT_RESULT_WIDTH-1:0] result
);

// pragma uvmf custom interface_item_additional begin
// pragma uvmf custom interface_item_additional end

endinterface

