`ifndef I3C_SLAVE_PKG_INCLUDED_
`define I3C_SLAVE_PKG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Package: i3c_slave_pkg
//  Includes all the files related to i3c_slave
//--------------------------------------------------------------------------------------------
package i3c_slave_pkg;

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
  `include "i3c_slave_agent_config.sv"
  `include "i3c_target_tx.sv"
  `include "i3c_slave_seq_item_converter.sv"
  `include "i3c_slave_cfg_converter.sv"
  `include "i3c_slave_sequencer.sv"
  `include "i3c_slave_driver_proxy.sv"
  `include "i3c_slave_monitor_proxy.sv"
  `include "i3c_slave_coverage.sv"
  `include "i3c_slave_agent.sv"
  
endpackage : i3c_slave_pkg

`endif
