//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU_out interface agent
// Unit            : Interface Signal Bundle
// File            : FPU_out_if.sv
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface contains the FPU_out interface signals.
//      It is instantiated once per FPU_out bus.  Bus Functional Models, 
//      BFM's named FPU_out_driver_bfm, are used to drive signals on the bus.
//      BFM's named FPU_out_monitor_bfm are used to monitor signals on the 
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
// .dut_signal_port(FPU_out_bus.ine), // Agent input 
// .dut_signal_port(FPU_out_bus.overflow), // Agent input 
// .dut_signal_port(FPU_out_bus.underflow), // Agent input 
// .dut_signal_port(FPU_out_bus.div_zero), // Agent input 
// .dut_signal_port(FPU_out_bus.inf), // Agent input 
// .dut_signal_port(FPU_out_bus.zero), // Agent input 
// .dut_signal_port(FPU_out_bus.qnan), // Agent input 
// .dut_signal_port(FPU_out_bus.snan), // Agent input 
// .dut_signal_port(FPU_out_bus.ready), // Agent input 

import uvmf_base_pkg_hdl::*;
import FPU_out_pkg_hdl::*;

interface  FPU_out_if  ( 
  input tri clk, 
  input tri rst
  ,inout tri  ine
  ,inout tri  overflow
  ,inout tri  underflow
  ,inout tri  div_zero
  ,inout tri  inf
  ,inout tri  zero
  ,inout tri  qnan
  ,inout tri  snan
  ,inout tri  ready
);

endinterface

