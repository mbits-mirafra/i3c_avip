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
// Project         : vip_axi4
// Unit            : Sequence base
// File            : vip_axi4_env_sequence_base.svh
//----------------------------------------------------------------------
// Creation Date   : 02.24.2015
//----------------------------------------------------------------------
// Description: All environment level sequences are extended from this 
// sequence base.
//
class vip_axi4_env_sequence_base #(type REQ = uvmf_transaction_base, 
                                            type RSP = uvmf_transaction_base) 
                                            extends uvmf_sequence_base #(REQ, RSP );

  function new( string name ="");
    super.new( name );
  endfunction

endclass
