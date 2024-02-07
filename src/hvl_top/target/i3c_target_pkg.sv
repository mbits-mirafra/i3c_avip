`ifndef I3C_TARGET_PKG_INCLUDED_
`define I3C_TARGET_PKG_INCLUDED_

package i3c_target_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;

  import i3c_globals_pkg::*;

  `include "i3c_target_agent_config.sv"
  `include "i3c_target_tx.sv"
  `include "i3c_target_seq_item_converter.sv"
  `include "i3c_target_cfg_converter.sv"
  `include "i3c_target_sequencer.sv"
  `include "i3c_target_driver_proxy.sv"
  `include "i3c_target_monitor_proxy.sv"
  `include "i3c_target_coverage.sv"
  `include "i3c_target_agent.sv"
  
endpackage : i3c_target_pkg

`endif


