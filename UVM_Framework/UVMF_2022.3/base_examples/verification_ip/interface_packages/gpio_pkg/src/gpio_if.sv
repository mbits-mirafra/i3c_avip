//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface contains the gpio interface signals.
//      It is instantiated once per gpio bus.  Bus Functional Models, 
//      BFM's named gpio_driver_bfm, are used to drive signals on the bus.
//      BFM's named gpio_monitor_bfm are used to monitor signals on the 
//      bus. This interface signal bundle is passed in the port list of
//      the BFM in order to give the BFM access to the signals in this
//      interface.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
// This template can be used to connect a DUT to these signals
//
// .dut_signal_port(gpio_bus.read_port), // Agent input 
// .dut_signal_port(gpio_bus.write_port), // Agent output 

import uvmf_base_pkg_hdl::*;
import gpio_pkg_hdl::*;

interface  gpio_if #(
  int READ_PORT_WIDTH = 4,
  int WRITE_PORT_WIDTH = 4
  )

  (
  input tri clk, 
  input tri rst,
  inout tri [READ_PORT_WIDTH-1:0] read_port,
  inout tri [WRITE_PORT_WIDTH-1:0] write_port
  );

modport monitor_port 
  (
  input clk,
  input rst,
  input read_port,
  input write_port
  );

modport initiator_port 
  (
  input clk,
  input rst,
  input read_port,
  output write_port
  );

modport responder_port 
  (
  input clk,
  input rst,  
  output read_port,
  input write_port
  );
  

// pragma uvmf custom interface_item_additional begin
// pragma uvmf custom interface_item_additional end

endinterface

