`ifndef I3C_SLAVE_PKG_INCLUDED_
`define I3C_SLAVE_PKG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Package: slave_pkg
//  Includes all the files related to SPI slave
//--------------------------------------------------------------------------------------------
package i3c_slave_unit_test_pkg;

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


endpackage : i3c_slave_unit_test_pkg


`endif 
