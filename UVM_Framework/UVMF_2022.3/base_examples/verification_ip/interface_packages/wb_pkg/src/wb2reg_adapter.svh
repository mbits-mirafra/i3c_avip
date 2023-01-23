//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This file contains the UVM register adapter for the wb interface.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class wb2reg_adapter #(
      int WB_ADDR_WIDTH = 32,
      int WB_DATA_WIDTH = 16
      ) extends uvm_reg_adapter;

  `uvm_object_param_utils( wb2reg_adapter #(
                           WB_ADDR_WIDTH,
                           WB_DATA_WIDTH
                           ))
  
  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end

  //--------------------------------------------------------------------
  // new
  //--------------------------------------------------------------------
  function new (string name = "wb2reg_adapter" );
    super.new(name);
    // pragma uvmf custom new begin
    // UVMF_CHANGE_ME : Configure the adapter regarding byte enables and provides response.

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





    // pragma uvmf custom new end

  endfunction: new

  //--------------------------------------------------------------------
  // reg2bus
  //--------------------------------------------------------------------
  virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);

    wb_transaction #(
                    .WB_ADDR_WIDTH(WB_ADDR_WIDTH),
                    .WB_DATA_WIDTH(WB_DATA_WIDTH)
                    ) trans_h = wb_transaction #(
                             .WB_ADDR_WIDTH(WB_ADDR_WIDTH),
                             .WB_DATA_WIDTH(WB_DATA_WIDTH)
                             )::type_id::create("trans_h");
    
    // pragma uvmf custom reg2bus begin
    //Adapt the following for your sequence item type
    trans_h.op = (rw.kind == UVM_READ) ? WB_READ : WB_WRITE;
    //Copy over address
    trans_h.addr = rw.addr;
    //Copy over write data
    trans_h.data = rw.data;
    // pragma uvmf custom reg2bus end
    
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
        ) trans_h;
    if (!$cast(trans_h, bus_item)) begin
      `uvm_fatal("ADAPT","Provided bus_item is not of the correct type")
      return;
    end
    // pragma uvmf custom bus2reg begin
    //Adapt the following for your sequence item type
    //Copy over instruction type 
    rw.kind = (trans_h.op == WB_WRITE) ? UVM_WRITE : UVM_READ;
    //Copy over address
    rw.addr = trans_h.addr;
    //Copy over read data
    rw.data = trans_h.data;
    //Check for errors on the bus and return UVM_NOT_OK if there is an error
    rw.status = UVM_IS_OK;
    // pragma uvmf custom bus2reg end

  endfunction: bus2reg

endclass : wb2reg_adapter
