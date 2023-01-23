//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This sequences randomizes the wb transaction and sends it 
// to the UVM driver.
//
// This sequence constructs and randomizes a wb_transaction.
// 
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class wb_random_sequence #(
      int WB_ADDR_WIDTH = 32,
      int WB_DATA_WIDTH = 16
      )
  extends wb_sequence_base #(
      .WB_ADDR_WIDTH(WB_ADDR_WIDTH),
      .WB_DATA_WIDTH(WB_DATA_WIDTH)
      );

  `uvm_object_param_utils( wb_random_sequence #(
                           WB_ADDR_WIDTH,
                           WB_DATA_WIDTH
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
    begin
      // Construct the transaction
      req=wb_transaction#(
                .WB_ADDR_WIDTH(WB_ADDR_WIDTH),
                .WB_DATA_WIDTH(WB_DATA_WIDTH)
                )::type_id::create("req");
      start_item(req);
      // Randomize the transaction
      if(!req.randomize()) `uvm_fatal("SEQ", "wb_random_sequence::body()-wb_transaction randomization failed")
      // Send the transaction to the wb_driver_bfm via the sequencer and wb_driver.
      finish_item(req);
      `uvm_info("SEQ", {"Response:",req.convert2string()},UVM_MEDIUM)
    end

  endtask

endclass: wb_random_sequence
