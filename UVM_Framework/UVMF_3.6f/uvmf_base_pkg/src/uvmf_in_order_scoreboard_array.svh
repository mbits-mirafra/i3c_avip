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
//                   Mentor Graphics Inc
//----------------------------------------------------------------------
// Project         : UVM Framework
// Unit            : In order scoreboard array
// File            : uvmf_in_order_scoreboard_array.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------

import uvm_pkg::*;
`include "uvm_macros.svh"

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
   uvm_tlm_analysis_fifo #(T) expected_results_af[] = new[ARRAY_DEPTH];

   // FUNCTION: new
   function new(string name, uvm_component parent );
      super.new(name, parent);
   endfunction : new

   // FUNCTION: build
   // Construct the analysis fifo
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      foreach (expected_results_af[i])
        expected_results_af[i]=new($sformatf("expected_results_af[%3d]",i),this);

   endfunction

   // FUNCTION: write_expected
   // Transactions arrive through this interface from one or more predictors.
   // The transaction is stored in an analysis_fifo to wait for the actual transaction.
   function void write_expected( input T t);
      super.write_expected(t);
      expected_results_af[t.get_key()].try_put(t);
   endfunction

   // FUNCTION: write_actual
   // Transactions arrive through this interface from one or more DUT output monitors.
   // The arrival of a transaction through this interface triggers its comparison to the
   // next transaction in the analysis fifo that holds expected results.
   function void write_actual( input T t);
      T expected_transaction;
      super.write_actual(t);

      // Get next entry from analysis fifo.  Error if none exists
      if ( !expected_results_af[t.get_key()].try_get(expected_transaction)) 
         begin : no_item_exists_in_selected_array
         nothing_to_compare_against_count++;
         `uvm_error($sformatf("SCOREBOARD_ERROR.%s",this.get_full_name()),$sformatf("NO PREDICTED ENTRY TO COMPARE AGAINST:%s",t.convert2string()))
         end : no_item_exists_in_selected_array
      else 
         begin : item_exists_in_selected_array
         // Compare actual transaction to expected transaction
         if (t.compare(expected_transaction)) 
            begin : compare_passed
            match_count++;
            `uvm_info($sformatf("SCOREBOARD_INFO.%s",this.get_full_name()),compare_message("MATCH! - ",expected_transaction,t),UVM_MEDIUM)
            end : compare_passed
         else 
            begin : compare_failed
            mismatch_count++;
            `uvm_error($sformatf("SCOREBOARD_ERROR.%s",this.get_full_name()),compare_message("MISMATCH! - ",expected_transaction,t))
            end : compare_failed
         end : item_exists_in_selected_array
   endfunction : write_actual

   // TASK: wait_for_scoreboard_drain
  // This task is used to implement a mechanism to delay run_phase termination to allow the scoreboard time to drain.  
  virtual task wait_for_scoreboard_drain();
      bit entries_remaining;
      foreach ( expected_results_af[i]) 
            if (expected_results_af[i].is_empty() == 0) entries_remaining |= 1;
      while (entries_remaining) 
         begin : while_entries_remaining
         @entry_received;
         entries_remaining=0;
         foreach ( expected_results_af[i]) 
            if (expected_results_af[i].is_empty() == 0) entries_remaining |= 1;
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
         foreach ( expected_results_af[i]) 
            begin : foreach_expected_results_af
            if (expected_results_af[i].is_empty() == 0) 
               begin : entries_remain
               while ( (expected_results_af[i].is_empty() == 0) && ( fifo_entry <  max_remaining_transaction_print )) 
                  begin : print_entries
                  void'(expected_results_af[i].try_get(expected_transaction));
                  `uvm_info($sformatf("SCOREBOARD_INFO.%s",this.get_full_name()),$sformatf("Channel %d Entry %d:%s",i,fifo_entry++,expected_transaction.convert2string()),UVM_MEDIUM)
                  end : print_entries
               `uvm_error($sformatf("SCOREBOARD_ERROR.%s",this.get_full_name()),$sformatf("CHANNEL [%d] SCOREBOARD NOT EMPTY",i));
               fifo_entry = 0;
               end : entries_remain
            end : foreach_expected_results_af
         end : end_of_test_empty_check
   endfunction


endclass : uvmf_in_order_scoreboard_array
