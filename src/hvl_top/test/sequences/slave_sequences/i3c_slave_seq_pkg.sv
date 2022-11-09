`ifndef I3C_SLAVE_SEQ_PKG_INCLUDED
`define I3C_SLAVE_SEQ_PKG_INCLUDED

//-----------------------------------------------------------------------------------------
// Package: i3c_slave_seq_pkg
// Description:
// Includes all the files written to run the simulation
//-------------------------------------------------------------------------------------------
package i3c_slave_seq_pkg;

  //-------------------------------------------------------
  // Import uvm package
  //-------------------------------------------------------
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import i3c_slave_pkg::*;
  import i3c_globals_pkg::*;
  //-------------------------------------------------------
  // Importing the required packages
  //-------------------------------------------------------
  
  `include "i3c_slave_base_seq.sv"
  `include "i3c_8b_slave_seq.sv"
endpackage : i3c_slave_seq_pkg
`endif
