//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface contains the spi interface signals.
//      It is instantiated once per spi bus.  Bus Functional Models, 
//      BFM's named spi_driver_bfm, are used to drive signals on the bus.
//      BFM's named spi_monitor_bfm are used to monitor signals on the 
//      bus. This interface signal bundle is passed in the port list of
//      the BFM in order to give the BFM access to the signals in this
//      interface.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
// This template can be used to connect a DUT to these signals
//
// .dut_signal_port(spi_bus.mosi), // Agent output 
// .dut_signal_port(spi_bus.miso), // Agent input 

import uvmf_base_pkg_hdl::*;
import spi_pkg_hdl::*;

interface  spi_if 

  (
  input tri sck, 
  input tri rst,
  inout tri  mosi,
  inout tri  miso
  );

modport monitor_port 
  (
  input sck,
  input rst,
  input mosi,
  input miso
  );

modport initiator_port 
  (
  input sck,
  input rst,
  output mosi,
  input miso
  );

modport responder_port 
  (
  input sck,
  input rst,  
  input mosi,
  output miso
  );
  

// pragma uvmf custom interface_item_additional begin
// pragma uvmf custom interface_item_additional end

endinterface

