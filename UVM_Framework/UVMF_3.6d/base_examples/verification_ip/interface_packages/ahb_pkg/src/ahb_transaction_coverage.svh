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
// Project         : AHB interface agent
// Unit            : Transaction coverage
// File            : ahb_transaction_coverage.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This class records AHB transaction information using
//       a covergroup named ahb_transaction_cg.  An instance of this
//       coverage component is instantiated in the uvmf_parameterized_agent
//       if the has_coverage flag is set.
//
//----------------------------------------------------------------------
class ahb_transaction_coverage extends uvm_subscriber#(ahb_transaction);

  `uvm_component_utils( ahb_transaction_coverage )

  ahb_op_t                 op;
  bit [AHB_DATA_WIDTH-1:0] data;
  bit [AHB_ADDR_WIDTH-1:0] addr;

// ****************************************************************************
  covergroup ahb_transaction_cg;
     option.auto_bin_max=1024;
     coverpoint op
     {
        bins ahb_read = {AHB_READ};
        bins ahb_write = {AHB_WRITE};
        ignore_bins ahb_reset = {AHB_RESET};
     }
     coverpoint data;
     coverpoint addr;
     op_x_addr: cross op, addr;
  endgroup

// ****************************************************************************
  function new(string name="", uvm_component parent=null);
    super.new(name,parent);
    ahb_transaction_cg=new;
    ahb_transaction_cg.set_inst_name($sformatf("ahb_transaction_cg_%s",get_full_name()));
  endfunction

// ****************************************************************************
  virtual function void write (T t);
    `uvm_info("Coverage","Received transaction",UVM_HIGH);
    op = t.op;
    data = t.data;
    addr = t.addr;
    ahb_transaction_cg.sample();
  endfunction

endclass
