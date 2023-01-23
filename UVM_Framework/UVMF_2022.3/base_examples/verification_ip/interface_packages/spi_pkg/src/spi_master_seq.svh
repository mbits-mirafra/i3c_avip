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
// Project         : spi interface agent
// Unit            : Sequence library
// File            : spi_master_seq.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This file contains the sequence used for master 
//    operations on the spi bus.
//
//----------------------------------------------------------------------
//
class spi_master_seq extends spi_sequence_base;

  `uvm_object_utils( spi_master_seq )

  REQ mosi_transaction;
  RSP miso_transaction;

  function new(string name = "" );
     super.new( name );
     mosi_transaction=spi_transaction::type_id::create("mosi_transaction");
  endfunction
  
  function void set_mosi(bit [7:0] data);
        mosi_transaction.mosi_data = data;
  endfunction
  
  function bit [7:0] get_miso();
        return miso_transaction.miso_data;
  endfunction
  
  function string convert2string();
     return ({"MOSI:",mosi_transaction.convert2string(),"MISO:",miso_transaction.convert2string()});
  endfunction

  virtual task body();
     start_item(mosi_transaction);
     finish_item(mosi_transaction);
     //get_response(miso_transaction);
  endtask

endclass
