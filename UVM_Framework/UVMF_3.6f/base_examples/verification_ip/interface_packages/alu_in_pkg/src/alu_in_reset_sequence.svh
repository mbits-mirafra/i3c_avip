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
// Project         : ALU_IN interface agent
// Unit            : Sequence library
// File            : alu_in_reset_sequence.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This sequence generates a sequence on the alu bus.
//
// ****************************************************************************
class alu_in_reset_sequence extends alu_in_sequence_base;

  // declaration macros
  `uvm_object_utils(alu_in_reset_sequence)

  // variables
  alu_in_transaction req;
  alu_in_transaction rsp;

//*****************************************************************
  function new(string name = "");
    super.new(name);
  endfunction: new

//*****************************************************************
  task body();

    begin
      req=alu_in_transaction::type_id::create("req");
      req.op = rst_op;

      start_item(req);
      finish_item(req);
    end

  endtask: body

endclass: alu_in_reset_sequence
