`ifndef I3C_TARGET_COVERAGE_INCLUDED_
`define I3C_TARGET_COVERAGE_INCLUDED_

class i3c_target_coverage extends uvm_subscriber#(i3c_target_tx);
  `uvm_component_utils(i3c_target_coverage)

 covergroup target_covergroup with function sample (i3c_target_tx packet);
  option.per_instance = 1;
  
     
   OPERATION_CP : coverpoint packet.operation{
   option.comment = "Operation";
   bins OPERATION_WRITE = {0};
   bins OPERATION_READ = {1};
   }

  TARGET_ADDRESS_CP : coverpoint packet.targetAddress{
   option.comment = "TargetAddress";
   bins TARGETADDRESS = {[8:119]};
   illegal_bins RESERVEDADDRESS = {[0:7],[120:127]};
 }

   TARGET_ADDRESS_STATUS_CP : coverpoint packet.targetAddressStatus{
   option.comment = "targetAddressStatus";
   bins TARGET_ADDRESS_STATUS_ACK = {0};
   bins TARGET_ADDRESS_STATUS_NACK = {1};
  }

  WRITEDATA_CP : coverpoint packet.writeData.size()*DATA_WIDTH {
   option.comment = "writeData size of the packet transfer";
   bins WRITEDATA_WIDTH_1 = {8};
   bins WRITEDATA_WIDTH_2 = {16};
   bins WRITEDATA_WIDTH_3 = {24};
   bins WRITEDATA_WIDTH_4 = {32};
   bins WRITEDATA_WIDTH_5 = {64};
   bins WRITEDATA_WIDTH_6 = {[72:MAXIMUM_BITS]};
 }

  READDATA_CP : coverpoint packet.readData.size()*DATA_WIDTH {
   option.comment = "readData size of the packet transfer";
   bins READDATA_WIDTH_1 = {8};
   bins READDATA_WIDTH_2 = {16};
   bins READDATA_WIDTH_3 = {24};
   bins READDATA_WIDTH_4 = {32};
   bins READDATA_WIDTH_5 = {64};
   bins READDATA_WIDTH_6 = {[72:MAXIMUM_BITS]};
 }

 WRITEDATA_STATUS_CP : coverpoint packet.writeDataStatus.size()==1 {
  option.comment = "writeData status";
  bins WRITEDATA_STATUS_ACK= {0};
  bins WRITEDATA_STATUS_NACK= {1};
}

  READDATA_STATUS_CP : coverpoint packet.readDataStatus.size()==1 {
  option.comment = "readData status";
  bins READDATA_STATUS_ACK= {0};
  bins READDATA_STATUS_NACK= {1};
}

OPERATION_CP_X_WRITEDATA_CP:cross OPERATION_CP, WRITEDATA_CP;

OPERATION_CP_X_READDATA_CP:cross OPERATION_CP, READDATA_CP;

  endgroup :target_covergroup


   extern function new(string name = "i3c_target_coverage", uvm_component parent = null);
  extern virtual function void display();
  extern virtual function void write(i3c_target_tx t);
  extern virtual function void report_phase(uvm_phase phase);

endclass : i3c_target_coverage

function i3c_target_coverage::new(string name = "i3c_target_coverage", uvm_component parent = null);
  super.new(name, parent);
   target_covergroup = new(); 
endfunction : new

function void i3c_target_coverage::display();
  $display("");
  $display("--------------------------------------");
  $display("target COVERAGE");
  $display("--------------------------------------");
  $display("");
endfunction : display

function void i3c_target_coverage::write(i3c_target_tx t);
 `uvm_info("DEBUG_m_coverage", $sformatf("I3C_target_TX %0p",t),UVM_NONE);
    target_covergroup.sample(t);     
endfunction: write

function void i3c_target_coverage::report_phase(uvm_phase phase);
  display();
 `uvm_info(get_type_name(), $sformatf("target Agent Coverage = %0.2f %%",
                                       target_covergroup.get_coverage()), UVM_NONE);
endfunction: report_phase
`endif

