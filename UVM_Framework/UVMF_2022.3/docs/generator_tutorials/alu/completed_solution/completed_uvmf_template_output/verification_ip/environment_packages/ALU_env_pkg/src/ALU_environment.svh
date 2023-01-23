//----------------------------------------------------------------------
// Created with uvmf_gen version 2020.2
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

class ALU_environment  extends uvmf_environment_base #(
    .CONFIG_T( ALU_env_configuration 
  ));
  `uvm_component_utils( ALU_environment )





  typedef ALU_in_agent  ALU_in_agent_agent_t;
  ALU_in_agent_agent_t ALU_in_agent;

  typedef ALU_out_agent  ALU_out_agent_agent_t;
  ALU_out_agent_agent_t ALU_out_agent;




  typedef ALU_predictor #(
                .CONFIG_T(CONFIG_T)
                ) ALU_pred_t;
  ALU_pred_t ALU_pred;

  typedef uvmf_in_order_scoreboard #(.T(ALU_out_transaction))  ALU_sb_t;
  ALU_sb_t ALU_sb;


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
    super.build_phase(phase);
    ALU_in_agent = ALU_in_agent_agent_t::type_id::create("ALU_in_agent",this);
    ALU_in_agent.set_config(configuration.ALU_in_agent_config);
    ALU_out_agent = ALU_out_agent_agent_t::type_id::create("ALU_out_agent",this);
    ALU_out_agent.set_config(configuration.ALU_out_agent_config);
    ALU_pred = ALU_pred_t::type_id::create("ALU_pred",this);
    ALU_pred.configuration = configuration;
    ALU_sb = ALU_sb_t::type_id::create("ALU_sb",this);
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
    super.connect_phase(phase);
    ALU_in_agent.monitored_ap.connect(ALU_pred.ALU_in_agent_ae);
    ALU_pred.ALU_sb_ap.connect(ALU_sb.expected_analysis_export);
    ALU_out_agent.monitored_ap.connect(ALU_sb.actual_analysis_export);
    // pragma uvmf custom reg_model_connect_phase begin
    // pragma uvmf custom reg_model_connect_phase end
  endfunction

endclass

