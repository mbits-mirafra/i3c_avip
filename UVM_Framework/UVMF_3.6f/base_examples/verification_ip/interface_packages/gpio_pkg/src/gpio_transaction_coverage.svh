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
// Unit            : Transaction coverage
// File            : gpio_transaction_coverage.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This class records gpio transaction information using
//       a covergroup named gpio_transaction_cg.  An instance of this 
//       coverage component is instantiated in the uvmf_parameterized_agent
//       if the has_coverage flag is set.
//
//----------------------------------------------------------------------
//
class gpio_transaction_coverage #(int READ_PORT_WIDTH=4, int WRITE_PORT_WIDTH=4 ) 
            extends uvm_subscriber#(gpio_transaction#(READ_PORT_WIDTH,WRITE_PORT_WIDTH));

  `uvm_component_param_utils( gpio_transaction_coverage #(READ_PORT_WIDTH, WRITE_PORT_WIDTH) )

   logic  [WRITE_PORT_WIDTH-1:0] write_port;
   logic  [READ_PORT_WIDTH-1:0] read_port;

// ****************************************************************************
  covergroup gpio_transaction_cg;
     coverpoint write_port;
     coverpoint read_port;
  endgroup


  function new(string name="", uvm_component parent=null);
    super.new(name,parent);
    gpio_transaction_cg=new();
    gpio_transaction_cg.set_inst_name($sformatf("gpio_transaction_cg_%s",get_full_name()));
 endfunction

  virtual function void write (T t);
    `uvm_info("Coverage","Received transaction",UVM_LOW);
    write_port = t.write_port;
    read_port = t.read_port;
    gpio_transaction_cg.sample();
  endfunction

endclass
