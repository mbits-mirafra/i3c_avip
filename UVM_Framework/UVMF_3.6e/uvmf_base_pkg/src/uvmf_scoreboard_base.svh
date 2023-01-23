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
// Unit            : Scoreboard base
// File            : uvmf_scoreboard_base.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------

import uvm_pkg::*;
`include "uvm_macros.svh"

`uvm_analysis_imp_decl(_expected)
`uvm_analysis_imp_decl(_actual)


// CLASS: uvmf_scoreboard_base
// This class defines a base class for scoreboards which require separate analysis
// exports for actual and expected transactions.  It creates two analysis export
// implementations:
//          - actual_analysis_export   accessed through write_actual
//          - expected_analysis_export accessed through write_expected
//
// (see uvmf_scoreboard_base.jpg)
//
// PARAMETERS:
//
//   T - Specifies the type of transactions to be compared.
//       Must be derived from uvmf_transaction_base.

class uvmf_scoreboard_base #(type T = uvmf_transaction_base) extends uvm_scoreboard;

  uvm_analysis_imp_expected#(T, uvmf_scoreboard_base #(T)) expected_analysis_export;
  uvm_analysis_imp_actual#(T, uvmf_scoreboard_base #(T)) actual_analysis_export;

  // Variable used to enable end of test scoreboard empty check
  bit end_of_test_empty_check=1;

  // Variables used to determine if scoreboard was used during the test
  bit end_of_test_activity_check=1;
  int transaction_count;

  // FUNCTION: new
  function new(string name, uvm_component parent);
    super.new(name,parent);
    expected_analysis_export = new("expected_analysis_export", this);
    actual_analysis_export = new("actual_analysis_export", this);
  endfunction

   // FUNCTION: build
   // Construct the analysis fifo and non-blocking get port
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      // Checking for command line disable of scoreboard empty check.  
      // This is only added for QA testing of UVMF code generators.
      // This is NOT recommended for use when verifying a design.
      void'(uvm_config_db #(uvm_bitstream_t)::get(this,"","end_of_test_empty_check",end_of_test_empty_check));
   endfunction

  // FUNCTION: disable_end_of_test_empty_check
  // Used to diable the end of test empty check.
  function void disable_end_of_test_empty_check();
     end_of_test_empty_check=0;
  endfunction

  // FUNCTION: disable_end_of_test_activity_check
  // Used to diable the end of test activity check.
  function void disable_end_of_test_activity_check();
     end_of_test_activity_check=0;
  endfunction

  // FUNCTION: write_expected
  // That predicted transactions are received through
  virtual function void write_expected(T t);
     transaction_count++;
  endfunction

  // FUNCTION: write_actual
  // That DUT output, actual, transactions are received through
  virtual function void write_actual(T t);
  endfunction

  // FUNCTION: check_phase
  // Conditionally check scoreboard usage during the UVM check_phase
  virtual function void check_phase(uvm_phase phase);
     if (end_of_test_activity_check && (transaction_count == 0) ) `uvm_error("SCOREBOARD", "No transactions scoreboarded")
  endfunction

  // TASK: wait_for_scoreboard_drain
  // This task is used to implement a mechanism to delay run_phase termination to allow the scoreboard time to drain.  
  // Extend a scoreboard to override this task based on project requirements.  The delay mechanism can be for instance 
  // a mechanism that ends when the last entry is removed from the scoreboard.
  virtual task wait_for_scoreboard_drain();
  endtask

  // FUNCTION: phase_ready_to_end
  // This function is executed at the end of the run_phase.  
  // It allows the simulation to continue so that remaining transactions on the scoreboard can be removed.
 virtual function void phase_ready_to_end( uvm_phase phase );
     if (phase.get_name() == "run") begin
        phase.raise_objection( this , {get_full_name(),"- Delaying run_phase termination to allow scoreboard to empty."} );
        fork begin
          wait_for_scoreboard_drain();
          `uvm_info("PHASE_READY_TO_END", get_full_name(),UVM_HIGH)
          phase.drop_objection( this , {get_full_name(),"- Done waiting for scoreboard to empty."});
        end
        join_none
     end
 endfunction : phase_ready_to_end

endclass : uvmf_scoreboard_base
