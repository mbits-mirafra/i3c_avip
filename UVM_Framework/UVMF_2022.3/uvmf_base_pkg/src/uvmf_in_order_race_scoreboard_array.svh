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
// Unit            : In order race scoreboard array
// File            : uvmf_in_order_race_scoreboard_array.svh
//----------------------------------------------------------------------
// Creation Date   : 04.12.2021
//----------------------------------------------------------------------

// CLASS: uvmf_in_order_race_scoreboard_array
// This class defines a scoreboard that can be used where multiple logical channels of data are sent through a single
// physical channel.  Each channel will use one fifo within the array of fifo's.  The number of logical channels, and
// therefore number of fifo's, is determined by the ARRAY_DEPTH parameter.  The order of data on each individual channel
// is assumed to be preserved. The get_key() function of the transaction is used to identify the transactions logical
// channel. This scoreboard requires the transaction class to be an extension of uvmf_transaction_base.
//
// This scoreboard two uvm_tlm_analysis_fifo's to queue expected as well as actual transactions since either
// could arrive first.
//
// PARAMETERS:
//   T           - Specifies the type of transactions to be compared.
//                 Must be derived from uvmf_transaction_base.
//   ARRAY_DEPTH - Specifies the number of expected transaction fifos.

class uvmf_in_order_race_scoreboard_array #(type T = uvmf_transaction_base, int ARRAY_DEPTH = 1) extends uvmf_scoreboard_base#(T);

  `uvm_component_param_utils( uvmf_in_order_race_scoreboard_array #(T, ARRAY_DEPTH))

   // Analysis fifo to queue up expected transactions.  This is required because of DUT latency.
   typedef T expected_results_q_t[$];
   expected_results_q_t expected_results_q[ARRAY_DEPTH];
   typedef T actual_results_q_t[$];
   actual_results_q_t actual_results_q[ARRAY_DEPTH];

   // FUNCTION: new
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
      foreach (expected_results_q[i]) begin
         expected_results_q[i].delete();
         actual_results_q[i].delete();
      end
   endfunction

   // FUNCTION:
   // Used to remove an entry from the scoreboard
   // An entry is removed from the out side of the fifo
   // The key field is used to identify which fifo to remove an entry from
   // Key[31] = 0 : expected side of scoreboard
   // Key[31] = 1 : actual side of scoreboard
   // Key[30:0]   : array from which to remove entry
   virtual function void remove_entry(int unsigned key=0);
      T flushed_transaction;
      int unsigned real_key;
      real_key = key & 32'h7FFFFFFF;
      if ( real_key >= ARRAY_DEPTH )
         begin : key_check
         `uvm_error("SCBD", $sformatf("Invalid key %d out of valid range between 0 and %d", real_key, ARRAY_DEPTH))
         end : key_check
      else if ( key[31] == 0 )
         begin : remove_from_expected
         flushed_transaction = expected_results_q[real_key].pop_front();
         end : remove_from_expected
      else
         begin : remove_from_actual
         flushed_transaction = actual_results_q[real_key].pop_front();
         end : remove_from_actual
   endfunction

   // FUNCTION: write_expected
   // Transactions arrive through this interface from one or more predictors.
   // Since the actual transaction may have arrived first, the arrival of a transaction through
   // this interface triggers its comparision to the next transaction in the analysis fifo that
   // holds actual results.  If no actual result exists, the transaction is stored in an
   // analysis_fifo to wait for the actual transaction.
   virtual function void write_expected( input T t);
      T actual_transaction;
      int unsigned real_key;
      real_key = t.get_key() & 32'h7FFFFFFF;
      if (scoreboard_enabled && enable_expected_port)
         begin : in_write_expected
         if ( real_key >= ARRAY_DEPTH )
            begin : expected_key_check
            `uvm_error("SCBD", $sformatf("Invalid key %d out of valid range between 0 and %d", real_key, ARRAY_DEPTH))
            end : expected_key_check
         super.write_expected(t);
         // Check if there is a next entry from actual analysis fifo.  If none exists, queue expected item
         if ( actual_results_q[real_key].size() == 0 )
            begin : no_actual_entry_to_compare_against
            expected_results_q[real_key].push_back(t);
            end : no_actual_entry_to_compare_against
         else
            begin : compare_against_actual
            actual_transaction = actual_results_q[real_key].pop_front();
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
   // next transaction in the analysis fifo that holds expected results.
   virtual function void write_actual( input T t);
      T expected_transaction;
      int unsigned real_key;
      real_key = t.get_key() & 32'h7FFFFFFF;
      if (scoreboard_enabled && enable_actual_port)
         begin : in_write_actual
         super.write_actual(t);
         if ( real_key >= ARRAY_DEPTH )
            begin : actual_key_check
            `uvm_error("SCBD", $sformatf("Invalid key %d out of valid range between 0 and %d", real_key, ARRAY_DEPTH))
            end : actual_key_check

         // Check if there is a next entry from expected analysis fifo.  If none exists, queue actual item
         if ( expected_results_q[real_key].size() == 0 )
            begin : no_expected_entry_to_compare_against
            actual_results_q[real_key].push_back(t);
            end : no_expected_entry_to_compare_against
         else
            begin : compare_against_expected
            expected_transaction = expected_results_q[real_key].pop_front();
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
      // Compare actual transaction to expected transaction
      if (actual.compare(expected))
         begin : compare_passed
         match_count++;
         `uvm_info("SCBD",compare_message("MATCH! - ",expected,actual),UVM_MEDIUM)
         end : compare_passed
      else
         begin : compare_failed
         mismatch_count++;
         `uvm_error("SCBD",compare_message("MISMATCH! - ",expected,actual))
         end : compare_failed
   endfunction

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
            // Check expected fifo
            if (expected_results_q[i].size() != 0)
               begin : expected_entries_remain
               while ( (expected_results_q[i].size() != 0) && ( fifo_entry <  max_remaining_transaction_print ))
                  begin : print_expected_entries
                  expected_transaction = expected_results_q[i].pop_front();
                  `uvm_info("SCBD",$sformatf("Channel %d Expected Entry %d:%s",i,fifo_entry++,expected_transaction.convert2string()),UVM_MEDIUM)
                  end : print_expected_entries
               `uvm_error("SCBD","EXPECTED SCOREBOARD NOT EMPTY");
               end : expected_entries_remain
            // Check actual fifo
            if (actual_results_q[i].size() != 0)
               begin : actual_entries_remain
               fifo_entry=0;
               while ( (actual_results_q[i].size() != 0) && ( fifo_entry <  max_remaining_transaction_print ))
                  begin : print_actual_entries
                  expected_transaction = actual_results_q[i].pop_front();
                  `uvm_info("SCBD",$sformatf("Channel %d Actual Entry %d:%s",i,fifo_entry++,expected_transaction.convert2string()),UVM_MEDIUM)
                  end : print_actual_entries
               `uvm_error("SCBD","ACTUAL SCOREBOARD NOT EMPTY");
               end : actual_entries_remain
            end : foreach_expected_results_q
         end : end_of_test_empty_check
   endfunction

endclass : uvmf_in_order_race_scoreboard_array
