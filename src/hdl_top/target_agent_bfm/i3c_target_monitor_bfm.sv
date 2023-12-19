`ifndef I3C_TARGET_MONITOR_BFM_INCLUDED_
`define I3C_TARGET_MONITOR_BFM_INCLUDED_
//--------------------------------------------------------------------------------------------
// Class    : I3C target Monitor BFM
// Description  : Connects the target monitor bfm with the monitor proxy
//--------------------------------------------------------------------------------------------

interface i3c_target_monitor_bfm(input pclk, 
                                input areset, 
                                input scl_i,
                                input scl_o,
                                input scl_oen,
                                input sda_i,
                                input sda_o,
                                input sda_oen);
 //-------------------------------------------------------
 // Package : Importing Uvm Pakckage and Test Package
 //-------------------------------------------------------
 import uvm_pkg::*;
 `include "uvm_macros.svh"
 
  //-------------------------------------------------------
 //Package : Importing I3C Global Package and I3C target Package
 //-------------------------------------------------------
 import i3c_target_pkg::*;
 import i3c_target_pkg::i3c_target_monitor_proxy;
 
  //Variable : i3c_target_mon_proxy_h
  //Creating the handle for proxy driver
 i3c_target_monitor_proxy i3c_target_mon_proxy_h; 
  initial begin
    $display("target Monitor BFM");
  end

endinterface : i3c_target_monitor_bfm


`endif
