//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU_in interface agent
// Unit            : Interface random sequence
// File            : FPU_in_random_sequence.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This sequences randomizes the FPU_in transaction and sends it 
// to the UVM driver.
//
// ****************************************************************************
// This sequence constructs and randomizes a FPU_in_transaction.
// 
class FPU_in_random_sequence  #(
      int FP_WIDTH = 32                                
      )
extends FPU_in_sequence_base  #(
                             .FP_WIDTH(FP_WIDTH)                                
                             ) ;

  `uvm_object_param_utils( FPU_in_random_sequence #(
                           FP_WIDTH
                            ))

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
      req=FPU_in_transaction #( 
                .FP_WIDTH(FP_WIDTH)                                
               ) ::type_id::create("req");

      start_item(req);
      // Randomize the transaction
      if(!req.randomize()) `uvm_fatal("SEQ", "FPU_in_random_sequence::body()-FPU_in_transaction randomization failed")
      // Send the transaction to the FPU_in_driver_bfm via the sequencer and FPU_in_driver.
      finish_item(req);
      `uvm_info("SEQ", {"Response:",req.convert2string()},UVM_MEDIUM)
    end

  endtask: body

endclass: FPU_in_random_sequence
//----------------------------------------------------------------------
//
