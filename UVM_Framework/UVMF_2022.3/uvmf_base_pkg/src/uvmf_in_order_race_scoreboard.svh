//----------------------------------------------------------------------
//   Copyright 2013-2021 Siemens Corporation
//   Digital Industries Software
//   Siemens EDA
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
   T expected_results_q [$];
   T actual_results_q   [$];

   // Local members for debug
   T last_expected;
   T last_actual;
   bit last_mismatched = 0;

   // FUNCTION: new - Constructor
   function new(string name, uvm_component parent );
      super.new(name, parent);
   endfunction : new

   // FUNCTION: build
   // Construct the analysis fifos
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction

   // FUNCTION: 
   // Used to flush all entries in the scoreboard
   virtual function void flush_scoreboard();
      expected_results_q.delete();
      actual_results_q.delete();
   endfunction

   // FUNCTION: 
   // Used to remove an entry from the scoareboard
   // An entry is removed from the out side of the fifo
   // The key is used to identify which fifo an entry is removed from
   // Key = 0 : expected side of scoreboard
   // Key = 1 : actual side of scoreboard
   virtual function void remove_entry(int unsigned key=0);
      T flushed_transaction;
      if ( key == 0 ) 
         begin : remove_from_expected
         flushed_transaction = expected_results_q.pop_front();
         end : remove_from_expected
      else if ( key == 1 )
         begin : remove_from_actual
         flushed_transaction = actual_results_q.pop_front();
         end : remove_from_actual
      else 
         begin : invalid_key
         `uvm_error("SCBD", $sformatf("Invalid key %d out of valid range of 0 and 1", key))
         end : invalid_key
   endfunction

   // FUNCTION: write_expected
   // Transactions arrive through this interface from the predictor.
   // Since the actual transaction may have arrived first, the arrival of a transaction through
   // this interface triggers its comparision to the next transaction in the analysis fifo that
   // holds actual results.  If no actual result exists, the transaction is stored in an
   // analysis_fifo to wait for the actual transaction.
   function void write_expected( input T t);
      T actual_transaction;
      if (scoreboard_enabled && enable_expected_port) 
         begin : in_write_expected
         super.write_expected(t);

         // Check if there is a next entry from actual analysis fifo.  If none exists, queue expected item
         if ( actual_results_q.size() == 0 ) 
            begin : no_actual_entry_to_compare_against
            expected_results_q.push_back(t);
            end : no_actual_entry_to_compare_against
         else 
            begin : compare_against_actual
            actual_transaction = actual_results_q.pop_front();
            // Exit function if comparison is disabled
            if ( disable_entry_compare ) begin : comparison_disabled_expected
                  `uvm_warning("SCBD", "COMPARISONS DISABLED")
                  return;
                end : comparison_disabled_expected
            compare_entries(t, actual_transaction);
            end : compare_against_actual
         end : in_write_expected
   endfunction

   // FUNCTION: write_actual
   // Transactions arrive through this interface from one or more DUT output monitors.
   // The arrival of a transaction through this interface triggers its comparison to the
   // next transaction in the analysis fifo that holds expected results.  If no expected result
   // exists, the transaction is stored in an analysis_fifo to wait for the expected transaction.
   function void write_actual( input T t);
      T expected_transaction;
      if (scoreboard_enabled && enable_actual_port) 
         begin : in_write_actual
         super.write_actual(t);
   
         // Check if there is a next entry from expected analysis fifo.  If none exists, queue actual item
         if ( expected_results_q.size() == 0 ) 
            begin : no_expected_entry_to_compare_against
            actual_results_q.push_back(t);
            end : no_expected_entry_to_compare_against
         else 
            begin : compare_against_expected
            expected_transaction = expected_results_q.pop_front();
            // Exit function if comparison is disabled
            if ( disable_entry_compare ) begin : comparison_disabled_actual
                  `uvm_warning("SCBD", "COMPARISONS DISABLED")
                  return;
                end : comparison_disabled_actual
            compare_entries(expected_transaction, t);
            end : compare_against_expected
         end : in_write_actual
   endfunction : write_actual

   // FUNCTION: compare_entries
   // This function executes the compare function which causes the actual_transaction to 
   // compare itself with the expected transaction.
   function void compare_entries(T expected, T actual);
      last_actual = actual;
      last_expected = expected;
      // Compare actual transaction to expected transaction
      if (actual.compare(expected)) 
         begin : compare_passed
         match_count++;
         `uvm_info("SCBD",compare_message("MATCH! - ",expected,actual),UVM_MEDIUM)
         last_mismatched = 0;
         end : compare_passed
      else 
         begin : compare_failed
         mismatch_count++;
         last_mismatched = 1;
         `uvm_error("SCBD",compare_message("MISMATCH! - ",expected,actual))
         end : compare_failed
   endfunction

  // TASK: wait_for_scoreboard_drain
  // This task is used to implement a mechanism to delay run_phase termination to allow the scoreboard time to drain.  
  virtual task wait_for_scoreboard_drain();
      while ((expected_results_q.size() != 0) || (actual_results_q.size() != 0))
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
      if ( end_of_test_empty_check  && (expected_results_q.size() != 0)) 
         begin : expected_entries_remain
         while ( (expected_results_q.size() != 0) && ( fifo_entry <  max_remaining_transaction_print )) 
            begin : print_expected_entries
            expected_transaction = expected_results_q.pop_front();
            `uvm_info("SCBD",$sformatf("Expected Entry %d:%s",fifo_entry++,expected_transaction.convert2string()),UVM_MEDIUM)
            end : print_expected_entries
         `uvm_error("SCBD","EXPECTED SCOREBOARD NOT EMPTY");
         end : expected_entries_remain
      // Check actual fifo
      if ( end_of_test_empty_check  && (actual_results_q.size() != 0)) 
         begin : actual_entries_remain
         fifo_entry=0;
         while ( (actual_results_q.size() != 0) && ( fifo_entry <  max_remaining_transaction_print )) 
            begin : print_actual_entries
            expected_transaction = actual_results_q.pop_front();
            `uvm_info("SCBD",$sformatf("Actual Entry %d:%s",fifo_entry++,expected_transaction.convert2string()),UVM_MEDIUM)
            end : print_actual_entries
         `uvm_error("SCBD","ACTUAL SCOREBOARD NOT EMPTY");
         end : actual_entries_remain
   endfunction

endclass : uvmf_in_order_race_scoreboard
