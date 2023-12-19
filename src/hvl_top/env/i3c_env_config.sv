`ifndef I3C_ENV_CONFIG_INCLUDED_
`define I3C_ENV_CONFIG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: i3c_env_config
// This class is used as configuration class for environment and its components
//--------------------------------------------------------------------------------------------
class i3c_env_config extends uvm_object;
  `uvm_object_utils(i3c_env_config)

  // Variable: has_scoreboard
  // Enables the scoreboard. Default value is 1
  bit has_scoreboard = 1;
  
  // Variable: has_virtual_sqr
  // Enables the virtual sequencer. Default value is 1
  bit has_virtual_sequencer = 1;
  
  // Variable: no_of_targets
  // Number of controllers connected to the I3C interface
  int no_of_controllers;
  
  // Variable: no_of_targets
  // Number of targets connected to the I3C interface
  int no_of_targets;
  
  // Variable: i3c_controller_agent_cfg_h
  // Dynamic array of controller agnet configuration handles
  i3c_controller_agent_config i3c_controller_agent_cfg_h[];
  
  // Variable: i3c_target_agent_cfg_h
  // Dynamic array of target agnet configuration handles
  i3c_target_agent_config i3c_target_agent_cfg_h[];



  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "i3c_env_config");
  extern function void do_print(uvm_printer printer);
endclass : i3c_env_config

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - i3c_env_config
//--------------------------------------------------------------------------------------------
function i3c_env_config::new(string name = "i3c_env_config");
  super.new(name);
endfunction : new

function void i3c_env_config::do_print(uvm_printer printer);
  super.do_print(printer);
  printer.print_field ("has_scoreboard",has_scoreboard,1, UVM_DEC);
  printer.print_field ("has_virtual_sequencer",has_virtual_sequencer,1, UVM_DEC);
  printer.print_field ("no_of_controllers",no_of_controllers,$bits(no_of_controllers), UVM_DEC);
  printer.print_field ("no_of_targets",no_of_targets,$bits(no_of_targets), UVM_DEC);
  
endfunction : do_print

`endif


