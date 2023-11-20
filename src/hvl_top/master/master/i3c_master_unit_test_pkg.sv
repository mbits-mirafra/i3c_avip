`ifndef I3C_MASTER_PKG_INCLUDED_
`define I3C_MASTER_PKG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Package: master_pkg
//  Includes all the files related to SPI master
//--------------------------------------------------------------------------------------------
package i3c_master_unit_test_pkg;

  //-------------------------------------------------------
  // Import uvm package
  //-------------------------------------------------------
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import i3c_globals_pkg::*;

  //-------------------------------------------------------
  // Include all other files
  //-------------------------------------------------------
  `include "i3c_master_agent_config.sv"
  `include "i3c_master_tx.sv"
  
endpackage : i3c_master_unit_test_pkg


`endif
