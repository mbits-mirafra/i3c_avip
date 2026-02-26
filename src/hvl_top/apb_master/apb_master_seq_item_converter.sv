`ifndef APB_MASTER_SEQ_ITEM_CONVERTER_INCLUDED_
`define APB_MASTER_SEQ_ITEM_CONVERTER_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class : apb_master_seq_item_converter
//  This class converts seq_item transactions into struct data items and viceversa
//--------------------------------------------------------------------------------------------
class apb_master_seq_item_converter extends uvm_object;
  
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "apb_master_seq_item_converter");
  extern static function void from_class(input apb_master_tx input_conv, output apb_transfer_char_s output_conv);
  extern static function void to_class(input apb_transfer_char_s input_conv, ref apb_master_tx output_conv_h);
  extern function void do_print(uvm_printer printer);

endclass : apb_master_seq_item_converter

//-------------------------------------------------------
// Construct:new
// 
// Parameters:
//  name - apb_master_seq_item_converter
//-------------------------------------------------------
function apb_master_seq_item_converter::new(string name = "apb_master_seq_item_converter");
  super.new(name);
endfunction: new

//--------------------------------------------------------------------------------------------
// Function: from_class
//  Converting seq_item transactions into struct data items
//
// Parameters:
//  name - apb_master_tx, apb_transfer_char_s
//--------------------------------------------------------------------------------------------
function void apb_master_seq_item_converter::from_class(input apb_master_tx input_conv, output apb_transfer_char_s output_conv);
  
  `uvm_info("apb_master_seq_item_conv_class",$sformatf("-------------------------------------------------------------"),UVM_HIGH);
 
  //output_conv.pprot = input_conv.pprot;
  $cast(output_conv.pprot,input_conv.pprot); 
  `uvm_info("apb_master_seq_item_conv_class",$sformatf("After randomize pprot =  %b",output_conv.pprot),UVM_HIGH);

  //output_conv.pselx = input_conv.pselx; 
  $cast(output_conv.pselx,input_conv.pselx);
  `uvm_info("apb_master_seq_item_conv_class",$sformatf("After randomize pselx =  %b",output_conv.pselx),UVM_HIGH);

  $cast(output_conv.pwrite,input_conv.pwrite);
  `uvm_info("apb_master_seq_item_conv_class",$sformatf("After randomizing pwrite =  %b",output_conv.pwrite),UVM_HIGH);

  output_conv.paddr = input_conv.paddr;
  `uvm_info("apb_master_seq_item_conv_class",$sformatf("after writnig addr =  %0h",output_conv.paddr),UVM_HIGH);

  output_conv.pwdata = input_conv.pwdata;
  `uvm_info("apb_master_seq_item_conv_class",$sformatf("after randomizing pwdata =  %0h",output_conv.pwdata),UVM_HIGH);

  output_conv.pstrb = input_conv.pstrb;
  `uvm_info("apb_master_seq_item_conv_class",$sformatf("After randomize pstrb =  %b",output_conv.pstrb),UVM_HIGH);

  //output_conv.pslverr = input_conv.pslverr;
  $cast(output_conv.pslverr,input_conv.pslverr);
  `uvm_info("apb_master_seq_item_conv_class",$sformatf("After randomize pslverr =  %b",output_conv.pslverr),UVM_HIGH);

  output_conv.prdata = input_conv.prdata;
  `uvm_info("apb_master_seq_item_conv_class",$sformatf("Before randomize prdata =  %0h",output_conv.prdata),UVM_HIGH);
  
  output_conv.no_of_wait_states = input_conv.no_of_wait_states_detected;
  `uvm_info("apb_master_seq_item_conv_class",$sformatf("After randomize no_of_wait_states =  %d",
                                             output_conv.no_of_wait_states),UVM_HIGH);

  `uvm_info("apb_master_seq_item_conv_class",$sformatf("-------------------------------------------------------------"),UVM_HIGH);
 
endfunction : from_class 

//--------------------------------------------------------------------------------------------
// Function: to_class
// Converting struct data items into seq_item transactions
//
// Parameters:
// name - apb_master_tx, apb_transfer_char_s
//--------------------------------------------------------------------------------------------
function void apb_master_seq_item_converter::to_class(input apb_transfer_char_s input_conv, ref apb_master_tx output_conv_h);

  `uvm_info("apb_master_seq_item_conv",$sformatf("-------------------------------------------------------------------"),UVM_HIGH);
  
  $cast(output_conv_h.pprot,input_conv.pprot);
  `uvm_info("apb_master_seq_item_conv_class",$sformatf("After randomize pprot =  %b",output_conv_h.pprot),UVM_HIGH);
 
  $cast(output_conv_h.pselx,input_conv.pselx);
  `uvm_info("apb_master_seq_item_conv_class",$sformatf("After randomize pselx =  %b",output_conv_h.pselx),UVM_HIGH);

  $cast(output_conv_h.pwrite,input_conv.pwrite);
  `uvm_info("apb_master_seq_item_conv_class",$sformatf("After randomize pwrite =  %0h",output_conv_h.pwrite),UVM_HIGH);
  
  output_conv_h.paddr = input_conv.paddr;
  `uvm_info("apb_master_seq_item_conv_class",$sformatf("After randomize paddr =  %0h",output_conv_h.paddr),UVM_HIGH);

  output_conv_h.pwdata = input_conv.pwdata;
  `uvm_info("apb_master_seq_item_conv_class",$sformatf("After randomize pwdata =  %0h",output_conv_h.pwdata),UVM_HIGH);

  output_conv_h.pstrb = input_conv.pstrb;
  `uvm_info("apb_master_seq_item_conv_class",$sformatf("After randomize pwdta =  %b",output_conv_h.pstrb),UVM_HIGH);
 
  $cast(output_conv_h.pslverr,input_conv.pslverr);
  `uvm_info("apb_master_seq_item_conv_class",$sformatf("After randomize pslverr =  %b",output_conv_h.pslverr),UVM_HIGH);  

  output_conv_h.prdata = input_conv.prdata;
  `uvm_info("apb_master_seq_item_conv_class",$sformatf("After randomize prdata =  %0h",output_conv_h.prdata),UVM_HIGH);

  output_conv_h.no_of_wait_states_detected = input_conv.no_of_wait_states;
  `uvm_info("apb_master_seq_item_conv_class",$sformatf("After randomize no_of_wait_states =  %d",
                                              output_conv_h.no_of_wait_states_detected),UVM_HIGH);

  `uvm_info("apb_master_seq_item_conv",$sformatf("-------------------------------------------------------------------"),UVM_HIGH);
    
endfunction : to_class

//--------------------------------------------------------------------------------------------
// Function : do_print method
//  Print method can be added to display the data members values
//---------------------------------------------------------------------------------------------
function void apb_master_seq_item_converter::do_print(uvm_printer printer);
  apb_transfer_char_s apb_st;
  super.do_print(printer);

  printer.print_field("pwdata",apb_st.pwdata,$bits(apb_st.pwdata),UVM_DEC);
  printer.print_field("prdata",apb_st.prdata,$bits(apb_st.pwdata),UVM_DEC);
  printer.print_field("pprot",apb_st.pprot,$bits(apb_st.pprot),UVM_BIN);
  printer.print_field("pselx",apb_st.pselx,$bits(apb_st.pselx),UVM_BIN);
  printer.print_field("pwrite",apb_st.pwrite,$bits(apb_st.pwrite),UVM_BIN);
  printer.print_field("pstrb",apb_st.pstrb,$bits(apb_st.pstrb),UVM_BIN);
  printer.print_field("pslverr",apb_st.pslverr,$bits(apb_st.pslverr),UVM_BIN);

endfunction : do_print  

`endif
  
