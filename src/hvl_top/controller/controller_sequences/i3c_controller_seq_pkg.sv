`ifndef I3C_CONTROLLER_SEQ_PKG_INCLUDED
`define I3C_CONTROLLER_SEQ_PKG_INCLUDED

package i3c_controller_seq_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import i3c_controller_pkg::*;
  import i3c_globals_pkg::*; 
 
  `include "i3c_controller_base_seq.sv"
  `include "i3c_controller_writeOperationWith8bitsData_seq.sv"
  `include "i3c_controller_readOperationWith8bitsData_seq.sv"
  `include "i3c_controller_writeOperationWith16bitsData_seq.sv"
  `include "i3c_controller_readOperationWith16bitsData_seq.sv"
  `include "i3c_controller_writeOperationWith32bitsData_seq.sv"
  `include "i3c_controller_readOperationWith32bitsData_seq.sv"
  `include "i3c_controller_writeOperationWith64bitsData_seq.sv"
  `include "i3c_controller_readOperationWith64bitsData_seq.sv"
  `include "i3c_controller_writeOperationWithMaximumbitsData_seq.sv"
  `include "i3c_controller_readOperationWithMaximumbitsData_seq.sv"
  `include "i3c_controller_writeOperationWithRandomDataTransferWidth_seq.sv"
  `include "i3c_controller_readOperationWithRandomDataTransferWidth_seq.sv"
  `include "i3c_controller_randomOperationWithRandomDataTransferWidth_seq.sv"

  //  `include "i3c_controller_8b_write_read_seq.sv"
endpackage : i3c_controller_seq_pkg
`endif
