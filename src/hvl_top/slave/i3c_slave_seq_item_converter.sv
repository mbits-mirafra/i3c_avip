`ifndef I3C_SLAVE_SEQ_ITEM_CONVERTER_INCLUDED_
`define I3C_SLAVE_SEQ_ITEM_CONVERTER_INCLUDED_

//--------------------------------------------------------------------------------------------
// class : i3c_slave_seq_item_converter
// Description:
// class converting seq_item transactions into struct data items and viceversa
//--------------------------------------------------------------------------------------------

class i3c_slave_seq_item_converter extends uvm_object;
  
  //static int c2t;
  //static int t2c;
  //static int baudrate_divisor;
  
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "i3c_slave_seq_item_converter");
  extern static function void from_class(input i3c_slave_tx input_conv_h,
                                         output i3c_transfer_bits_s output_conv);

  extern static function void to_class(input i3c_transfer_bits_s input_conv_h,     
                                       output i3c_slave_tx output_conv);
  //extern function void from_class_msb_first(input i3c_slave_tx input_conv_h, 
  //                                           output i3c_transfer_bits_s output_conv);
  extern function void do_print(uvm_printer printer);

endclass : i3c_slave_seq_item_converter

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - i3c_slave_seq_item_converter
//--------------------------------------------------------------------------------------------
function i3c_slave_seq_item_converter::new(string name = "i3c_slave_seq_item_converter");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// function: from_class
// converting seq_item transactions into struct data items
//--------------------------------------------------------------------------------------------
function void i3c_slave_seq_item_converter::from_class(input i3c_slave_tx input_conv_h,
                                                        output i3c_transfer_bits_s output_conv);
  
  //converting of the slave address                                                      
  output_conv.slave_address = input_conv_h.slave_address;

  output_conv.read_write = read_write_e'(input_conv_h.read_write);
  
  //converting of the register address
  //output_conv.register_address = input_conv_h.register_address;
  //`uvm_info("DEBUG_MSHA", $sformatf("input_conv_h.register_address = %0x and output_conv.register_address = %0x", input_conv_h.register_address, output_conv.register_address ), UVM_NONE)



  //for(int i=0; i<input_conv_h.data.size();i++) begin
   // MSHA: `uvm_info("slave_seq_item_conv_class",
   // MSHA: $sformatf("data = \n %p",output_conv.data),UVM_LOW)
   // MSHA:// output_conv.data = output_conv.data << DATA_LENGTH;
   // MSHA: `uvm_info("slave_seq_item_conv_class",
   // MSHA: $sformatf("After shift data = \n %p",output_conv.data),UVM_LOW)
   // MSHA: `uvm_info("slave_seq_item_conv_class",
   // MSHA: $sformatf("After shift input_cov_h data = \n %p",
   // MSHA: input_conv_h.data[i]),UVM_LOW)

    //output_conv.data[i][DATA_WIDTH-1:0] = input_conv_h.data[i];    

   // MSHA: `uvm_info("slave_seq_item_conv_class",
   // MSHA: $sformatf("After shift input_cov_h data = \n %p",
   // MSHA: input_conv_h.data[i]),UVM_LOW)
   // MSHA: //output_conv.data[i*8 +: 8]= input_conv_h.data[i];    
   // MSHA: 
   // MSHA: `uvm_info("slave_seq_item_conv_class",
   // MSHA: $sformatf("data = \n %p",output_conv.data),UVM_LOW)
  //end

  // Be default the ACK should be 1
  // so that the slave ACK value can be stored
  //output_conv.slave_add_ack = 1;
  output_conv.reg_add_ack = 1;
  output_conv.wr_data_ack= '1;

endfunction: from_class 


//--------------------------------------------------------------------------------------------
// function:to_class
// converting struct data items into seq_item transactions
//--------------------------------------------------------------------------------------------
function void i3c_slave_seq_item_converter::to_class(input i3c_transfer_bits_s input_conv_h,
                                                      output i3c_slave_tx output_conv);
  output_conv = new();

  // Defining the size of arrays
  //output_conv.data = new[input_conv_h.no_of_i3c_bits_transfer/DATA_WIDTH];

  // Storing the values in the respective arrays
  //converting back the slave address 
  output_conv.slave_address = input_conv_h.slave_address;    
  `uvm_info("slave_seq_item_conv_class",
  $sformatf("To class slave_address = \n %p",output_conv.slave_address),UVM_LOW)

  //converting back the register_address 
  //output_conv.register_address = input_conv_h.register_address;
  //`uvm_info("slave_seq_item_conv_class",
  //$sformatf("To class register_address = \n %p",output_conv.register_address),UVM_LOW)

 
  //converting back the data
  //for(int i=0; i<input_conv_h.no_of_i3c_bits_transfer/DATA_WIDTH; i++) begin
  //output_conv.data[i] = input_conv_h.data[i][DATA_WIDTH-1:0];
  //`uvm_info("slave_seq_item_conv_class",
  //$sformatf("To class data = \n %p",output_conv.data[i]),UVM_LOW)
  //end

  // Acknowledgement bits
  //output_conv.slave_add_ack = input_conv_h.slave_add_ack;
  //output_conv.reg_add_ack = input_conv_h.reg_add_ack;
  // MSHA: for(int i=0nput_conv_h.wr_data_ack[i]) begin
  // MSHA:   output_conv.wr_data_ack= '1;
  
endfunction: to_class

//--------------------------------------------------------------------------------------------
// Function: do_print method
// Print method can be added to display the data members values
//--------------------------------------------------------------------------------------------
function void i3c_slave_seq_item_converter::do_print(uvm_printer printer);

  i3c_transfer_bits_s i3c_st;
  super.do_print(printer);


  if(i3c_st.slave_address) begin
    printer.print_field($sformatf("slave_address"),i3c_st.slave_address,8,UVM_HEX);
  end
  
  //if(i3c_st.register_address) begin
  //  printer.print_field($sformatf("register_address"),i3c_st.register_address,8,UVM_HEX);
  //end

  //foreach(i3c_st.data[i]) begin
  //  printer.print_field($sformatf("data[%0d]",i),i3c_st.data[i],8,UVM_HEX);
  //end

endfunction : do_print

`endif
