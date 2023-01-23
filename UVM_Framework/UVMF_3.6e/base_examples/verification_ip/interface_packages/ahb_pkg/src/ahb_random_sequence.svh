//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 15
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb interface agent
// Unit            : Interface random sequence
// File            : ahb_random_sequence.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This sequences randomizes the ahb transaction and sends it 
// to the UVM driver.
//
// ****************************************************************************
// This sequence constructs and randomizes a ahb_transaction.
// 
class ahb_random_sequence extends ahb_sequence_base;

  // declaration macros
  `uvm_object_utils(ahb_random_sequence)

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
      if(!req.randomize()) `uvm_fatal("RANDOMIZE_FAILURE", "ahb_random_sequence::body()-ahb_transaction")
      // Send the transaction to the ahb_driver_bfm via the sequencer and ahb_driver.
      finish_item(req);
    end

  endtask: body

endclass: ahb_random_sequence
//----------------------------------------------------------------------
//
