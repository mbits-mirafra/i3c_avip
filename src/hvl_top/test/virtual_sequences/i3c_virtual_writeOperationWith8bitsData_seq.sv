`ifndef I3C_VIRTUAL_WRITEOPERATIONWITH8BITSDATA_SEQ_INCLUDED_
`define I3C_VIRTUAL_WRITEOPERATIONWITH8BITSDATA_SEQ_INCLUDED_

class i3c_virtual_writeOperationWith8bitsData_seq extends i3c_virtual_base_seq;
  `uvm_object_utils(i3c_virtual_writeOperationWith8bitsData_seq)
  
  i3c_controller_writeOperationWith8bitsData_seq i3c_controller_writeOperationWith8bitsData_seq_h;
  i3c_target_writeOperationWith8bitsData_seq  i3c_target_writeOperationWith8bitsData_seq_h;
 
  extern function new(string name = "i3c_virtual_writeOperationWith8bitsData_seq");
  extern task body();

endclass : i3c_virtual_writeOperationWith8bitsData_seq

function i3c_virtual_writeOperationWith8bitsData_seq::new(string name = "i3c_virtual_writeOperationWith8bitsData_seq");
  super.new(name);
endfunction : new

//task : body

task i3c_virtual_writeOperationWith8bitsData_seq::body();
 super.body(); //Sets up the sub-sequencer pointer

   //crearions controller and target sequence handles here  
  
   i3c_controller_writeOperationWith8bitsData_seq_h=i3c_controller_writeOperationWith8bitsData_seq::type_id::create("i3c_controller_writeOperationWith8bitsData_seq_h");
   i3c_target_writeOperationWith8bitsData_seq_h=i3c_target_writeOperationWith8bitsData_seq::type_id::create("i3c_target_writeOperationWith8bitsData_seq_h");

 fork
    begin: TARGET_SEQ_START
      forever begin
        i3c_target_writeOperationWith8bitsData_seq_h.start(p_sequencer.i3c_target_seqr_h); 
      end
    end
  join_none


  fork
    begin: CONTROLLER_SEQ_START
      repeat(1) begin
        i3c_controller_writeOperationWith8bitsData_seq_h.start(p_sequencer.i3c_controller_seqr_h);
      end
    end
  join

endtask: body

`endif

