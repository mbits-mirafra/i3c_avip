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
 `include "i3c_writeOperationWith8bitsData_test.sv"
 `include "i3c_readOperationWith8bitsData_test.sv"
 `include "i3c_writeOperationWith16bitsData_test.sv"
 `include "i3c_readOperationWith16bitsData_test.sv"
 `include "i3c_writeOperationWith32bitsData_test.sv"
 `include "i3c_readOperationWith32bitsData_test.sv"
 `include "i3c_writeOperationWith64bitsData_test.sv"
 `include "i3c_readOperationWith64bitsData_test.sv"
 `include "i3c_writeOperationWithMaximumbitsData_test.sv"
 `include "i3c_readOperationWithMaximumbitsData_test.sv"
 `include "i3c_writeOperationWith8bitsData_startStopCombination_test.sv"
 `include "i3c_readOperationWith8bitsData_startStopCombination_test.sv"
 `include "i3c_writeOperationWithRandomDataTransferWidth_test.sv"
 `include "i3c_readOperationWithRandomDataTransferWidth_test.sv"
 `include "i3c_randomOperationWithRandomDataTransferWidth_test.sv"

 `include "i3c_writeOperationWithMSBDataDirection_test.sv"
 `include "i3c_writeOperationWithLSBDataDirection_test.sv"
 `include "i3c_readOperationWithMSBDataDirection_test.sv"
 `include "i3c_readOperationWithLSBDataDirection_test.sv"


 `include "i3c_WriteFollowedByReadOperationWith32bitsData_test.sv"
 `include "i3c_ReadFollowedByWriteFollowedByReadOperationWith32bitsData_test.sv"
 `include "i3c_WriteFollowedByReadFollowedByWriteFollowedByReadOperationWith32bitsData_test.sv"
 `include "i3c_MultipleWritesMultipleReadsOperationWith32bitsData_test.sv"
// GopalS:  `include "i3c_8b_write_followed_by_read_test.sv"
// GopalS:  `include "i3c_direct_ccc_setdasa_test.sv"
endpackage : i3c_test_pkg

`endif
