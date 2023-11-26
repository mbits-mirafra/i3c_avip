`ifndef I3C_TARGET_TX_INCLUDED_
`define I3C_TARGET_TX_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: i3c_target_tx
//--------------------------------------------------------------------------------------------
class i3c_target_tx extends uvm_sequence_item;
  `uvm_object_utils(i3c_target_tx)

       operationType_e operation;
  rand bit [DATA_WIDTH-1:0] readData[];
  rand acknowledge_e writeDataStatus[];
       bit [DATA_WIDTH-1:0] writeData[];
       bit [TARGET_ADDRESS_WIDTH-1:0] targetAddress;
  rand bit[31:0] size;

  
  // rand read_write_e read_write;


  bit ack;
  
  rand bit [NO_OF_TARGETS-1:0] index; 
  rand bit [7:0] raddr; 

 // bit [TARGET_ADDRESS_WIDTH1:0]targetAddress;
 // bit [REGISTER_ADDRESS_WIDTH-1:0]register_address;
 // bit [DATA_WIDTH-1:0]data[];
 // bit ack;
 // 
 // 
 // // Receiving data fields
 // bit slave_add_ack;
 // bit reg_add_ack;
 // bit wr_data_ack[$];
  
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "i3c_target_tx");

endclass : i3c_target_tx

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - i3c_target_tx
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function i3c_target_tx::new(string name = "i3c_target_tx");

  super.new(name);
endfunction : new

`endif

