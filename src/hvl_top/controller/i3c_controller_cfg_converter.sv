`ifndef I3C_CONTROLLER_CFG_CONVERTER_INCLUDED_
`define I3C_CONTROLLER_CFG_CONVERTER_INCLUDED_

//--------------------------------------------------------------------------------------------
// class : i3c_controller_cfg_converter
// Description:
// class converting seq_item transactions into struct data items and viceversa
//--------------------------------------------------------------------------------------------

class i3c_controller_cfg_converter extends uvm_object;
  
  
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "i3c_controller_cfg_converter");
  extern static function void from_class(input i3c_controller_agent_config input_conv_h,
                                          output i3c_transfer_cfg_s output_conv);

  extern function void do_print(uvm_printer printer);

endclass : i3c_controller_cfg_converter

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - i3c_controller_cfg_converter
//--------------------------------------------------------------------------------------------
function i3c_controller_cfg_converter::new(string name = "i3c_controller_cfg_converter");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// function: from_class
// converting seq_item transactions into struct data items
//--------------------------------------------------------------------------------------------
function void i3c_controller_cfg_converter::from_class(input i3c_controller_agent_config input_conv_h,
                                                    output i3c_transfer_cfg_s output_conv);


  bit target_address_width;
  
  //slave address is configurable so for it we do casting 
  // slave_address_width=slave_address_width_e'(input_conv_h.slave_address_width);

//  target_address_width=target_address_width_e'(input_conv_h.target_address_width);
  
 output_conv.DataTransferdirection = dataTransferDirection_e'(input_conv_h.DataTransferdirection);
 output_conv.clockRateDividerValue = input_conv_h.get_clockrate_divider_value();

 `uvm_info("conv_bd",$sformatf("bd = \n %p",output_conv.clockRateDividerValue),UVM_LOW)

endfunction: from_class 

//--------------------------------------------------------------------------------------------
// Function: do_print method
// Print method can be added to display the data members values
//--------------------------------------------------------------------------------------------
function void i3c_controller_cfg_converter::do_print(uvm_printer printer);

  i3c_transfer_cfg_s i3c_st;


  super.do_print(printer);
 // foreach (i3c_controller_agent_cfg_h[i])begin
  printer.print_field ("clockRateDividerValue",i3c_st.clockRateDividerValue, 
                            $bits(i3c_st.clockRateDividerValue), UVM_DEC);
                          
 // end
endfunction : do_print

`endif
