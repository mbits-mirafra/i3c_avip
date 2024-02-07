`ifndef I3C_VIRTUAL_SEQUENCER_INCLUDED_
`define I3C_VIRTUAL_SEQUENCER_INCLUDED_

//--------------------------------------------------------------------------------------------
// This class contains the handle of actual sequencer pointing towards them
//--------------------------------------------------------------------------------------------
class i3c_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
  `uvm_component_utils(i3c_virtual_sequencer)
  
  // Declaring environment configuration handle
   i3c_env_config i3c_env_cfg_h;

  // Declaring controller sequencer handle
  i3c_controller_sequencer i3c_controller_seqr_h;

  // Declaring target sequencer handle
  i3c_target_sequencer  i3c_target_seqr_h;

  extern function new(string name = "i3c_virtual_sequencer", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
endclass : i3c_virtual_sequencer

function i3c_virtual_sequencer::new(string name = "i3c_virtual_sequencer",uvm_component parent );
    super.new(name, parent);
endfunction : new

function void i3c_virtual_sequencer::build_phase(uvm_phase phase);
  super.build_phase(phase);
  
  if(!uvm_config_db #(i3c_env_config)::get(this,"","i3c_env_config",i3c_env_cfg_h))
  `uvm_error("VSEQR","COULDNT GET")
  
  //target_seqr_h = new[env_cfg_h.no_of_sagent];
  i3c_controller_seqr_h = i3c_controller_sequencer::type_id::create("i3c_controller_seqr_h",this);
  i3c_target_seqr_h = i3c_target_sequencer::type_id::create("i3c_target_seqr_h",this);
  
endfunction : build_phase

`endif

