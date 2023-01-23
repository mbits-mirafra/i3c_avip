//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 15
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb interface agent
// Unit            : Interface Signal Bundle
// File            : ahb_if.sv
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
// ****************************************************************************
// ****************************************************************************
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

interface ahb_if ( 
  input tri hclk, 
  input tri hresetn
  ,output tri [31:0] haddr
  ,output tri [15:0] hwdata
  ,output tri [1:0] htrans
  ,output tri [2:0] hburst
  ,output tri [2:0] hsize
  ,output tri  hwrite
  ,output tri  hsel
  ,input tri  hready
  ,input tri [15:0] hrdata
  ,input tri [1:0] hresp
);

property ahb_hready_follows_hsel;
@(posedge hclk) disable iff (!hresetn) $rose(hsel)  |=> (hsel & !hready)[*1:4] ##1 (hsel & hready) ##1 (!hsel & !hready);
endproperty

property ahb_address_stable_throughout_transfer;
@(posedge hclk) disable iff (!hresetn) $rose(hsel)  |=> $stable(haddr)[*1:4] ##1 !hsel;
endproperty

property ahb_wdata_stable_throughout_write;
@(posedge hclk) disable iff (!hresetn) $rose(hwrite)  |=> $stable(hwdata)[*1:4] ##1 !hwrite;
endproperty

assert property(ahb_hready_follows_hsel) else $error("The AHB hsel was not terminated with a hready");
assert property(ahb_address_stable_throughout_transfer) else $error("The AHB address did not remain stable throughout the transfer");
assert property(ahb_wdata_stable_throughout_write) else $error("The AHB write data did not remain stable throughout the write transfer");

cover property(ahb_hready_follows_hsel);
cover property(ahb_address_stable_throughout_transfer);
cover property(ahb_wdata_stable_throughout_write);

endinterface

