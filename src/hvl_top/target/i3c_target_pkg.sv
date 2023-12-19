`ifndef I3C_TARGET_PKG_INCLUDED_
`define I3C_TARGET_PKG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Package: i3c_target_pkg
//  Includes all the files related to i3c_target
//--------------------------------------------------------------------------------------------
package i3c_target_pkg;

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
  `include "i3c_target_agent_config.sv"
  `include "i3c_target_tx.sv"
  `include "i3c_target_seq_item_converter.sv"
  `include "i3c_target_cfg_converter.sv"
  `include "i3c_target_sequencer.sv"
  // GopalS: `include "i3c_target_driver_proxy.sv"
  `include "i3c_target_monitor_proxy.sv"
  // GopalS: `include "i3c_target_coverage.sv"
  `include "i3c_target_agent.sv"
  
endpackage : i3c_target_pkg

`endif


