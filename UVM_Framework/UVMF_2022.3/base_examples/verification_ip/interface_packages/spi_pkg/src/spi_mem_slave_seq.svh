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
// File            : spi_mem_slave_seq.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This sequence is used to model a memory slave on the 
//    spi bus.
//
//----------------------------------------------------------------------
//
class spi_mem_slave_seq extends spi_sequence_base;

  `uvm_object_utils( spi_mem_slave_seq )

  spi_mem_slave_transaction req_transaction;
  // mem_slave_transaction rsp_transaction;

  bit [7:0] next_req;
  bit [3:0] mem [7:0];

  function new(string name = "" );
    super.new( name );
  endfunction

  virtual task body();
    forever  begin
      req_transaction=spi_mem_slave_transaction::type_id::create("req_transaction");
      req_transaction.dir = MISO;
      req_transaction.status = next_req[7];
      req_transaction.addr = next_req[6:4];
      req_transaction.data = next_req[3:0];
      req_transaction.pack_fields();
      start_item(req_transaction);
      finish_item(req_transaction);
      // get_response(rsp_transaction);
      if (req_transaction.mosi_data[7] == SPI_SLAVE_WRITE ) begin
         mem[req_transaction.mosi_data[6:4]]=req_transaction.mosi_data[3:0];
         next_req = {1'b1, req_transaction.mosi_data[6:0]};
         `uvm_info("SEQ",{"WRITE:",req_transaction.convert2string()},UVM_HIGH)
      end else begin // SPI_SLAVE_READ
         next_req = {1'b1, req_transaction.mosi_data[6:4], mem[req_transaction.mosi_data[6:4]]};
         `uvm_info("SEQ",{"READ:",req_transaction.convert2string()},UVM_HIGH)
      end
    end
  endtask

endclass
