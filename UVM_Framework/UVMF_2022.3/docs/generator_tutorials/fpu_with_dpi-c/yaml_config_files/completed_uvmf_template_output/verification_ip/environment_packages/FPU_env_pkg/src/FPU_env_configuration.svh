//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU Environment 
// Unit            : Environment configuration
// File            : FPU_env_configuration.svh
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: THis is the configuration for the FPU environment.
//  it contains configuration classes for each agent.  It also contains
//  environment level configuration variables.
//
//
//
//----------------------------------------------------------------------
//
class FPU_env_configuration 
extends uvmf_environment_configuration_base;

  `uvm_object_utils( FPU_env_configuration ); 


//Constraints for the configuration variables:


  covergroup FPU_configuration_cg;
    option.auto_bin_max=1024;
  endgroup


    typedef FPU_in_configuration FPU_in_agent_config_t;
    FPU_in_agent_config_t FPU_in_agent_config;

    typedef FPU_out_configuration FPU_out_agent_config_t;
    FPU_out_agent_config_t FPU_out_agent_config;





// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
// This function constructs the configuration object for each agent in the environment.
//
  function new( string name = "" );
    super.new( name );


    FPU_in_agent_config = FPU_in_agent_config_t::type_id::create("FPU_in_agent_config");
    FPU_out_agent_config = FPU_out_agent_config_t::type_id::create("FPU_out_agent_config");


  endfunction

// ****************************************************************************
// FUNCTION: post_randomize()
// This function is automatically called after the randomize() function 
// is executed.
//
  function void post_randomize();
    super.post_randomize();


    if(!FPU_in_agent_config.randomize()) `uvm_fatal("RAND","FPU_in_agent randomization failed");
    if(!FPU_out_agent_config.randomize()) `uvm_fatal("RAND","FPU_out_agent randomization failed");

  endfunction
  
// ****************************************************************************
// FUNCTION: convert2string()
// This function converts all variables in this class to a single string for
// logfile reporting. This function concatenates the convert2string result for
// each agent configuration in this configuration class.
//
  virtual function string convert2string();
    return {
     
     "\n", FPU_in_agent_config.convert2string,
     "\n", FPU_out_agent_config.convert2string


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



  // Interface initialization for local agents
     FPU_in_agent_config.initialize( interface_activity[0], {environment_path,".FPU_in_agent"}, interface_names[0]);
     FPU_in_agent_config.initiator_responder = INITIATOR;
     FPU_out_agent_config.initialize( interface_activity[1], {environment_path,".FPU_out_agent"}, interface_names[1]);
     FPU_out_agent_config.initiator_responder = INITIATOR;





  endfunction

endclass

