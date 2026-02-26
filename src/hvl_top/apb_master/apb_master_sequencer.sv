`ifndef APB_MASTER_SEQUENCER_INCLUDED_
`define APB_MASTER_SEQUENCER_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: apb_master_sequencer
//--------------------------------------------------------------------------------------------
class apb_master_sequencer extends uvm_sequencer #(apb_master_tx);
  `uvm_component_utils(apb_master_sequencer)

  //Variable: apb_master_agent_cfg_h
  //Declaring handle for apb_master agent config class 
  apb_master_agent_config apb_master_agent_cfg_h;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "apb_master_sequencer", uvm_component parent);
 
endclass : apb_master_sequencer
 
//--------------------------------------------------------------------------------------------
// Construct: new
//  Initializes the apb_master sequencer class component
//
// Parameters:
//  name - apb_master_sequencer
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function apb_master_sequencer::new(string name = "apb_master_sequencer",uvm_component parent);
  super.new(name,parent);
endfunction : new

`endif

