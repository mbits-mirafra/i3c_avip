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
// Unit            : gpio example random sequence 
// File            : gpio_example_sequence_constrained_random.svh
//----------------------------------------------------------------------
// Creation Date   : 02.20.2013
//----------------------------------------------------------------------
// Description: This sequence is used to generate random bus_a and bus_b
//  port values using constrained random.
//
//----------------------------------------------------------------------
//
class gpio_example_sequence_constrained_random #(int READ_PORT_WIDTH=4, int WRITE_PORT_WIDTH=4) extends
    gpio_example_sequence_base #(READ_PORT_WIDTH, WRITE_PORT_WIDTH);

  `uvm_object_param_utils( gpio_example_sequence_constrained_random #(READ_PORT_WIDTH, WRITE_PORT_WIDTH));

  bit [15:0] bus_a;
  bit [15:0] bus_b;

  covergroup gpio_cg;
    coverpoint bus_a;
    coverpoint bus_b;
    bus_a_x_bus_b: cross bus_a, bus_b;
  endgroup;

// ****************************************************************************
  function new( string name = "" );
     super.new( name );
     gpio_cg = new();
  endfunction

// ****************************************************************************
  virtual task body();

     gpio_seq = new("gpio_seq");
     gpio_seq.start(gpio_sequencer);
     repeat (100) begin
        if ( !gpio_seq.randomize()) `uvm_fatal("RANDOMIZE FAILURE", "gpio_seq randomize failed")
        bus_a = gpio_seq.bus_a;
        bus_b = gpio_seq.bus_b;
        gpio_cg.sample();
        gpio_seq.write_gpio();
        gpio_config.wait_for_num_clocks(1);  //#10ns;
     end


  endtask

endclass
