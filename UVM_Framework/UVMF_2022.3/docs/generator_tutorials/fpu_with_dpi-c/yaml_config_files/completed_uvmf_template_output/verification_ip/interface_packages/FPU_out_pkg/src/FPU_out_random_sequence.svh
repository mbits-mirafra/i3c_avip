//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU_out interface agent
// Unit            : Interface random sequence
// File            : FPU_out_random_sequence.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This sequences randomizes the FPU_out transaction and sends it 
// to the UVM driver.
//
// ****************************************************************************
// This sequence constructs and randomizes a FPU_out_transaction.
// 
class FPU_out_random_sequence extends FPU_out_sequence_base ;

  `uvm_object_utils(FPU_out_random_sequence)

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
      req=FPU_out_transaction::type_id::create("req");

      start_item(req);
      // Randomize the transaction
      if(!req.randomize()) `uvm_fatal("SEQ", "FPU_out_random_sequence::body()-FPU_out_transaction randomization failed")
      // Send the transaction to the FPU_out_driver_bfm via the sequencer and FPU_out_driver.
      finish_item(req);
      `uvm_info("SEQ", {"Response:",req.convert2string()},UVM_MEDIUM)
    end

  endtask: body

endclass: FPU_out_random_sequence
//----------------------------------------------------------------------
//
