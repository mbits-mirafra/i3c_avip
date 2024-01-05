`ifndef I3C_TARGET_SEQ_PKG_INCLUDED_
`define I3C_TARGET_SEQ_PKG_INCLUDED_

package i3c_target_seq_pkg;

  `include "uvm_macros.svh"
   import uvm_pkg::*;
   import i3c_target_pkg::*;
   import i3c_globals_pkg::*;
  
   `include "i3c_target_base_seq.sv"
   `include "i3c_target_8b_seq.sv"
   `include "i3c_target_8b_write_seq.sv" 
   `include "i3c_target_8b_read_seq.sv" 
   `include "i3c_target_16b_write_seq.sv"
   `include "i3c_target_16b_read_seq.sv"
   `include "i3c_target_32b_write_seq.sv"
   `include "i3c_target_32b_read_seq.sv"
   `include "i3c_target_64b_write_seq.sv"
   `include "i3c_target_64b_read_seq.sv"
   `include "i3c_target_maximum_bits_write_seq.sv"
   `include "i3c_target_maximum_bits_read_seq.sv"

endpackage : i3c_target_seq_pkg
`endif
