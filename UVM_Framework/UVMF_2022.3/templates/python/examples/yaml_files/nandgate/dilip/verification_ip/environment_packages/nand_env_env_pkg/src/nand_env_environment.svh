//----------------------------------------------------------------------
// Created with uvmf_gen version 2022.3
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This environment contains all agents, predictors and
// scoreboards required for the block level design.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//

class nand_env_environment  extends uvmf_environment_base #(
    .CONFIG_T( nand_env_env_configuration 
  ));
  `uvm_component_utils( nand_env_environment )





  typedef nand_in_agent  nand_in_agent_t;
  nand_in_agent_t nand_in_agent;

  typedef nand_out_agent  nand_out_agent_t;
  nand_out_agent_t nand_out_agent;




  typedef nand_predictor #(
                .CONFIG_T(CONFIG_T)
                ) nand_pred_t;
  nand_pred_t nand_pred;
  typedef nand_scoreboard #(
                .CONFIG_T(CONFIG_T)
                ) nand_sco_t;
  nand_sco_t nand_sco;




  typedef uvmf_virtual_sequencer_base #(.CONFIG_T(nand_env_env_configuration)) nand_env_vsqr_t;
  nand_env_vsqr_t vsqr;

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end
 
// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
//
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

// ****************************************************************************
// FUNCTION: build_phase()
// This function builds all components within this environment.
//
  virtual function void build_phase(uvm_phase phase);
// pragma uvmf custom build_phase_pre_super begin
// pragma uvmf custom build_phase_pre_super end
    super.build_phase(phase);
    nand_in_agent = nand_in_agent_t::type_id::create("nand_in_agent",this);
    nand_in_agent.set_config(configuration.nand_in_agent_config);
    nand_out_agent = nand_out_agent_t::type_id::create("nand_out_agent",this);
    nand_out_agent.set_config(configuration.nand_out_agent_config);
    nand_pred = nand_pred_t::type_id::create("nand_pred",this);
    nand_pred.configuration = configuration;
    nand_sco = nand_sco_t::type_id::create("nand_sco",this);
    nand_sco.configuration = configuration;

    vsqr = nand_env_vsqr_t::type_id::create("vsqr", this);
    vsqr.set_config(configuration);
    configuration.set_vsqr(vsqr);

    // pragma uvmf custom build_phase begin
    // pragma uvmf custom build_phase end
  endfunction

// ****************************************************************************
// FUNCTION: connect_phase()
// This function makes all connections within this environment.  Connections
// typically inclue agent to predictor, predictor to scoreboard and scoreboard
// to agent.
//
  virtual function void connect_phase(uvm_phase phase);
// pragma uvmf custom connect_phase_pre_super begin
// pragma uvmf custom connect_phase_pre_super end
    super.connect_phase(phase);
    nand_in_agent.monitored_ap.connect(nand_pred.nand_in_agent_ae);
    nand_pred.nand_sco_ap.connect(nand_sco.nand_out_pred_sb_ae);
    nand_out_agent.monitored_ap.connect(nand_sco.nand_out_ag_sb_ae);
    // pragma uvmf custom reg_model_connect_phase begin
    // pragma uvmf custom reg_model_connect_phase end
  endfunction

// ****************************************************************************
// FUNCTION: end_of_simulation_phase()
// This function is executed just prior to executing run_phase.  This function
// was added to the environment to sample environment configuration settings
// just before the simulation exits time 0.  The configuration structure is 
// randomized in the build phase before the environment structure is constructed.
// Configuration variables can be customized after randomization in the build_phase
// of the extended test.
// If a sequence modifies values in the configuration structure then the sequence is
// responsible for sampling the covergroup in the configuration if required.
//
  virtual function void start_of_simulation_phase(uvm_phase phase);
     configuration.nand_env_configuration_cg.sample();
  endfunction

endclass

// pragma uvmf custom external begin
// pragma uvmf custom external end

