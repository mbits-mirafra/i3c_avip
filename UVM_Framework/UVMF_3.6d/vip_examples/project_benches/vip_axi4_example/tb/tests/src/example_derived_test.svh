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
// Project         : UVMF_Templates
// Unit            : test_top
// File            : test_top.svh
//----------------------------------------------------------------------
// Created by      : student
// Creation Date   : 2014/11/03
//----------------------------------------------------------------------

// DESCRIPTION: This test extends test_top and makes the following
//    changes to test_top using the UVM factory type_override:
//
//    Test scenario: 
//      This is a template test that can be used to create future tests.
//
//----------------------------------------------------------------------
//
class example_derived_test extends test_top;

  `uvm_component_utils( example_derived_test );

  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

  virtual function void build_phase(uvm_phase phase);
    // The factory override below is an example of how to replace the vip_axi4_bench_sequence_base 
    // sequence with the example_derived_test.svh.
    vip_axi4_bench_sequence_base_t::type_id::set_type_override(example_derived_test_sequence_t::get_type());
    // Call super.build() to execute the build_phase of test_top AFTER all factory overrides 
    // have been created.
    super.build_phase(phase);
  endfunction

endclass

