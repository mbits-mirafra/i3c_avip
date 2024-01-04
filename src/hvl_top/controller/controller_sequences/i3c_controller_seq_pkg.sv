`ifndef I3C_CONTROLLER_SEQ_PKG_INCLUDED
`define I3C_CONTROLLER_SEQ_PKG_INCLUDED

package i3c_controller_seq_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import i3c_controller_pkg::*;
  import i3c_globals_pkg::*; 
 
  `include "i3c_controller_base_seq.sv"
  `include "i3c_controller_8b_write_seq.sv"
  `include "i3c_controller_8b_read_seq.sv"
  `include "i3c_controller_16b_write_seq.sv"
  `include "i3c_controller_16b_read_seq.sv"
  `include "i3c_controller_32b_write_seq.sv"
  `include "i3c_controller_32b_read_seq.sv"

  //  `include "i3c_controller_8b_write_read_seq.sv"
endpackage : i3c_controller_seq_pkg
`endif
