`ifndef I3C_TARGET_8B_SEQ_UNIT_TEST_PKG_INCLUDED_
`define I3C_TARGET_8B_SEQ_UNIT_TEST_PKG_INCLUDED_

package i3c_target_8b_seq_unit_test_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import i3c_globals_pkg::*;

  `include "i3c_target_tx.sv"
  `include "i3c_target_agent_config.sv"
  `include "i3c_target_sequencer.sv"
  `include "i3c_target_base_seq.sv"
  `include "i3c_target_8b_seq.sv"

endpackage : i3c_target_8b_seq_unit_test_pkg

`endif 
