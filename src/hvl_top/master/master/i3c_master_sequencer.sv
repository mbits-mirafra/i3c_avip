`ifndef I3C_MASTER_SEQUENCER_INCLUDED_
`define I3C_MASTER_SEQUENCER_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: i3c_master_sequencer
// <Description_here>
//--------------------------------------------------------------------------------------------
class i3c_master_sequencer extends uvm_sequencer#(i3c_master_tx) ;
  `uvm_component_utils(i3c_master_sequencer)
 
  i3c_master_agent_config i3c_master_agent_cfg_h;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "i3c_master_sequencer", uvm_component parent = null);

endclass : i3c_master_sequencer

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - i3c_master_sequencer
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function i3c_master_sequencer::new(string name = "i3c_master_sequencer",
                                 uvm_component parent = null);
  super.new(name, parent);
endfunction : new

`endif

