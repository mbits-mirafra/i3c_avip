`ifndef I3C_TARGET_UNIT_TEST_PKG_INCLUDED_
`define I3C_TARGET_UNIT_TEST_PKG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Package: i3c_target_unit_test
//--------------------------------------------------------------------------------------------
package i3c_target_unit_test_pkg;

  //-------------------------------------------------------
  // Import uvm package
  //-------------------------------------------------------
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import i3c_globals_pkg::*;
  //-------------------------------------------------------
  // Include all other files
  //-------------------------------------------------------
  `include "i3c_slave_agent_config.sv"
  `include "i3c_target_tx.sv"


endpackage : i3c_target_unit_test_pkg


`endif 
