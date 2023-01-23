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
// Unit            : Constrained Random Test
// File            : test_constrained_random.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This test extends test_top and makes the following
//    changes to test_top using the UVM factory type_override:
//
//    Test scenario: 
//      Uses the UVM factory type override to replace gpio_example_sequence_base
//      with gpio_example_sequence_constrained_random.
//
//----------------------------------------------------------------------
//
//

class test_constrained_random extends test_top;

  `uvm_component_utils( test_constrained_random );

  typedef gpio_example_sequence_constrained_random #(TEST_GPIO_READ_PORT_WIDTH, TEST_GPIO_WRITE_PORT_WIDTH)
      gpio_example_sequence_constrained_random_t;

  typedef gpio_example_sequence_base #(TEST_GPIO_READ_PORT_WIDTH, TEST_GPIO_WRITE_PORT_WIDTH)
      gpio_example_sequence_base_t;

  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

  virtual function void build_phase(uvm_phase phase);
    gpio_example_sequence_base_t::type_id::set_type_override(gpio_example_sequence_constrained_random_t::get_type());
    super.build_phase(phase);
  endfunction

endclass
