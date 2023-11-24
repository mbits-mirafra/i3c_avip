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
  `include "../src/hvl_top/master/i3c_master_agent_config.sv"
  `include "../src/hvl_top/master/i3c_master_tx.sv"
  `include "../src/hvl_top/master/i3c_master_sequencer.sv"
  `include "../src/hvl_top/test/sequences/master_sequences/i3c_master_base_seq.sv"

   // slave transaction
  `include "../src/hvl_top/slave/i3c_slave_agent_config.sv"
  `include "../src/hvl_top/slave/i3c_slave_tx.sv"

  // sequence for write and read
  `include "../src/hvl_top/test/sequences/master_sequences/i3c_master_8b_write_seq.sv"
  `include "../src/hvl_top/test/sequences/master_sequences/i3c_master_8b_read_seq.sv"


endpackage : i3c_master_unit_test_pkg


`endif 
