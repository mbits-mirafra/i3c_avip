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
// Project         : AHB to WB Simulation Bench
// Unit            : AHB Random Test
// File            : alu_random_test.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This test extends test_top and makes the following
//    changes to test_top using the UVM factory type_override:
//
//    Test scenario: 
//      Replace alu_sequence_base with alu_random_sequence
//
//----------------------------------------------------------------------
//
class alu_mul_test extends test_top;

  `uvm_component_utils( alu_mul_test );

  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

  virtual function void build_phase(uvm_phase phase);
    alu_in_random_sequence#(ALU_IN_OP_WIDTH)::type_id::set_type_override(alu_in_mul_sequence#(ALU_IN_OP_WIDTH)::get_type());
    super.build_phase(phase);
  endfunction

endclass
