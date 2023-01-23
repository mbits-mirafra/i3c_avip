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
// Unit            : In order scoreboard array
// File            : uvmf_in_order_scoreboard_array.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------

// CLASS: uvmf_in_order_scoreboard_array
// This class defines a scoreboard that can be used where multiple logical channels of data are sent through a single
// physical channel.  Each channel will use one fifo within the array of fifo's.  The number of logical channels, and
// therefore number of fifo's, is determined by the ARRAY_DEPTH parameter.  The order of data on each individual channel
// is assumed to be preserved. The get_key() function of the transaction is used to identify the transactions logical
// channel. This scoreboard requires the transaction class to be an extension of uvmf_transaction_base.
//
// (see uvmf_in_order_scoreboard_array.jpg)
//
// PARAMETERS:
//   T           - Specifies the type of transactions to be compared. 
//                 Must be derived from uvmf_transaction_base.
//   ARRAY_DEPTH - Specifies the number of expected transaction fifos.

class uvmf_in_order_scoreboard_array #(type T = uvmf_transaction_base, int ARRAY_DEPTH = 1) extends uvmf_scoreboard_base#(T);

  `uvm_component_param_utils( uvmf_in_order_scoreboard_array #(T, ARRAY_DEPTH))

   // Analysis fifo to queue up expected transactions.  This is required because of DUT latency.
   typedef T expected_results_q_t[$];
   expected_results_q_t expected_results_q[ARRAY_DEPTH];

   // Local data members for debug
   T last_actual;
   T last_expected;
   bit last_mismatched = 0;

   // FUNCTION: new
   function new(string name, uvm_component parent );
      super.new(name, parent);
   endfunction : new

   // FUNCTION: build
   // Construct the analysis fifo
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction

   // FUNCTION: 
   // Used to flush all entries in the scoreboard
   virtual function void flush_scoreboard();
      foreach (expected_results_q[i])
        expected_results_q[i].delete();
   endfunction

   // FUNCTION: 
   // Used to remove an entry from the scoareboard
   // An entry is removed from the out side of the fifo
   // The key field is used to identify which fifo to remove an entry from
   virtual function void remove_entry(int unsigned key=0);
      T flushed_transaction;
      if ( key >= ARRAY_DEPTH ) 
         begin : key_check
         `uvm_error("SCBD", $sformatf("Invalid key %d out of valid range between 0 and %d", key, ARRAY_DEPTH))
         end : key_check
      else 
         begin : remove_entry
         flushed_transaction = expected_results_q[key].pop_front();
         end : remove_entry
   endfunction

   // FUNCTION: write_expected
   // Transactions arrive through this interface from one or more predictors.
   // The transaction is stored in an analysis_fifo to wait for the actual transaction.
   function void write_expected( input T t);
      if (scoreboard_enabled) 
         begin : in_write_expected
         if ( t.get_key() >= ARRAY_DEPTH ) 
            begin : expected_key_check
            `uvm_error("SCBD", $sformatf("Invalid key %d out of valid range between 0 and %d", t.get_key(), ARRAY_DEPTH))
            end : expected_key_check
         super.write_expected(t);
         expected_results_q[t.get_key()].push_back(t);
         end : in_write_expected
   endfunction

   // FUNCTION: write_actual
   // Transactions arrive through this interface from one or more DUT output monitors.
   // The arrival of a transaction through this interface triggers its comparison to the
   // next transaction in the analysis fifo that holds expected results.
   function void write_actual( input T t);
      T expected_transaction;
      if (scoreboard_enabled) 
         begin : in_write_actual
         super.write_actual(t);
         if ( t.get_key() >= ARRAY_DEPTH ) 
            begin : actual_key_check
            `uvm_error("SCBD", $sformatf("Invalid key %d out of valid range between 0 and %d", t.get_key(), ARRAY_DEPTH))
            end : actual_key_check
   
         // Get next entry from analysis fifo.  Error if none exists
         if ( expected_results_q[t.get_key()].size() == 0 ) 
            begin : no_item_exists_in_selected_q
            nothing_to_compare_against_count++;
            `uvm_error("SCBD",$sformatf("NO PREDICTED ENTRY TO COMPARE AGAINST:%s",t.convert2string()))
            end : no_item_exists_in_selected_q
         else 
            begin : item_exists_in_selected_q
            expected_transaction = expected_results_q[t.get_key()].pop_front();
            // Exit function if comparison is disabled
            if ( disable_entry_compare ) begin : comparison_disabled
                  `uvm_warning("SCBD", "COMPARISONS DISABLED")
                  return;
                end : comparison_disabled
            // Compare actual transaction to expected transaction
            last_expected = expected_transaction;
            last_actual = t;
            if (t.compare(expected_transaction)) 
               begin : compare_passed
               match_count++;
               `uvm_info("SCBD",compare_message("MATCH! - ",expected_transaction,t),UVM_MEDIUM)
               last_mismatched = 0;
               end : compare_passed
            else 
               begin : compare_failed
               mismatch_count++;
               `uvm_error("SCBD",compare_message("MISMATCH! - ",expected_transaction,t))
               last_mismatched = 1;
               end : compare_failed
            end : item_exists_in_selected_q
            end : in_write_actual
   endfunction : write_actual

   // TASK: wait_for_scoreboard_drain
  // This task is used to implement a mechanism to delay run_phase termination to allow the scoreboard time to drain.  
  virtual task wait_for_scoreboard_drain();
      bit entries_remaining;
      foreach ( expected_results_q[i]) 
            if (expected_results_q[i].size() != 0) entries_remaining |= 1;
      while (entries_remaining) 
         begin : while_entries_remaining
         @entry_received;
         entries_remaining=0;
         foreach ( expected_results_q[i]) 
            if (expected_results_q[i].size() != 0) entries_remaining |= 1;
         end : while_entries_remaining
  endtask

   // FUNCTION: check_phase
   // Check for scoreboard empty at end of test if configured to do so
   virtual function void check_phase( uvm_phase phase);
      T expected_transaction;
      int fifo_entry;
      super.check_phase(phase);
      if ( end_of_test_empty_check  ) 
         begin : end_of_test_empty_check
         foreach ( expected_results_q[i]) 
            begin : foreach_expected_results_q
            if (expected_results_q[i].size() != 0) 
               begin : entries_remain
               while ( (expected_results_q[i].size() != 0) && ( fifo_entry <  max_remaining_transaction_print )) 
                  begin : print_entries
                  expected_transaction = expected_results_q[i].pop_front();
                  `uvm_info("SCBD",$sformatf("Channel %d Entry %d:%s",i,fifo_entry++,expected_transaction.convert2string()),UVM_MEDIUM)
                  end : print_entries
               `uvm_error("SCBD",$sformatf("CHANNEL [%d] SCOREBOARD NOT EMPTY",i));
               fifo_entry = 0;
               end : entries_remain
            end : foreach_expected_results_q
         end : end_of_test_empty_check
   endfunction


endclass : uvmf_in_order_scoreboard_array
