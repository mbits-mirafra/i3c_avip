`ifndef I3C_CONTROLLER_AGENT_CONFIG_INCLUDED_
`define I3C_CONTROLLER_AGENT_CONFIG_INCLUDED_

class i3c_controller_agent_config extends uvm_object;
  `uvm_object_utils(i3c_controller_agent_config)

  uvm_active_passive_enum isActive=UVM_ACTIVE;  
  hasCoverage_e hasCoverage = TRUE;
  rand dataTransferDirection_e dataTransferDirection;
  bit [TARGET_ADDRESS_WIDTH-1:0] targetAddress[];

  rand protected bit[2:0] primary_prescalar;
  rand protected bit[2:0] secondary_prescalar;
  protected int clockRateDividerValue;

  int no_of_targets;

  extern function new(string name = "i3c_controller_agent_config");
  extern function void do_print(uvm_printer printer);
  extern function void set_clockrate_divider_value(int primary_prescalar, int secondary_prescalar);
  extern function int get_clockrate_divider_value();
  extern function void post_randomize();
endclass : i3c_controller_agent_config


function i3c_controller_agent_config::new(string name = "i3c_controller_agent_config");
  super.new(name);
endfunction : new


function void i3c_controller_agent_config::do_print(uvm_printer printer);
  super.do_print(printer);

  printer.print_string ("isActive",isActive.name());
  printer.print_field ("no_of_targets",no_of_targets,$bits(no_of_targets), UVM_DEC);
  printer.print_string ("dataTransferDirection",dataTransferDirection.name());
  printer.print_field ("primary_prescalar",primary_prescalar, 3, UVM_DEC);
  printer.print_field ("secondary_prescalar",secondary_prescalar, 3, UVM_DEC);
  printer.print_field ("clockRateDividerValue",clockRateDividerValue, $bits(clockRateDividerValue), UVM_DEC);
  printer.print_string("hasCoverage",hasCoverage.name());
  
endfunction : do_print

  
  function void i3c_controller_agent_config::set_clockrate_divider_value(int primary_prescalar, int secondary_prescalar);
    this.primary_prescalar = primary_prescalar;
    this.secondary_prescalar = secondary_prescalar;
 
    clockRateDividerValue = (this.secondary_prescalar + 1) * (2 ** (this.primary_prescalar + 1));
 
  endfunction : set_clockrate_divider_value


  function void i3c_controller_agent_config::post_randomize();
    set_clockrate_divider_value(this.primary_prescalar,this.secondary_prescalar);
  endfunction: post_randomize
  
  function int i3c_controller_agent_config::get_clockrate_divider_value();
    return(this.clockRateDividerValue);
  endfunction: get_clockrate_divider_value

`endif
