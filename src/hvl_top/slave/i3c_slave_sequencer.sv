`ifndef I3C_SLAVE_SEQUENCER_INCLUDED_
`define I3C_SLAVE_SEQUENCER_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: i3c_slave_sequencer
// <Description_here>
//--------------------------------------------------------------------------------------------
class i3c_slave_sequencer extends uvm_sequencer#(i3c_slave_tx);
  `uvm_component_utils(i3c_slave_sequencer)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "i3c_slave_sequencer", uvm_component parent = null);

endclass : i3c_slave_sequencer

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - i3c_slave_sequencer
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function i3c_slave_sequencer::new(string name = "i3c_slave_sequencer",
                                 uvm_component parent = null);
  super.new(name, parent);
endfunction : new

`endif

