`ifndef I3C_SLAVE_AGENT_CONFIG_INCLUDED_
`define I3C_SLAVE_AGENT_CONFIG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: i3c_slave_agent_config
// <Description_here>
//--------------------------------------------------------------------------------------------
class i3c_slave_agent_config extends uvm_object;
  `uvm_object_utils(i3c_slave_agent_config)
  
  // Variable: is_active
  // Used for creating the agent in either passive or active mode
  uvm_active_passive_enum is_active=UVM_ACTIVE;
  
  // Variable: shift_dir
  // Shifts the data, LSB first or MSB first
  shift_direction_e shift_dir;

  // Variable:slave_address
  // Used for storing the address 
  bit [SLAVE_ADDRESS_WIDTH-1 :0] slave_address;
  
  // Variable: has_coverage
  // Used for enabling the slave agent coverage
  bit has_coverage;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "i3c_slave_agent_config");
  extern function void do_print(uvm_printer printer);

endclass : i3c_slave_agent_config

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - slave_agent_config
//--------------------------------------------------------------------------------------------
function i3c_slave_agent_config::new(string name = "i3c_slave_agent_config");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: do_print method
// Print method can be added to display the data members values
//--------------------------------------------------------------------------------------------
function void i3c_slave_agent_config::do_print(uvm_printer printer);
  super.do_print(printer);


  printer.print_string ("is_active",is_active.name());
  //printer.print_field ("no_of_slaves",no_of_slaves,$bits(no_of_slaves), UVM_DEC);
  printer.print_string ("shift_dir",shift_dir.name());
  //printer.print_string ("read_write",read_write.name());
  //printer.print_string ("slave_address_width",slave_address_width.name());
  printer.print_field ("has_coverage",has_coverage, 1, UVM_DEC);
  
endfunction : do_print

`endif

