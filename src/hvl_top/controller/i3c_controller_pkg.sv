`ifndef I3C_CONTROLLER_PKG_INCLUDED_
`define I3C_CONTROLLER_PKG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Package: controller_pkg
//  Includes all the files related to SPI controller
//--------------------------------------------------------------------------------------------
package i3c_controller_pkg;

  //-------------------------------------------------------
  // Import uvm package
  //-------------------------------------------------------
  `include "uvm_macros.svh"
  import uvm_pkg::*;
 
  // Import spi_globals_pkg 
  import i3c_globals_pkg::*;

  //-------------------------------------------------------
  // Include all other files
  //-------------------------------------------------------
  `include "i3c_controller_agent_config.sv"
  `include "i3c_controller_tx.sv"
  `include "i3c_controller_seq_item_converter.sv"
  `include "i3c_controller_cfg_converter.sv"
  `include "i3c_controller_sequencer.sv"
  `include "i3c_controller_driver_proxy.sv"
 // GopalS:  `include "i3c_controller_monitor_proxy.sv"
 // GopalS:  `include "i3c_controller_coverage.sv"
 `include "i3c_controller_agent.sv"
  
endpackage : i3c_controller_pkg

`endif
