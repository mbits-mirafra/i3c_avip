
`ifndef I3C_SLAVE_BASE_SEQ_INCLUDED_
`define I3C_SLAVE_BASE_SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: i3c_slave_seq 
// creating i3c_slave_seq class extends from uvm_sequence
//--------------------------------------------------------------------------------------------

class i3c_slave_base_seq extends uvm_sequence #(i3c_slave_tx);
  //factory registration
  `uvm_object_utils(i3c_slave_base_seq)
  
  //-------------------------------------------------------
  // Externally defined Function
  //-------------------------------------------------------
  extern function new(string name = "i3c_slave_base_seq");
endclass : i3c_slave_base_seq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the master_sequence class object
//
// Parameters:
//  name - instance name of the config_template
//-----------------------------------------------------------------------------

function i3c_slave_base_seq::new(string name = "i3c_slave_base_seq");
  super.new(name);
endfunction : new

`endif
