`ifndef I3C_CONTROLLER_COVERAGE_INCLUDED_
`define I3C_CONTROLLER_COVERAGE_INCLUDED_

class i3c_controller_coverage extends uvm_subscriber#(i3c_controller_tx);
 `uvm_component_utils(i3c_controller_coverage)

 i3c_controller_agent_config i3c_controller_agent_cfg_h;
 
covergroup controller_covergroup with function sample (i3c_controller_agent_config cfg, i3c_controller_tx packet);
   option.per_instance = 1;
   
   OPERATION_CP : coverpoint packet.operation{
   option.comment = "Operation";
   bins OPERATION = {0,1};
   }

   TARGET_ADRRESS_CP : coverpoint packet.targetAddress{
   option.comment = "TargetAddress";
   bins TARGETADDRESS = {[0:$]};
   }

/*   foreach(packet.writeData[i]) begin
   WRITEDATA_CP : coverpoint packet.writeData[0]{
   option.comment = "writeData";
   bins WRITEDATA = {[0:$]};
   } 
  end
   READDATA_CP : coverpoint packet.readData{
   option.comment = "readData";
   bins READDATA = {[0:$]};
   }

*/
  endgroup : controller_covergroup

  extern function new(string name = "i3c_controller_coverage", uvm_component parent = null);
  extern virtual function void write(i3c_controller_tx t);
  extern virtual function void report_phase(uvm_phase phase);

endclass : i3c_controller_coverage


function i3c_controller_coverage::new(string name = "i3c_controller_coverage", uvm_component parent = null);
  super.new(name, parent);
 controller_covergroup = new(); 
 //`uvm_info(get_type_name(),$sformatf(controller_cg),UVM_LOW); 
endfunction : new

function void i3c_controller_coverage::write(i3c_controller_tx t);
//  // TODO(mshariff): 
   controller_covergroup.sample(i3c_controller_agent_cfg_h,t);     
  // `uvm_info(get_type_name(),$sformatf("controller_cg=%0d",controller_cg),UVM_LOW);
//
 //  `uvm_info(get_type_name(),$sformatf(controller_cg),UVM_LOW);
//
endfunction: write

function void i3c_controller_coverage::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $sformatf("controller Agent Coverage = %0.2f %%",controller_covergroup.get_coverage()), UVM_NONE);
  `uvm_info(get_type_name(), $sformatf("controller Agent Coverage") ,UVM_NONE);
endfunction: report_phase
`endif

