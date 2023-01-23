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
class wb_slave_access_sequence #(
      int WB_ADDR_WIDTH = 32,      int WB_DATA_WIDTH = 16     )
extends wb_sequence_base  #(
          .WB_ADDR_WIDTH(WB_ADDR_WIDTH),          .WB_DATA_WIDTH(WB_DATA_WIDTH)       ) ;

  `uvm_object_param_utils( wb_slave_access_sequence #(    WB_ADDR_WIDTH,      WB_DATA_WIDTH          ))

  function new(string name = "wb_memory_slave_sequence");
    super.new(name);
  endfunction

  task body();
    req=wb_transaction #(      .WB_ADDR_WIDTH(WB_ADDR_WIDTH),         .WB_DATA_WIDTH(WB_DATA_WIDTH)            ) ::type_id::create("req");
    // This loop will reuse the transaction object created above for as long as the simulation is
    // running.  The first call to start_item() and finish_item() is a "dummy" transaction. The
    // finish_item() call will block in the driver BFM until a valid transaction is seen at which
    // point this will unblock, allowing the sequence to act on the resulting information. In the event
    // of a read, we return the inverted address seen. This response is passed back into the driver
    // on the next pass into start_item()/finish_item() which will also block again waiting for the
    // next transaction.
    forever begin
      start_item(req);
      finish_item(req);
      if (req.op == WB_READ) begin
        req.data = ~req.addr;
      end
      `uvm_info("SEQ",$sformatf("Processed txn: %s",req.convert2string()),UVM_HIGH)
    end
  endtask

endclass
