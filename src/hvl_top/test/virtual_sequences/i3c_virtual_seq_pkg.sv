`ifndef I3C_VIRTUAL_SEQ_PKG_INCLUDED_
`define I3C_VIRTUAL_SEQ_PKG_INCLUDED_

package i3c_virtual_seq_pkg;

 `include "uvm_macros.svh"
 
  import uvm_pkg::*;
  import i3c_controller_pkg::*;
  import i3c_target_pkg::*;
  import i3c_controller_seq_pkg::*;
  import i3c_target_seq_pkg::*;
  import i3c_env_pkg::*;

 `include "i3c_virtual_base_seq.sv"
 `include "i3c_virtual_8b_write_seq.sv"
 `include "i3c_virtual_8b_read_seq.sv"
 `include "i3c_virtual_16b_write_seq.sv"
 `include "i3c_virtual_16b_read_seq.sv"
 `include "i3c_virtual_32b_write_seq.sv"
 `include "i3c_virtual_32b_read_seq.sv"

// GopalS:  `include "i3c_virtual_8b_write_followed_by_read_seq.sv"
// GopalS:  `include "i3c_virtual_8b_direct_ccc_setdasa_seq.sv" 
endpackage : i3c_virtual_seq_pkg

`endif
