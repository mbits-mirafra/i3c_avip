`ifndef I3C_CONTROLLER_COVERAGE_INCLUDED_
`define I3C_CONTROLLER_COVERAGE_INCLUDED_

class i3c_controller_coverage extends uvm_subscriber#(i3c_controller_tx);
 `uvm_component_utils(i3c_controller_coverage)

i3c_controller_agent_config i3c_controller_agent_cfg_h;
 
covergroup i3c_controller_coverage with function sample(i3c_controller_agent_config cfg, i3c_controller_tx packet);
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
   option.comment = "Data size of the packet transfer";
   bins WRITEDATA_WIDTH_1 = {8};
   bins WRITEDATA_WIDTH_2 = {16};
   bins WRITEDATA_WIDTH_3 = {24};
   bins WRITEDATA_WIDTH_4 = {32};
   bins WRITEDATA_WIDTH_5 = {64};
   bins WRITEDATA_WIDTH_6 = {[72:MAXIMUM_BITS]};
 }

/*
   READDATA_CP : coverpoint packet.readData{
   option.comment = "readData";
master_coverage.sv   bins READDATA = {[0:$]};
   }

*/
  endgroup : i3c_controller_coverage

  extern function new(string name = "i3c_controller_coverage", uvm_component parent = null);
  extern virtual function void display();
  extern virtual function void write(i3c_controller_tx t);
  extern virtual function void report_phase(uvm_phase phase);

endclass : i3c_controller_coverage


function i3c_controller_coverage::new(string name = "i3c_controller_coverage", uvm_component parent = null);
  super.new(name, parent);
  i3c_controller_coverage  = new(); 
endfunction : new


function void  i3c_controller_coverage::display();  
  $display("");
  $display("--------------------------------------");
  $display(" COVERAGE");
  $display("--------------------------------------");
  $display("");
endfunction : display


function void i3c_controller_coverage::write(i3c_controller_tx t);
//  // TODO(mshariff): 
  `uvm_info("MUNEEB_DEBUG", $sformatf("Config values = %0s",i3c_controller_agent_cfg_h.sprint()), UVM_HIGH);
   i3c_controller_coverage.sample(i3c_controller_agent_cfg_h,t);     
endfunction: write

function void i3c_controller_coverage::report_phase(uvm_phase phase);
display(); 
`uvm_info(get_type_name(), $sformatf("controller Agent Coverage = %0.2f %%",i3c_controller_coverage.get_coverage()), UVM_NONE);
//  `uvm_info(get_type_name(), $sformatf("controller Agent Coverage") ,UVM_NONE);
endfunction: report_phase
`endif

