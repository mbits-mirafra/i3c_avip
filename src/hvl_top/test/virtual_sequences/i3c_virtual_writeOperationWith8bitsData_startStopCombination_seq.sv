`ifndef I3C_VIRTUAL_WRITEOPERATIONWITH8BITSDATA_STARTSTOPCOMBINATION_SEQ_INCLUDED_
`define I3C_VIRTUAL_WRITEOPERATIONWITH8BITSDATA_STARTSTOPCOMBINATION_SEQ_INCLUDED_

class i3c_virtual_writeOperationWith8bitsData_startStopCombination_seq extends i3c_virtual_base_seq;
  `uvm_object_utils(i3c_virtual_writeOperationWith8bitsData_startStopCombination_seq)
  
  i3c_controller_writeOperationWith8bitsData_seq i3c_controller_writeOperationWith8bitsData_seq_h;
  i3c_target_writeOperationWith8bitsData_seq  i3c_target_writeOperationWith8bitsData_seq_h;
 
  extern function new(string name = "i3c_virtual_writeOperationWith8bitsData_startStopCombination_seq");
  extern task body();

endclass : i3c_virtual_writeOperationWith8bitsData_startStopCombination_seq

function i3c_virtual_writeOperationWith8bitsData_startStopCombination_seq::new(string name = "i3c_virtual_writeOperationWith8bitsData_startStopCombination_seq");
  super.new(name);
endfunction : new


task i3c_virtual_writeOperationWith8bitsData_startStopCombination_seq::body();
 super.body();
  
   i3c_controller_writeOperationWith8bitsData_seq_h=i3c_controller_writeOperationWith8bitsData_seq::type_id::create("i3c_controller_writeOperationWith8bitsData_seq_h");
   i3c_target_writeOperationWith8bitsData_seq_h=i3c_target_writeOperationWith8bitsData_seq::type_id::create("i3c_target_writeOperationWith8bitsData_seq_h");

  fork
    begin: TARGET_SEQ_START
      forever begin
        i3c_target_writeOperationWith8bitsData_seq_h.start(p_sequencer.i3c_target_seqr_h); 
      end
    end
  join_none

  begin: CONTROLLER_SEQ_START
    repeat(2) begin
      i3c_controller_writeOperationWith8bitsData_seq_h.start(p_sequencer.i3c_controller_seqr_h);
    end
  end
endtask: body

`endif

