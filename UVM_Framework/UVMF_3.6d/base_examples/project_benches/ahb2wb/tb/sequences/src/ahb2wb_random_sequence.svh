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
// File            : ahb2wb_sequence_base.svh
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
class ahb2wb_random_sequence extends ahb2wb_sequence_base;

  `uvm_object_utils( ahb2wb_random_sequence );

  ahb_random_sequence ahb_random_s;


// ****************************************************************************
  function new( string name = "" );
     super.new( name );
  endfunction

// ****************************************************************************
  virtual task body();
     ahb_reset_s = ahb_reset_sequence::type_id::create("ahb_reset_s");
     ahb_random_s = ahb_random_sequence::type_id::create("ahb_random_s");
     wb_memory_slave_s = wb_memory_slave_sequence::type_id::create("wb_memory_slave_s");


     ahb_reset_s.start(ahb_sequencer);

     fork wb_memory_slave_s.start(wb_sequencer); join_none

     repeat (100) ahb_random_s.start(ahb_sequencer);

     wb_config.wait_for_num_clocks(10);  // Wait for DUT latency to allow final traffic to flush

  endtask

endclass
