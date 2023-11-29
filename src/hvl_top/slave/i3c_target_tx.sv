`ifndef I3C_TARGET_TX_INCLUDED_
`define I3C_TARGET_TX_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: i3c_target_tx
//--------------------------------------------------------------------------------------------
class i3c_target_tx extends uvm_sequence_item;
  `uvm_object_utils(i3c_target_tx)

  rand bit [DATA_WIDTH-1:0] readData[];
  rand acknowledge_e targetAddressStatus;  
  rand acknowledge_e writeDataStatus[];
  
       operationType_e operation;
       bit [TARGET_ADDRESS_WIDTH-1:0] targetAddress;
       bit [DATA_WIDTH-1:0] writeData[];
       acknowledge_e readDataStatus[];

  rand bit[31:0] size;  
  // rand read_write_e read_write;

  constraint readDataSizeMax_c{
          soft readData.size() == MAXIMUM_BYTES;}

  constraint targetAddressStatus_c { 
                targetAddressStatus dist { 
                      ACK:=40, NACK:=60};}

  constraint writeDataStatusSize_c{ 
                soft writeDataStatus.size() ==MAXIMUM_BYTES;}

  constraint operationWRITExwriteDataStatusSize_c{
                      if(operation==WRITE)
                        writeDataStatus.size() >0;
                      else
                        writeDataStatus.size() ==0;}
  
 constraint operationREADxreadDataSize_c{
                      if(operation==READ)
                        readData.size() >0;
                      else
                        readData.size() ==0;}
  
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

