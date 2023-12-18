`ifndef I3C_CONTROLLER_AGENT_BFM_INCLUDED_
`define I3C_CONTROLLER_AGENT_BFM_INCLUDED_

//-------------------------------------------------------
//module : i3c_controller_agent_bfm
//Description : Instaniate driver and monitor
//
//-------------------------------------------------------
module i3c_controller_agent_bfm(i3c_if intf);

 //-------------------------------------------------------
 // Package : Importing Uvm Pakckage and Test Package
 //-------------------------------------------------------
 import uvm_pkg::*;
 `include "uvm_macros.svh"
  //-------------------------------------------------------
  // Package : Importing SPI Global Package 
  //-------------------------------------------------------
  import i3c_globals_pkg::*;

 //-------------------------------------------------------
 //controller driver bfm instantiation
 //-------------------------------------------------------
 i3c_controller_driver_bfm i3c_controller_drv_bfm_h(.pclk(intf.pclk), 
                                            .areset(intf.areset),
                                            .scl_i(intf.scl_i),
                                            .scl_o(intf.scl_o),
                                            .scl_oen(intf.scl_oen),
                                            .sda_i(intf.sda_i),
                                            .sda_o(intf.sda_o),
                                            .sda_oen(intf.sda_oen)
                                           );

 //-------------------------------------------------------
 //controller monitor bfm instatiation
 //-------------------------------------------------------
 i3c_controller_monitor_bfm i3c_controller_mon_bfm_h(.pclk(intf.pclk), 
                                            .areset(intf.areset),
                                            .scl_i(intf.scl_i),
                                            .scl_o(intf.scl_o),
                                            .scl_oen(intf.scl_oen),
                                            .sda_i(intf.sda_i),
                                            .sda_o(intf.sda_o),
                                            .sda_oen(intf.sda_oen)
                                            );

 //-------------------------------------------------------
 // Setting the virtual handle of BMFs into config_db
 //-------------------------------------------------------
 
 initial begin
  uvm_config_db#(virtual i3c_controller_driver_bfm)::set(null,"*","i3c_controller_driver_bfm",
                                                              i3c_controller_drv_bfm_h);

  uvm_config_db#(virtual i3c_controller_monitor_bfm)::set(null,"*","i3c_controller_monitor_bfm",
                                                              i3c_controller_mon_bfm_h);
  end

 initial begin
   $display("controller Agent BFM");
 end

endmodule : i3c_controller_agent_bfm

`endif
