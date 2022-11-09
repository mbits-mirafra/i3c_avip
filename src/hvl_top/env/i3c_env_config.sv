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
  
  // Variable: no_of_slaves
  // Number of masters connected to the I3C interface
  int no_of_masters;
  
  // Variable: no_of_slaves
  // Number of slaves connected to the I3C interface
  int no_of_slaves;
  
  // Variable: i3c_master_agent_cfg_h
  // Dynamic array of master agnet configuration handles
  i3c_master_agent_config i3c_master_agent_cfg_h[];
  
  // Variable: i3c_slave_agent_cfg_h
  // Dynamic array of slave agnet configuration handles
  i3c_slave_agent_config i3c_slave_agent_cfg_h[];



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
  printer.print_field ("no_of_masters",no_of_masters,$bits(no_of_masters), UVM_DEC);
  printer.print_field ("no_of_slaves",no_of_slaves,$bits(no_of_slaves), UVM_DEC);
  
endfunction : do_print

`endif


