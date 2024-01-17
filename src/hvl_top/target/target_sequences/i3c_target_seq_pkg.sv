`ifndef I3C_TARGET_SEQ_PKG_INCLUDED_
`define I3C_TARGET_SEQ_PKG_INCLUDED_

package i3c_target_seq_pkg;

  `include "uvm_macros.svh"
   import uvm_pkg::*;
   import i3c_target_pkg::*;
   import i3c_globals_pkg::*;
  
   `include "i3c_target_base_seq.sv"
   `include "i3c_target_writeOperationWith8bitsData_seq.sv"
   `include "i3c_target_readOperationWith8bitsData_seq.sv"
   `include "i3c_target_writeOperationWith16bitsData_seq.sv"
   `include "i3c_target_readOperationWith16bitsData_seq.sv"
   `include "i3c_target_writeOperationWith32bitsData_seq.sv"
   `include "i3c_target_readOperationWith32bitsData_seq.sv"
   `include "i3c_target_writeOperationWith64bitsData_seq.sv"
   `include "i3c_target_readOperationWith64bitsData_seq.sv"
   `include "i3c_target_writeOperationWithMaximumbitsData_seq.sv"
   `include "i3c_target_readOperationWithMaximumbitsData_seq.sv"
   `include "i3c_target_writeOperationWithRandomDataTransferWidth_seq.sv"
   `include "i3c_target_readOperationWithRandomDataTransferWidth_seq.sv"
   `include "i3c_target_randomOperationWithRandomDataTransferWidth_seq.sv"

 endpackage : i3c_target_seq_pkg
`endif
