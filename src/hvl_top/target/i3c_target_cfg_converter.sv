`ifndef I3C_TARGET_CFG_CONVERTER_INCLUDED_
`define I3C_TARGET_CFG_CONVERTER_INCLUDED_

class i3c_target_cfg_converter extends uvm_object;
  
  //static int c2t;
  //static int t2c;
  //static int baudrate_divisor;
  
 extern function new(string name = "i3c_target_cfg_converter");
  extern static function void from_class(input i3c_target_agent_config input_conv_h,
                                          output i3c_transfer_cfg_s output_conv);

  extern function void do_print(uvm_printer printer);

endclass : i3c_target_cfg_converter

function i3c_target_cfg_converter::new(string name = "i3c_target_cfg_converter");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// function: from_class
// converting seq_item transactions into struct data items
//--------------------------------------------------------------------------------------------
function void i3c_target_cfg_converter::from_class(input i3c_target_agent_config input_conv_h,
                                                    output i3c_transfer_cfg_s output_conv);


  bit target_address_width;
  
  //target address is configurable so for it we do casting 
 // target_address_width=target_address_width_e'(input_conv_h.target_address_width);
  
 output_conv.DataTransferdirection = dataTransferDirection_e'(input_conv_h.DataTransferdirection);
 //output_conv.targetAddress = input_conv_h.targetAddress;
 output_conv.targetFIFOMemory = input_conv_h.targetFIFOMemory;
  


endfunction: from_class 

//--------------------------------------------------------------------------------------------
// Function: do_print method
// Print method can be added to display the data members values
//--------------------------------------------------------------------------------------------
function void i3c_target_cfg_converter::do_print(uvm_printer printer);

  i3c_transfer_cfg_s i3c_st;

  super.do_print(printer);


endfunction : do_print

`endif
