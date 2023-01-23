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
// File            : wb_sequence_base.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This file contains wb base sequence for all wb 
//    sequences.
//
//----------------------------------------------------------------------
//
class wb_sequence_base #(type REQ=wb_transaction, type RSP=REQ) extends uvmf_sequence_base #( REQ, RSP );

  // variables  
  wb_transaction req, req_a;    
  wb_transaction rsp;    

//*****************************************************************
  function new(string name = "");
    super.new(name);
  endfunction: new

endclass: wb_sequence_base
