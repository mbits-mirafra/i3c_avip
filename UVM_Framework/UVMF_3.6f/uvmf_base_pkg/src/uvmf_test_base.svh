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
// Unit            : Test base
// File            : uvmf_test_base.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------


// CLASS: uvmf_test_base
// This class provides base functionality for uvm tests. It generates debug
// information during end_of_elaboration phase based on simulation verbosity.
// It also conditionally writes a ucdb at the end of the simulation. In order
// for a ucdb to be written the save_ucdb_file_at_end_of_test flag must be set
// and the test must have no uvm errors or uvm fatals.  The name of the ucdb
// file is test_name.seed_number.ucdb.
// This class also instantiates the top configuration, environment and sequence.
// The top level sequence is started by this class in the run_phase.
//
// PARAMETERS:
//   CONFIG_T         - The class type of the top level configuration.
//   ENV_T            - The class type of the top level environment.
//   TOP_LEVEL_SEQ_T  - The class type of the top level sequence.

class uvmf_test_base #(
   type CONFIG_T,
   type ENV_T,
   type TOP_LEVEL_SEQ_T
) extends uvm_test;

  `uvm_component_param_utils( uvmf_test_base #(CONFIG_T, ENV_T, TOP_LEVEL_SEQ_T));

  // Instantiate the top level configuration, environment and sequence.
  CONFIG_T        configuration;
  ENV_T           environment;
  TOP_LEVEL_SEQ_T top_level_sequence;

  // STRING: test_name
  // Variable used to set the name of the ucdb file from this test
  string test_name;

  // BIT: save_ucdb_file_at_end_of_test
  // Flag to enable automatic ucdb generation at end of test.
  bit save_ucdb_file_at_end_of_test=1'b0;

  // BIT: save_ucdb_regardless_of_error_or_fatal
  //  By default a ucdb file is not generated if the test has a UVM error or fatal.
  //  Setting this flag enables automatic generation of a ucdb file even if
  //  the test has a UVM error or fatal.
  bit save_ucdb_regardless_of_error_or_fatal =1'b0;

  // FUNCTION: new
  function new( string name = "", uvm_component parent = null );
     super.new( name ,parent );
  endfunction

  // FUNCTION: build_phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Get test name from UVM_TESTNAME command line argument
    if(!$value$plusargs("UVM_TESTNAME=%s", test_name))
      `uvm_error("TEST", {"Unknown Test name", test_name})
    // Save transcript
    // void'(mti_Cmd($sformatf("transcript file %s.$Sv_Seed.transcript.txt", test_name)));


    // Construct the top level configuration, environment and sequence.
    configuration = CONFIG_T::type_id::create("configuration");
    if (!configuration.randomize()) `uvm_fatal("UVMF_CONFIG_RANDOMIZE",get_name());
    environment   = ENV_T::type_id::create("environment",this);

    environment.set_config(configuration);

    `uvm_info("TOP_LEVEL_CONFIGURATION",configuration.convert2string(),UVM_HIGH);

  endfunction

  // FUNCTION: end_of_elaboration_phase
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

    if (get_report_verbosity_level() >= int'(UVM_HIGH) ) begin
       uvm_top.enable_print_topology = 1;
       uvm_top.dump_report_state();
       // Commented for UVM 1.2 compatability factory.print();
       uvm_top.check_config_usage(1);
       // uvm_config_db::dump();
       // uvm_top.print_conifg(1,1);
       // show_connectivity(uvm_top,0);
       // uvmf_analysis_debug #( uvmf_standard_port_debug_policy )::uvmf_analysis_debug( this );
    end

  endfunction

  // FUNCTION: connect_phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    top_level_sequence = TOP_LEVEL_SEQ_T::type_id::create("top_level_sequence");
  endfunction

// FUNCTION: run_phase
// This task manages the test objection and starts the top level sequence.
  virtual task run_phase( uvm_phase phase );
    phase.raise_objection(this, "Objection raised by test_top");
    top_level_sequence.start(null);
    phase.drop_objection(this, "Objection dropped by test_top");
  endtask


// FUNCTION: report_phase
virtual function void report_phase(uvm_phase phase);
    uvm_report_server urs;

    urs = get_report_server();

    // Save ucdb if end_of_test flag set and either no error/fatal or regardless flag cleared
    if  ( save_ucdb_file_at_end_of_test ) begin
         if ( ((urs.get_severity_count(UVM_ERROR) == 0 ) && (urs.get_severity_count(UVM_FATAL) == 0 )) ||
              ( save_ucdb_regardless_of_error_or_fatal )) begin
            void'(mti_Cmd("coverage attribute -name QUESTASIMVERSION -value [vsimVersionString]"));
            // Use the coverage file save command below to change file name to include seed number
            // void'(mti_Cmd($sformatf("coverage save %s.$Sv_Seed.ucdb", test_name)));
            void'(mti_Cmd("coverage save sim.ucdb" ));
         end
    end
endfunction

endclass : uvmf_test_base
