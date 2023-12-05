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
  `include "i3c_controller_tx.sv"

endpackage : i3c_controller_unit_test_pkg


`endif 
