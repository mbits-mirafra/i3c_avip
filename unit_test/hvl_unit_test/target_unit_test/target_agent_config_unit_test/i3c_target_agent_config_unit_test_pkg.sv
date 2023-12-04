`ifndef I3C_TARGET_AGENT_CONFIG_UNIT_TEST_PKG_INCLUDED_
`define I3C_TARGET_AGENT_CONFIG_UNIT_TEST_PKG_INCLUDED_


//--------------------------------------------------------------------------------------------
// Package: i3c_target_agent_config_unit_test_pkg
//--------------------------------------------------------------------------------------------
package i3c_target_agent_config_unit_test_pkg;

  //-------------------------------------------------------
  // Import uvm package
  //-------------------------------------------------------
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import i3c_globals_pkg::*;
  //-------------------------------------------------------
  // Include all other files
  //-------------------------------------------------------
  `include "i3c_target_agent_config.sv"


endpackage : i3c_target_agent_config_unit_test_pkg


`endif 

