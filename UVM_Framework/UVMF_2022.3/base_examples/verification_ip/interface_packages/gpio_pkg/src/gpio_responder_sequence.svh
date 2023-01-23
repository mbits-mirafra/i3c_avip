//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class can be used to provide stimulus when an interface
//              has been configured to run in a responder mode. It
//              will never finish by default, always going back to the driver
//              and driver BFM for the next transaction with which to respond.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class gpio_responder_sequence #(
      int READ_PORT_WIDTH = 4,
      int WRITE_PORT_WIDTH = 4
      )
  extends gpio_sequence_base #(
      .READ_PORT_WIDTH(READ_PORT_WIDTH),
      .WRITE_PORT_WIDTH(WRITE_PORT_WIDTH)
      );

  `uvm_object_param_utils( gpio_responder_sequence #(
                           READ_PORT_WIDTH,
                           WRITE_PORT_WIDTH
                           ))

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end

  function new(string name = "gpio_responder_sequence");
    super.new(name);
  endfunction

  task body();
    req=gpio_transaction#(
                .READ_PORT_WIDTH(READ_PORT_WIDTH),
                .WRITE_PORT_WIDTH(WRITE_PORT_WIDTH)
                )::type_id::create("req");
    forever begin
      start_item(req);
      finish_item(req);
      // pragma uvmf custom body begin
      // UVMF_CHANGE_ME : Do something here with the resulting req item.  The
      // finish_item() call above will block until the req transaction is ready
      // to be handled by the responder sequence.
      // If this was an item that required a response, the expectation is
      // that the response should be populated within this transaction now.
      `uvm_info("SEQ",$sformatf("Processed txn: %s",req.convert2string()),UVM_HIGH)
      // pragma uvmf custom body end
    end
  endtask

endclass
