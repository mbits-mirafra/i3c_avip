`ifndef I3C_CONTROLLER_SEQ_PKG_INCLUDED
`define I3C_CONTROLLER_SEQ_PKG_INCLUDED

//-----------------------------------------------------------------------------------------
// Package: i3c_controller_seq_pkg
// Description:
// Includes all the files written to run the simulation
//-------------------------------------------------------------------------------------------
package i3c_controller_seq_pkg;

  //-------------------------------------------------------
  // Import uvm package
  //-------------------------------------------------------
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import i3c_controller_pkg::*;
  import i3c_globals_pkg::*; 
  //-------------------------------------------------------
  // Importing the required packages
  //-------------------------------------------------------
  
  `include "i3c_controller_base_seq.sv"

  `include "i3c_controller_8b_write_seq.sv"
  `include "i3c_controller_8b_read_seq.sv"
//  `include "i3c_controller_8b_write_read_seq.sv"
endpackage : i3c_controller_seq_pkg
`endif
