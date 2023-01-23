class nand_in_fixed_sequence extends nand_in_sequence_base;

`uvm_object_param_utils( nand_in_fixed_sequence)

// pragma uvmf custom class_item_additional begin
// pragma uvmf custom class_item_additional end

//*****************************************************************
function new(string name = "nand_in_fixed_sequence");         
  super.new(name);
endfunction: new


// **************************************************************************     
// TASK : body()
// This task is automatically executed when this sequence is started using the 
// start(sequencerHandle) task.

task body();

  // Construct the transaction
  req=nand_in_transaction::type_id::create("req");
  start_item(req);
//req.a=1;
  //req.b=0;
//#1;
//req.a=0;
//req.b=0;
//#1;
//req.a=1;
//req.b=1;
//#1;
req.a=0;
req.b=1;
//#1;
  finish_item(req);
  `uvm_info("SEQ", {"Response:",req.convert2string()},UVM_MEDIUM)

endtask
endclass:nand_in_fixed_sequence
