/*
`ifndef I3C_ENV_PKG_INCLUDED_
`define I3C_ENV_PKG_INCLUDED_

package i3c_env_pkg;
  
  `include "uvm_macros.svh"
  import uvm_pkg::*;

  import i3c_globals_pkg::*;
  import i3c_controller_pkg::*;
  import i3c_target_pkg::*;

  `include "i3c_env_config.sv"
  `include "i3c_virtual_sequencer.sv"
  `include "i3c_scoreboard.sv" 
  `include "i3c_scoreboard_expactedTargetAddressNACK.sv"
  `include "i3c_env.sv"

endpackage : i3c_env_pkg

`endif

*/

`ifndef I3C_ENV_PKG_INCLUDED_
`define I3C_ENV_PKG_INCLUDED_
 
package i3c_env_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
 
  import i3c_globals_pkg::*;
 
//added apb_master pkg
  import apb_master_pkg::*;
  import i3c_target_pkg::*;
 
  `include "i3c_env_config.sv"
  `include "top_virtual_sequencer.sv"
  `include "i3c_scoreboard.sv" 
  `include "i3c_scoreboard_expactedTargetAddressNACK.sv"
  `include "i3c_env.sv"
 
  //added apb_config
`include "apb_env_config.sv"
 
endpackage : i3c_env_pkg
 
`endif
