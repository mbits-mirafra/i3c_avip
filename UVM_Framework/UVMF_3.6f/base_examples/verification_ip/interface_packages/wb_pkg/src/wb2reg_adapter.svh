//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : jcraft
// Creation Date   : 2016 Nov 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : wb interface agent
// Unit            : Interface Register Adapter
// File            : wb2reg_adapter.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This file contains the UVM register adapter for the wb interface.
//
// ****************************************************************************
// ****************************************************************************
class wb2reg_adapter       #(
      int WB_ADDR_WIDTH = 32,                                
      int WB_DATA_WIDTH = 16                                
      ) extends uvm_reg_adapter;
  
  `uvm_object_param_utils( wb2reg_adapter #(
                           WB_ADDR_WIDTH,
                           WB_DATA_WIDTH
                         ))

  
  //--------------------------------------------------------------------
  // new
  //--------------------------------------------------------------------
  function new (string name = "wb2reg_adapter" );
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

    wb_transaction #(
                    .WB_ADDR_WIDTH(WB_ADDR_WIDTH),                                
                    .WB_DATA_WIDTH(WB_DATA_WIDTH)                                
                    )  trans_h = wb_transaction #(
                             .WB_ADDR_WIDTH(WB_ADDR_WIDTH),                                
                             .WB_DATA_WIDTH(WB_DATA_WIDTH)                                
                             ) ::type_id::create("trans_h");
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
    wb_transaction #(
                    .WB_ADDR_WIDTH(WB_ADDR_WIDTH),                                
                    .WB_DATA_WIDTH(WB_DATA_WIDTH)                                
                    )  trans_h;
    if (!$cast(trans_h, bus_item)) begin
      `uvm_fatal("NOT_BUS_TYPE","Provided bus_item is not of the correct type")
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

endclass : wb2reg_adapter
//----------------------------------------------------------------------
//
