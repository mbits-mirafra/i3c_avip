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
//----------------------------------------------------------------------
//                   Mentor Graphics Inc
//----------------------------------------------------------------------
// Project         : GPIO Example Project Bench
// Unit            : UVM Test Top
// File            : test_top.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This top level UVM test is the base class for all 
//     future tests created for this project.  
//    
//     This test class contains:
//          Configuration:  The top level configuration for the project.
//          Environment:    The top level environment for the project.
//          Top_level_sequence:  The top level sequence for the project.
//
//----------------------------------------------------------------------
//
class test_top extends uvmf_test_base #(
   .CONFIG_T(gpio_example_configuration_t),
   .ENV_T(gpio_example_environment_t),
   .TOP_LEVEL_SEQ_T(gpio_example_sequence_base_t)
);

  `uvm_component_utils( test_top );

// ****************************************************************************
  function new( string name = "", uvm_component parent = null );
     super.new( name ,parent );
  endfunction

// ****************************************************************************
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    configuration.initialize(BLOCK, "uvm_test_top.environment",{ "gpio_bfm" } );
    configuration.gpio_config.has_coverage = 0;
    set_config_int("*", "recording_detail", UVM_FULL);
  endfunction

endclass
