`ifndef I3C_TARGET_BASE_SEQ_INCLUDED_
`define I3C_TARGET_BASE_SEQ_INCLUDED_

class i3c_target_base_seq extends uvm_sequence #(i3c_target_tx);
  `uvm_object_utils(i3c_target_base_seq)
  
  `uvm_declare_p_sequencer(i3c_target_sequencer) 

 extern function new(string name = "i3c_target_base_seq");
  extern virtual task body();
endclass : i3c_target_base_seq

function i3c_target_base_seq::new(string name = "i3c_target_base_seq");
  super.new(name);
endfunction : new

task i3c_target_base_seq::body();
  //dynamic casting of p_sequencer and m_sequencer
  if(!$cast(p_sequencer,m_sequencer))begin
    `uvm_error(get_full_name(),"Virtual sequencer pointer cast failed")
  end
endtask:body
`endif
