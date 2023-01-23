//----------------------------------------------------------------------
// Created with uvmf_gen version 2021.1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This sequences randomizes the ccs transaction and sends it 
// to the UVM driver.
//
// This sequence constructs and randomizes a ccs_transaction.
// 
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class ccs_random_sequence #(
      int WIDTH = 32
      )
  extends ccs_sequence_base #(
      .WIDTH(WIDTH)
      );

  `uvm_object_param_utils( ccs_random_sequence #(
                           WIDTH
                           ))

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end
  
  //*****************************************************************
  function new(string name = "");
    super.new(name);
  endfunction: new

  // ****************************************************************************
  // TASK : body()
  // This task is automatically executed when this sequence is started using the 
  // start(sequencerHandle) task.
  //
  task body();
  
      // Construct the transaction
      req=ccs_transaction#(
                .WIDTH(WIDTH)
                )::type_id::create("req");
      start_item(req);
      // Randomize the transaction
      if(!req.randomize()) `uvm_fatal("SEQ", "ccs_random_sequence::body()-ccs_transaction randomization failed")
      // Send the transaction to the ccs_driver_bfm via the sequencer and ccs_driver.
      finish_item(req);
      `uvm_info("SEQ", {"Response:",req.convert2string()},UVM_MEDIUM)

  endtask

endclass: ccs_random_sequence
