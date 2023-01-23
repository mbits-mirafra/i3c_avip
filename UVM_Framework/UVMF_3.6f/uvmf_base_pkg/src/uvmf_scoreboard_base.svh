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

  // Variables used to report transaction matches and mismatches
  int match_count;
  int mismatch_count;
  int nothing_to_compare_against_count;

  // Variables used for report_phase summary output formatting using report_message()
  int report_variables[];
  string report_header = "SCOREBOARD_RESULTS: ";

  // Variable used to enable end of test scoreboard empty check
  bit end_of_test_empty_check=1;

  // Variables used to determine if scoreboard was used during the test
  bit end_of_test_activity_check=1;
  int transaction_count;

  // Variables used to define maximum number of transactions to print if 
  // the scoreboard contains transactions after test completion
  int max_remaining_transaction_print=10;

  // Variable used to delay run phase completion until scoreboard empty
  bit wait_for_scoreboard_empty;
  event entry_received;

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

  // FUNCTION: enable_end_of_test_empty_check
  // Used to diable the end of test empty check.
  function void enable_end_of_test_empty_check();
     end_of_test_empty_check=1;
  endfunction

  // FUNCTION: disable_end_of_test_activity_check
  // Used to diable the end of test activity check.
  function void disable_end_of_test_activity_check();
     end_of_test_activity_check=0;
  endfunction

  // FUNCTION: enable_end_of_test_activity_check
  // Used to diable the end of test activity check.
  function void enable_end_of_test_activity_check();
     end_of_test_activity_check=1;
  endfunction

  // FUNCTION: disable_wait_for_scoreboard_empty
  // Used to disable delaying run phase completion until scoreboard empty.
  function void disable_wait_for_scoreboard_empty();
     wait_for_scoreboard_empty=0;
  endfunction

  // FUNCTION: enable_wait_for_scoreboard_empty
  // Used to enable delaying run phase completion until scoreboard empty.
  function void enable_wait_for_scoreboard_empty();
     wait_for_scoreboard_empty=1;
  endfunction

  // FUNCTION: set_max_remaining_transaction_print
  // Used to set maximum number of transactions to print of transactions 
  // remaining in scoreboard in check phase 
  function void set_max_remaining_transaction_print(int count);
     max_remaining_transaction_print=count;
  endfunction

  // FUNCTION: write_expected
  // That predicted transactions are received through
  virtual function void write_expected(T t);
     transaction_count++;
     ->entry_received;
  endfunction

  // FUNCTION: write_actual
  // That DUT output, actual, transactions are received through
  virtual function void write_actual(T t);
       ->entry_received;
  endfunction

  // FUNCTION: compare_message
  // Builds the message printed when comparing transactions
  // Provides for customization of mismatch output formatting
  virtual function string compare_message(string header, T expected, T actual);
        return {header,"EXPECTED: ",expected.convert2string(),"ACTUAL: ",actual.convert2string()};
  endfunction

  // FUNCTION: check_phase
  // Conditionally check scoreboard usage during the UVM check_phase
  virtual function void check_phase(uvm_phase phase);
     super.check_phase(phase);
     if (end_of_test_activity_check && (transaction_count == 0) ) `uvm_error($sformatf("SCOREBOARD_ERROR.%s",this.get_full_name()),"No Transactions Scoreboarded")
  endfunction

  // FUNCTION: extract_phase
  // Extract results data and place in report_variables array for reporting
  virtual function void extract_phase(uvm_phase phase);
     super.extract_phase(phase);
     report_variables = {transaction_count, match_count, mismatch_count, nothing_to_compare_against_count};
  endfunction

  // FUNCTION: report_message
  // Builds the report_phase message printed for scoreboards derived from this base 
  // Provides for customization of output formatting
  virtual function string report_message(string header, int variables [] );
        return {$sformatf("%s PREDICTED_TRANSACTIONS=%.0d MATCHES=%.0d MISMATCHES=%.0d", header, variables[0], variables[1], variables[2])}; 
  endfunction

  // FUNCTION: report_phase
  // Display the transaction comparison summary during the UVM report_phase
  virtual function void report_phase(uvm_phase phase);
     super.report_phase(phase);
     `uvm_info( $sformatf("SCOREBOARD_SUMMARY.%s",this.get_full_name()), report_message(report_header, report_variables),
UVM_LOW)
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
     if (phase.get_name() == "run") 
        begin : if_run_phase
        if ( wait_for_scoreboard_empty ) 
           begin : if_wait_for_scoreboard_empty
           phase.raise_objection( this , {get_full_name(),"- Delaying run_phase termination to allow scoreboard to empty."} );
           fork 
             begin : wait_for_scoreboard_to_drain
                wait_for_scoreboard_drain();
                phase.drop_objection( this , {get_full_name(),"- Done waiting for scoreboard to empty."});
             end : wait_for_scoreboard_to_drain
           join_none
           end : if_wait_for_scoreboard_empty
        end : if_run_phase
 endfunction

endclass : uvmf_scoreboard_base
