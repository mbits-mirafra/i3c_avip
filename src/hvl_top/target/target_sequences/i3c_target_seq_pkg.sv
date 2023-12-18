`ifndef I3C_TARGET_SEQ_PKG_INCLUDED_
`define I3C_TARGET_SEQ_PKG_INCLUDED_

//-----------------------------------------------------------------------------------------
// Package: i3c_target_seq_pkg
// Description:
// Includes all the files written to run the simulation
//-------------------------------------------------------------------------------------------
package i3c_target_seq_pkg;

  //-------------------------------------------------------
  // Import uvm package
  //-------------------------------------------------------
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import i3c_target_pkg::*;
  import i3c_globals_pkg::*;
  //-------------------------------------------------------
  // Importing the required packages
  //-------------------------------------------------------
  
  `include "i3c_target_base_seq.sv"
  `include "i3c_target_8b_seq.sv"

endpackage : i3c_target_seq_pkg
`endif
