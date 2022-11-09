`ifndef I3C_SLAVE_TX_INCLUDED_
`define I3C_SLAVE_TX_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: i3c_slave_tx
// <Description_here>
//--------------------------------------------------------------------------------------------
class i3c_slave_tx extends uvm_sequence_item;
  `uvm_object_utils(i3c_slave_tx)

  rand read_write_e read_write;
  rand bit [SLAVE_ADDRESS_WIDTH-1:0] slave_address;
  rand bit[31:0] size;
  rand bit [DATA_WIDTH-1:0] wr_data[];
  rand bit [DATA_WIDTH-1:0] rd_data[];

  bit ack;
  
  rand bit [NO_OF_SLAVES-1:0] index; 
  rand bit [7:0] raddr; 

 // bit [SLAVE_ADDRESS_WIDTH-1:0]slave_address;
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
  extern function new(string name = "i3c_slave_tx");

endclass : i3c_slave_tx

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - i3c_slave_tx
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function i3c_slave_tx::new(string name = "i3c_slave_tx");

  super.new(name);
endfunction : new

`endif

