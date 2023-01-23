//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Nov 30
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : gpio_example Environment 
// Unit            : Environment configuration
// File            : gpio_example_env_configuration.svh
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: THis is the configuration for the gpio_example environment.
//  it contains configuration classes for each agent.  It also contains
//  environment level configuration variables.
//
//
//
//----------------------------------------------------------------------
//
class gpio_example_env_configuration 
extends uvmf_environment_configuration_base;

  `uvm_object_utils( gpio_example_env_configuration ); 


//Constraints for the configuration variables:

  covergroup gpio_example_configuration_cg;
    option.auto_bin_max=1024;
  endgroup


    typedef gpio_configuration #(.WRITE_PORT_WIDTH(32),.READ_PORT_WIDTH(16)) gpio_a_config_t;
    gpio_a_config_t gpio_a_config;

    typedef gpio_configuration #(.WRITE_PORT_WIDTH(16),.READ_PORT_WIDTH(32)) gpio_b_config_t;
    gpio_b_config_t gpio_b_config;



// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
// This function constructs the configuration object for each agent in the environment.
//
  function new( string name = "" );
    super.new( name );


    gpio_a_config = gpio_a_config_t::type_id::create("gpio_a_config");
    gpio_b_config = gpio_b_config_t::type_id::create("gpio_b_config");


  endfunction
// ****************************************************************************
// FUNCTION: convert2string()
// This function converts all variables in this class to a single string for
// logfile reporting. This function concatenates the convert2string result for
// each agent configuration in this configuration class.
//
  virtual function string convert2string();
    return {
     
     "\n", gpio_a_config.convert2string,
     "\n", gpio_b_config.convert2string


       };

  endfunction
// ****************************************************************************
// FUNCTION: initialize();
// This function configures each interface agents configuration class.  The 
// sim level determines the active/passive state of the agent.  The environment_path
// identifies the hierarchy down to and including the instantiation name of the
// environment for this configuration class.  Each instance of the environment 
// has its own configuration class.  The string interface names are used by 
// the agent configurations to identify the virtual interface handle to pull from
// the uvm_config_db.  
//
  function void initialize(uvmf_sim_level_t sim_level, 
                                      string environment_path,
                                      string interface_names[],
                                      uvm_reg_block register_model = null,
                                      uvmf_active_passive_t interface_activity[] = null
                                     );


    super.initialize(sim_level, environment_path, interface_names, register_model, interface_activity);


     gpio_a_config.initialize( interface_activity[0], {environment_path,".gpio_a"}, interface_names[0]);
     gpio_a_config.initiator_responder = INITIATOR;
     gpio_b_config.initialize( interface_activity[1], {environment_path,".gpio_b"}, interface_names[1]);
     gpio_b_config.initiator_responder = INITIATOR;




  endfunction

endclass

