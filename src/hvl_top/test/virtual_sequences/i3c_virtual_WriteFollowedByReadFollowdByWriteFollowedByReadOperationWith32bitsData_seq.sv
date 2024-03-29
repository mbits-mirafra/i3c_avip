`ifndef I3C_VIRTUAL_WRITEFOLLOWEDBYREADFOLLOWDBYWRITEFOLLOWEDBYREADOPERATIONWITH32BITSDATA_SEQ_INCLUDED_
`define I3C_VIRTUAL_WRITEFOLLOWEDBYREADFOLLOWDBYWRITEFOLLOWEDBYREADOPERATIONWITH32BITSDATA_SEQ_INCLUDED_

class i3c_virtual_WriteFollowedByReadFollowedByWriteFollowedByReadOperationWith32bitsData_seq extends
i3c_virtual_WriteFollowedByReadOperationWith32bitsData_seq;
`uvm_object_utils(i3c_virtual_WriteFollowedByReadFollowedByWriteFollowedByReadOperationWith32bitsData_seq)
  
  extern function new(string name = "i3c_virtual_WriteFollowedByReadFollowedByWriteFollowedByReadOperationWith32bitsData_seq");
  extern task body();

endclass : i3c_virtual_WriteFollowedByReadFollowedByWriteFollowedByReadOperationWith32bitsData_seq

function i3c_virtual_WriteFollowedByReadFollowedByWriteFollowedByReadOperationWith32bitsData_seq::new(string name = "i3c_virtual_WriteFollowedByReadFollowedByWriteFollowedByReadOperationWith32bitsData_seq");
  super.new(name);
endfunction : new


task i3c_virtual_WriteFollowedByReadFollowedByWriteFollowedByReadOperationWith32bitsData_seq::body();
 super.body(); 

begin: CONTROLLER_SEQ_START
      repeat(1) begin
        i3c_controller_writeOperationWith32bitsData_seq_h.start(p_sequencer.i3c_controller_seqr_h);
        i3c_controller_readOperationWith32bitsData_seq_h.start(p_sequencer.i3c_controller_seqr_h);
end
end
endtask: body

`endif

