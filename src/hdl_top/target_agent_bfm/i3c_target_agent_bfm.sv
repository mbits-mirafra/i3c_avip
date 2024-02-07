`ifndef I3C_TARGET_AGENT_BFM_INCLUDED_
`define I3C_TARGET_AGENT_BFM_INCLUDED_

module i3c_target_agent_bfm #(parameter int target_ID=0) 
                              (i3c_if intf);

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import i3c_globals_pkg::*;

  i3c_target_driver_bfm i3c_target_drv_bfm_h(.pclk(intf.pclk), 
                                           .areset(intf.areset),
                                           .scl_i(intf.scl_i),
                                           .scl_o(intf.scl_o),
                                           .scl_oen(intf.scl_oen),
                                           .sda_i(intf.sda_i),
                                           .sda_o(intf.sda_o),
                                           .sda_oen(intf.sda_oen)
                                          );

  //-------------------------------------------------------
  //I3C target driver bfm instantiation
  //-------------------------------------------------------
  i3c_target_monitor_bfm i3c_target_mon_bfm_h(.pclk(intf.pclk), 
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

  static string drv_str, mon_str;
  drv_str = {"i3c_target_driver_bfm_",$sformatf("%0d",target_ID)};
  $display("DEBUG_MSHA :: drv_str = %0s", drv_str);

  mon_str = {"i3c_target_monitor_bfm_",$sformatf("%0d",target_ID)};
  $display("DEBUG_MSHA :: mon_str = %0s", mon_str);

  uvm_config_db#(virtual i3c_target_driver_bfm)::set(null,"*","i3c_target_driver_bfm",
                                                              i3c_target_drv_bfm_h);

  uvm_config_db#(virtual i3c_target_monitor_bfm)::set(null,"*","i3c_target_monitor_bfm",
                                                              i3c_target_mon_bfm_h);
  end

  initial begin
    $display("target Agent BFM");
  end
endmodule : i3c_target_agent_bfm

`endif
