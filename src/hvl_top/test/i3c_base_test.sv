`ifndef I3C_BASE_TEST_INCLUDED_
`define I3C_BASE_TEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: i3c_base_test
// <Description_here>
//--------------------------------------------------------------------------------------------
class i3c_base_test extends uvm_test;
  `uvm_component_utils(i3c_base_test)

  i3c_env i3c_env_h;
  i3c_env_config i3c_env_cfg_h;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "i3c_base_test", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void setup_env_cfg();
  extern virtual function void setup_controller_agent_cfg();
  extern virtual function void setup_target_agent_cfg();
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass : i3c_base_test

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - i3c_base_test
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function i3c_base_test::new(string name = "i3c_base_test",uvm_component parent = null);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void i3c_base_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  
  i3c_env_cfg_h = i3c_env_config::type_id::create("i3c_env_cfg_h");
  i3c_env_h = i3c_env::type_id::create("i3c_env_h",this);
  setup_env_cfg();
endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Function:setup_env_cfg()
//--------------------------------------------------------------------------------------------


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

  // TODO(mshariff): Call the required check functions                                                          
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
    
  // TODO(mshariff): Call the required check functions                                                          
    `uvm_info(get_type_name(),$sformatf("i3c_target_agent_cfg = \n %0p",
    i3c_env_cfg_h.i3c_target_agent_cfg_h[i].sprint()),UVM_NONE)
  end
  
  uvm_config_db #(i3c_env_config)::set(this,"*","i3c_env_config",i3c_env_cfg_h);
  `uvm_info(get_type_name(),$sformatf("i3c_env_cfg = \n %0p", i3c_env_cfg_h.sprint()),UVM_NONE)

  
 endfunction: setup_env_cfg

//--------------------------------------------------------------------------------------------
// Function: setup_controller_agent_cfg
// Setup the controller agent configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
function void i3c_base_test::setup_controller_agent_cfg();
  
  foreach(i3c_env_cfg_h.i3c_controller_agent_cfg_h[i])begin

    i3c_env_cfg_h.i3c_controller_agent_cfg_h[i].set_clockrate_divider_value(.primary_prescalar(1),
                                                                  .secondary_prescalar(0));
     // Configure the controller agent configuration
    i3c_env_cfg_h.i3c_controller_agent_cfg_h[i].isActive     = uvm_active_passive_enum'(UVM_ACTIVE);
    i3c_env_cfg_h.i3c_controller_agent_cfg_h[i].no_of_targets  = NO_OF_TARGETS;
    i3c_env_cfg_h.i3c_controller_agent_cfg_h[i].DataTransferdirection     = dataTransferDirection_e'(MSB_FIRST);
    i3c_env_cfg_h.i3c_controller_agent_cfg_h[i].hasCoverage  = 1;

    // Stores all the target addresses
    i3c_env_cfg_h.i3c_controller_agent_cfg_h[i].targetAddress = new[NO_OF_TARGETS]; 
    i3c_env_cfg_h.i3c_controller_agent_cfg_h[i].targetAddress[0] = TARGET0_ADDRESS;
    //i3c_env_cfg_h.i3c_controller_agent_cfg_h[i].target_address_array[1] = SLAVE1_ADDRESS;
    //i3c_env_cfg_h.i3c_controller_agent_cfg_h[i].target_address_array[2] = SLAVE2_ADDRESS;
    //i3c_env_cfg_h.i3c_controller_agent_cfg_h[i].target_address_array[3] = SLAVE3_ADDRESS;

    // MSHA:target_address_array = new[NO_OF_SLAVES];

    // MSHA:// TODO(mshariff): Make this logic work for many targets
    // MSHA:// Create a check for unique values
    // MSHA:target_address_array[0] = 7'b110_1000;
    // MSHA:target_address_array[1] = 7'b110_1100;
    // MSHA:target_address_array[2] = 7'b111_1100;
    // MSHA:target_address_array[3] = 7'b100_1100;


    // MSHA:// Create a check for unique values
    // MSHA:// Check to see if there are only 2**8 = 256 registers are there for each target
    // MSHA:// For each register we need to store 32bits of data
    // MSHA:register_address_array[8'h0000_0000] = 0;
    // MSHA:register_address_array[8'h0000_0000] = 0;
    // MSHA:register_address_array[8'h0000_0000] = 0;
    // MSHA:register_address_array[8'h0000_0000] = 0;

  end

endfunction: setup_controller_agent_cfg

//--------------------------------------------------------------------------------------------
// Function: setup_target_agents_cfg
// Setup the target agent(s) configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
function void i3c_base_test::setup_target_agent_cfg();

  foreach(i3c_env_cfg_h.i3c_controller_agent_cfg_h[i]) begin    
  end

  // Create target agent(s) configurations
  // Setting the configuration for each target
  // target 0 
  i3c_env_cfg_h.i3c_target_agent_cfg_h[0].targetAddress[0] = TARGET0_ADDRESS;
  i3c_env_cfg_h.i3c_target_agent_cfg_h[0].isActive    = uvm_active_passive_enum'(UVM_ACTIVE);
  i3c_env_cfg_h.i3c_target_agent_cfg_h[0].DataTransferdirection    = dataTransferDirection_e'(MSB_FIRST);
  i3c_env_cfg_h.i3c_target_agent_cfg_h[0].hasCoverage = 1;

  // target 1
  //i3c_env_cfg_h.i3c_target_agent_cfg_h[1].slave_address = SLAVE1_ADDRESS;
  //i3c_env_cfg_h.i3c_target_agent_cfg_h[1].is_active    = uvm_active_passive_enum'(UVM_ACTIVE);
  //i3c_env_cfg_h.i3c_target_agent_cfg_h[1].DataTransferdirection    = dataTransferDirection_e'(MSB_FIRST);
  //i3c_env_cfg_h.i3c_target_agent_cfg_h[1].hasCoverage = 1;

  //// target 2
  //i3c_env_cfg_h.i3c_target_agent_cfg_h[2].slave_address = SLAVE2_ADDRESS;
  //i3c_env_cfg_h.i3c_target_agent_cfg_h[2].is_active    = uvm_active_passive_enum'(UVM_ACTIVE);
  //i3c_env_cfg_h.i3c_target_agent_cfg_h[2].DataTransferdirection    = dataTransferDirection_e'(MSB_FIRST);
  //i3c_env_cfg_h.i3c_target_agent_cfg_h[2].hasCoverage = 1;
  //
  //// target 3
  //i3c_env_cfg_h.i3c_target_agent_cfg_h[3].slave_address = SLAVE3_ADDRESS;
  //i3c_env_cfg_h.i3c_target_agent_cfg_h[3].is_active    = uvm_active_passive_enum'(UVM_ACTIVE);
  //i3c_env_cfg_h.i3c_target_agent_cfg_h[3].DataTransferdirection    = dataTransferDirection_e'(MSB_FIRST);
  //i3c_env_cfg_h.i3c_target_agent_cfg_h[3].hasCoverage = 1;

  // TODO(mshariff): 

endfunction: setup_target_agent_cfg

//--------------------------------------------------------------------------------------------
// Function: end_of_elaboration_phase
// Used for printing the testbench topology
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void i3c_base_test::end_of_elaboration_phase(uvm_phase phase);
  uvm_top.print_topology();
endfunction : end_of_elaboration_phase

//--------------------------------------------------------------------------------------------
// Task: run_phase
// Used for giving basic delay for simulation 
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
task i3c_base_test::run_phase(uvm_phase phase);

 // super.run_phase(phase);
  phase.raise_objection(this, "i3c_base_test");

  `uvm_info(get_type_name(), $sformatf("Inside I3C_BASE_TEST"), UVM_NONE);
  super.run_phase(phase);

  #100;
  
  `uvm_info(get_type_name(), $sformatf("Done I3C_BASE_TEST"), UVM_NONE);
  phase.drop_objection(this);

endtask : run_phase
`endif

