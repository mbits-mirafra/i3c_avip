//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface contains the ahb interface signals.
//      It is instantiated once per ahb bus.  Bus Functional Models, 
//      BFM's named ahb_driver_bfm, are used to drive signals on the bus.
//      BFM's named ahb_monitor_bfm are used to monitor signals on the 
//      bus. This interface signal bundle is passed in the port list of
//      the BFM in order to give the BFM access to the signals in this
//      interface.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
// This template can be used to connect a DUT to these signals
//
// .dut_signal_port(ahb_bus.haddr), // Agent output 
// .dut_signal_port(ahb_bus.hwdata), // Agent output 
// .dut_signal_port(ahb_bus.htrans), // Agent output 
// .dut_signal_port(ahb_bus.hburst), // Agent output 
// .dut_signal_port(ahb_bus.hsize), // Agent output 
// .dut_signal_port(ahb_bus.hwrite), // Agent output 
// .dut_signal_port(ahb_bus.hsel), // Agent output 
// .dut_signal_port(ahb_bus.hready), // Agent input 
// .dut_signal_port(ahb_bus.hrdata), // Agent input 
// .dut_signal_port(ahb_bus.hresp), // Agent input 

import uvmf_base_pkg_hdl::*;
import ahb_pkg_hdl::*;

interface  ahb_if 

  (
  input tri hclk, 
  input tri hresetn,
  inout tri [31:0] haddr,
  inout tri [15:0] hwdata,
  inout tri [1:0] htrans,
  inout tri [2:0] hburst,
  inout tri [2:0] hsize,
  inout tri  hwrite,
  inout tri  hsel,
  inout tri  hready,
  inout tri [15:0] hrdata,
  inout tri [1:0] hresp
  );

modport monitor_port 
  (
  input hclk,
  input hresetn,
  input haddr,
  input hwdata,
  input htrans,
  input hburst,
  input hsize,
  input hwrite,
  input hsel,
  input hready,
  input hrdata,
  input hresp
  );

modport initiator_port 
  (
  input hclk,
  input hresetn,
  output haddr,
  output hwdata,
  output htrans,
  output hburst,
  output hsize,
  output hwrite,
  output hsel,
  input hready,
  input hrdata,
  input hresp
  );

modport responder_port 
  (
  input hclk,
  input hresetn,  
  input haddr,
  input hwdata,
  input htrans,
  input hburst,
  input hsize,
  input hwrite,
  input hsel,
  output hready,
  output hrdata,
  output hresp
  );
  

// pragma uvmf custom interface_item_additional begin
// pragma uvmf custom interface_item_additional end

endinterface

