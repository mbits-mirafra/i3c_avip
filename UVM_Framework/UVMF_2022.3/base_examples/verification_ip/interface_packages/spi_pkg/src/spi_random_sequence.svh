//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This sequences randomizes the spi transaction and sends it 
// to the UVM driver.
//
// This sequence constructs and randomizes a spi_transaction.
// 
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class spi_random_sequence 
  extends spi_sequence_base ;

  `uvm_object_utils( spi_random_sequence )

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
      req=spi_transaction::type_id::create("req");
      start_item(req);
      // Randomize the transaction
      if(!req.randomize()) `uvm_fatal("SEQ", "spi_random_sequence::body()-spi_transaction randomization failed")
      // Send the transaction to the spi_driver_bfm via the sequencer and spi_driver.
      finish_item(req);
      `uvm_info("SEQ", {"Response:",req.convert2string()},UVM_MEDIUM)
    end

  endtask

endclass: spi_random_sequence
