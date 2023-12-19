`ifndef I3C_CONTROLLER_SEQUENCER_INCLUDED_
`define I3C_CONTROLLER_SEQUENCER_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: i3c_controller_sequencer
// <Description_here>
//--------------------------------------------------------------------------------------------
class i3c_controller_sequencer extends uvm_sequencer#(i3c_controller_tx) ;
  `uvm_component_utils(i3c_controller_sequencer)
 
  i3c_controller_agent_config i3c_controller_agent_cfg_h;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "i3c_controller_sequencer", uvm_component parent = null);

endclass : i3c_controller_sequencer

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - i3c_controller_sequencer
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function i3c_controller_sequencer::new(string name = "i3c_controller_sequencer",
                                 uvm_component parent = null);
  super.new(name, parent);
endfunction : new

`endif

