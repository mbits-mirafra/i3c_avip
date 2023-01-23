//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 06
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb2wb Environment 
// Unit            : Environment configuration
// File            : ahb2wb_env_configuration.svh
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: THis is the configuration for the ahb2wb environment.
//  it contains configuration classes for each agent.  It also contains
//  environment level configuration variables.
//
//
//
//----------------------------------------------------------------------
//
class ahb2wb_env_configuration #(int WB_ADDR_WIDTH = 32,int WB_DATA_WIDTH = 16)
   extends uvmf_environment_configuration_base;

  `uvm_object_param_utils( ahb2wb_env_configuration#(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH)) );


//Constraints for the configuration variables:

  covergroup ahb2wb_configuration_cg;
    option.auto_bin_max=1024;
  endgroup


    ahb_configuration ahb_config;
    wb_configuration #(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH)) wb_config;


// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
// This function constructs the configuration object for each agent in the environment.
//
  function new( string name = "" );
    super.new( name );


    ahb_config = ahb_configuration::type_id::create("ahb_config");
    ahb_config.master_slave = MASTER;

    wb_config = wb_configuration#(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH))::type_id::create("wb_config");
    wb_config.initiator_responder = RESPONDER;


  endfunction
// ****************************************************************************
// FUNCTION: convert2string()
// This function converts all variables in this class to a single string for
// logfile reporting. This function concatenates the convert2string result for
// each agent configuration in this configuration class.
//
  virtual function string convert2string();
    return {
     
     "\n", ahb_config.convert2string,
     "\n", wb_config.convert2string


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


     ahb_config.initialize( interface_activity[0], {environment_path,".ahb"}, interface_names[0]);
     wb_config.initialize( interface_activity[1], {environment_path,".wb"}, interface_names[1]);




  endfunction

endclass

