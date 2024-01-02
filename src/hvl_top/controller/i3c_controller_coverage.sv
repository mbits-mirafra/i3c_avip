`ifndef I3C_CONTROLLER_COVERAGE_INCLUDED_
`define I3C_CONTROLLER_COVERAGE_INCLUDED_

class i3c_controller_coverage extends uvm_subscriber#(i3c_controller_tx);
 `uvm_component_utils(i3c_controller_coverage)

i3c_controller_agent_config i3c_controller_agent_cfg_h;
 
covergroup i3c_controller_covergroup with function sample(i3c_controller_agent_config cfg, i3c_controller_tx packet);
   option.per_instance = 1;
   
  OPERATION_CP : coverpoint packet.operation{
   option.comment = "Operation";
   bins OPERATION = {0,1};
  } 

  TARGET_ADRRESS_CP : coverpoint packet.targetAddress{
   option.comment = "TargetAddress";
   bins TARGETADDRESS = {[0:$]};
  }

  TARGET_ADDRESS_STATUS_CP : coverpoint packet.targetAddressStatus{
   option.comment = "targetAddressStatus";
   bins TARGET_ADDRESS_STATUS = {0,1};
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
  bins WRITEDATA_STATUS = {1,0};
}

  READDATA_STATUS_CP : coverpoint packet.readDataStatus.size()==1 {
  option.comment = "readData status";
  bins READDATA_STATUS = {1,0};
}
  endgroup : i3c_controller_covergroup

  extern function new(string name = "i3c_controller_coverage", uvm_component parent = null);
  extern virtual function void display();
  extern virtual function void write(i3c_controller_tx t);
  extern virtual function void report_phase(uvm_phase phase);

endclass : i3c_controller_coverage


function i3c_controller_coverage::new(string name = "i3c_controller_coverage", uvm_component parent = null);
  super.new(name, parent);
  i3c_controller_covergroup = new(); 
endfunction : new


function void  i3c_controller_coverage::display();  
  $display("");
  $display("--------------------------------------");
  $display(" COVERAGE");
  $display("--------------------------------------");
  $display("");
endfunction : display


function void i3c_controller_coverage::write(i3c_controller_tx t);
 `uvm_info(get_type_name(), $sformatf("Config values = %0s",i3c_controller_agent_cfg_h.sprint()), UVM_HIGH);
  i3c_controller_covergroup.sample(i3c_controller_agent_cfg_h,t);     
endfunction: write

function void i3c_controller_coverage::report_phase(uvm_phase phase);
display(); 
`uvm_info(get_type_name(), $sformatf("controller Agent Coverage = %0.2f %%",i3c_controller_covergroup.get_coverage()), UVM_NONE);
endfunction: report_phase
`endif

