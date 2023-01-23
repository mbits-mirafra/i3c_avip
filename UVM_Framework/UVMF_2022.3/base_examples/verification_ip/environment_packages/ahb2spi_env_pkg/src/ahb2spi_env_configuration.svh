//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: THis is the configuration for the ahb2spi environment.
//  it contains configuration classes for each agent.  It also contains
//  environment level configuration variables.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class ahb2spi_env_configuration #(
             int WB_DATA_WIDTH = 16,
             int WB_ADDR_WIDTH = 32
             )
extends uvmf_environment_configuration_base;

  `uvm_object_param_utils( ahb2spi_env_configuration #(
                           WB_DATA_WIDTH,
                           WB_ADDR_WIDTH
                           ))


//Constraints for the configuration variables:

// Instantiate the register model
  ahb2spi_reg_model  ahb2spi_rm;

  covergroup ahb2spi_configuration_cg;
    // pragma uvmf custom covergroup begin
    option.auto_bin_max=1024;
  // pragma uvmf custom covergroup end
  endgroup

typedef ahb2wb_env_configuration#(
                .WB_DATA_WIDTH(WB_DATA_WIDTH),
                .WB_ADDR_WIDTH(WB_ADDR_WIDTH)
                ) ahb2wb_config_t;
ahb2wb_config_t ahb2wb_config;

typedef wb2spi_env_configuration#(
                .WB_DATA_WIDTH(WB_DATA_WIDTH),
                .WB_ADDR_WIDTH(WB_ADDR_WIDTH)
                ) wb2spi_config_t;
wb2spi_config_t wb2spi_config;



    string                ahb2wb_interface_names[];
    uvmf_active_passive_t ahb2wb_interface_activity[];
    string                wb2spi_interface_names[];
    uvmf_active_passive_t wb2spi_interface_activity[];


  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
// This function constructs the configuration object for each agent in the environment.
//
  function new( string name = "" );
    super.new( name );

   ahb2wb_config = ahb2wb_config_t::type_id::create("ahb2wb_config");
   wb2spi_config = wb2spi_config_t::type_id::create("wb2spi_config");


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
   if(!ahb2wb_config.randomize()) `uvm_fatal("RAND","ahb2wb randomization failed");
   if(!wb2spi_config.randomize()) `uvm_fatal("RAND","wb2spi randomization failed");


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
     

     "\n", ahb2wb_config.convert2string,
     "\n", wb2spi_config.convert2string

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

  // Interface initialization for sub-environments
    ahb2wb_interface_names    = new[2];
    ahb2wb_interface_activity = new[2];

    ahb2wb_interface_names     = interface_names[0:1];
    ahb2wb_interface_activity  = interface_activity[0:1];
    wb2spi_interface_names    = new[2];
    wb2spi_interface_activity = new[2];

    wb2spi_interface_names     = interface_names[2:3];
    wb2spi_interface_activity  = interface_activity[2:3];


    // pragma uvmf custom reg_model_config_initialize begin
    // Register model creation and configuation
    if (register_model == null) begin
      ahb2spi_rm = ahb2spi_reg_model::type_id::create("ahb2spi_rm");
      ahb2spi_rm.build();
      enable_reg_adaptation = 1;
      enable_reg_prediction = 1;
    end else begin
      $cast(ahb2spi_rm,register_model);
      enable_reg_prediction = 0;
    end
    // pragma uvmf custom reg_model_config_initialize end

     ahb2wb_config.initialize( sim_level, {environment_path,".ahb2wb"}, ahb2wb_interface_names, null,   ahb2wb_interface_activity);
     wb2spi_config.initialize( sim_level, {environment_path,".wb2spi"}, wb2spi_interface_names, ahb2spi_rm.wb2spi_rm,   wb2spi_interface_activity);



  // pragma uvmf custom initialize begin
  // pragma uvmf custom initialize end

  endfunction

endclass

