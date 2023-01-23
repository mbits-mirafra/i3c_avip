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
// File            : alu_out_transaction_coverage.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This class records AHB transaction information using
//       a covergroup named alu_out_transaction_cg.  An instance of this
//       coverage component is instantiated in the uvmf_parameterized_agent
//       if the has_coverage flag is set.
//
// ****************************************************************************
class alu_out_transaction_coverage extends uvm_subscriber#(alu_out_transaction);

  `uvm_component_utils( alu_out_transaction_coverage )

  bit [ALU_OUT_RESULT_WIDTH-1:0] result;

// ****************************************************************************
  covergroup alu_out_transaction_cg;
     option.auto_bin_max=1024;
     coverpoint result;
  endgroup

  function new(string name="", uvm_component parent=null);
    super.new(name,parent);
    alu_out_transaction_cg=new;
    alu_out_transaction_cg.set_inst_name($sformatf("alu_out_transaction_cg_%s",get_full_name()));
 endfunction

  virtual function void write (T t);
    `uvm_info("Coverage","Received transaction",UVM_HIGH);
    result = t.result;
    alu_out_transaction_cg.sample();
  endfunction

endclass
