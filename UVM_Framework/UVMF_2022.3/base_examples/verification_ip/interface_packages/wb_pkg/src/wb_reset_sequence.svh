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
// File            : wb_reset_sequence.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This file contains wb sequence used to generate a reset
//    on the wb bus.
//
//----------------------------------------------------------------------
//
class wb_reset_sequence #(int WB_ADDR_WIDTH = 32, int WB_DATA_WIDTH = 16 ) extends wb_sequence_base #(
                             .WB_ADDR_WIDTH(WB_ADDR_WIDTH),                                
                             .WB_DATA_WIDTH(WB_DATA_WIDTH) );

  // declaration macros
  `uvm_object_param_utils( wb_reset_sequence #(
                             .WB_ADDR_WIDTH(WB_ADDR_WIDTH),                                
                             .WB_DATA_WIDTH(WB_DATA_WIDTH) ))

  typedef wb_transaction#(
                             .WB_ADDR_WIDTH(WB_ADDR_WIDTH),                                
                             .WB_DATA_WIDTH(WB_DATA_WIDTH) ) wb_trans_t;

//*****************************************************************
  function new(string name = "");
    super.new(name);
  endfunction: new

//*****************************************************************
  task body();

    begin
      assert($cast(req, create_item(wb_trans_t::get_type(), m_sequencer, "req")));
      start_item(req);
      req.op = WB_RESET;
      `uvm_info("SEQ",{"Sending transaction ",req.convert2string()}, UVM_MEDIUM);
      finish_item(req);
    end

  endtask: body

endclass: wb_reset_sequence
