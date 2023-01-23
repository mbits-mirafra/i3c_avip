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
// Unit            : Sequence library
// File            : wb_master_access_sequence.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This file contains the sequence used to initiate master
//    access on the wb bus.
//
//----------------------------------------------------------------------
//
class wb_master_access_sequence extends wb_sequence_base #(wb_transaction);

  // declaration macros
  `uvm_object_utils(wb_master_access_sequence)

  // variables  
  bit[WB_ADDR_WIDTH-1:0] req_addr;
  bit[WB_DATA_WIDTH-1:0] req_data;
  wb_op_t req_op;

//*****************************************************************
  function new(string name = "");
    super.new(name);
  endfunction: new

//*****************************************************************
  task read(input bit [WB_ADDR_WIDTH-1:0] addr, output bit [WB_DATA_WIDTH-1:0] read_data,
            input uvm_sequencer #(wb_transaction) seqr, input uvm_sequence_base parent = null);
    this.req_addr = addr;
    this.req_op   = WB_READ;
    this.start(seqr, parent);
    read_data = req.data;
  endtask : read


//*****************************************************************
  task write(input bit [WB_ADDR_WIDTH-1:0] addr, input bit [WB_DATA_WIDTH-1:0] write_data,
            input uvm_sequencer #(wb_transaction) seqr, input uvm_sequence_base parent = null);
    this.req_addr = addr;
    this.req_data = write_data;
    this.req_op   = WB_WRITE;
    this.start(seqr, parent);
  endtask : write

//*****************************************************************
  task body();

       req=wb_transaction::type_id::create("req");
     start_item(req);
       assert(req.randomize() with {
            op   == req_op;
            addr == req_addr;
            data == req_data;
            });
       `uvm_info("write_sequence",{"Sending transaction ",req.convert2string()}, UVM_MEDIUM)
       finish_item(req);

      `uvm_info("read_result",{"Sending transaction ",req.convert2string()}, UVM_MEDIUM)

  endtask: body


endclass: wb_master_access_sequence
