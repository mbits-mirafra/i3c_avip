`ifndef I3C_TARGET_TX_INCLUDED_
`define I3C_TARGET_TX_INCLUDED_

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

  constraint readDataSizeMax_c{
             soft readData.size() == MAXIMUM_BYTES;}

  constraint targetAddressStatus_c { 
                targetAddressStatus dist { 
                      ACK  :=40, 
                      NACK :=60 };}

  constraint writeDataStatusSize_c{ 
             soft writeDataStatus.size() == MAXIMUM_BYTES;}
 
  constraint writeDataStatusValue_c{foreach(writeDataStatus[i])
                                      soft writeDataStatus[i] == ACK;}

  extern function new(string name = "i3c_target_tx");
  extern function void do_copy(uvm_object rhs);
  extern function bit do_compare(uvm_object rhs, 
                            uvm_comparer comparer); 
  extern function void do_print(uvm_printer printer);
endclass : i3c_target_tx

function i3c_target_tx::new(string name = "i3c_target_tx");
  super.new(name);
endfunction : new

function void i3c_target_tx::do_copy (uvm_object rhs);
  i3c_target_tx target_rhs;
  
  if(!$cast(target_rhs,rhs)) begin
    `uvm_fatal("do_copy","cast of the rhs object failed")
  end
  super.do_copy(rhs);

  targetAddress = target_rhs.targetAddress;
  targetAddressStatus = target_rhs.targetAddressStatus;
  operation = target_rhs.operation;
  writeData = target_rhs.writeData;
  writeDataStatus = target_rhs.writeDataStatus;
  readData = target_rhs.readData;
  readDataStatus = target_rhs.readDataStatus;

endfunction : do_copy

function bit  i3c_target_tx::do_compare (uvm_object rhs,uvm_comparer comparer);
  i3c_target_tx target_rhs;

  if(!$cast(target_rhs,rhs)) begin
  `uvm_fatal("FATAL_I3C_target_TX_DO_COMPARE_FAILED","cast of the rhs object failed")
  return 0;
  end

  return super.do_compare(rhs,comparer) &&
  targetAddress == target_rhs.targetAddress &&
  targetAddressStatus == target_rhs.targetAddressStatus &&
  operation == target_rhs.operation &&
  writeData == target_rhs.writeData &&
  writeDataStatus == target_rhs.writeDataStatus &&
  readData == target_rhs.readData &&
  readDataStatus == target_rhs.readDataStatus;
endfunction : do_compare 

function void i3c_target_tx::do_print(uvm_printer printer);
  super.do_print(printer);

  printer.print_field($sformatf("targetAddress"),this.targetAddress,$bits(targetAddress),UVM_HEX);
  printer.print_string($sformatf("targetAddressStatus"),targetAddressStatus.name());
  printer.print_string($sformatf("operation"),operation.name());

  if(operation == WRITE) begin
    foreach(writeData[i]) begin
      printer.print_field($sformatf("writeData[%0d]",i),this.writeData[i],$bits(writeData[i]),UVM_HEX);
    end

    foreach(writeDataStatus[i]) begin
      printer.print_string($sformatf("writeDataStatus[%0d]",i),writeDataStatus[i].name());
    end
  end else begin
  
    foreach(readData[i]) begin
      printer.print_field($sformatf("readData[%0d]",i),this.readData[i],$bits(readData[i]),UVM_HEX);
    end
  
    foreach(readDataStatus[i]) begin
      printer.print_string($sformatf("readDataStatus[%0d]",i),readDataStatus[i].name());
    end
  end
endfunction
`endif

