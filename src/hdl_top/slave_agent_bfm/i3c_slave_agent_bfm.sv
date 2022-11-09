`ifndef I3C_SLAVE_AGENT_BFM_INCLUDED_
`define I3C_SLAVE_AGENT_BFM_INCLUDED_

module i3c_slave_agent_bfm(i3c_if intf);
  

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
  //-------------------------------------------------------
  //I3C Slave driver bfm instantiation
  //-------------------------------------------------------
  i3c_slave_driver_bfm i3c_slave_drv_bfm_h(.pclk(intf.pclk), 
                                            .areset(intf.areset),
                                            .scl_i(intf.scl_i),
                                            .scl_o(intf.scl_o),
                                            .scl_oen(intf.scl_oen),
                                            .sda_i(sda_i),
                                            .sda_o(sda_o),
                                            .sda_oen(sda_oen)//.scl(intf.scl),
                                            //.sda(intf.sda)
);

  //-------------------------------------------------------
  //I3C slave driver bfm instantiation
  //-------------------------------------------------------
  i3c_slave_monitor_bfm i3c_slave_mon_bfm_h(.pclk(intf.pclk), 
                                            .areset(intf.areset),
                                            .scl_i(intf.scl_i),
                                            .scl_o(intf.scl_o),
                                            .scl_oen(intf.scl_oen),
                                            .sda_i(sda_i),
                                            .sda_o(sda_o),
                                            .sda_oen(sda_oen)
                                          );
 //-------------------------------------------------------
 // Setting the virtual handle of BMFs into config_db
 //-------------------------------------------------------
 
 initial begin
  uvm_config_db#(virtual i3c_slave_driver_bfm)::set(null,"*","i3c_slave_driver_bfm",
                                                              i3c_slave_drv_bfm_h);

  uvm_config_db#(virtual i3c_slave_monitor_bfm)::set(null,"*","i3c_slave_monitor_bfm",
                                                              i3c_slave_mon_bfm_h);
  end

initial begin
    $display("Slave Agent BFM");
  end


endmodule : i3c_slave_agent_bfm

`endif
