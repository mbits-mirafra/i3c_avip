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
// Unit            : Out of order race scoreboard
// File            : uvmf_out_of_order_race_scoreboard.svh
//----------------------------------------------------------------------
// Creation Date   : 07.06.2022
//----------------------------------------------------------------------

// CLASS: uvmf_out_of_order_race_scoreboard
// This class defines an out of order race scoreboard that is based on the uvmf_out_of_order_scoreboard class.
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
//
// PARAMETERS:
//    T    - Specifies the type of transactions to be compared.
//           Must be derived from uvmf_transaction_base.

class uvmf_out_of_order_race_scoreboard #(type T=uvmf_transaction_base) extends uvmf_out_of_order_scoreboard #(T);

   `uvm_component_param_utils(uvmf_out_of_order_race_scoreboard #(T))

   // FUNCTION: new
   function new(string name, uvm_component parent );
      super.new(name, parent);
   endfunction : new
 
   // FUNCTION: write_expected
   // Transactions arrive through this interface from one or more predictors.
   // Transactions are either compared against a transaction with a matching key 
   // or stored in the hash if a transaction with a matching key does not exist.
   virtual function void write_expected (input T t);
     transaction_count++;
     ->entry_received;
     compare_or_store_entry(t);
   endfunction

   // FUNCTION: write_actual
   // Transactions arrive through this interface from one or more DUT output monitors.
   // Transactions are either compared against a transaction with a matching key 
   // or stored in the hash if a transaction with a matching key does not exist.
   virtual function void write_actual (input T t);
     ->entry_received;
     compare_or_store_entry(t);
   endfunction

   virtual function void compare_or_store_entry (input T t);
      T expected_item;
      if (scoreboard_enabled) 
         begin : in_compare_or_store_entry
         // Test if matching item exists in expected hash
         if ( expected_hash.exists(t.get_key()) ) 
            begin : item_exists_in_array
            expected_item=expected_hash[t.get_key()];
            expected_hash.delete(t.get_key());
            // Exit function if comparison is disabled
            if ( disable_entry_compare ) begin : comparison_disabled
                  `uvm_warning("SCBD", "COMPARISONS DISABLED")
                  return;
                end : comparison_disabled
            // Compare actual transaction to expected transaction
            last_expected = expected_item;
            last_actual = t;
            if ( t.compare(expected_item) ) 
               begin : compare_passed
               match_count++;
               last_mismatched = 0;
               `uvm_info("SCBD",compare_message("MATCH! - ",expected_item,t),UVM_MEDIUM)
               end : compare_passed
            else 
               begin : compare_failed
               mismatch_count++;
               last_mismatched = 1;
               `uvm_error("SCBD",compare_message("MISMATCH! - ",expected_item,t))
               end : compare_failed
            end : item_exists_in_array
         else 
            begin : no_item_exists_in_array_add_item_to_array
               expected_hash[t.get_key()]=t;
            end : no_item_exists_in_array_add_item_to_array
         end : in_compare_or_store_entry
   endfunction : compare_or_store_entry
  
endclass : uvmf_out_of_order_race_scoreboard
