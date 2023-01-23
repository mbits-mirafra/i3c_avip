//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : shwetapatil
// Creation Date   : 2022 Jun 06
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : apb_if interface agent
// Unit            : Interface random sequence
// File            : apb_if_random_sequence.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This sequences randomizes the apb_if transaction and sends it 
// to the UVM driver.
//
// ****************************************************************************
// This sequence constructs and randomizes a apb_if_transaction.
// 
class apb_if_random_sequence  #(
      int DATA_WIDTH = 32,                                
      int ADDR_WIDTH = 32                                
      )
extends apb_if_sequence_base  #(
                             .DATA_WIDTH(DATA_WIDTH),                                
                             .ADDR_WIDTH(ADDR_WIDTH)                                
                             ) ;

  `uvm_object_param_utils( apb_if_random_sequence #(
                           DATA_WIDTH,
                           ADDR_WIDTH
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
      req=apb_if_transaction #( 
                .DATA_WIDTH(DATA_WIDTH),                                
                .ADDR_WIDTH(ADDR_WIDTH)                                
               ) ::type_id::create("req");

      start_item(req);
      // Randomize the transaction
      if(!req.randomize()) `uvm_fatal("RANDOMIZE_FAILURE", "apb_if_random_sequence::body()-apb_if_transaction")
      // Send the transaction to the apb_if_driver_bfm via the sequencer and apb_if_driver.
      finish_item(req);
      `uvm_info("random_seq response from driver", req.convert2string(),UVM_MEDIUM)
    end

  endtask: body

endclass: apb_if_random_sequence
//----------------------------------------------------------------------
//
