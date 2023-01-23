//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : shwetapatil
// Creation Date   : 2022 Jun 06
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : apb_if responder sequence
// Unit            : Interface UVM Responder
// File            : apb_if_responder_sequence.svh
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
class apb_if_responder_sequence  #(
      int DATA_WIDTH = 32,      int ADDR_WIDTH = 32     )
extends apb_if_sequence_base  #(
          .DATA_WIDTH(DATA_WIDTH),          .ADDR_WIDTH(ADDR_WIDTH)       ) ;

  `uvm_object_param_utils( apb_if_responder_sequence #(    DATA_WIDTH,      ADDR_WIDTH          ))

  function new(string name = "apb_if_responder_sequence");
    super.new(name);
  endfunction

  task body();
    req=apb_if_transaction #(      .DATA_WIDTH(DATA_WIDTH),         .ADDR_WIDTH(ADDR_WIDTH)            ) ::type_id::create("req");
    forever begin
      start_item(req);
      finish_item(req);
      // UVMF_CHANGE_ME : Do something here with the resulting req item.  The
      // finish_item() call above will block until the req transaction is ready
      // to be handled by the responder sequence.
      // If this was an item that required a response, the expectation is
      // that the response should be populated within this transaction now.
      `uvm_info("RESPSEQ",$sformatf("Processed txn: %s",req.convert2string()),UVM_HIGH)
    end
  endtask

endclass
