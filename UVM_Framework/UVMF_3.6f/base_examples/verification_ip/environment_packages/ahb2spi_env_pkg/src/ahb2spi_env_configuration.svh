//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 14
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb2spi Environment 
// Unit            : Environment configuration
// File            : ahb2spi_env_configuration.svh
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: THis is the configuration for the ahb2spi environment.
//  it contains configuration classes for each agent.  It also contains
//  environment level configuration variables.
//
//
//
//----------------------------------------------------------------------
//
class ahb2spi_env_configuration #(int WB_ADDR_WIDTH = 32,int WB_DATA_WIDTH = 16) extends uvmf_environment_configuration_base;

  `uvm_object_param_utils( ahb2spi_env_configuration#(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH)) );


//Constraints for the configuration variables:

  covergroup ahb2spi_configuration_cg;
    option.auto_bin_max=1024;
  endgroup

   ahb2wb_env_configuration#(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH)) ahb2wb_env_config;
   wb2spi_env_configuration#(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH)) wb2spi_env_config;

  ahb2spi_reg_block     reg_model;

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
// This function constructs the configuration object for each agent in the environment.
//
  function new( string name = "" );
    super.new( name );

   ahb2wb_env_config = ahb2wb_env_configuration#(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH))::type_id::create("ahb2wb_env_config");
   wb2spi_env_config = wb2spi_env_configuration#(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH))::type_id::create("wb2spi_env_config");



  endfunction
// ****************************************************************************
// FUNCTION: convert2string()
// This function converts all variables in this class to a single string for
// logfile reporting. This function concatenates the convert2string result for
// each agent configuration in this configuration class.
//
  virtual function string convert2string();
    return {
     

     "\n", ahb2wb_env_config.convert2string,
     "\n", wb2spi_env_config.convert2string

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
    string                ahb2wb_env_interface_names[];
    uvmf_active_passive_t ahb2wb_env_interface_activity[];
    string                wb2spi_env_interface_names[];
    uvmf_active_passive_t wb2spi_env_interface_activity[];


    super.initialize(sim_level, environment_path, interface_names, register_model, interface_activity);

    ahb2wb_env_interface_names    = new[2];
    ahb2wb_env_interface_activity = new[2];

    ahb2wb_env_interface_names     = interface_names[0:1];
    ahb2wb_env_interface_activity  = interface_activity[0:1];

    wb2spi_env_interface_names    = new[2];
    wb2spi_env_interface_activity = new[2];

    wb2spi_env_interface_names     = interface_names[2:3];
    wb2spi_env_interface_activity  = interface_activity[2:3];

    if (register_model == null) begin
      reg_model = ahb2spi_reg_block::type_id::create("reg_model");
      reg_model.build();

      enable_reg_adaptation = 1;
      wb2spi_env_config.enable_reg_prediction = 1;
    end

     ahb2wb_env_config.initialize( NA, {environment_path,".ahb2wb_env"}, ahb2wb_env_interface_names, null,             ahb2wb_env_interface_activity);
     wb2spi_env_config.initialize( NA, {environment_path,".wb2spi_env"}, wb2spi_env_interface_names, reg_model.wb2spi, wb2spi_env_interface_activity);



  endfunction

endclass

