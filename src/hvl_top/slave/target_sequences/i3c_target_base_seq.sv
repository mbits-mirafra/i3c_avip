`ifndef I3C_TARGET_BASE_SEQ_INCLUDED_
`define I3C_TARGET_BASE_SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: i3c_target_seq 
// creating i3c_target_seq class extends from uvm_sequence
//--------------------------------------------------------------------------------------------

class i3c_target_base_seq extends uvm_sequence #(i3c_target_tx);
  `uvm_object_utils(i3c_target_base_seq)
  
  //-------------------------------------------------------
  // Externally defined Function
  //-------------------------------------------------------
  extern function new(string name = "i3c_target_base_seq");
endclass : i3c_target_base_seq


function i3c_target_base_seq::new(string name = "i3c_target_base_seq");
  super.new(name);
endfunction : new

`endif