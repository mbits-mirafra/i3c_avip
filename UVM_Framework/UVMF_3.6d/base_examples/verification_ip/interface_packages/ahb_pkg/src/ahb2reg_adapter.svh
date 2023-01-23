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
// Project         : wb interface agent
// Unit            : UVM register package adapter
// File            : ahb2reg_adapter.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This class performs the following tranlations:
//
//    reg2bus: UVM register package transaction to wb transaction.
//    bus2reg: wb transaction to UVM register package transaction.
//
//----------------------------------------------------------------------
//
class ahb2reg_adapter extends uvm_reg_adapter;
  
  // factory registration macro
  `uvm_object_utils(ahb2reg_adapter)

  
  //--------------------------------------------------------------------
  // new
  //--------------------------------------------------------------------
  function new (string name = "ahb2reg_adapter" );
    super.new(name);
    
    // Does the protocol the Agent is modeling support byte enables?
    // 0 = NO
    // 1 = YES
    supports_byte_enable = 0;

    // Does the Agent's Driver provide separate response sequence items?
    // i.e. Does the driver call seq_item_port.put() 
    // and do the sequences call get_response()?
    // 0 = NO
    // 1 = YES
    provides_responses = 0;

  endfunction: new

  //--------------------------------------------------------------------
  // reg2bus
  //--------------------------------------------------------------------
  virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);

    ahb_transaction trans_h = ahb_transaction::type_id::create("trans_h");
    //Adapt the following for your sequence item type
    //Copy over instruction type 
    trans_h.op = (rw.kind == UVM_READ) ? AHB_READ : AHB_WRITE;
    //Copy over address
    trans_h.addr = rw.addr;
    //Copy over write data
    trans_h.data = rw.data;
    return trans_h;

  endfunction: reg2bus

  //--------------------------------------------------------------------
  // bus2reg
  //--------------------------------------------------------------------
  virtual function void bus2reg(uvm_sequence_item bus_item,
                                ref uvm_reg_bus_op rw);
    ahb_transaction trans_h;
    if (!$cast(trans_h, bus_item)) begin
      `uvm_fatal("NOT_BUS_TYPE","Provided bus_item is not of the correct type")
      return;
    end
    //Adapt the following for your sequence item type
    //Copy over instruction type 
    rw.kind = (trans_h.op == AHB_WRITE) ? UVM_WRITE : UVM_READ;
    //Copy over address
    rw.addr = trans_h.addr;
    //Copy over read data
    rw.data = trans_h.data;
    //Check for errors on the bus and return UVM_NOT_OK if there is an error
    rw.status = UVM_IS_OK;

  endfunction: bus2reg

endclass : ahb2reg_adapter
