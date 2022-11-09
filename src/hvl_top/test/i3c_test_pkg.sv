`ifndef I3C_TEST_PKG_INCLUDED_
`define I3C_TEST_PKG_INCLUDED_

//-----------------------------------------------------------------------------------------
// Package: Test
// Description:
// Includes all the files written to run the simulation
//--------------------------------------------------------------------------------------------
package i3c_test_pkg;

  //-------------------------------------------------------
  // Import uvm package
  //-------------------------------------------------------
  `include "uvm_macros.svh"
  import uvm_pkg::*;

  //-------------------------------------------------------
  // Importing the required packages
  //-------------------------------------------------------
  import i3c_globals_pkg::*;
  import i3c_master_pkg::*;
  import i3c_slave_pkg::*;
  import i3c_env_pkg::*;
  import i3c_master_seq_pkg::*;
  import i3c_slave_seq_pkg::*;
  import i3c_virtual_seq_pkg::*;

 //including base_test for testing
 `include "i3c_base_test.sv"
 `include "i3c_8b_test.sv"
endpackage : i3c_test_pkg

`endif
