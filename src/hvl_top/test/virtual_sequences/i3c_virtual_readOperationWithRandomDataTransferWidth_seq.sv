`ifndef I3C_VIRTUAL_READOPERATIONWITHRANDOMDATATRANSFERWIDTH_SEQ_INCLUDED_
`define I3C_VIRTUAL_READOPERATIONWITHRANDOMDATATRANSFERWIDTH_SEQ_INCLUDED_

class i3c_virtual_readOperationWithRandomDataTransferWidth_seq extends i3c_virtual_base_seq;
  `uvm_object_utils(i3c_virtual_readOperationWithRandomDataTransferWidth_seq)
  
  i3c_controller_readOperationWithRandomDataTransferWidth_seq i3c_controller_readOperationWithRandomDataTransferWidth_seq_h;
  i3c_target_readOperationWithRandomDataTransferWidth_seq  i3c_target_readOperationWithRandomDataTransferWidth_seq_h;
 
  extern function new(string name = "i3c_virtual_readOperationWithRandomDataTransferWidth_seq");
  extern task body();

endclass : i3c_virtual_readOperationWithRandomDataTransferWidth_seq

function i3c_virtual_readOperationWithRandomDataTransferWidth_seq::new(string name = "i3c_virtual_readOperationWithRandomDataTransferWidth_seq");
  super.new(name);
endfunction : new


task i3c_virtual_readOperationWithRandomDataTransferWidth_seq::body();
 super.body(); 

   i3c_controller_readOperationWithRandomDataTransferWidth_seq_h=i3c_controller_readOperationWithRandomDataTransferWidth_seq::type_id::create("i3c_controller_readOperationWithRandomDataTransferWidth_seq_h");
   i3c_target_readOperationWithRandomDataTransferWidth_seq_h=i3c_target_readOperationWithRandomDataTransferWidth_seq::type_id::create("i3c_target_readOperationWithRandomDataTransferWidth_seq_h");

  fork
    begin: TARGET_SEQ_START
      forever begin
        i3c_target_readOperationWithRandomDataTransferWidth_seq_h.start(p_sequencer.i3c_target_seqr_h); 
      end
    end
  join_none

  begin: CONTROLLER_SEQ_START
    repeat(1) begin
      i3c_controller_readOperationWithRandomDataTransferWidth_seq_h.start(p_sequencer.i3c_controller_seqr_h);
    end
  end
endtask: body

`endif
