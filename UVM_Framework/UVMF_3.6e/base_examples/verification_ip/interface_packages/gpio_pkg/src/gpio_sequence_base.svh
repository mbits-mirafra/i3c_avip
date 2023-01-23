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
// Project         : gpio interface agent
// Unit            : Sequence library
// File            : gpio_sequence_base.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This sequence is the base sequence for all gpio
//    sequences.
//
//----------------------------------------------------------------------
//
class gpio_sequence_base #(int READ_PORT_WIDTH=4, int WRITE_PORT_WIDTH=4) extends 
    uvmf_sequence_base #(
        .REQ(gpio_transaction#(READ_PORT_WIDTH, WRITE_PORT_WIDTH)), 
        .RSP(gpio_transaction#(READ_PORT_WIDTH, WRITE_PORT_WIDTH))
    );

  `uvm_object_param_utils( gpio_sequence_base #(READ_PORT_WIDTH, WRITE_PORT_WIDTH))

// ****************************************************************************
  function new( string name ="");
    super.new( name );
  endfunction

// ****************************************************************************
  task body();
  endtask

endclass
