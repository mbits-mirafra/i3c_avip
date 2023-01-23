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
// File            : alu_in_driver_bfm.sv
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This interface performs the ALU_IN signal driving.  It is
//     accessed by the uvm alu_in driver through a virtual interface
//     handle in the alu_in configuration.  It drives the singals passed
//     in through the port connection named bus of type alu_in_if.
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i
//
//     The output signal connections are as follows:
//        signal_o -> bus.signal
//
//      Interface functions and tasks used by UVM components:
//             configure(...);
//             set_clock_period(int period);
//                   This function gets configuration descriptor, cfg, 
//                   from the UVM driver to set any required configuration 
//                   variables.
//
//             assert_rst();
//                   This task performs a reset operation on the ALU interface.
//
//             access(input alu_in_transaction_s txn);
//                   This task receives transaction attributes from the UVM
//                   driver and then executes the corresponding ALU operation.
//
// ****************************************************************************

import uvmf_base_pkg_hdl::*;
import alu_in_pkg_hdl::*;

interface alu_in_driver_bfm(alu_in_if bus);
// pragma attribute alu_in_driver_bfm partition_interface_xif

   tri                          clk_i;
   tri                          rst_i;
   tri                          valid_i;
   tri                          ready_i;
   tri   [2:0]                  op_i;
   tri   [ALU_IN_OP_WIDTH-1:0] a_i;
   tri   [ALU_IN_OP_WIDTH-1:0] b_i;


   bit                          clk_o;
   bit                          rst_o;
   bit                          valid_o;
   logic   [2:0]                  op_o;
   logic [ALU_IN_OP_WIDTH-1:0] a_o;
   logic [ALU_IN_OP_WIDTH-1:0] b_o;

   assign     clk_i    =   bus.clk;
   assign     rst_i    =   bus.rst;
   assign     valid_i  =   bus.valid;
   assign     ready_i  =   bus.ready;
   assign     op_i     =   bus.op;
   assign     a_i      =   bus.a;
   assign     b_i      =   bus.b;

   assign bus.clk   = clk_o;
   assign bus.rst   = rst_o;
   assign bus.valid = valid_o;
   assign bus.op = op_o;
   assign bus.a = a_o;
   assign bus.b = b_o;


   shortint half_clk_period = 10;

// ****************************************************************************
   // tbx clkgen
   initial begin
      clk_o = 0;
      //forever #10ns clk_o = ~clk_o;
      //forever #(clk_period/2)ns clk_o = ~clk_o;
      forever #(half_clk_period) clk_o = ~clk_o;
   end

//******************************************************************
   function void set_clock_period(int period); // pragma tbx xtf
      half_clk_period <= period >> 1;
   endfunction

// ****************************************************************************
   task assert_rst(); // pragma tbx xtf
     @(posedge clk_i);
     do_assert_rst();
   endtask

// ****************************************************************************
  task access(input alu_in_transaction_s txn); // pragma tbx xtf
     @(posedge clk_i);
     case (txn.op)
        rst_op  : do_assert_rst();
        default : alu_in_op(txn);
     endcase
  endtask

// ****************************************************************************
  task do_assert_rst();
     rst_o <= 1'b0;
     repeat (10) @(posedge clk_i);
     rst_o <= 1'b1;
     repeat (5) @(posedge clk_i);
  endtask

// ****************************************************************************
  task alu_in_op(input alu_in_transaction_s txn);
      
     while ( ready_i == 1'b0 ) @(posedge clk_i) ;
     valid_o <= 1'b1;
     op_o <= txn.op;
     a_o <= txn.a;
     b_o <= txn.b;
      
     @(posedge clk_i);
     valid_o <= 1'b0;
     op_o <= {3{1'bx}};
     a_o <= {ALU_IN_OP_WIDTH{1'bx}};
     b_o <= {ALU_IN_OP_WIDTH{1'bx}};
     
   endtask

endinterface
