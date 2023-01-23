//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This sequences randomizes the alu_in transaction and sends it 
// to the UVM driver.
//
// This sequence constructs and randomizes a alu_in_transaction.
// 
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class alu_in_and_sequence #(
      int ALU_IN_OP_WIDTH = 8
      )
  extends alu_in_random_sequence #(
      .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)
      );

  `uvm_object_param_utils( alu_in_and_sequence #(
                           ALU_IN_OP_WIDTH
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
      req=alu_in_transaction#(
                .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)
                )::type_id::create("req");
      start_item(req);
      // Randomize the transaction
      if(!req.randomize() with { op == and_op; }) `uvm_fatal("SEQ", "alu_in_and_sequence::body()-alu_in_transaction randomization failed")
      // Send the transaction to the alu_in_driver_bfm via the sequencer and alu_in_driver.
      finish_item(req);
      `uvm_info("SEQ", {"Response:",req.convert2string()},UVM_MEDIUM)
    end

  endtask

endclass
