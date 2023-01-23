//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: THis is the configuration for the wb2spi environment.
//  it contains configuration classes for each agent.  It also contains
//  environment level configuration variables.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class wb2spi_env_configuration #(
             int WB_DATA_WIDTH = 16,
             int WB_ADDR_WIDTH = 32
             )
extends uvmf_environment_configuration_base;

  `uvm_object_param_utils( wb2spi_env_configuration #(
                           WB_DATA_WIDTH,
                           WB_ADDR_WIDTH
                           ))


//Constraints for the configuration variables:

// Instantiate the register model
  wb2spi_reg_model  wb2spi_rm;

  covergroup wb2spi_configuration_cg;
    // pragma uvmf custom covergroup begin
    option.auto_bin_max=1024;
  // pragma uvmf custom covergroup end
  endgroup


    typedef wb_configuration#(
                .WB_DATA_WIDTH(WB_DATA_WIDTH),
                .WB_ADDR_WIDTH(WB_ADDR_WIDTH)
                ) wb_config_t;
    wb_config_t wb_config;

    typedef spi_configuration spi_config_t;
    spi_config_t spi_config;




  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
// This function constructs the configuration object for each agent in the environment.
//
  function new( string name = "" );
    super.new( name );


    wb_config = wb_config_t::type_id::create("wb_config");
    spi_config = spi_config_t::type_id::create("spi_config");

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

    if(!wb_config.randomize()) `uvm_fatal("RAND","wb randomization failed");
    if(!spi_config.randomize()) `uvm_fatal("RAND","spi randomization failed");

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
     
     "\n", wb_config.convert2string,
     "\n", spi_config.convert2string


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



  // Interface initialization for local agents
     wb_config.initialize( interface_activity[0], {environment_path,".wb"}, interface_names[0]);
     wb_config.initiator_responder = INITIATOR;
     spi_config.initialize( interface_activity[1], {environment_path,".spi"}, interface_names[1]);
     spi_config.initiator_responder = RESPONDER;

    // pragma uvmf custom reg_model_config_initialize begin
    // Register model creation and configuation
    if (register_model == null) begin
      wb2spi_rm = wb2spi_reg_model
      ::type_id::create("wb2spi_rm");
      wb2spi_rm.build();
      enable_reg_adaptation = 1;
      enable_reg_prediction = 1;
    end else begin
      $cast(wb2spi_rm,register_model);
      enable_reg_prediction = 1;
    end
    // pragma uvmf custom reg_model_config_initialize end



  // pragma uvmf custom initialize begin
  // pragma uvmf custom initialize end

  endfunction

endclass

