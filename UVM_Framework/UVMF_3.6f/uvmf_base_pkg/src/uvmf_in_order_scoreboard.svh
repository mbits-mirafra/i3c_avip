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
// Unit            : In order scoreboard based on uvmf_scoreboard_base
// File            : uvmf_in_order_scoreboard.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------

import uvm_pkg::*;
`include "uvm_macros.svh"

// CLASS: uvmf_in_order_scoreboard
// This class defines an in order scoreboard that is based on the uvmf_scoreboard_base class.
// It uses a uvm_tlm_analysis_fifo to queue expected transactions.
//
// (see uvmf_in_order_scoreboard.jpg)
//
// PARAMETERS:
//       T - Specifies the type of transactions to be compared.
//           Must be derived from uvmf_transaction_base.

class uvmf_in_order_scoreboard #(type T = uvmf_transaction_base) extends uvmf_scoreboard_base#(T);

  `uvm_component_param_utils( uvmf_in_order_scoreboard #(T))

   // Analysis fifo to queue up expected transactions. This is required because of DUT latency.
   uvm_tlm_analysis_fifo #(T) expected_results_af;

   // FUNCTION: new - Constructor
   function new(string name, uvm_component parent );
      super.new(name, parent);
   endfunction : new

   // FUNCTION: build
   // Construct the analysis fifo
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      expected_results_af=new("expected_results_af",this);
   endfunction

   // FUNCTION: write_expected
   // Transactions arrive through this interface from one or more predictors.
   // The transaction is stored in an analysis_fifo to wait for the actual transaction.
   function void write_expected( input T t);
      super.write_expected(t);
      void'(expected_results_af.try_put(t));
   endfunction

   // FUNCTION: write_actual
   // Transactions arrive through this interface from one or more DUT output monitors.
   // The arrival of a transaction through this interface triggers its comparison to the
   // next transaction in the analysis fifo that holds expected results.
   function void write_actual( input T t);
      T expected_transaction;
      super.write_actual(t);

      // Get next entry from analysis fifo.  Error if none exists
      if ( !expected_results_af.try_get(expected_transaction)) 
         begin : try_get_fail
         nothing_to_compare_against_count++;
         `uvm_error($sformatf("SCOREBOARD_ERROR.%s",this.get_full_name()),$sformatf("NO PREDICTED ENTRY TO COMPARE AGAINST:%s",t.convert2string()))
         end : try_get_fail
      else 
         begin : try_get_pass
            // Compare actual transaction to expected transaction
            if (t.compare(expected_transaction)) 
               begin : compare_pass
               match_count++;
               `uvm_info($sformatf("SCOREBOARD_INFO.%s",this.get_full_name()),compare_message("MATCH! - ",expected_transaction,t),UVM_MEDIUM)
               end : compare_pass
            else 
               begin : compare_fail
               mismatch_count++;
               `uvm_error($sformatf("SCOREBOARD_ERROR.%s",this.get_full_name()),compare_message("MISMATCH! - ",expected_transaction,t))
               end : compare_fail
         end : try_get_pass
   endfunction : write_actual


  // TASK: wait_for_scoreboard_drain
  // This task is used to implement a mechanism to delay run_phase termination to allow the scoreboard time to drain.  
  virtual task wait_for_scoreboard_drain();
      while (expected_results_af.is_empty() == 0) 
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
      if ( end_of_test_empty_check  && (expected_results_af.is_empty() == 0)) 
         begin : entries_remain
         while ( (expected_results_af.is_empty() == 0) && ( fifo_entry <  max_remaining_transaction_print )) 
            begin : print_entries
            void'(expected_results_af.try_get(expected_transaction));
            `uvm_info($sformatf("SCOREBOARD_INFO.%s",this.get_full_name()),$sformatf("Entry %d:%s",fifo_entry++,expected_transaction.convert2string()),UVM_MEDIUM)
            end : print_entries
         `uvm_error($sformatf("SCOREBOARD_ERROR.%s",this.get_full_name()),"SCOREBOARD NOT EMPTY");
         end : entries_remain
   endfunction

endclass : uvmf_in_order_scoreboard
