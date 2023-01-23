//----------------------------------------------------------------------
//   Vijay Gill vijay_gill@mentor.com
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
//                   Mentor Graphics Inc
//----------------------------------------------------------------------
// Project         : UVM Framework
// Unit            : In order race scoreboard based on scoreboard_base
// File            : in_order_race_scoreboard.svh
//----------------------------------------------------------------------
// Created by      : vijay_gill@mentor.com
// Creation Date   : 08.22.2014
//----------------------------------------------------------------------

import uvm_pkg::*;
`include "uvm_macros.svh"

// CLASS: uvmf_in_race_order_scoreboard
// This class defines an in order race scoreboard that is based on the scoreboard_base class.
// It uses two uvm_tlm_analysis_fifo's to queue expected as well as actual transactions since either
// could arrive first.
//
// PARAMETERS:
//       T - Specifies the type of transactions to be compared.
//           Must be derived from uvmf_transaction_base.

class uvmf_in_order_race_scoreboard #(type T = uvmf_transaction_base) extends uvmf_scoreboard_base#(T);

  `uvm_component_param_utils( uvmf_in_order_race_scoreboard #(T))

   // Analysis fifo to queue up expected & actual transactions.
   uvm_tlm_analysis_fifo #(T) expected_results_af;
   uvm_tlm_analysis_fifo #(T) actual_results_af;

   // FUNCTION: new - Constructor
   function new(string name, uvm_component parent );
      super.new(name, parent);
   endfunction : new

   // FUNCTION: build
   // Construct the analysis fifos
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      expected_results_af=new("expected_results_af",this);
      actual_results_af=new("actual_results_af",this);
   endfunction

   // FUNCTION: write_expected
   // Transactions arrive through this interface from the predictor.
   // Since the actual transaction may have arrived first, the arrival of a transaction through
   // this interface triggers its comparision to the next transaction in the analysis fifo that
   // holds actual results.  If no actual result exists, the transaction is stored in an
   // analysis_fifo to wait for the actual transaction.
   function void write_expected( input T t);
      T actual_transaction;
      super.write_expected(t);

      // Check if there is a next entry from actual analysis fifo.  If none exists, queue expected item
      if ( !actual_results_af.try_get(actual_transaction)) begin
         `uvm_info("SCOREBOARD RESULTS","NO ACTUAL ENTRY, QUEUEING EXPECTED ENTRY",UVM_HIGH)
         void'(expected_results_af.try_put(t));
      end
      else begin
         compare_entries(t, actual_transaction);
      end
   endfunction

   // FUNCTION: write_actual
   // Transactions arrive through this interface from one or more DUT output monitors.
   // The arrival of a transaction through this interface triggers its comparison to the
   // next transaction in the analysis fifo that holds expected results.  If no expected result
   // exists, the transaction is stored in an analysis_fifo to wait for the expected transaction.
   function void write_actual( input T t);
      T expected_transaction;
      super.write_actual(t);

      // Check if there is a next entry from expected analysis fifo.  If none exists, queue actual item
      if ( !expected_results_af.try_get(expected_transaction)) begin
         `uvm_info("SCOREBOARD RESULTS","NO PREDICTED ENTRY, QUEUEING ACTUAL ENTRY",UVM_HIGH)
         void'(actual_results_af.try_put(t));
      end
      else begin
         compare_entries(expected_transaction, t);
      end
   endfunction : write_actual

   // FUNCTION: compare_entries
   // This function executes the compare function which causes the actual_transaction to 
   // compare itself with the expected transaction.
   function void compare_entries(T expected, T actual);
      // Display the two transactions
      `uvm_info("SCOREBOARD",{"Expected:",expected.convert2string()},UVM_MEDIUM)
      `uvm_info("SCOREBOARD",{"Actual:",actual.convert2string()},UVM_MEDIUM)

      // Compare actual transaction to expected transaction
      if (actual.compare(expected)) begin
         `uvm_info("SCOREBOARD RESULTS","MATCH!",UVM_MEDIUM)
      end
      else begin
         `uvm_error("SCOREBOARD RESULTS","MISMATCH!")
      end
   endfunction

   // FUNCTION: check_phase
   // Check for scoreboard empty at end of test if configured to do so
   virtual function void check_phase( uvm_phase phase);
      super.check_phase(phase);
      if ( end_of_test_empty_check  && ( (expected_results_af.is_empty() == 0) || (actual_results_af.is_empty() == 0)))
         `uvm_error("SCOREBOARD RESULTS","SCOREBOARD NOT EMPTY");
   endfunction

endclass : uvmf_in_order_race_scoreboard
