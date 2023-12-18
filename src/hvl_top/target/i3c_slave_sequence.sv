`ifndef I3C_SLAVE_SEQUENCE_INCLUDED_
`define I3C_SLAVE_SEQUENCE_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: i3c_slave_sequence
// <Description_here>
//--------------------------------------------------------------------------------------------
class i3c_slave_sequence extends uvm_object;
  `uvm_object_utils(i3c_slave_sequence)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "i3c_slave_sequence");
endclass : i3c_slave_sequence

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - i3c_slave_sequence
//--------------------------------------------------------------------------------------------
function i3c_slave_sequence::new(string name = "i3c_slave_sequence");
  super.new(name);
endfunction : new

`endif

