`ifndef APB_ENV_CONFIG_INCLUDED_
`define APB_ENV_CONFIG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: apb_env_config
// This class is used as configuration class for apb_environment and its components
//--------------------------------------------------------------------------------------------
class apb_env_config extends uvm_object;
  `uvm_object_utils(apb_env_config)
  
  //Variable: has_scoreboard
  //Enables the scoreboard. Default value is 1
  bit has_scoreboard = 1;

  //Variable: has_virtual_sqr
  //Enables the virtual sequencer. Default value is 1
  bit has_virtual_seqr = 1;

  //Variable: no_of_slaves
  //Number of slaves connected to the SPI interface
  int no_of_slaves;

  //Variable: master_agent_cfg_h
  //Handle for master agent configuration
  apb_master_agent_config apb_master_agent_cfg_h;

  //Variable: slave_agent_cfg_h
  //Dynamic array of slave agnet configuration handles
  apb_slave_agent_config apb_slave_agent_cfg_h[];

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "apb_env_config");
  extern function void do_print(uvm_printer printer);

endclass : apb_env_config

//--------------------------------------------------------------------------------------------
// Construct: new
//  Initialization of new memory
//
// Parameters:
//  name - apb_env_config
//--------------------------------------------------------------------------------------------
function apb_env_config::new(string name = "apb_env_config");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: do_print method
//  Print method can be added to display the data members values
//
// Parameters :
//  printer - uvm_printer
//--------------------------------------------------------------------------------------------
function void apb_env_config::do_print(uvm_printer printer);
  super.do_print(printer);
  
  printer.print_field ("has_scoreboard",   has_scoreboard,   $bits(has_scoreboard),   UVM_DEC);
  printer.print_field ("has_virtual_seqr", has_virtual_seqr, $bits(has_virtual_seqr), UVM_DEC);
  printer.print_field ("no_of_slaves",     no_of_slaves,     $bits(no_of_slaves),     UVM_DEC);

endfunction : do_print

`endif
