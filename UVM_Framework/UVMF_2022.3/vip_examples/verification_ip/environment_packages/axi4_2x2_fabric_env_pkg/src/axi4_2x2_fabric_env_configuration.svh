//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_5
//----------------------------------------------------------------------
// Created by: Vijay Gill
// E-mail:     vijay_gill@mentor.com
// Date:       2019/11/05
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: THis is the configuration for the axi4_2x2_fabric environment.
//  it contains configuration classes for each agent.  It also contains
//  environment level configuration variables.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class axi4_2x2_fabric_env_configuration 
extends uvmf_environment_configuration_base;

  `uvm_object_utils( axi4_2x2_fabric_env_configuration )


//Constraints for the configuration variables:


  covergroup axi4_2x2_fabric_configuration_cg;
    // pragma uvmf custom covergroup begin
    option.auto_bin_max=1024;
    // pragma uvmf custom covergroup end
  endgroup




    axi4_2x2_fabric_qvip_env_configuration     axi4_qvip_subenv_config;
    string                                   axi4_qvip_subenv_interface_names[];
    uvmf_active_passive_t                    axi4_qvip_subenv_interface_activity[];

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
// This function constructs the configuration object for each agent in the environment.
//
  function new( string name = "" );
    super.new( name );



    axi4_qvip_subenv_config = axi4_2x2_fabric_qvip_env_configuration::type_id::create("axi4_qvip_subenv_config");
  // pragma uvmf custom new begin
  // pragma uvmf custom new end
  endfunction

// ****************************************************************************
// FUNCTION: post_randomize()
// This function is automatically called after the randomize() function 
// is executed.
//
  function void post_randomize();
    super.post_randomize();
    // pragma uvmf custom post_randomize begin

    // pragma uvmf custom post_randomize end

  endfunction
  
// ****************************************************************************
// FUNCTION: convert2string()
// This function converts all variables in this class to a single string for
// logfile reporting. This function concatenates the convert2string result for
// each agent configuration in this configuration class.
//
  virtual function string convert2string();
    // pragma uvmf custom convert2string begin
    return {
     


     "\n", axi4_qvip_subenv_config.convert2string
       };
    // pragma uvmf custom convert2string end
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
                                      uvmf_active_passive_t interface_activity[] = {}
                                     );

    super.initialize(sim_level, environment_path, interface_names, register_model, interface_activity);


  // Interface initialization for QVIP sub-environments
    axi4_qvip_subenv_interface_names    = new[4];
    axi4_qvip_subenv_interface_activity = new[4];

    axi4_qvip_subenv_interface_names     = interface_names[0:3];
    axi4_qvip_subenv_interface_activity  = interface_activity[0:3];





     axi4_qvip_subenv_config.initialize( sim_level, {environment_path,".axi4_qvip_subenv"}, axi4_qvip_subenv_interface_names, null,   axi4_qvip_subenv_interface_activity);


  // pragma uvmf custom initialize begin
  // pragma uvmf custom initialize end

  endfunction

endclass

