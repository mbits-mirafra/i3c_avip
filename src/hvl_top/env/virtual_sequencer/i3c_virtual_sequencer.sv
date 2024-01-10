`ifndef I3C_VIRTUAL_SEQUENCER_INCLUDED_
`define I3C_VIRTUAL_SEQUENCER_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: i3c_virtual_sequencer
// Description of the class.
//  
// This class contains the handle of actual sequencer pointing towards them
//--------------------------------------------------------------------------------------------
class i3c_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
  `uvm_component_utils(i3c_virtual_sequencer)
  
  // Variable: env_cfg_h
  // Declaring environment configuration handle
   i3c_env_config i3c_env_cfg_h;

  // Variable: controller_seqr_h
  // Declaring controller sequencer handle
  i3c_controller_sequencer i3c_controller_seqr_h;

  // Variable: target_seqr_h
  // Declaring target sequencer handle
  i3c_target_sequencer  i3c_target_seqr_h;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "i3c_virtual_sequencer", uvm_component parent);
  extern function void build_phase(uvm_phase phase);

endclass : i3c_virtual_sequencer

//--------------------------------------------------------------------------------------------
// Construct: new
// initializes the monitor class object
//
// Parameters:
//  name - instance name of the  i3c_virtual_sequencer
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function i3c_virtual_sequencer::new(string name = "i3c_virtual_sequencer",uvm_component parent );
    super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
// creates the required ports
//
// Parameters:
//  phase - stores the current phase
//--------------------------------------------------------------------------------------------
function void i3c_virtual_sequencer::build_phase(uvm_phase phase);
  super.build_phase(phase);
  
  if(!uvm_config_db #(i3c_env_config)::get(this,"","i3c_env_config",i3c_env_cfg_h))
  `uvm_error("VSEQR","COULDNT GET")
  
  //target_seqr_h = new[env_cfg_h.no_of_sagent];
  i3c_controller_seqr_h = i3c_controller_sequencer::type_id::create("i3c_controller_seqr_h",this);
  i3c_target_seqr_h = i3c_target_sequencer::type_id::create("i3c_target_seqr_h",this);
  
endfunction : build_phase


`endif

