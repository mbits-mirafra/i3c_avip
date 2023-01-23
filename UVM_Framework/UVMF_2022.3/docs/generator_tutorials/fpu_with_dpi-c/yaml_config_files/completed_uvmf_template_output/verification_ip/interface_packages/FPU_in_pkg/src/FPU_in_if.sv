//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU_in interface agent
// Unit            : Interface Signal Bundle
// File            : FPU_in_if.sv
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface contains the FPU_in interface signals.
//      It is instantiated once per FPU_in bus.  Bus Functional Models, 
//      BFM's named FPU_in_driver_bfm, are used to drive signals on the bus.
//      BFM's named FPU_in_monitor_bfm are used to monitor signals on the 
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
// .dut_signal_port(FPU_in_bus.ready), // Agent input 
// .dut_signal_port(FPU_in_bus.start), // Agent output 
// .dut_signal_port(FPU_in_bus.op), // Agent output 
// .dut_signal_port(FPU_in_bus.rmode), // Agent output 
// .dut_signal_port(FPU_in_bus.a), // Agent output 
// .dut_signal_port(FPU_in_bus.b), // Agent output 
// .dut_signal_port(FPU_in_bus.result), // Agent input 

import uvmf_base_pkg_hdl::*;
import FPU_in_pkg_hdl::*;

interface  FPU_in_if       #(
      int FP_WIDTH = 32                                
      )
 ( 
  input tri clk, 
  input tri rst
  ,inout tri  ready
  ,inout tri  start
  ,inout tri [2:0] op
  ,inout tri [1:0] rmode
  ,inout tri [FP_WIDTH-1:0] a
  ,inout tri [FP_WIDTH-1:0] b
  ,inout tri [FP_WIDTH-1:0] result
);

endinterface

