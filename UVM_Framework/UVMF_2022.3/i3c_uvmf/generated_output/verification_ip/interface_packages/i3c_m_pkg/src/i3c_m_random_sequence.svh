//----------------------------------------------------------------------
// Created with uvmf_gen version 2022.3
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This sequences randomizes the i3c_m transaction and sends it 
// to the UVM driver.
//
// This sequence constructs and randomizes a i3c_m_transaction.
// 
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class i3c_m_random_sequence 
  extends i3c_m_sequence_base ;

  `uvm_object_utils( i3c_m_random_sequence )

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
      req=i3c_m_transaction::type_id::create("req");
      start_item(req);
      // Randomize the transaction
      if(!req.randomize()) `uvm_fatal("SEQ", "i3c_m_random_sequence::body()-i3c_m_transaction randomization failed")
      // Send the transaction to the i3c_m_driver_bfm via the sequencer and i3c_m_driver.
      finish_item(req);
      `uvm_info("SEQ", {"Response:",req.convert2string()},UVM_MEDIUM)

  endtask

endclass: i3c_m_random_sequence

// pragma uvmf custom external begin
// pragma uvmf custom external end

