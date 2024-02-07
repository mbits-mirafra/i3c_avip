`ifndef I3C_CONTROLLER_SEQUENCER_INCLUDED_
`define I3C_CONTROLLER_SEQUENCER_INCLUDED_

class i3c_controller_sequencer extends uvm_sequencer#(i3c_controller_tx) ;
  `uvm_component_utils(i3c_controller_sequencer)
 
  i3c_controller_agent_config i3c_controller_agent_cfg_h;

  extern function new(string name = "i3c_controller_sequencer", uvm_component parent = null);
endclass : i3c_controller_sequencer

function i3c_controller_sequencer::new(string name = "i3c_controller_sequencer",
                                 uvm_component parent = null);
  super.new(name, parent);
endfunction : new

`endif

