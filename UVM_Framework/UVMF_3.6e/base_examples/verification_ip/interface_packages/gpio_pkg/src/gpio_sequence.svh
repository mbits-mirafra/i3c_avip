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
// File            : gpio_sequence.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This sequence provides the write and read functionality
//    for the gpio interface.
//
//----------------------------------------------------------------------
//
class gpio_sequence #(int READ_PORT_WIDTH=4, int WRITE_PORT_WIDTH=4) extends 
    gpio_sequence_base #(READ_PORT_WIDTH, WRITE_PORT_WIDTH);

  `uvm_object_param_utils( gpio_sequence #(READ_PORT_WIDTH, WRITE_PORT_WIDTH))

  REQ gpio_trans;

// ****************************************************************************
  function new(string name = "" );
     super.new( name );
     gpio_trans=REQ::type_id::create("gpio_trans");
     gpio_trans.op = GPIO_RD; 
  endfunction

// ****************************************************************************
  virtual function string convert2string();
     return $psprintf(" \nwrite_port:0x%h \nread_port: 0x%h",gpio_trans.write_port, gpio_trans.read_port);
  endfunction

// ****************************************************************************
// Use this task to write a new value to the gpio write port
  virtual task write( input bit  [WRITE_PORT_WIDTH-1:0] value );
     gpio_trans.op = GPIO_WR; 
     gpio_trans.write_port = value; 
     this.start(m_sequencer);
  endtask

// ****************************************************************************
// This task returns the current value on the gpio read port
  virtual task read( inout bit  [READ_PORT_WIDTH-1:0] value );
     value = gpio_trans.read_port;
  endtask

// ****************************************************************************
// This task blocks until a change on the gpio read port then returns the 
//     new value on the gpio read port.
  virtual task read_on_change( inout bit  [READ_PORT_WIDTH-1:0] value );
     @(gpio_trans.read_port_change) value = gpio_trans.read_port;
  endtask
  
// ****************************************************************************
  virtual task body();
     start_item(gpio_trans);
     finish_item(gpio_trans);
  endtask

endclass
