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
// Project         : WB interface agent
// Unit            : Transaction coverage
// File            : wb_transaction_coverage.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This class records wb transaction information using
//       a covergroup named wb_transaction_cg.  An instance of this 
//       coverage component is instantiated in the uvmf_parameterized_agent
//       if the has_coverage flag is set.
//
//----------------------------------------------------------------------
//
class wb_transaction_coverage extends uvm_subscriber#(wb_transaction);

  `uvm_component_utils( wb_transaction_coverage )


   int delay=0;
   bit [WB_ADDR_WIDTH-1:0] addr;
   bit [WB_DATA_WIDTH-1:0] data;
   bit [2:0] byte_select;
   wb_op_t                 op;


//*******************************************************************
   covergroup wb_transaction_cg;
      coverpoint delay;
      coverpoint addr;
      coverpoint data;
      coverpoint byte_select;
      coverpoint op;
      op_x_addr: cross op, addr;
   endgroup


// ****************************************************************************
  function new(string name="", uvm_component parent=null);
    super.new(name,parent);
    wb_transaction_cg=new;
    wb_transaction_cg.set_inst_name($sformatf("wb_transaction_cg_%s",get_full_name()));
  endfunction

// ****************************************************************************
  function void write (T t);
    `uvm_info("Coverage","Received transaction",UVM_HIGH);
    delay = t.delay;
    addr = t.addr;
    data = t.data;
    byte_select = t.byte_select;
    op = t.op;
    wb_transaction_cg.sample();
  endfunction

endclass
