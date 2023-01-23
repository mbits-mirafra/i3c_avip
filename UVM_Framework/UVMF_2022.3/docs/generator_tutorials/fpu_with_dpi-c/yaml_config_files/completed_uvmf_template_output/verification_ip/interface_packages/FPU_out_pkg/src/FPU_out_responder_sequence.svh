//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU_out responder sequence
// Unit            : Interface UVM Responder
// File            : FPU_out_responder_sequence.svh
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
class FPU_out_responder_sequence extends FPU_out_sequence_base ;

  `uvm_object_utils(FPU_out_responder_sequence)

  function new(string name = "FPU_out_responder_sequence");
    super.new(name);
  endfunction

  task body();
    req=FPU_out_transaction::type_id::create("req");
    forever begin
      start_item(req);
      finish_item(req);
      // UVMF_CHANGE_ME : Do something here with the resulting req item.  The
      // finish_item() call above will block until the req transaction is ready
      // to be handled by the responder sequence.
      // If this was an item that required a response, the expectation is
      // that the response should be populated within this transaction now.
      `uvm_info("SEQ",$sformatf("Processed txn: %s",req.convert2string()),UVM_HIGH)
    end
  endtask

endclass
