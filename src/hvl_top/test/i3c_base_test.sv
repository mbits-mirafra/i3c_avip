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
  extern virtual function void setup_master_agent_cfg();
  extern virtual function void setup_slave_agent_cfg();
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
  
  i3c_env_cfg_h.no_of_masters = NO_OF_MASTERS;
  i3c_env_cfg_h.no_of_slaves = NO_OF_SLAVES;
  i3c_env_cfg_h.has_scoreboard = 1;
  i3c_env_cfg_h.has_virtual_sequencer = 1;

  i3c_env_cfg_h.i3c_master_agent_cfg_h = new[i3c_env_cfg_h.no_of_masters];
  foreach (i3c_env_cfg_h.i3c_master_agent_cfg_h[i])begin
    i3c_env_cfg_h.i3c_master_agent_cfg_h[i] = i3c_master_agent_config::type_id::create($sformatf(
                                                                "i3c_master_agent_cfg_h[%0d]",i));
  end
  setup_master_agent_cfg();
  
  foreach (i3c_env_cfg_h.i3c_master_agent_cfg_h[i])begin
    uvm_config_db
    #(i3c_master_agent_config)::set(this,$sformatf("*i3c_master_agent_h[%0d]*",i),
                                "i3c_master_agent_config",i3c_env_cfg_h.i3c_master_agent_cfg_h[i]);

  // TODO(mshariff): Call the required check functions                                                          
  `uvm_info(get_type_name(),$sformatf("i3c_master_agent_cfg = \n %0p",
                                   i3c_env_cfg_h.i3c_master_agent_cfg_h[i].sprint()),UVM_NONE)

  end
  
  i3c_env_cfg_h.i3c_slave_agent_cfg_h = new[i3c_env_cfg_h.no_of_slaves];
  
  foreach (i3c_env_cfg_h.i3c_slave_agent_cfg_h[i])begin
    i3c_env_cfg_h.i3c_slave_agent_cfg_h[i] = i3c_slave_agent_config::type_id::create($sformatf
                                                              ("i3c_slave_agent_cfg_h[%0d]",i));
  end
  setup_slave_agent_cfg();
  
  
  
  foreach(i3c_env_cfg_h.i3c_slave_agent_cfg_h[i]) begin
    uvm_config_db #(i3c_slave_agent_config)::set(this,$sformatf("*i3c_slave_agent_h[%0d]*",i),
                             "i3c_slave_agent_config", i3c_env_cfg_h.i3c_slave_agent_cfg_h[i]);
    
  // TODO(mshariff): Call the required check functions                                                          
    `uvm_info(get_type_name(),$sformatf("i3c_slave_agent_cfg = \n %0p",
    i3c_env_cfg_h.i3c_slave_agent_cfg_h[i].sprint()),UVM_NONE)
  end
  
  uvm_config_db #(i3c_env_config)::set(this,"*","i3c_env_config",i3c_env_cfg_h);
  `uvm_info(get_type_name(),$sformatf("i3c_env_cfg = \n %0p", i3c_env_cfg_h.sprint()),UVM_NONE)

  
 endfunction: setup_env_cfg

//--------------------------------------------------------------------------------------------
// Function: setup_master_agent_cfg
// Setup the master agent configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
function void i3c_base_test::setup_master_agent_cfg();
  
  foreach(i3c_env_cfg_h.i3c_master_agent_cfg_h[i])begin

    i3c_env_cfg_h.i3c_master_agent_cfg_h[i].set_baudrate_divisor(.primary_prescalar(1),
                                                                  .secondary_prescalar(0));
     // Configure the Master agent configuration
    i3c_env_cfg_h.i3c_master_agent_cfg_h[i].is_active     = uvm_active_passive_enum'(UVM_ACTIVE);
    i3c_env_cfg_h.i3c_master_agent_cfg_h[i].no_of_slaves  = NO_OF_SLAVES;
    i3c_env_cfg_h.i3c_master_agent_cfg_h[i].shift_dir     = shift_direction_e'(MSB_FIRST);
    i3c_env_cfg_h.i3c_master_agent_cfg_h[i].has_coverage  = 1;

    // Stores all the Slave addresses
    i3c_env_cfg_h.i3c_master_agent_cfg_h[i].slave_address_array = new[NO_OF_SLAVES]; 
    i3c_env_cfg_h.i3c_master_agent_cfg_h[i].slave_address_array[0] = SLAVE0_ADDRESS;
    //i3c_env_cfg_h.i3c_master_agent_cfg_h[i].slave_address_array[1] = SLAVE1_ADDRESS;
    //i3c_env_cfg_h.i3c_master_agent_cfg_h[i].slave_address_array[2] = SLAVE2_ADDRESS;
    //i3c_env_cfg_h.i3c_master_agent_cfg_h[i].slave_address_array[3] = SLAVE3_ADDRESS;

    // MSHA:slave_address_array = new[NO_OF_SLAVES];

    // MSHA:// TODO(mshariff): Make this logic work for many slaves
    // MSHA:// Create a check for unique values
    // MSHA:slave_address_array[0] = 7'b110_1000;
    // MSHA:slave_address_array[1] = 7'b110_1100;
    // MSHA:slave_address_array[2] = 7'b111_1100;
    // MSHA:slave_address_array[3] = 7'b100_1100;


    // MSHA:// Create a check for unique values
    // MSHA:// Check to see if there are only 2**8 = 256 registers are there for each slave
    // MSHA:// For each register we need to store 32bits of data
    // MSHA:register_address_array[8'h0000_0000] = 0;
    // MSHA:register_address_array[8'h0000_0000] = 0;
    // MSHA:register_address_array[8'h0000_0000] = 0;
    // MSHA:register_address_array[8'h0000_0000] = 0;

  end

endfunction: setup_master_agent_cfg

//--------------------------------------------------------------------------------------------
// Function: setup_slave_agents_cfg
// Setup the slave agent(s) configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
function void i3c_base_test::setup_slave_agent_cfg();

  foreach(i3c_env_cfg_h.i3c_master_agent_cfg_h[i]) begin    
  end

  // Create slave agent(s) configurations
  // Setting the configuration for each slave
  // Slave 0 
  i3c_env_cfg_h.i3c_slave_agent_cfg_h[0].slave_address = SLAVE0_ADDRESS;
  i3c_env_cfg_h.i3c_slave_agent_cfg_h[0].is_active    = uvm_active_passive_enum'(UVM_ACTIVE);
  i3c_env_cfg_h.i3c_slave_agent_cfg_h[0].shift_dir    = shift_direction_e'(MSB_FIRST);
  i3c_env_cfg_h.i3c_slave_agent_cfg_h[0].has_coverage = 1;

  // Slave 1
  //i3c_env_cfg_h.i3c_slave_agent_cfg_h[1].slave_address = SLAVE1_ADDRESS;
  //i3c_env_cfg_h.i3c_slave_agent_cfg_h[1].is_active    = uvm_active_passive_enum'(UVM_ACTIVE);
  //i3c_env_cfg_h.i3c_slave_agent_cfg_h[1].shift_dir    = shift_direction_e'(MSB_FIRST);
  //i3c_env_cfg_h.i3c_slave_agent_cfg_h[1].has_coverage = 1;

  //// Slave 2
  //i3c_env_cfg_h.i3c_slave_agent_cfg_h[2].slave_address = SLAVE2_ADDRESS;
  //i3c_env_cfg_h.i3c_slave_agent_cfg_h[2].is_active    = uvm_active_passive_enum'(UVM_ACTIVE);
  //i3c_env_cfg_h.i3c_slave_agent_cfg_h[2].shift_dir    = shift_direction_e'(MSB_FIRST);
  //i3c_env_cfg_h.i3c_slave_agent_cfg_h[2].has_coverage = 1;
  //
  //// Slave 3
  //i3c_env_cfg_h.i3c_slave_agent_cfg_h[3].slave_address = SLAVE3_ADDRESS;
  //i3c_env_cfg_h.i3c_slave_agent_cfg_h[3].is_active    = uvm_active_passive_enum'(UVM_ACTIVE);
  //i3c_env_cfg_h.i3c_slave_agent_cfg_h[3].shift_dir    = shift_direction_e'(MSB_FIRST);
  //i3c_env_cfg_h.i3c_slave_agent_cfg_h[3].has_coverage = 1;

  // TODO(mshariff): 

endfunction: setup_slave_agent_cfg

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

