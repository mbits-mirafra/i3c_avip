`ifndef I3C_TARGET_WRITEOPERATIONWITHRANDOMDATATRANSFERWIDTH_SEQ_INCLUDED_
`define I3C_TARGET_WRITEOPERATIONWITHRANDOMDATATRANSFERWIDTH_SEQ_INCLUDED_

class i3c_target_writeOperationWithRandomDataTransferWidth_seq extends i3c_target_base_seq;
  `uvm_object_utils(i3c_target_writeOperationWithRandomDataTransferWidth_seq)

  extern function new(string name = "i3c_target_writeOperationWithRandomDataTransferWidth_seq");
  extern task body();
endclass : i3c_target_writeOperationWithRandomDataTransferWidth_seq

function i3c_target_writeOperationWithRandomDataTransferWidth_seq::new(string name = "i3c_target_writeOperationWithRandomDataTransferWidth_seq");
  super.new(name);
endfunction : new


task i3c_target_writeOperationWithRandomDataTransferWidth_seq::body();
 // super.body();

  req = i3c_target_tx::type_id::create("req"); 

  start_item(req);
    if(!req.randomize()) begin
      `uvm_error(get_type_name(), "Randomization failed")
    end
  
    req.print();
  finish_item(req);

endtask:body
  
`endif

