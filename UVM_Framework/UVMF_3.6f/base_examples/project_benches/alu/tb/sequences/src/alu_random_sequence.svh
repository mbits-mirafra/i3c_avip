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
// Unit            : Sequence base
// File            : alu_sequence_base.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: this class defines a sequence that generates random
//    operations.  
//
//    It performes the following stimulus:
//         1) Generates a reset on the AHB bus.
//         2) Initiates the WB slave sequence.
//         3) Generates 100 random AHB transactions.  
//         4) Waits for 10 WB clocks before terminating.
//
//----------------------------------------------------------------------
//
//
class alu_random_sequence extends alu_sequence_base;

  `uvm_object_utils( alu_random_sequence );

  alu_in_random_sequence alu_in_random_s;


// ****************************************************************************
  function new( string name = "" );
     super.new( name );
  endfunction

// ****************************************************************************
  virtual task body();
     alu_in_random_s = alu_in_random_sequence::type_id::create("alu_in_random_s");

     repeat (100) alu_in_random_s.start(alu_in_sequencer);

     alu_in_config.wait_for_num_clocks(50);  // 50 = 1000ns/20ns

  endtask

endclass
