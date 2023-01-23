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
// Unit            : gpio example sequence item
// File            : gpio_gpio_sequence.svh
//----------------------------------------------------------------------
// Creation Date   : 02.20.2013
//----------------------------------------------------------------------
// Description: This sequence randomizes the write port value for
//   demonstrating coverage closure using iTBA compared to coverage
//   closure using constrained random.
//
//   This class also demonstrates how to create individual variables
//   that are mapped to the GPIO read and write port.  In this example
//   the bus_a and bus_b variables are mapped to the write port and the
//   bus_c and bus_d ports are mapped to the read port.
//
//----------------------------------------------------------------------
//
class gpio_gpio_sequence #( int READ_PORT_WIDTH=4, int WRITE_PORT_WIDTH=4 ) extends
    gpio_sequence #(READ_PORT_WIDTH, WRITE_PORT_WIDTH);

  `uvm_object_param_utils( gpio_gpio_sequence #(READ_PORT_WIDTH, WRITE_PORT_WIDTH))

  rand bit [(WRITE_PORT_WIDTH/2-1):0] bus_a;
  rand bit [(WRITE_PORT_WIDTH/2-1):0] bus_b;
  bit [(READ_PORT_WIDTH/2-1):0] bus_c;
  bit [(READ_PORT_WIDTH/2-1):0] bus_d;

// ****************************************************************************
  function new(string name = "" );
     super.new( name );
  endfunction

// ****************************************************************************
  virtual task write_gpio( );
     write({bus_a, bus_b});
  endtask

// ****************************************************************************
  virtual task read_gpio( );
     read({bus_c, bus_d});
  endtask

// ****************************************************************************
  virtual task read_on_gpio_change( );
     read_on_change({bus_c, bus_d});
  endtask

// ****************************************************************************
  function string convert2string();
     return {super.convert2string(),$psprintf("\nbus_a: %h bus_b: %h bus_c: %h bus_d: %h",bus_a, bus_b, bus_c, bus_d) };
  endfunction

endclass

