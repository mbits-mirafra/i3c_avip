`ifndef I3C_CONTROLLER_8B_READ_SEQ_UNIT_TEST_PKG_INCLUDED_
`define I3C_CONTROLLER_8B_READ_SEQ_UNIT_TEST_PKG_INCLUDED_

package i3c_controller_8b_read_seq_unit_test_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import i3c_globals_pkg::*;

  `include "i3c_controller_tx.sv"
  `include "i3c_controller_agent_config.sv"
  `include "i3c_controller_sequencer.sv"
  `include "i3c_controller_base_seq.sv"
  `include "i3c_controller_8b_read_seq.sv"

endpackage : i3c_controller_8b_read_seq_unit_test_pkg

`endif 
