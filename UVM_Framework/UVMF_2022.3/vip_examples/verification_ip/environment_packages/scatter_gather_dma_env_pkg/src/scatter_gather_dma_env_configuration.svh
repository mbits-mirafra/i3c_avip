//----------------------------------------------------------------------
// Created with uvmf_gen version 2021.1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: THis is the configuration for the scatter_gather_dma environment.
//  it contains configuration classes for each agent.  It also contains
//  environment level configuration variables.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class scatter_gather_dma_env_configuration #(
             int dma_done_rsc_WIDTH = 1
             )
extends uvmf_environment_configuration_base;

  `uvm_object_param_utils( scatter_gather_dma_env_configuration #(
                           dma_done_rsc_WIDTH
                           ))


//Constraints for the configuration variables:


  covergroup scatter_gather_dma_configuration_cg;
    // pragma uvmf custom covergroup begin
    option.auto_bin_max=1024;
    // pragma uvmf custom covergroup end
  endgroup


    typedef ccs_configuration#(
                .WIDTH(1)
                ) dma_done_rsc_config_t;
    rand dma_done_rsc_config_t dma_done_rsc_config;



    scatter_gather_dma_qvip_env_configuration     scatter_gather_dma_qvip_subenv_config;
    string                                   scatter_gather_dma_qvip_subenv_interface_names[];
    uvmf_active_passive_t                    scatter_gather_dma_qvip_subenv_interface_activity[];

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
// This function constructs the configuration object for each agent in the environment.
//
  function new( string name = "" );
    super.new( name );


    dma_done_rsc_config = dma_done_rsc_config_t::type_id::create("dma_done_rsc_config");

    scatter_gather_dma_qvip_subenv_config = scatter_gather_dma_qvip_env_configuration::type_id::create("scatter_gather_dma_qvip_subenv_config");
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
     
     "\n", dma_done_rsc_config.convert2string,

     "\n", scatter_gather_dma_qvip_subenv_config.convert2string
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
    scatter_gather_dma_qvip_subenv_interface_names    = new[2];
    scatter_gather_dma_qvip_subenv_interface_activity = new[2];

    scatter_gather_dma_qvip_subenv_interface_names     = interface_names[0:1];
    scatter_gather_dma_qvip_subenv_interface_activity  = interface_activity[0:1];


  // Interface initialization for local agents
     dma_done_rsc_config.initialize( interface_activity[2], {environment_path,".dma_done_rsc"}, interface_names[2]);
     dma_done_rsc_config.initiator_responder = RESPONDER;
     // dma_done_rsc_config.has_coverage = 1;



     scatter_gather_dma_qvip_subenv_config.initialize( sim_level, {environment_path,".scatter_gather_dma_qvip_subenv"}, scatter_gather_dma_qvip_subenv_interface_names, null,   scatter_gather_dma_qvip_subenv_interface_activity);

     dma_done_rsc_config.reset_polarity = 0;
     dma_done_rsc_config.protocol_kind = CCS_WAIT;

  // pragma uvmf custom initialize begin
  // pragma uvmf custom initialize end

  endfunction

endclass

