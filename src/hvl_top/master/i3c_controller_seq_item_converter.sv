`ifndef I3C_CONTROLLER_SEQ_ITEM_CONVERTER_INCLUDED_
`define I3C_CONTROLLER_SEQ_ITEM_CONVERTER_INCLUDED_

//--------------------------------------------------------------------------------------------
// class : i3c_controller_seq_item_converter
// Description:
// class converting seq_item transactions into struct data items and viceversa
//--------------------------------------------------------------------------------------------

class i3c_controller_seq_item_converter extends uvm_object;
  
  
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "i3c_controller_seq_item_converter");
  extern static function void from_class(input i3c_controller_tx input_conv_h,
                                         output i3c_transfer_bits_s output_conv);

  extern static function void to_class(input i3c_transfer_bits_s input_conv_h,     
                                       output i3c_controller_tx output_conv);
  //extern function void from_class_msb_first(input i3c_controller_tx input_conv_h, 
  //                                           output i3c_transfer_bits_s output_conv);
  extern function void do_print(uvm_printer printer);

endclass : i3c_controller_seq_item_converter

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - i3c_controller_seq_item_converter
//--------------------------------------------------------------------------------------------
function i3c_controller_seq_item_converter::new(string name = "i3c_controller_seq_item_converter");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// function: from_class
// converting seq_item transactions into struct data items
//--------------------------------------------------------------------------------------------
function void i3c_controller_seq_item_converter::from_class(input i3c_controller_tx input_conv_h,
                                                        output i3c_transfer_bits_s output_conv);
  
  //converting of the slave address                                                      
  output_conv.targetAddress = input_conv_h.targetAddress;

  output_conv.operation = operationType_e'(input_conv_h.operation);
 // GopalS:  output_conv.size = input_conv_h.size;
  // GopalS: output_conv.writeData = new[output_conv.size];    
  for(int i=0; i<input_conv_h.writeData.size();i++) begin
    output_conv.writeData[i] = input_conv_h.writeData[i];    
  end
  
  //converting of the register address
 output_conv.register_address = input_conv_h.register_address;
 `uvm_info("DEBUG_MSHA", $sformatf("input_conv_h.register_address = %0x and output_conv.register_address = %0x", input_conv_h.register_address, output_conv.register_address ), UVM_NONE)

  output_conv.no_of_i3c_bits_transfer = input_conv_h.writeData.size() * DATA_WIDTH;

  for(int i=0; i<input_conv_h.writeData.size();i++) begin
   // MSHA: `uvm_info("controller_seq_item_conv_class",
   // MSHA: $sformatf("writeData = \n %p",output_conv.writeData),UVM_LOW)
   // MSHA:// output_conv.writeData = output_conv.writeData << data_LENGTH;
   // MSHA: `uvm_info("controller_seq_item_conv_class",
   // MSHA: $sformatf("After shift writeData = \n %p",output_conv.writeData),UVM_LOW)
   // MSHA: `uvm_info("controller_seq_item_conv_class",
   // MSHA: $sformatf("After shift input_cov_h writeData = \n %p",
   // MSHA: input_conv_h.writeData[i]),UVM_LOW)

    //output_conv.writeData[i][DATA_WIDTH-1:0] = input_conv_h.writeData[i];    

   // MSHA: `uvm_info("controller_seq_item_conv_class",
   // MSHA: $sformatf("After shift input_cov_h writeData = \n %p",
   // MSHA: input_conv_h.writeData[i]),UVM_LOW)
   // MSHA: //output_conv.writeData[i*8 +: 8]= input_conv_h.writeData[i];    
   // MSHA: 
   // MSHA: `uvm_info("controller_seq_item_conv_class",
   // MSHA: $sformatf("writeData = \n %p",output_conv.writeData),UVM_LOW)
  end

  // Be default the ACK should be 1
  // so that the slave ACK value can be stored
  output_conv.slave_add_ack = 1;
  output_conv.reg_add_ack = 1;
  output_conv.writeData_ack= '1;

endfunction: from_class 


//--------------------------------------------------------------------------------------------
// function:to_class
// converting struct data items into seq_item transactions
//--------------------------------------------------------------------------------------------
function void i3c_controller_seq_item_converter::to_class(input i3c_transfer_bits_s input_conv_h,
                                                      output i3c_controller_tx output_conv);
  output_conv = new();

  // Defining the size of arrays
  output_conv.writeData = new[input_conv_h.no_of_i3c_bits_transfer/DATA_WIDTH];

  // Storing the values in the respective arrays
  //converting back the slave address 
  output_conv.targetAddress = input_conv_h.targetAddress;    
  `uvm_info("controller_seq_item_conv_class",
  $sformatf("To class targetAddress = \n %p",output_conv.targetAddress),UVM_LOW)

  //converting back the register_address 
  // GopalS: output_conv.register_address = input_conv_h.register_address;
 // GopalS:  `uvm_info("controller_seq_item_conv_class",
 // GopalS:  $sformatf("To class register_address = \n %p",output_conv.register_address),UVM_LOW)

 
  //converting back the data
  for(int i=0; i<input_conv_h.no_of_i3c_bits_transfer/DATA_WIDTH; i++) begin
  output_conv.writeData[i] = input_conv_h.writeData[i][DATA_WIDTH-1:0];
  `uvm_info("controller_seq_item_conv_class",
  $sformatf("To class writeData = \n %p",output_conv.writeData[i]),UVM_LOW)
  end

  // Acknowledgement bits
// GopalS:   output_conv.slave_add_ack = input_conv_h.slave_add_ack;
// GopalS:   output_conv.reg_add_ack = input_conv_h.reg_add_ack;
// GopalS:   for(int i=0; i<input_conv_h.no_of_i3c_bits_transfer/DATA_WIDTH; i++) begin
// GopalS:     output_conv.writeData_ack.push_back(input_conv_h.writeData_ack[i]);
// GopalS:   end
  
endfunction: to_class

//--------------------------------------------------------------------------------------------
// Function: do_print method
// Print method can be added to display the data members values
//--------------------------------------------------------------------------------------------
function void i3c_controller_seq_item_converter::do_print(uvm_printer printer);

  i3c_transfer_bits_s i3c_st;
  super.do_print(printer);


  if(i3c_st.targetAddress) begin
    printer.print_field($sformatf("targetAddress"),i3c_st.targetAddress,8,UVM_HEX);
  end
// GopalS:   if(i3c_st.size) begin
// GopalS:     printer.print_field($sformatf("size"),i3c_st.size,8,UVM_HEX);
// GopalS:   end
  
  //if(i3c_st.register_address) begin
  //  printer.print_field($sformatf("register_address"),i3c_st.register_address,8,UVM_HEX);
  //end

  foreach(i3c_st.writeData[i]) begin
    printer.print_field($sformatf("writeData[%0d]",i),i3c_st.writeData[i],8,UVM_HEX);
  end

endfunction : do_print

`endif
