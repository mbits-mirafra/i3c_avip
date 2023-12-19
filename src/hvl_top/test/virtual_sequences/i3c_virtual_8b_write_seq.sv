`ifndef I3C_VIRTUAL_8B_WRITE_SEQ_INCLUDED_
`define I3C_VIRTUAL_8B_WRITE_SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: i3c_virtual_8b_write_seq
// <Description_here>
//--------------------------------------------------------------------------------------------
class i3c_virtual_8b_write_seq extends i3c_virtual_base_seq;
  `uvm_object_utils(i3c_virtual_8b_write_seq)
  
  i3c_controller_8b_write_seq i3c_controller_8b_write_seq_h;
  i3c_target_8b_seq  i3c_target_8b_seq_h;
 
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "i3c_virtual_8b_write_seq");
  extern task body();

endclass : i3c_virtual_8b_write_seq

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - i3c_virtual_8b_write_seq
//--------------------------------------------------------------------------------------------
function i3c_virtual_8b_write_seq::new(string name = "i3c_virtual_8b_write_seq");
  super.new(name);
endfunction : new

//-------------------------------------------------------
//task : body
//
//-------------------------------------------------------

task i3c_virtual_8b_write_seq::body();
 super.body(); //Sets up the sub-sequencer pointer

   //crearions controller and target sequence handles here  
   i3c_controller_8b_write_seq_h=i3c_controller_8b_write_seq::type_id::create("i3c_controller_8b_write_seq_h");
   i3c_target_8b_seq_h=i3c_target_8b_seq::type_id::create("i3c_target_8b_seq_h");

   repeat(1) begin : CONTROLLER_SEQ_START
     i3c_controller_8b_write_seq_h.start(p_sequencer.i3c_controller_seqr_h);
   end

endtask: body

`endif

