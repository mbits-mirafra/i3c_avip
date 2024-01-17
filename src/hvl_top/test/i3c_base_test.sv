`ifndef I3C_BASE_TEST_INCLUDED_
`define I3C_BASE_TEST_INCLUDED_

class i3c_base_test extends uvm_test;
  `uvm_component_utils(i3c_base_test)

  i3c_env i3c_env_h;
  i3c_env_config i3c_env_cfg_h;

  extern function new(string name = "i3c_base_test", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void setup_env_cfg();
  extern virtual function void setup_controller_agent_cfg();
  extern virtual function void setup_target_agent_cfg();
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
endclass : i3c_base_test

function i3c_base_test::new(string name = "i3c_base_test",uvm_component parent = null);
  super.new(name, parent);
endfunction : new

function void i3c_base_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  i3c_env_cfg_h = i3c_env_config::type_id::create("i3c_env_cfg_h");
  i3c_env_h = i3c_env::type_id::create("i3c_env_h",this);
  setup_env_cfg();
endfunction : build_phase


function void i3c_base_test::setup_env_cfg();
  
  i3c_env_cfg_h.no_of_controllers = NO_OF_CONTROLLERS;
  i3c_env_cfg_h.no_of_targets = NO_OF_TARGETS;
  i3c_env_cfg_h.has_scoreboard = 1;
  i3c_env_cfg_h.has_virtual_sequencer = 1;

  i3c_env_cfg_h.i3c_controller_agent_cfg_h = new[i3c_env_cfg_h.no_of_controllers];
  foreach (i3c_env_cfg_h.i3c_controller_agent_cfg_h[i])begin
    i3c_env_cfg_h.i3c_controller_agent_cfg_h[i] = i3c_controller_agent_config::type_id::create($sformatf(
                                                                "i3c_controller_agent_cfg_h[%0d]",i));
  end
  setup_controller_agent_cfg();
  
  foreach (i3c_env_cfg_h.i3c_controller_agent_cfg_h[i])begin
    uvm_config_db
    #(i3c_controller_agent_config)::set(this,$sformatf("*i3c_controller_agent_h[%0d]*",i),
                                "i3c_controller_agent_config",i3c_env_cfg_h.i3c_controller_agent_cfg_h[i]);

    `uvm_info(get_type_name(),$sformatf("i3c_controller_agent_cfg = \n %0p",
                                   i3c_env_cfg_h.i3c_controller_agent_cfg_h[i].sprint()),UVM_NONE)
  end
  
  i3c_env_cfg_h.i3c_target_agent_cfg_h = new[i3c_env_cfg_h.no_of_targets];
  
  foreach (i3c_env_cfg_h.i3c_target_agent_cfg_h[i])begin
    i3c_env_cfg_h.i3c_target_agent_cfg_h[i] = i3c_target_agent_config::type_id::create($sformatf
                                                              ("i3c_target_agent_cfg_h[%0d]",i));
  end
  setup_target_agent_cfg();
  
  foreach(i3c_env_cfg_h.i3c_target_agent_cfg_h[i]) begin
    uvm_config_db #(i3c_target_agent_config)::set(this,$sformatf("*i3c_target_agent_h[%0d]*",i),
                             "i3c_target_agent_config", i3c_env_cfg_h.i3c_target_agent_cfg_h[i]);
    
    `uvm_info(get_type_name(),$sformatf("i3c_target_agent_cfg = \n %0p",
    i3c_env_cfg_h.i3c_target_agent_cfg_h[i].sprint()),UVM_NONE)
  end
  
  uvm_config_db #(i3c_env_config)::set(this,"*","i3c_env_config",i3c_env_cfg_h);
  `uvm_info(get_type_name(),$sformatf("i3c_env_cfg = \n %0p", i3c_env_cfg_h.sprint()),UVM_NONE)

endfunction: setup_env_cfg

function void i3c_base_test::setup_controller_agent_cfg();
    
  foreach(i3c_env_cfg_h.i3c_controller_agent_cfg_h[i])begin
    i3c_env_cfg_h.i3c_controller_agent_cfg_h[i].set_clockrate_divider_value(.primary_prescalar(1),
                                                                  .secondary_prescalar(0));
     // Configure the controller agent configuration
    i3c_env_cfg_h.i3c_controller_agent_cfg_h[i].isActive     = uvm_active_passive_enum'(UVM_ACTIVE);
    i3c_env_cfg_h.i3c_controller_agent_cfg_h[i].no_of_targets  = NO_OF_TARGETS;
    i3c_env_cfg_h.i3c_controller_agent_cfg_h[i].dataTransferDirection = dataTransferDirection_e'(MSB_FIRST);
    i3c_env_cfg_h.i3c_controller_agent_cfg_h[i].hasCoverage  = hasCoverage_e'(TRUE);

    // Stores all the target addresses
    i3c_env_cfg_h.i3c_controller_agent_cfg_h[i].targetAddress = new[NO_OF_TARGETS]; 
    i3c_env_cfg_h.i3c_controller_agent_cfg_h[i].targetAddress[0] = TARGET0_ADDRESS;
    //i3c_env_cfg_h.i3c_controller_agent_cfg_h[i].target_address_array[1] = SLAVE1_ADDRESS;
    //i3c_env_cfg_h.i3c_controller_agent_cfg_h[i].target_address_array[2] = SLAVE2_ADDRESS;
    //i3c_env_cfg_h.i3c_controller_agent_cfg_h[i].target_address_array[3] = SLAVE3_ADDRESS;
  end
endfunction: setup_controller_agent_cfg


function void i3c_base_test::setup_target_agent_cfg();

  // Create target agent(s) configurations
  // Setting the configuration for each target
  // target 0 
  i3c_env_cfg_h.i3c_target_agent_cfg_h[0].targetAddress = TARGET0_ADDRESS;
  i3c_env_cfg_h.i3c_target_agent_cfg_h[0].isActive    = uvm_active_passive_enum'(UVM_ACTIVE);
  i3c_env_cfg_h.i3c_target_agent_cfg_h[0].dataTransferDirection    = dataTransferDirection_e'(MSB_FIRST);
  i3c_env_cfg_h.i3c_target_agent_cfg_h[0].hasCoverage = hasCoverage_e'(TRUE);

endfunction: setup_target_agent_cfg

function void i3c_base_test::end_of_elaboration_phase(uvm_phase phase);
  uvm_top.print_topology();
endfunction : end_of_elaboration_phase

task i3c_base_test::run_phase(uvm_phase phase);

  phase.raise_objection(this, "i3c_base_test");
  `uvm_info(get_type_name(), $sformatf("Inside I3C_BASE_TEST"), UVM_NONE);
  super.run_phase(phase);
  #100;
  `uvm_info(get_type_name(), $sformatf("Done I3C_BASE_TEST"), UVM_NONE);
  phase.drop_objection(this);

endtask : run_phase
`endif

