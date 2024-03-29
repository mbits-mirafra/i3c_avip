`ifndef I3C_CONTROLLER_TX_INCLUDED_
`define I3C_CONTROLLER_TX_INCLUDED_

class i3c_controller_tx extends uvm_sequence_item;
  `uvm_object_utils(i3c_controller_tx)

  // Reserved 8 address for first group 0000_XXX 
  typedef enum bit[6:0] {
    GRP0_RSVD0 = 7'b0000_000,
    GRP0_RSVD1 = 7'b0000_001,
    GRP0_RSVD2 = 7'b0000_010,
    GRP0_RSVD3 = 7'b0000_011,
    GRP0_RSVD4 = 7'b0000_100,
    GRP0_RSVD5 = 7'b0000_101,
    GRP0_RSVD6 = 7'b0000_110,
    GRP0_RSVD7 = 7'b0000_111
  } group0_e;

  // Reserved 8 address for second group 1111_XXX 
  typedef enum bit[6:0] {
    GRP1_RSVD0 = 7'b1111_000,
    GRP1_RSVD1 = 7'b1111_001,
    GRP1_RSVD2 = 7'b1111_010,
    GRP1_RSVD3 = 7'b1111_011,
    GRP1_RSVD4 = 7'b1111_100,
    GRP1_RSVD5 = 7'b1111_101,
    GRP1_RSVD6 = 7'b1111_110,
    GRP1_RSVD7 = 7'b1111_111
  } group1_e;

  rand operationType_e operation;
  rand bit [TARGET_ADDRESS_WIDTH-1:0] targetAddress;
  rand bit [DATA_WIDTH-1:0] writeData[];
  rand acknowledge_e readDataStatus[];

       bit [DATA_WIDTH-1:0] readData[];
       acknowledge_e targetAddressStatus;
       acknowledge_e writeDataStatus[];

  //-------------------------------------------------------
  // Constraints for I3C
  //-------------------------------------------------------
  
  // Basic support for not including two groups of 8 address
  // 0000 XXX (8 addresses) and 1111 XXX (8 addresses) 
  //
  constraint reservedTargetAddressGroup0_c {
    !(targetAddress inside {[GRP0_RSVD0 : GRP0_RSVD7]}) ; 
  }

  constraint reservedTargetAddressGroup1_c {
    !(targetAddress inside {[GRP1_RSVD0 : GRP1_RSVD7]}) ; 
  }


  constraint writeDataSize_c {
    writeData.size() <= MAXIMUM_BYTES;
  }
  
  constraint readDataStatusSize_c {
    readDataStatus.size() <= MAXIMUM_BYTES;
  }

  constraint readDataStatusValue_c{foreach(readDataStatus[i])
                                      soft readDataStatus[i] == ACK;}

  constraint operationWRITExwriteDataSize_c {
                    if(operation == WRITE) 
                      (writeData.size() > 0);
                    else 
                      writeData.size() == 0;}

  constraint operationREADxreadDataStatusSize_c {
                    if(operation == READ) 
                      (readDataStatus.size() > 0);
                    else 
                      readDataStatus.size() == 0;}


  extern function new(string name = "i3c_controller_tx");
  extern function void post_randomize();
  extern function void do_copy(uvm_object rhs);
  extern function bit do_compare(uvm_object rhs, 
                            uvm_comparer comparer); 
  extern function void do_print(uvm_printer printer);
  extern function bit[1:0] getWriteDataStatus();
  extern function bit[1:0] getReadDataStatus();

endclass : i3c_controller_tx

function i3c_controller_tx::new(string name = "i3c_controller_tx");
  super.new(name);
endfunction : new


function void i3c_controller_tx::do_copy (uvm_object rhs);
  i3c_controller_tx controller_rhs;
  
  if(!$cast(controller_rhs,rhs)) begin
    `uvm_fatal("do_copy","cast of the rhs object failed")
  end
  super.do_copy(rhs);

  targetAddress = controller_rhs.targetAddress;
  targetAddressStatus = controller_rhs.targetAddressStatus;
  operation = controller_rhs.operation;
  writeData = controller_rhs.writeData;
  writeDataStatus = controller_rhs.writeDataStatus;
  readData = controller_rhs.readData;
  readDataStatus = controller_rhs.readDataStatus;

endfunction : do_copy

function bit  i3c_controller_tx::do_compare (uvm_object rhs,uvm_comparer comparer);
  i3c_controller_tx controller_rhs;

  if(!$cast(controller_rhs,rhs)) begin
  `uvm_fatal("FATAL_I3C_controller_TX_DO_COMPARE_FAILED","cast of the rhs object failed")
  return 0;
  end

  return super.do_compare(rhs,comparer) &&
  targetAddress == controller_rhs.targetAddress &&
  targetAddressStatus == controller_rhs.targetAddressStatus &&
  operation == controller_rhs.operation &&
  writeData == controller_rhs.writeData &&
  writeDataStatus == controller_rhs.writeDataStatus &&
  readData == controller_rhs.readData &&
  readDataStatus == controller_rhs.readDataStatus;
endfunction : do_compare 


function void i3c_controller_tx::do_print(uvm_printer printer);
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

endfunction : do_print

function void i3c_controller_tx::post_randomize();
  readDataStatus[readDataStatus.size()-1] = NACK;
endfunction: post_randomize


function bit[1:0] i3c_controller_tx::getWriteDataStatus();
  int counterAckReceived;
  int counterNAckReceived;
  bit ack_value;
  bit nack_value;

  foreach(writeDataStatus[i]) begin
    if(writeDataStatus[i] == ACK) begin
      counterAckReceived++;
    end
    if(writeDataStatus[i] == NACK) begin
      counterNAckReceived++;
    end
  end

  ack_value = counterAckReceived > 0 ? ACK : NACK;
  nack_value = counterNAckReceived > 0 ? NACK : ACK;
  
  return ({ack_value, nack_value});
  
endfunction: getWriteDataStatus

function bit[1:0] i3c_controller_tx::getReadDataStatus();
  int counterAckReceived;
  int counterNAckReceived;
  bit ack_value;
  bit nack_value;

  foreach(readDataStatus[i]) begin
    if(readDataStatus[i] == ACK) begin
      counterAckReceived++;
    end
    if(readDataStatus[i] == NACK) begin
      counterNAckReceived++;
    end
  end

  ack_value = counterAckReceived > 0 ? ACK : NACK;
  nack_value = counterNAckReceived > 0 ? NACK : ACK;
  
  return ({ack_value, nack_value});
  
endfunction: getReadDataStatus 
`endif
