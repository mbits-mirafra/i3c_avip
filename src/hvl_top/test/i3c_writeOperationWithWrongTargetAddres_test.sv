`ifndef I3C_WRITEOPERATIONWITHWRONGTARGETADDRES_TEST_INCLUDED_
`define I3C_WRITEOPERATIONWITHWRONGTARGETADDRES_TEST_INCLUDED_

class i3c_writeOperationWithWrongTargetAddres_test extends i3c_base_test;
  `uvm_component_utils(i3c_writeOperationWithWrongTargetAddres_test)

  i3c_virtual_writeOperationWith8bitsData_seq i3c_virtual_writeOperationWith8bitsData_seq_h;

  extern function new(string name = "i3c_writeOperationWithWrongTargetAddres_test", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void setup_controller_agent_cfg();
  extern virtual task run_phase(uvm_phase phase);

endclass : i3c_writeOperationWithWrongTargetAddres_test

function i3c_writeOperationWithWrongTargetAddres_test::new(string name = "i3c_writeOperationWithWrongTargetAddres_test",
                                 uvm_component parent = null);
  super.new(name, parent);
endfunction : new

function void i3c_writeOperationWithWrongTargetAddres_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction : build_phase

function void i3c_writeOperationWithWrongTargetAddres_test::setup_controller_agent_cfg();
super.setup_controller_agent_cfg();    
  foreach(i3c_env_cfg_h.i3c_controller_agent_cfg_h[i])begin
   i3c_env_cfg_h.i3c_controller_agent_cfg_h[i].targetAddress[0] = TARGET1_ADDRESS;
 end
endfunction: setup_controller_agent_cfg


task i3c_writeOperationWithWrongTargetAddres_test::run_phase(uvm_phase phase);

  i3c_virtual_writeOperationWith8bitsData_seq_h = i3c_virtual_writeOperationWith8bitsData_seq::type_id::create("i3c_virtual_writeOperationWith8bitsData_seq_h");

  phase.raise_objection(this);

  i3c_virtual_writeOperationWith8bitsData_seq_h.start(i3c_env_h.i3c_virtual_seqr_h); 
  #20;

  phase.drop_objection(this);

endtask : run_phase

`endif


