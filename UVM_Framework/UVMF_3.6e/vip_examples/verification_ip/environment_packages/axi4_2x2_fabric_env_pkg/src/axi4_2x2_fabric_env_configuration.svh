//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : daerne
// Creation Date   : 2016 Oct 16
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : axi4_2x2_fabric Environment 
// Unit            : Environment configuration
// File            : axi4_2x2_fabric_env_configuration.svh
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: THis is the configuration for the axi4_2x2_fabric environment.
//  it contains configuration classes for each agent.  It also contains
//  environment level configuration variables.
//
//
//
//----------------------------------------------------------------------
//
class axi4_2x2_fabric_env_configuration 
            #(
             int AXI4_ADDRESS_WIDTH = 32,                                
             int AXI4_RDATA_WIDTH = 32,                                
             int AXI4_WDATA_WIDTH = 32,                                
             int AXI4_MASTER_ID_WIDTH = 4,                                
             int AXI4_SLAVE_ID_WIDTH = 5,                                
             int AXI4_USER_WIDTH = 4,                                
             int AXI4_REGION_MAP_SIZE = 16                                
             )
extends uvmf_environment_configuration_base;

  `uvm_object_param_utils( axi4_2x2_fabric_env_configuration #(
                           AXI4_ADDRESS_WIDTH,
                           AXI4_RDATA_WIDTH,
                           AXI4_WDATA_WIDTH,
                           AXI4_MASTER_ID_WIDTH,
                           AXI4_SLAVE_ID_WIDTH,
                           AXI4_USER_WIDTH,
                           AXI4_REGION_MAP_SIZE
                         ))


//Constraints for the configuration variables:

  covergroup axi4_2x2_fabric_configuration_cg;
    option.auto_bin_max=1024;
  endgroup



    axi4_2x2_fabric_qvip_env_configuration            qvip_env_config;

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
// This function constructs the configuration object for each agent in the environment.
//
  function new( string name = "" );
    super.new( name );



    qvip_env_config = axi4_2x2_fabric_qvip_env_configuration::type_id::create("qvip_env_config");

  endfunction
// ****************************************************************************
// FUNCTION: convert2string()
// This function converts all variables in this class to a single string for
// logfile reporting. This function concatenates the convert2string result for
// each agent configuration in this configuration class.
//
  virtual function string convert2string();
    return {
     


     "\n", qvip_env_config.convert2string
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

    string                qvip_env_interface_names[];
    uvmf_active_passive_t qvip_env_interface_activity[];

    super.initialize(sim_level, environment_path, interface_names, register_model, interface_activity);


    qvip_env_interface_names    = new[4];
    qvip_env_interface_activity = new[4];

    qvip_env_interface_names     = interface_names[0:3];
    qvip_env_interface_activity  = interface_activity[0:3];



     qvip_env_config.initialize( NA, {environment_path,".qvip_env"}, qvip_env_interface_names, null,   qvip_env_interface_activity);


  endfunction

endclass

