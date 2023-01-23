//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : shwetapatil
// Creation Date   : 2022 Jun 06
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : apb_if interface agent
// Unit            : Interface Register Adapter
// File            : apb_if2reg_adapter.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This file contains the UVM register adapter for the apb_if interface.
//
// ****************************************************************************
// ****************************************************************************
class apb_if2reg_adapter       #(
      int DATA_WIDTH = 32,                                
      int ADDR_WIDTH = 32                                
      ) extends uvm_reg_adapter;
  
  `uvm_object_param_utils( apb_if2reg_adapter #(
                           DATA_WIDTH,
                           ADDR_WIDTH
                         ))

  
  //--------------------------------------------------------------------
  // new
  //--------------------------------------------------------------------
  function new (string name = "apb_if2reg_adapter" );
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

    apb_if_transaction #(
                    .DATA_WIDTH(DATA_WIDTH),                                
                    .ADDR_WIDTH(ADDR_WIDTH)                                
                    )  trans_h = apb_if_transaction #(
                             .DATA_WIDTH(DATA_WIDTH),                                
                             .ADDR_WIDTH(ADDR_WIDTH)                                
                             ) ::type_id::create("trans_h");
    
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
    apb_if_transaction #(
                    .DATA_WIDTH(DATA_WIDTH),                                
                    .ADDR_WIDTH(ADDR_WIDTH)                                
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

endclass : apb_if2reg_adapter
//----------------------------------------------------------------------
//
