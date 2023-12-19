`ifndef I3C_CONTROLLER_MONITOR_BFM_INCLUDED_
`define I3C_CONTROLLER_MONITOR_BFM_INCLUDED_

//-------------------------------------------------------
//Module : i3c controller Monitor BFM
//Description : connects the controller monitor bfm with the monitor proxy
//-------------------------------------------------------
import i3c_globals_pkg::*;
interface i3c_controller_monitor_bfm(input pclk, 
                                 input areset, 
                                 input scl_i,
                                 input scl_o,
                                 input scl_oen,
                                 input sda_i,
                                 input sda_o,
                                 input sda_oen
                                 //input scl,
                                 //input sda
                                );
 
 //-------------------------------------------------------
 // Package : Importing Uvm Pakckage and Test Package
 //-------------------------------------------------------
 import uvm_pkg::*;
 `include "uvm_macros.svh"
 
 
 //-------------------------------------------------------
 //Package : Importing I3C Global Package and I3C controller Package
 //-------------------------------------------------------
 import i3c_controller_pkg::*;
 import i3c_controller_pkg::i3c_controller_monitor_proxy;
 
  //Variable : i3c_controller_mon_proxy_h
  //Creating the handle for proxy driver
 i3c_controller_monitor_proxy i3c_controller_mon_proxy_h;

 initial begin
   $display("i3c controller Monitor BFM");
 end

endinterface : i3c_controller_monitor_bfm

`endif
