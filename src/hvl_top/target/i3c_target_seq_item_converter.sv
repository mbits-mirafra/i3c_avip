`ifndef I3C_TARGET_SEQ_ITEM_CONVERTER_INCLUDED_
`define I3C_TARGET_SEQ_ITEM_CONVERTER_INCLUDED_

//--------------------------------------------------------------------------------------------
// class : i3c_target_seq_item_converter
// Description:
// class converting seq_item transactions into struct data items and viceversa
//--------------------------------------------------------------------------------------------

class i3c_target_seq_item_converter extends uvm_object;
  
  //static int c2t;
  //static int t2c;
  //static int baudrate_divisor;
  
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "i3c_target_seq_item_converter");
  extern static function void from_class(input i3c_target_tx input_conv_h,
                                         output i3c_transfer_bits_s output_conv);

  extern static function void to_class(input i3c_transfer_bits_s input_conv_h,     
                                       output i3c_target_tx output_conv);
  //extern function void from_class_msb_first(input i3c_target_tx input_conv_h, 
  //                                           output i3c_transfer_bits_s output_conv);
  extern function void do_print(uvm_printer printer);

endclass : i3c_target_seq_item_converter

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - i3c_target_seq_item_converter
//--------------------------------------------------------------------------------------------
function i3c_target_seq_item_converter::new(string name = "i3c_target_seq_item_converter");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// function: from_class
// converting seq_item transactions into struct data items
//--------------------------------------------------------------------------------------------
function void i3c_target_seq_item_converter::from_class(input i3c_target_tx input_conv_h,
                                                        output i3c_transfer_bits_s output_conv);
  
  //converting of the target address                                                      
  output_conv.targetAddress = input_conv_h.targetAddress;

  output_conv.operation = operationType_e'(input_conv_h.operation);
  output_conv.targetAddressStatus = acknowledge_e'(input_conv_h.targetAddressStatus);
  
 //converting of the register address
 //output_conv.register_address = input_conv_h.register_address;
  //`uvm_info("DEBUG_MSHA", $sformatf("input_conv_h.register_address = %0x and output_conv.register_address = %0x", input_conv_h.register_address, output_conv.register_address ), UVM_NONE)



  for(int i=0; i<input_conv_h.readData.size();i++)  begin
    output_conv.readData[i]= input_conv_h.readData[i]; 
  end

  for(int i=0; i<input_conv_h.writeDataStatus.size();i++) begin
    output_conv.writeDataStatus[i] = input_conv_h.writeDataStatus[i];    
  end
 
if(input_conv_h.operation == 1) begin
  output_conv.no_of_i3c_bits_transfer = input_conv_h.readData.size() * DATA_WIDTH;
end else begin
  output_conv.no_of_i3c_bits_transfer = input_conv_h.writeDataStatus.size() * DATA_WIDTH;
end

  for(int i=0; i<input_conv_h.readData.size();i++) begin
  end 
   // MSHA: `uvm_info("target_seq_item_conv_class",
   // MSHA: $sformatf("data = \n %p",output_conv.data),UVM_LOW)
   // MSHA:// output_conv.data = output_conv.data << DATA_LENGTH;
   // MSHA: `uvm_info("target_seq_item_conv_class",
   // MSHA: $sformatf("After shift data = \n %p",output_conv.data),UVM_LOW)
   // MSHA: `uvm_info("target_seq_item_conv_class",
   // MSHA: $sformatf("After shift input_cov_h data = \n %p",
   // MSHA: input_conv_h.data[i]),UVM_LOW)
   // MSHA: `uvm_info("target_seq_item_conv_class",
   // MSHA: $sformatf("After shift input_cov_h data = \n %p",
   // MSHA: input_conv_h.data[i]),UVM_LOW)
   // MSHA: //output_conv.data[i*8 +: 8]= input_conv_h.data[i];    
   // MSHA: 
   // MSHA: `uvm_info("target_seq_item_conv_class",
   // MSHA: $sformatf("data = \n %p",output_conv.data),UVM_LOW)
  //end

  // Be default the ACK should be 1
  // so that the target ACK value can be stored
  //output_conv.target_add_ack = 1;
//  output_conv.reg_add_ack = 1;
 // output_conv.readData_ack = '1;

endfunction: from_class 


//--------------------------------------------------------------------------------------------
// function:to_class
// converting struct data items into ctions
//--------------------------------------------------------------------------------------------
function void i3c_target_seq_item_converter::to_class(input i3c_transfer_bits_s input_conv_h,
                                                      output i3c_target_tx output_conv);
  output_conv = new();

  // Defining the size of arrays
  output_conv.readData = new[input_conv_h.no_of_i3c_bits_transfer/DATA_WIDTH];

  // Storing the values in the respective arrays
  //converting back the target address 
  output_conv.targetAddress = input_conv_h.targetAddress;    
  `uvm_info("target_seq_item_conv_class",
  $sformatf("To class targetAddress = \n %p",output_conv.targetAddress),UVM_LOW)

  //converting back the register_address 
  //output_conv.register_address = input_conv_h.register_address;
  //`uvm_info("target_seq_item_conv_class",
  //$sformatf("To class register_address = \n %p",output_conv.register_address),UVM_LOW)

 
  //converting back the data
  for(int i=0; i<input_conv_h.no_of_i3c_bits_transfer/DATA_WIDTH; i++) begin
  output_conv.readData[i] = input_conv_h.readData[i][DATA_WIDTH-1:0];
  `uvm_info("target_seq_item_conv_class",
  $sformatf("To class data = \n %p",output_conv.readData[i]),UVM_LOW)
  end

  // Acknowledgement bits
  //output_conv.target_add_ack = input_conv_h.target_add_ack;
  //output_conv.reg_add_ack = input_conv_h.reg_add_ack;
  // MSHA: for(int i=0nput_conv_h.wr_data_ack[i]) begin
  // MSHA:   output_conv.wr_data_ack= '1;
  
endfunction: to_class

//--------------------------------------------------------------------------------------------
// Function: do_print method
// Print method can be added to display the data members values
//--------------------------------------------------------------------------------------------
function void i3c_target_seq_item_converter::do_print(uvm_printer printer);

  i3c_transfer_bits_s i3c_st;
  super.do_print(printer);


  if(i3c_st.targetAddress) begin
    printer.print_field($sformatf("targetAddress"),i3c_st.targetAddress,8,UVM_HEX);
  end
  
  //if(i3c_st.register_address) begin
  //  printer.print_field($sformatf("register_address"),i3c_st.register_address,8,UVM_HEX);
  //end

  foreach(i3c_st.writeData[i]) begin
  printer.print_field($sformatf("writeData[%0d]",i),i3c_st.writeData[i],8,UVM_HEX);
  end

endfunction : do_print

`endif
