`ifndef I3C_CONTROLLER_BASE_SEQ_INCLUDED_
`define I3C_CONTROLLER_BASE_SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: i3c_controller_base_seq 
// creating i3c_controller_base_seq class extends from uvm_sequence
//--------------------------------------------------------------------------------------------

class i3c_controller_base_seq extends uvm_sequence #(i3c_controller_tx);
  //factory registration
  `uvm_object_utils(i3c_controller_base_seq)
// GopalS:   `uvm_declare_p_sequencer(i3c_controller_sequencer) 

  //-------------------------------------------------------
  // Externally defined Function
  //-------------------------------------------------------
  extern function new(string name = "i3c_controller_base_seq");
  extern virtual task body();
endclass : i3c_controller_base_seq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the controller_base_sequence class object
//
// Parameters:
//  name - instance name of the config_template
//-----------------------------------------------------------------------------

function i3c_controller_base_seq::new(string name = "i3c_controller_base_seq");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
//task:body
//Creates the required ports
//
//Parameters:
// phase - stores the current phase
//--------------------------------------------------------------------------------------------
task i3c_controller_base_seq::body();

  //dynamic casting of p_sequencer and m_sequencer
// GopalS:   if(!$cast(p_sequencer,m_sequencer))begin
// GopalS:     `uvm_error(get_full_name(),"Virtual sequencer pointer cast failed")
// GopalS:   end
            
endtask:body

`endif
