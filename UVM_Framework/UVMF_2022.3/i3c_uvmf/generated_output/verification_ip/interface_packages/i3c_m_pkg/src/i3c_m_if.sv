//----------------------------------------------------------------------
// Created with uvmf_gen version 2022.3
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface contains the i3c_m interface signals.
//      It is instantiated once per i3c_m bus.  Bus Functional Models, 
//      BFM's named i3c_m_driver_bfm, are used to drive signals on the bus.
//      BFM's named i3c_m_monitor_bfm are used to monitor signals on the 
//      bus. This interface signal bundle is passed in the port list of
//      the BFM in order to give the BFM access to the signals in this
//      interface.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
// This template can be used to connect a DUT to these signals
//
// .dut_signal_port(i3c_m_bus.scl_i), // Agent input 
// .dut_signal_port(i3c_m_bus.scl_o), // Agent output 
// .dut_signal_port(i3c_m_bus.sda_o), // Agent output 
// .dut_signal_port(i3c_m_bus.sda_i), // Agent input 
// .dut_signal_port(i3c_m_bus.scl_oen), // Agent output 
// .dut_signal_port(i3c_m_bus.sda_oen), // Agent output 

import uvmf_base_pkg_hdl::*;
import i3c_m_pkg_hdl::*;

interface  i3c_m_if 

  (
  input tri clock, 
  input tri reset,
  inout tri  scl_i,
  inout tri  scl_o,
  inout tri  sda_o,
  inout tri  sda_i,
  inout tri  scl_oen,
  inout tri  sda_oen
  );

modport monitor_port 
  (
  input clock,
  input reset,
  input scl_i,
  input scl_o,
  input sda_o,
  input sda_i,
  input scl_oen,
  input sda_oen
  );

modport initiator_port 
  (
  input clock,
  input reset,
  input scl_i,
  output scl_o,
  output sda_o,
  input sda_i,
  output scl_oen,
  output sda_oen
  );

modport responder_port 
  (
  input clock,
  input reset,  
  output scl_i,
  input scl_o,
  input sda_o,
  output sda_i,
  input scl_oen,
  input sda_oen
  );
  

// pragma uvmf custom interface_item_additional begin
// pragma uvmf custom interface_item_additional end

endinterface

// pragma uvmf custom external begin
// pragma uvmf custom external end

