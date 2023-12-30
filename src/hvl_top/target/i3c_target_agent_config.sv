`ifndef I3C_TARGET_AGENT_CONFIG_INCLUDED_
`define I3C_TARGET_AGENT_CONFIG_INCLUDED_

class i3c_target_agent_config extends uvm_object;
  `uvm_object_utils(i3c_target_agent_config)

  uvm_active_passive_enum isActive = UVM_ACTIVE;
  bit hasCoverage = 1;
  dataTransferDirection_e DataTransferdirection;
  bit [TARGET_ADDRESS_WIDTH-1 :0] targetAddress[];  
  bit [DATA_WIDTH-1:0]defaultReadData = 'hFF;
  bit [DATA_WIDTH-1:0]targetFIFOMemory[$];
 
  extern function new(string name = "i3c_target_agent_config");
 extern function void do_print(uvm_printer printer);

endclass : i3c_target_agent_config

function i3c_target_agent_config::new(string name = "i3c_target_agent_config");
  super.new(name);
endfunction : new

function void i3c_target_agent_config::do_print(uvm_printer printer);
  super.do_print(printer);

  printer.print_string ("isActive",isActive.name());
  printer.print_string ("DataTransferdirection",DataTransferdirection.name());
//printer.print_string ("TARGET_ADDRESS_WIDTH",TARGET_ADDRESS_WIDTH.name());
  printer.print_field ("hasCoverage",hasCoverage, 1, UVM_DEC);

endfunction : do_print

`endif
