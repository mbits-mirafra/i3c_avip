//----------------------------------------------------------------------
//   Copyright 2013 Mentor Graphics Corporation
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//                   Mentor Graphics Inc
//----------------------------------------------------------------------
// Project         : ALU_IN interface agent
// Unit            : Driver Bus Functional Model
// File            : alu_out_driver_bfm.sv
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This interface performs the ALU_IN signal driving.  It is
//     accessed by the uvm alu_out driver through a virtual interface
//     handle in the alu_out configuration.  It drives the singals passed
//     in through the port connection named bus of type alu_out_if.
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i
//
//     The output signal connections are as follows:
//        signal_o -> bus.signal
//
//      Interface functions and tasks used by UVM components:
//             access(input alu_in_transaction_s txn);
//                   This task receives the transaction, txn, from the
//                   UVM driver and then passes txn to a utility task
//                   to drive the transaction onto the ALU_IN bus signals.
//
// ****************************************************************************

import uvmf_base_pkg_hdl::*;
import alu_out_pkg_hdl::*;

interface alu_out_driver_bfm(alu_out_if bus);
// pragma attribute alu_out_driver_bfm partition_interface_xif

   tri                          clk_i;
   tri                          rst_i;
   tri                          done_i;
   tri   [ALU_OUT_RESULT_WIDTH-1:0] result_i;

   assign     clk_i    =   bus.clk;
   assign     rst_i    =   bus.rst;
   assign     done_i  =   bus.done;
   assign     result_i =   bus.result;

// ****************************************************************************
  task access(input alu_out_transaction_s txn); // pragma tbx xtf
     @(posedge clk_i);
     alu_out_op(txn);
  endtask

// ****************************************************************************
  task alu_out_op(input alu_out_transaction_s txn);
  endtask

endinterface
