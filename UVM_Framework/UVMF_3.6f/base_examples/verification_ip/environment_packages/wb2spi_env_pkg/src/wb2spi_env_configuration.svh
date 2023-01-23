//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 09
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : wb2spi Environment 
// Unit            : Environment configuration
// File            : wb2spi_env_configuration.svh
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: THis is the configuration for the wb2spi environment.
//  it contains configuration classes for each agent.  It also contains
//  environment level configuration variables.
//
//
//
//----------------------------------------------------------------------
//
class wb2spi_env_configuration #(int WB_DATA_WIDTH = 16, int WB_ADDR_WIDTH = 32) extends uvmf_environment_configuration_base;

  `uvm_object_param_utils( wb2spi_env_configuration#(.WB_DATA_WIDTH(WB_DATA_WIDTH),.WB_ADDR_WIDTH(WB_ADDR_WIDTH)) );


//Constraints for the configuration variables:

  covergroup wb2spi_configuration_cg;
    option.auto_bin_max=1024;
  endgroup


    wb_configuration #(.WB_DATA_WIDTH(WB_DATA_WIDTH),.WB_ADDR_WIDTH(WB_ADDR_WIDTH)) wb_config;
    spi_configuration spi_config;

  wb2spi_reg_block  reg_model;

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
// This function constructs the configuration object for each agent in the environment.
//
  function new( string name = "" );
    super.new( name );


    wb_config = wb_configuration#(.WB_DATA_WIDTH(WB_DATA_WIDTH),.WB_ADDR_WIDTH(WB_ADDR_WIDTH))::type_id::create("wb_config");
    wb_config.initiator_responder = INITIATOR;

    spi_config = spi_configuration::type_id::create("spi_config");
    spi_config.master_slave = SLAVE;



  endfunction
// ****************************************************************************
// FUNCTION: convert2string()
// This function converts all variables in this class to a single string for
// logfile reporting. This function concatenates the convert2string result for
// each agent configuration in this configuration class.
//
  virtual function string convert2string();
    return {
     
     "\n", wb_config.convert2string,
     "\n", spi_config.convert2string


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


     wb_config.initialize( interface_activity[0], {environment_path,".wb"}, interface_names[0]);
     spi_config.initialize( interface_activity[1], {environment_path,".spi"}, interface_names[1]);

    if (register_model == null) begin
      reg_model = wb2spi_reg_block::type_id::create("reg_model");
      reg_model.build();

      enable_reg_adaptation = 1;
      enable_reg_prediction = 1;
    end else begin
      $cast(reg_model,register_model);
      
      enable_reg_prediction = 1;
    end


  endfunction

endclass

