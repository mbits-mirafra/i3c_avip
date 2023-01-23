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
      if ( !actual_results_af.try_get(actual_transaction)) 
         begin : no_actual_entry_to_compare_against
         void'(expected_results_af.try_put(t));
         end : no_actual_entry_to_compare_against
      else 
         begin : compare_against_actual
         compare_entries(t, actual_transaction);
         end : compare_against_actual
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
      if ( !expected_results_af.try_get(expected_transaction)) 
         begin : no_expected_entry_to_compare_against
         void'(actual_results_af.try_put(t));
         end : no_expected_entry_to_compare_against
      else 
         begin : compare_against_expected
         compare_entries(expected_transaction, t);
         end : compare_against_expected
   endfunction : write_actual

   // FUNCTION: compare_entries
   // This function executes the compare function which causes the actual_transaction to 
   // compare itself with the expected transaction.
   function void compare_entries(T expected, T actual);
      // Compare actual transaction to expected transaction
      if (actual.compare(expected)) 
         begin : compare_passed
         match_count++;
         `uvm_info($sformatf("SCOREBOARD_INFO.%s",this.get_full_name()),compare_message("MATCH! - ",expected,actual),UVM_MEDIUM)
         end : compare_passed
      else 
         begin : compare_failed
         mismatch_count++;
         `uvm_error($sformatf("SCOREBOARD_ERROR.%s",this.get_full_name()),compare_message("MISMATCH! - ",expected,actual))
         end : compare_failed
   endfunction

  // TASK: wait_for_scoreboard_drain
  // This task is used to implement a mechanism to delay run_phase termination to allow the scoreboard time to drain.  
  virtual task wait_for_scoreboard_drain();
      while ((expected_results_af.is_empty() == 0) || (actual_results_af.is_empty() == 0))
         begin : while_entries_remain
         @entry_received;
         end : while_entries_remain
  endtask

   // FUNCTION: check_phase
   // Check for scoreboard empty at end of test if configured to do so
   virtual function void check_phase( uvm_phase phase);
      T expected_transaction;
      int fifo_entry;
      super.check_phase(phase);
      // Check expected fifo
      if ( end_of_test_empty_check  && (expected_results_af.is_empty() == 0)) 
         begin : expected_entries_remain
         while ( (expected_results_af.is_empty() == 0) && ( fifo_entry <  max_remaining_transaction_print )) 
            begin : print_expected_entries
            void'(expected_results_af.try_get(expected_transaction));
            `uvm_info($sformatf("SCOREBOARD_INFO.%s",this.get_full_name()),$sformatf("Expected Entry %d:%s",fifo_entry++,expected_transaction.convert2string()),UVM_MEDIUM)
            end : print_expected_entries
         `uvm_error($sformatf("SCOREBOARD_ERROR.%s",this.get_full_name()),"EXPECTED SCOREBOARD NOT EMPTY");
         end : expected_entries_remain
      // Check actual fifo
      if ( end_of_test_empty_check  && (actual_results_af.is_empty() == 0)) 
         begin : actual_entries_remain
         fifo_entry=0;
         while ( (actual_results_af.is_empty() == 0) && ( fifo_entry <  max_remaining_transaction_print )) 
            begin : print_actual_entries
            void'(actual_results_af.try_get(expected_transaction));
            `uvm_info($sformatf("SCOREBOARD_INFO.%s",this.get_full_name()),$sformatf("Actual Entry %d:%s",fifo_entry++,expected_transaction.convert2string()),UVM_MEDIUM)
            end : print_actual_entries
         `uvm_error($sformatf("SCOREBOARD_ERROR.%s",this.get_full_name()),"ACTUAL SCOREBOARD NOT EMPTY");
         end : actual_entries_remain
   endfunction

endclass : uvmf_in_order_race_scoreboard
