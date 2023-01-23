//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : jcraft
// Creation Date   : 2016 Nov 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : wb responder sequence
// Unit            : Interface UVM Responder
// File            : wb_responder_sequence.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class can be used to provide stimulus when an interface
//              has been configured to run in a responder mode. It
//              will never finish by default, always going back to the driver
//              and driver BFM for the next transaction with which to respond.
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
class wb_memory_slave_sequence #(
      int WB_ADDR_WIDTH = 32,      int WB_DATA_WIDTH = 16     )
extends wb_sequence_base  #(
          .WB_ADDR_WIDTH(WB_ADDR_WIDTH),          .WB_DATA_WIDTH(WB_DATA_WIDTH)       ) ;

  `uvm_object_param_utils( wb_memory_slave_sequence #(    WB_ADDR_WIDTH,      WB_DATA_WIDTH          ))

  bit [WB_DATA_WIDTH-1:0] mem[bit[WB_ADDR_WIDTH-1:0]];

  function new(string name = "wb_memory_slave_sequence");
    super.new(name);
  endfunction

  task body();
    req=wb_transaction #(      .WB_ADDR_WIDTH(WB_ADDR_WIDTH),         .WB_DATA_WIDTH(WB_DATA_WIDTH)            ) ::type_id::create("req");
    forever begin
      start_item(req);
      finish_item(req);
      if (req.op == WB_READ) begin
        if (mem.exists(req.addr)) req.data = mem[req.addr];
        else req.data = ~req.addr;
      end else begin
        mem[req.addr] = req.data;
      end
      `uvm_info("SEQ",$sformatf("Processed txn: %s",req.convert2string()),UVM_HIGH)
    end
  endtask

endclass
