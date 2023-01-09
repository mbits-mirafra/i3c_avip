`ifndef I3C_VIRTUAL_8B_WRITE_FOLLOWED_BY_READ_SEQ_INCLUDED_
`define I3C_VIRTUAL_8B_WRITE_FOLLOWED_BY_READ_SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: i3c_virtual_8b_write_followed_by_read_seq
// <Description_here>
//--------------------------------------------------------------------------------------------
class i3c_virtual_8b_write_followed_by_read_seq extends i3c_virtual_base_seq;
  `uvm_object_utils(i3c_virtual_8b_write_followed_by_read_seq)
  
  i3c_master_8b_write_read_seq i3c_master_8b_write_read_seq_h;
  i3c_8b_slave_seq  i3c_8b_slave_seq_h;
 
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "i3c_virtual_8b_write_followed_by_read_seq");
  extern task body();

endclass : i3c_virtual_8b_write_followed_by_read_seq

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - i3c_virtual_8b_write_followed_by_read_seq
//--------------------------------------------------------------------------------------------
function i3c_virtual_8b_write_followed_by_read_seq::new(string name = "i3c_virtual_8b_write_followed_by_read_seq");
  super.new(name);
endfunction : new

//-------------------------------------------------------
//task : body
//
//-------------------------------------------------------

task i3c_virtual_8b_write_followed_by_read_seq::body();
 super.body(); //Sets up the sub-sequencer pointer

   //crearions master and slave sequence handles here  
   i3c_master_8b_write_read_seq_h=i3c_master_8b_write_read_seq::type_id::create("i3c_master_8b_write_read_seq_h");
   i3c_8b_slave_seq_h=i3c_8b_slave_seq::type_id::create("i3c_8b_slave_seq_h");

   repeat(1) begin : MASTER_SEQ_START
     i3c_master_8b_write_read_seq_h.start(p_sequencer.i3c_master_seqr_h);
   end

endtask: body

`endif

