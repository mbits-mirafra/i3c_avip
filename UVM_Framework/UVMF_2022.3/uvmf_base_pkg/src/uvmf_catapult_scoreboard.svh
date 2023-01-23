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
// Unit            : Custom scoreboard based on uvmf_in_order_race_scoreboard
// File            : uvmf_catapult_scoreboard.svh
//----------------------------------------------------------------------
// Creation Date   : 01.19.2017
//----------------------------------------------------------------------

// CLASS: uvmf_catapult_scoreboard
// This class extends the uvmf_in_order_race_scoreboard to provide extra
// reporting/checking for use with the uvmf_tlm2_sysc_predictor.
//
// PARAMETERS:
//       T - Specifies the type of transactions to be compared.
//           Must be derived from uvmf_transaction_base.

class uvmf_catapult_scoreboard #(type T = uvmf_transaction_base) extends uvmf_in_order_race_scoreboard#(T);

  `uvm_component_param_utils( uvmf_catapult_scoreboard #(T))

   // FUNCTION: new - Constructor
   function new(string name, uvm_component parent );
      super.new(name, parent);
   endfunction : new

   // FUNCTION: build
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
//      wait_for_scoreboard_empty = 1; 
      disable_end_of_test_empty_check();
   endfunction

   // FUNCTION: report_phase
   // Display the transaction comparison summary during the UVM report_phase
   // (Replaces report_phase from base class)
   virtual function void report_phase(uvm_phase phase);
      // super.report_phase(phase);
      int actual_count = match_count + mismatch_count + actual_results_q.size();
      `uvm_info("SCBD",$sformatf(" Predictor  transaction count %d",transaction_count),UVM_LOW)
      `uvm_info("SCBD",$sformatf(" Actual DUT transaction count %d",actual_count),UVM_LOW)
      if (mismatch_count > 0)
        begin
        `uvm_info("SCBD",$sformatf("Mismatch count               %d",mismatch_count),UVM_LOW)
        end
      else
        begin
        `uvm_info("SCBD",$sformatf(" Mismatch count               %d",mismatch_count),UVM_LOW)
        end
      if ((mismatch_count > 0) || ((end_of_test_activity_check ==1) && ((transaction_count == 0) || (actual_count == 0))))
        begin
        `uvm_error("SCBD"," Scoreboard FAILED")
        end
      else
        begin
        `uvm_info("SCBD"," Scoreboard PASSED",UVM_LOW)
        end
   endfunction

endclass : uvmf_catapult_scoreboard
