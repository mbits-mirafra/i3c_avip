`ifndef I3C_CONTROLLER_SEQ_ITEM_CONVERTER_INCLUDED_
`define I3C_CONTROLLER_SEQ_ITEM_CONVERTER_INCLUDED_

class i3c_controller_seq_item_converter extends uvm_object;
  
  extern function new(string name = "i3c_controller_seq_item_converter");
  extern static function void from_class(input i3c_controller_tx input_conv_h,
                                         output i3c_transfer_bits_s output_conv);

  extern static function void to_class(input i3c_transfer_bits_s input_conv_h,     
                                       output i3c_controller_tx output_conv);
  extern function void do_print(uvm_printer printer);
endclass : i3c_controller_seq_item_converter

function i3c_controller_seq_item_converter::new(string name = "i3c_controller_seq_item_converter");
  super.new(name);
endfunction : new


function void i3c_controller_seq_item_converter::from_class(input i3c_controller_tx input_conv_h,
         output i3c_transfer_bits_s output_conv);

  output_conv.targetAddress = input_conv_h.targetAddress;
  output_conv.operation = operationType_e'(input_conv_h.operation);
  
  for(int i=0; i<input_conv_h.writeData.size();i++) begin
    output_conv.writeData[i] = input_conv_h.writeData[i];    
  end
  for(int i=0; i<input_conv_h.readDataStatus.size();i++) begin
    output_conv.readDataStatus[i] = input_conv_h.readDataStatus[i];    
  end

  if(input_conv_h.operation == WRITE) begin
    output_conv.no_of_i3c_bits_transfer = input_conv_h.writeData.size() * DATA_WIDTH;
  end else begin
    output_conv.no_of_i3c_bits_transfer = input_conv_h.readDataStatus.size() * DATA_WIDTH;
  end

  output_conv.targetAddressStatus = NACK;
  for(int i=0; i<input_conv_h.writeData.size();i++) begin
    output_conv.writeDataStatus[i] = NACK;    
  end
endfunction: from_class 


function void i3c_controller_seq_item_converter::to_class(input i3c_transfer_bits_s input_conv_h,
       output i3c_controller_tx output_conv);
  output_conv = new();

  output_conv.targetAddress = input_conv_h.targetAddress;    
  `uvm_info("controller_seq_item_conv_class",$sformatf("To class targetAddress =  %0b",output_conv.targetAddress),UVM_LOW)
  output_conv.targetAddressStatus = acknowledge_e'(input_conv_h.targetAddressStatus);
  output_conv.operation = operationType_e'(input_conv_h.operation);
 
   output_conv.writeData = new[input_conv_h.no_of_i3c_bits_transfer/DATA_WIDTH];
   output_conv.writeDataStatus = new[input_conv_h.no_of_i3c_bits_transfer/DATA_WIDTH];

  for(int i=0; i<input_conv_h.no_of_i3c_bits_transfer/DATA_WIDTH; i++) begin
  output_conv.writeData[i] = input_conv_h.writeData[i];
  `uvm_info("controller_seq_item_conv_class",
  $sformatf("To class writeData =  %0b",output_conv.writeData[i]),UVM_LOW)
  end
  for(int i=0; i<input_conv_h.no_of_i3c_bits_transfer/DATA_WIDTH; i++) begin
    output_conv.writeDataStatus[i] = acknowledge_e'(input_conv_h.writeDataStatus[i]);
  end

  output_conv.readData = new[input_conv_h.no_of_i3c_bits_transfer/DATA_WIDTH];
  output_conv.readDataStatus = new[input_conv_h.no_of_i3c_bits_transfer/DATA_WIDTH];

  for(int i=0; i<input_conv_h.no_of_i3c_bits_transfer/DATA_WIDTH; i++) begin
  output_conv.readData[i] = input_conv_h.readData[i];
  `uvm_info("controller_seq_item_conv_class",
  $sformatf("To class readData =  %0b",output_conv.readData[i]),UVM_LOW)
  end

  for(int i=0; i<input_conv_h.no_of_i3c_bits_transfer/DATA_WIDTH; i++) begin
    output_conv.readDataStatus[i] = acknowledge_e'(input_conv_h.readDataStatus[i]);
  end
endfunction: to_class


function void i3c_controller_seq_item_converter::do_print(uvm_printer printer);
  i3c_transfer_bits_s i3c_st;
  super.do_print(printer);

  if(i3c_st.targetAddress) begin
    printer.print_field($sformatf("targetAddress"),i3c_st.targetAddress,8,UVM_HEX);
  end
  foreach(i3c_st.writeData[i]) begin
    printer.print_field($sformatf("writeData[%0d]",i),i3c_st.writeData[i],8,UVM_HEX);
  end
endfunction : do_print

`endif
