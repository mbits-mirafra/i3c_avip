`ifndef I3C_WRITEOPERATIONWITHLSBDATADIRECTION_TEST_INCLUDED_ 
`define I3C_WRITEOPERATIONWITHLSBDATADIRECTION_TEST_INCLUDED_ 

class i3c_writeOperationWithLSBDataDirection_test extends i3c_writeOperationWithRandomDataTransferWidth_test;
  `uvm_component_utils(i3c_writeOperationWithLSBDataDirection_test)

  dataTransferDirection_e dataDirection = LSB_FIRST;

  extern function new(string name = "i3c_writeOperationWithLSBDataDirection_test", uvm_component parent = null);
  extern virtual function void setup_controller_agent_cfg();
  extern virtual function void setup_target_agent_cfg();
endclass : i3c_writeOperationWithLSBDataDirection_test

function i3c_writeOperationWithLSBDataDirection_test::new(string name = "i3c_writeOperationWithLSBDataDirection_test",
                                 uvm_component parent = null);
  super.new(name, parent);
endfunction : new

function void i3c_writeOperationWithLSBDataDirection_test::setup_controller_agent_cfg();
  super.setup_controller_agent_cfg();

  foreach(i3c_env_cfg_h.i3c_controller_agent_cfg_h[i])begin

    i3c_env_cfg_h.i3c_controller_agent_cfg_h[i].dataTransferDirection = dataDirection;

  end
endfunction: setup_controller_agent_cfg

function void i3c_writeOperationWithLSBDataDirection_test::setup_target_agent_cfg();
  super.setup_target_agent_cfg();

  // Create target agent(s) configurations
  // Setting the configuration for each target
  // target 0 
  i3c_env_cfg_h.i3c_target_agent_cfg_h[0].dataTransferDirection = dataDirection; 

endfunction: setup_target_agent_cfg

`endif
