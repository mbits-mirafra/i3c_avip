//----------------------------------------------------------------------
// Created with uvmf_gen version 2022.3
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This sequences randomizes the nand_out transaction and sends it 
// to the UVM driver.
//
// This sequence constructs and randomizes a nand_out_transaction.
// 
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class nand_out_random_sequence 
  extends nand_out_sequence_base ;

  `uvm_object_utils( nand_out_random_sequence )

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
      req=nand_out_transaction::type_id::create("req");
      start_item(req);
      // Randomize the transaction
      if(!req.randomize()) `uvm_fatal("SEQ", "nand_out_random_sequence::body()-nand_out_transaction randomization failed")
      // Send the transaction to the nand_out_driver_bfm via the sequencer and nand_out_driver.
      finish_item(req);
      `uvm_info("SEQ", {"Response:",req.convert2string()},UVM_MEDIUM)

  endtask

endclass: nand_out_random_sequence

// pragma uvmf custom external begin
// pragma uvmf custom external end

