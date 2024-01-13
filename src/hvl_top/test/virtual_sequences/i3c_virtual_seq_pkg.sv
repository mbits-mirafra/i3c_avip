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
 `include "i3c_virtual_writeOperationWith8bitsData_seq.sv"
 `include "i3c_virtual_readOperationWith8bitsData_seq.sv"
 `include "i3c_virtual_writeOperationWith16bitsData_seq.sv"
 `include "i3c_virtual_readOperationWith16bitsData_seq.sv"
 `include "i3c_virtual_writeOperationWith32bitsData_seq.sv"
 `include "i3c_virtual_readOperationWith32bitsData_seq.sv"
 `include "i3c_virtual_writeOperationWith64bitsData_seq.sv"
 `include "i3c_virtual_readOperationWith64bitsData_seq.sv"
 `include "i3c_virtual_writeOperationWithMaximumbitsData_seq.sv"
 `include "i3c_virtual_readOperationWithMaximumbitsData_seq.sv"
 `include "i3c_virtual_writeOperationWith8bitsData_startStopCombination_seq.sv"
 `include "i3c_virtual_readOperationWith8bitsData_startStopCombination_seq.sv"
 `include "i3c_virtual_writeOperationWithRandomDataTransferWidth_seq.sv"
 `include "i3c_virtual_readOperationWithRandomDataTransferWidth_seq.sv"
 `include "i3c_virtual_randomOperationWithRandomDataTransferWidth_seq.sv"

 `include "i3c_virtual_WriteFollowedByReadOperationWith32bitsData_seq.sv"
// GopalS:  `include "i3c_virtual_8b_write_followed_by_read_seq.sv"
// GopalS:  `include "i3c_virtual_8b_direct_ccc_setdasa_seq.sv" 
endpackage : i3c_virtual_seq_pkg

`endif
