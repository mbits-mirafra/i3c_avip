`ifndef I3C_TEST_PKG_INCLUDED_
`define I3C_TEST_PKG_INCLUDED_

package i3c_test_pkg;

 `include "uvm_macros.svh"

  import uvm_pkg::*;
  import i3c_globals_pkg::*;
  import i3c_controller_pkg::*;
  import i3c_target_pkg::*;
  import i3c_env_pkg::*;
  import i3c_controller_seq_pkg::*;
  import i3c_target_seq_pkg::*;
  import i3c_virtual_seq_pkg::*;

 `include "i3c_base_test.sv"
 `include "i3c_8b_write_test.sv"
 `include "i3c_8b_read_test.sv"
 `include "i3c_16b_write_test.sv"
 `include "i3c_16b_read_test.sv" 
 `include "i3c_32b_write_test.sv"
 `include "i3c_32b_read_test.sv"

// GopalS:  `include "i3c_8b_write_followed_by_read_test.sv"
// GopalS:  `include "i3c_direct_ccc_setdasa_test.sv"
endpackage : i3c_test_pkg

`endif
