//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU_out interface agent
// Unit            : Interface Register Adapter
// File            : FPU_out2reg_adapter.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This file contains the UVM register adapter for the FPU_out interface.
//
// ****************************************************************************
// ****************************************************************************
class FPU_out2reg_adapter extends uvm_reg_adapter;
  
  `uvm_object_utils(FPU_out2reg_adapter)

  
  //--------------------------------------------------------------------
  // new
  //--------------------------------------------------------------------
  function new (string name = "FPU_out2reg_adapter" );
    super.new(name);
    // UVMF_CHANGE_ME : Fill in the bus2reg adapter mapping protocol fields to register fields.

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

    FPU_out_transaction trans_h = FPU_out_transaction::type_id::create("trans_h");
    
    // UVMF_CHANGE_ME : Fill in the reg2bus adapter mapping registe fields to protocol fields.

    //Adapt the following for your sequence item type
    // trans_h.op = (rw.kind == UVM_READ) ? WB_READ : WB_WRITE;
    //Copy over address
    // trans_h.addr = rw.addr;
    //Copy over write data
    // trans_h.data = rw.data;

    // Return the adapted transaction
    return trans_h;

  endfunction: reg2bus

  //--------------------------------------------------------------------
  // bus2reg
  //--------------------------------------------------------------------
  virtual function void bus2reg(uvm_sequence_item bus_item,
                                ref uvm_reg_bus_op rw);
    FPU_out_transaction trans_h;
    if (!$cast(trans_h, bus_item)) begin
      `uvm_fatal("ADAPT","Provided bus_item is not of the correct type")
      return;
    end
    //Adapt the following for your sequence item type
    //Copy over instruction type 
    // rw.kind = (trans_h.op == WB_WRITE) ? UVM_WRITE : UVM_READ;
    //Copy over address
    // rw.addr = trans_h.addr;
    //Copy over read data
    // rw.data = trans_h.data;
    //Check for errors on the bus and return UVM_NOT_OK if there is an error
    // rw.status = UVM_IS_OK;

  endfunction: bus2reg

endclass : FPU_out2reg_adapter
//----------------------------------------------------------------------
//
