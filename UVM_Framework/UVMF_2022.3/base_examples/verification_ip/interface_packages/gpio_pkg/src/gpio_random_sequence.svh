//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This sequences randomizes the gpio transaction and sends it 
// to the UVM driver.
//
// This sequence constructs and randomizes a gpio_transaction.
// 
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class gpio_random_sequence #(
      int READ_PORT_WIDTH = 4,
      int WRITE_PORT_WIDTH = 4
      )
  extends gpio_sequence_base #(
      .READ_PORT_WIDTH(READ_PORT_WIDTH),
      .WRITE_PORT_WIDTH(WRITE_PORT_WIDTH)
      );

  `uvm_object_param_utils( gpio_random_sequence #(
                           READ_PORT_WIDTH,
                           WRITE_PORT_WIDTH
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
      req=gpio_transaction#(
                .READ_PORT_WIDTH(READ_PORT_WIDTH),
                .WRITE_PORT_WIDTH(WRITE_PORT_WIDTH)
                )::type_id::create("req");
      start_item(req);
      // Randomize the transaction
      if(!req.randomize()) `uvm_fatal("SEQ", "gpio_random_sequence::body()-gpio_transaction randomization failed")
      // Send the transaction to the gpio_driver_bfm via the sequencer and gpio_driver.
      finish_item(req);
      `uvm_info("SEQ", {"Response:",req.convert2string()},UVM_MEDIUM)
    end

  endtask

endclass: gpio_random_sequence
