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
// File            : ahb_random_sequence.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This file contains ahb sequence used 
//    They are utility level sequences that can be used to generate
//    a random ahb sequence.
//
//----------------------------------------------------------------------
class ahb_random_sequence extends ahb_sequence_base;

  // declaration macros
  `uvm_object_utils(ahb_random_sequence)

  // variables
  ahb_transaction req;
  ahb_transaction rsp;

//*****************************************************************
  function new(string name = "");
    super.new(name);
  endfunction: new

//*****************************************************************
  task body();

    begin
      req=ahb_transaction::type_id::create("req");
      if(!req.randomize() with {op != AHB_RESET;}) `uvm_fatal("RANDOMIZE_FAILURE", "ahb_random_sequence::body()-ahb_transaction")
      start_item(req);
      finish_item(req);
    end

  endtask: body

endclass: ahb_random_sequence
