`ifndef I3C_VIRTUAL_BASE_SEQ_INCLUDED_
`define I3C_VIRTUAL_BASE_SEQ_INCLUDED_

// This class contains the handle of actual sequencer pointing towards them
class i3c_virtual_base_seq extends uvm_sequence#(uvm_sequence_item);
  `uvm_object_utils(i3c_virtual_base_seq)

   `uvm_declare_p_sequencer(i3c_virtual_sequencer)
        
   //declaring virtual sequencer handle
   //virtual_sequencer  virtual_seqr_h;

   i3c_controller_sequencer  i3c_controller_seqr_h;
   i3c_target_sequencer   i3c_target_seqr_h;
   i3c_env_config i3c_env_cfg_h;
   
   extern function new(string name="i3c_virtual_base_seq");
   extern task body();
endclass:i3c_virtual_base_seq
 
function i3c_virtual_base_seq::new(string name="i3c_virtual_base_seq");
  super.new(name);
endfunction:new
  
task i3c_virtual_base_seq::body();
  if(!uvm_config_db#(i3c_env_config) ::get(null,get_full_name(),"i3c_env_config",i3c_env_cfg_h)) begin
  `uvm_fatal("CONFIG","cannot get() env_cfg from uvm_config_db.Have you set() it?")
  end

  //dynamic casting of p_sequncer and m_sequencer
  if(!$cast(p_sequencer,m_sequencer))begin
  `uvm_error(get_full_name(),"Virtual sequencer pointer cast failed")
  end
                                             
  //connecting controller sequencer and target sequencer present in p_sequencer to
  // local controller sequencer and target sequencer 
  i3c_controller_seqr_h=p_sequencer.i3c_controller_seqr_h;
  i3c_target_seqr_h=p_sequencer.i3c_target_seqr_h;

endtask:body

`endif
