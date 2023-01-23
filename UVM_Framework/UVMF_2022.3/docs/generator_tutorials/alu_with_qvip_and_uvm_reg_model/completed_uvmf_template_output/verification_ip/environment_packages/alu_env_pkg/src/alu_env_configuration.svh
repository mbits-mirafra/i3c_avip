//----------------------------------------------------------------------
// Created with uvmf_gen version 2020.1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: THis is the configuration for the alu environment.
//  it contains configuration classes for each agent.  It also contains
//  environment level configuration variables.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class alu_env_configuration #(
             int ALU_IN_OP_WIDTH = 8,
             int ALU_OUT_RESULT_WIDTH = 16,
             int APB_ADDR_WIDTH = 32,
             int APB_WDATA_WIDTH = 32,
             int APB_RDATA_WIDTH = 32
             )
extends uvmf_environment_configuration_base;

  `uvm_object_param_utils( alu_env_configuration #(
                           ALU_IN_OP_WIDTH,
                           ALU_OUT_RESULT_WIDTH,
                           APB_ADDR_WIDTH,
                           APB_WDATA_WIDTH,
                           APB_RDATA_WIDTH
                           ))


//Constraints for the configuration variables:

// Instantiate the register model
  alu_reg_model  alu_rm;

  covergroup alu_configuration_cg;
    // pragma uvmf custom covergroup begin
    option.auto_bin_max=1024;
    // pragma uvmf custom covergroup end
  endgroup


    typedef alu_in_configuration#(
                .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)
                ) alu_in_agent_config_t;
    alu_in_agent_config_t alu_in_agent_config;

    typedef alu_out_configuration#(
                .ALU_OUT_RESULT_WIDTH(ALU_OUT_RESULT_WIDTH)
                ) alu_out_agent_config_t;
    alu_out_agent_config_t alu_out_agent_config;



    qvip_agents_env_configuration     qvip_agents_env_config;
    string                                   qvip_agents_env_interface_names[];
    uvmf_active_passive_t                    qvip_agents_env_interface_activity[];

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
// This function constructs the configuration object for each agent in the environment.
//
  function new( string name = "" );
    super.new( name );


    alu_in_agent_config = alu_in_agent_config_t::type_id::create("alu_in_agent_config");
    alu_out_agent_config = alu_out_agent_config_t::type_id::create("alu_out_agent_config");

    qvip_agents_env_config = qvip_agents_env_configuration::type_id::create("qvip_agents_env_config");
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

    if(!alu_in_agent_config.randomize()) `uvm_fatal("RAND","alu_in_agent randomization failed");
    if(!alu_out_agent_config.randomize()) `uvm_fatal("RAND","alu_out_agent randomization failed");
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
     
     "\n", alu_in_agent_config.convert2string,
     "\n", alu_out_agent_config.convert2string,

     "\n", qvip_agents_env_config.convert2string
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
    qvip_agents_env_interface_names    = new[1];
    qvip_agents_env_interface_activity = new[1];

    qvip_agents_env_interface_names     = interface_names[0:0];
    qvip_agents_env_interface_activity  = interface_activity[0:0];


  // Interface initialization for local agents
     alu_in_agent_config.initialize( interface_activity[1], {environment_path,".alu_in_agent"}, interface_names[1]);
     alu_in_agent_config.initiator_responder = INITIATOR;
     // alu_in_agent_config.has_coverage = 1;
     alu_out_agent_config.initialize( interface_activity[2], {environment_path,".alu_out_agent"}, interface_names[2]);
     alu_out_agent_config.initiator_responder = INITIATOR;
     // alu_out_agent_config.has_coverage = 1;

    // pragma uvmf custom reg_model_config_initialize begin
    // Register model creation and configuation
    if (register_model == null) begin
      alu_rm = alu_reg_model::type_id::create("alu_rm");
      alu_rm.build();
      alu_rm.lock_model();
      enable_reg_adaptation = 1;
      enable_reg_prediction = 1;
    end else begin
      $cast(alu_rm,register_model);
      enable_reg_prediction = 1;
    end
    // pragma uvmf custom reg_model_config_initialize end


     qvip_agents_env_config.initialize( sim_level, {environment_path,".qvip_agents_env"}, qvip_agents_env_interface_names, null,   qvip_agents_env_interface_activity);


  // pragma uvmf custom initialize begin
  // pragma uvmf custom initialize end

  endfunction

endclass

