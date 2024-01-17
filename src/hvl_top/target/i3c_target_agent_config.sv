`ifndef I3C_TARGET_AGENT_CONFIG_INCLUDED_
`define I3C_TARGET_AGENT_CONFIG_INCLUDED_

class i3c_target_agent_config extends uvm_object;
  `uvm_object_utils(i3c_target_agent_config)

  uvm_active_passive_enum isActive = UVM_ACTIVE;
  hasCoverage_e hasCoverage = TRUE;
  dataTransferDirection_e dataTransferDirection;
  bit [TARGET_ADDRESS_WIDTH-1:0] targetAddress;
  bit [DATA_WIDTH-1:0]defaultReadData = 'hFF;
 
  extern function new(string name = "i3c_target_agent_config");
  extern function void do_print(uvm_printer printer);
endclass : i3c_target_agent_config


function i3c_target_agent_config::new(string name = "i3c_target_agent_config");
  super.new(name);
endfunction : new


function void i3c_target_agent_config::do_print(uvm_printer printer);
  super.do_print(printer);
  printer.print_string ("isActive",isActive.name());
  printer.print_string ("dataTransferDirection",dataTransferDirection.name());
  printer.print_string("hasCoverage",hasCoverage.name());
  printer.print_field("targetAddress",targetAddress,$bits(targetAddress),UVM_HEX);
endfunction : do_print

`endif
