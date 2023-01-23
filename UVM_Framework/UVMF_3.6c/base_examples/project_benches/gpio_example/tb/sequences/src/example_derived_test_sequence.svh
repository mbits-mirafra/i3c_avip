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
// Unit            : Top Level Sequences
// File            : example_derived_test_sequence.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This file contains the top level sequence used by example_derived_test.
//
//----------------------------------------------------------------------
//
class example_derived_test_sequence  #( int READ_PORT_WIDTH=4, int WRITE_PORT_WIDTH=4 ) extends
    gpio_example_sequence_base #(READ_PORT_WIDTH, WRITE_PORT_WIDTH);

  `uvm_object_param_utils( example_derived_test_sequence #(READ_PORT_WIDTH, WRITE_PORT_WIDTH));

  function new(string name = "" );
    super.new(name);
  endfunction

endclass
