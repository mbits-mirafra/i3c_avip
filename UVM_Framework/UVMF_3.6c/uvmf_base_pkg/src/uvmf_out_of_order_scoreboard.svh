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
// Unit            : Out of order scoreboard
// File            : uvmf_out_of_order_scoreboard.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------

import uvm_pkg::*;
`include "uvm_macros.svh"

// CLASS: uvmf_out_of_order_scoreboard
// This class defines an out of order scoreboard that is based on the uvmf_scoreboard_base class.
// This scoreboard is a generic scoreboard that will compare two objects of type T. Class T
// must be an extension of <uvmf_transaction_base>. Class T must have the following interfaces:
// - compare() which takes an object of class T as an argument and returns a bit result
//             with 1 representing a successful compare.
// - get_key() which returns an integer which is used as a key for the associative array
//             within the scoreboard.
// There are no ordering requirements for successful comparison. There are no assumptions
// made about the relative timing of the two streams of data. Comparisons are initiated
// by the arrival of transactions through the write interface.
//
// (see uvmf_out_of_order_scoreboard.jpg)
//
// PARAMETERS:
//    T    - Specifies the type of transactions to be compared.
//           Must be derived from uvmf_transaction_base.

class uvmf_out_of_order_scoreboard #(type T=uvmf_transaction_base) extends uvmf_scoreboard_base #(T);

   `uvm_component_param_utils(uvmf_out_of_order_scoreboard #(T))

   // Associative array of exptected transactions keyed with the integer accessed using
   // the transactions get_key() interface.
   T expected_hash[integer];

   // FUNCTION: new
   function new(string name, uvm_component parent );
      super.new(name, parent);
   endfunction : new

   // FUNCTION: build
   // Construct the analysis fifo and non-blocking get port
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction

   // FUNCTION: write_expected
   // Transactions arrive through this interface from one or more predictors.
   // Transactions are placed in the expected_hash for retrieval when the actual transaction arrives
   virtual function void write_expected (input T t);
         super.write_expected(t);
         expected_hash[t.get_key()]=t;
   endfunction

   // FUNCTION: write_actual
   // Transactions arrive through this interface from one or more DUT output monitors.
   // The arrival of a transaction through this interface triggers its comparison to the
   // item in the associative array with a matching key
   virtual function void write_actual (input T t);
      T expected_item;
      super.write_actual(t);
      // Test if matching item exists in expected hash
      if ( expected_hash.exists(t.get_key()) ) begin
            expected_item=expected_hash[t.get_key()];
            expected_hash.delete(t.get_key());
         // Display the two transactions
            `uvm_info("SCOREBOARD",{"Actual:",t.convert2string()},UVM_MEDIUM)
            `uvm_info("SCOREBOARD",{"Expected:",expected_item.convert2string()},UVM_MEDIUM)

         // Compare actual transaction to expected transaction
         if ( t.compare(expected_item) ) begin
            `uvm_info("SCOREBOARD RESULTS", "MATCH!",UVM_MEDIUM)
         end else begin
            `uvm_error("SCOREBOARD RESULTS", "MISMATCH!");
         end
      // No matching item exists within expected hash
      end else begin
         `uvm_info("SCOREBOARD",{"Actual:",t.convert2string()}, UVM_MEDIUM)
         `uvm_error("SCOREBOARD RESULTS","NO PREDICTED ENTRY TO COMPARE AGAINST")
         end
   endfunction : write_actual

   // FUNCTION: check_phase
   // Check for fifo empty at end of test if configured to do so
   virtual function void check_phase( uvm_phase phase);
      super.check_phase(phase);
      if ( end_of_test_empty_check  && (expected_hash.size() != 0))
         `uvm_error("SCOREBOARD RESULTS","SCOREBOARD NOT EMPTY")
   endfunction

endclass : uvmf_out_of_order_scoreboard
