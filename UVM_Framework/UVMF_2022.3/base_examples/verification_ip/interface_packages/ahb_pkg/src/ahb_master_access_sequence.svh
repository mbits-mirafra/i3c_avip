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
// Unit            : Sequence library
// File            : ahb_master_access_sequence.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This file contains the sequence used by an ahb master
//    for read and write operations.
//
//----------------------------------------------------------------------
class ahb_master_access_sequence extends ahb_sequence_base;

  // declaration macros
  `uvm_object_utils(ahb_master_access_sequence)

  // variables
  ahb_transaction req;
  bit[31:0] req_addr;
  bit[15:0] req_data;
  ahb_op_t  req_op;

//*****************************************************************
  function new(string name = "");
    super.new(name);
  endfunction: new

//*****************************************************************
  task read(input bit [31:0] read_addr, output bit [15:0] read_data,
            input uvm_sequencer #(ahb_transaction) seqr, input uvm_sequence_base parent = null);
    this.req_addr = read_addr;
    this.req_op   = AHB_READ;
    this.start(seqr, parent);
    read_data = req.data;
    `uvm_info("SEQ",{"Read:",req.convert2string()},UVM_MEDIUM)
  endtask : read

//*****************************************************************
  task write(input bit [31:0] write_addr, input bit [15:0] write_data,
            input uvm_sequencer #(ahb_transaction) seqr, input uvm_sequence_base parent = null);
    this.req_addr = write_addr;
    this.req_data = write_data;
    this.req_op   = AHB_WRITE;
    this.start(seqr, parent);
    `uvm_info("SEQ",{"Write:",req.convert2string()},UVM_MEDIUM)
  endtask : write

//*****************************************************************
  task body();

       req=ahb_transaction::type_id::create("req");
       req.op   = req_op;
       req.addr = req_addr;
       req.data = req_data;
       start_item(req);
       finish_item(req);

  endtask: body

endclass: ahb_master_access_sequence
