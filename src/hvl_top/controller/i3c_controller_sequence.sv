`ifndef I3C_CONTROLLER_SEQUENCE_INCLUDED_
`define I3C_CONTROLLER_SEQUENCE_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: i3c_controller_sequence
// <Description_here>
//--------------------------------------------------------------------------------------------
class i3c_controller_sequence extends uvm_component;
  `uvm_component_utils(i3c_controller_sequence)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "i3c_controller_sequence", uvm_component parent = null);

endclass : i3c_controller_sequence

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - i3c_controller_sequence
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function i3c_controller_sequence::new(string name = "i3c_controller_sequence",
                                 uvm_component parent = null);
  super.new(name, parent);
endfunction : new


`endif

