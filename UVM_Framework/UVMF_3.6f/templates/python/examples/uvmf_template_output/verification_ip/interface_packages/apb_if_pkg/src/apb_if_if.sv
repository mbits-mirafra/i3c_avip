//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : shwetapatil
// Creation Date   : 2022 Jun 06
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : apb_if interface agent
// Unit            : Interface Signal Bundle
// File            : apb_if_if.sv
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface contains the apb_if interface signals.
//      It is instantiated once per apb_if bus.  Bus Functional Models, 
//      BFM's named apb_if_driver_bfm, are used to drive signals on the bus.
//      BFM's named apb_if_monitor_bfm are used to monitor signals on the 
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
// .dut_signal_port(apb_if_bus.pselx), // Agent output 
// .dut_signal_port(apb_if_bus.penable), // Agent output 
// .dut_signal_port(apb_if_bus.pwrite), // Agent output 
// .dut_signal_port(apb_if_bus.pready), // Agent input 
// .dut_signal_port(apb_if_bus.pslverr), // Agent input 
// .dut_signal_port(apb_if_bus.pprot), // Agent output 
// .dut_signal_port(apb_if_bus.paddr), // Agent output 
// .dut_signal_port(apb_if_bus.pwdata), // Agent output 
// .dut_signal_port(apb_if_bus.prdata), // Agent input 
// .dut_signal_port(apb_if_bus.pstrb), // Agent output 
// .dut_signal_port(apb_if_bus.rdata), // Agent input 

import uvmf_base_pkg_hdl::*;
import apb_if_pkg_hdl::*;

interface  apb_if_if       #(
      int DATA_WIDTH = 32,                                
      int ADDR_WIDTH = 32                                
      )
 ( 
  input tri defaultClk, 
  input tri defaultRst
  ,inout tri  pselx
  ,inout tri  penable
  ,inout tri  pwrite
  ,inout tri  pready
  ,inout tri  pslverr
  ,inout tri  pprot
  ,inout tri [[ADDR_WIDTH-1:0]-1:0] paddr
  ,inout tri [[DATA_WIDTH-1:0]-1:0] pwdata
  ,inout tri [[DATA_WIDTH-1:0]-1:0] prdata
  ,inout tri [[(DATA_WIDTH/8)-1:0]-1:0] pstrb
  ,inout tri [DATA_WIDTH-1:0] rdata
);

endinterface

