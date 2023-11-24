`ifndef I3C_CONTROLLER_PKG_INCLUDED_
`define I3C_CONTROLLER_PKG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Package: controller_pkg
//  Includes all the files related to SPI controller
//--------------------------------------------------------------------------------------------
package i3c_controller_unit_test_pkg;

  //-------------------------------------------------------
  // Import uvm package
  //-------------------------------------------------------
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import i3c_globals_pkg::*;
  //-------------------------------------------------------
  // Include all other files
  //-------------------------------------------------------
  // MSHA: `include "i3c_controller_agent_config.sv"
  `include "i3c_controller_tx.sv"

  // MSHA: `include "i3c_controller_sequencer.sv"
  // MSHA: `include "i3c_controller_base_seq.sv"
  // MSHA: `include "i3c_controller_8b_write_seq.sv"
  // MSHA: `include "i3c_controller_8b_read_seq.sv"


endpackage : i3c_controller_unit_test_pkg


`endif 
