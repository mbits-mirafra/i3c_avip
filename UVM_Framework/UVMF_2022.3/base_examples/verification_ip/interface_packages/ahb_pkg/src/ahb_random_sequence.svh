//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This sequences randomizes the ahb transaction and sends it 
// to the UVM driver.
//
// This sequence constructs and randomizes a ahb_transaction.
// 
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class ahb_random_sequence 
  extends ahb_sequence_base ;

  `uvm_object_utils( ahb_random_sequence )

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
    begin
      // Construct the transaction
      req=ahb_transaction::type_id::create("req");
      start_item(req);
      // Randomize the transaction
      if(!req.randomize()) `uvm_fatal("SEQ", "ahb_random_sequence::body()-ahb_transaction randomization failed")
      // Send the transaction to the ahb_driver_bfm via the sequencer and ahb_driver.
      finish_item(req);
      `uvm_info("SEQ", {"Response:",req.convert2string()},UVM_MEDIUM)
    end

  endtask

endclass: ahb_random_sequence
