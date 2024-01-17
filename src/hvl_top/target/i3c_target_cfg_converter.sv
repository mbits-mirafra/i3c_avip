`ifndef I3C_TARGET_CFG_CONVERTER_INCLUDED_
`define I3C_TARGET_CFG_CONVERTER_INCLUDED_

class i3c_target_cfg_converter extends uvm_object;
  
  extern function new(string name = "i3c_target_cfg_converter");
  extern static function void from_class(input i3c_target_agent_config input_conv_h,
                                         output i3c_transfer_cfg_s output_conv);
  extern function void do_print(uvm_printer printer);
endclass : i3c_target_cfg_converter


function i3c_target_cfg_converter::new(string name = "i3c_target_cfg_converter");
  super.new(name);
endfunction : new


function void i3c_target_cfg_converter::from_class(input i3c_target_agent_config input_conv_h,
                                                   output i3c_transfer_cfg_s output_conv);
  bit target_address_width;
  
  output_conv.targetAddress = input_conv_h.targetAddress;
  output_conv.dataTransferDirection = dataTransferDirection_e'(input_conv_h.dataTransferDirection);
  output_conv.defaultReadData = input_conv_h.defaultReadData;
endfunction: from_class 


function void i3c_target_cfg_converter::do_print(uvm_printer printer);
  super.do_print(printer);
endfunction : do_print

`endif
