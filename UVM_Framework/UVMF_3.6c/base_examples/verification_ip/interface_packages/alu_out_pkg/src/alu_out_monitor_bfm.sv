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
// Project         : AHB interface agent
// Unit            : Monitor Bus Functional Model
// File            : alu_out_monitor_bfm.sv
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This interface performs the AHB signal monitoring.
//      It is accessed by the uvm alu_out monitor through a virtual
//      interface handle in the alu_out configuration.  It monitors the
//      signals passed in through the port connection named bus of
//      type alu_out_if.
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i
//
//      Interface functions and tasks used by UVM components:
//             wait_for_reset();
//                   This task blocks until the reset is release.  It
//                   returns immediately if reset is deasserted.
//
//             wait_for_clk(int clocks);
//                   This task waits for the number of clock events
//                   specified by the clocks argument.
//
//             start_monitoring();
//                   This function kicks off an autonomous monitor 
//                   thread to observe bus activity and pass sampled 
//                   bus transaction attributes to the associated 
//                   UVM monitor (the proxy) where they are used to
//                   populate transaction objects.
//
// ****************************************************************************

import uvmf_base_pkg_hdl::*;
import alu_out_pkg_hdl::*;

interface alu_out_monitor_bfm( alu_out_if bus );
// pragma attribute alu_out_monitor_bfm partition_interface_xif

   tri                          clk_i;
   tri                          rst_i;
   tri                          done_i;
   tri   [ALU_OUT_RESULT_WIDTH-1:0] result_i;

   assign     clk_i    =   bus.clk;
   assign     rst_i    =   bus.rst;
   assign     done_i  =   bus.done;
   assign     result_i =   bus.result;


   alu_out_pkg::alu_out_monitor proxy; // pragma tbx oneway proxy.notify_transaction

//******************************************************************
   task wait_for_reset(); // pragma tbx xtf
      @(posedge clk_i) ;
      do_wait_for_reset();
   endtask

//******************************************************************
   task wait_for_clk( input int unsigned count); // pragma tbx xtf
      @(posedge clk_i) ;
      repeat (count-1) @(posedge clk_i) ;
   endtask

//******************************************************************
   event go;
   function void start_monitoring(); // pragma tbx xtf
      -> go;
   endfunction

// ****************************************************************************
   initial begin
      @go;
      forever begin
        alu_out_transaction_s txn;

        @(posedge clk_i);
        do_monitor(txn);
        proxy.notify_transaction(txn);
      end
   end

// ****************************************************************************
   task do_wait_for_reset();
      wait ( rst_i == 1 ) ;
      @(posedge clk_i) ;
   endtask

// ****************************************************************************
   task do_monitor(output alu_out_transaction_s txn);
      //-start_time = $time + 1;
      while ( done_i == 1'b0 ) @(posedge clk_i);
      txn.result = result_i;
      //-end_time = $time - 1;
   endtask

endinterface
