//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
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

class alu_environment  extends uvmf_environment_base #(
    .CONFIG_T( alu_env_configuration 
  ));
  `uvm_component_utils( alu_environment )





  typedef alu_in_agent  alu_in_agent_agent_t;
  alu_in_agent_agent_t alu_in_agent;

  typedef alu_out_agent  alu_out_agent_agent_t;
  alu_out_agent_agent_t alu_out_agent;




  typedef alu_predictor #(
                .CONFIG_T(CONFIG_T)
                ) alu_pred_t;
  alu_pred_t alu_pred;

  typedef uvmf_in_order_scoreboard #(.T(alu_out_transaction))  alu_sb_t;
  alu_sb_t alu_sb;


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
    alu_in_agent = alu_in_agent_agent_t::type_id::create("alu_in_agent",this);
    alu_in_agent.set_config(configuration.alu_in_agent_config);
    alu_out_agent = alu_out_agent_agent_t::type_id::create("alu_out_agent",this);
    alu_out_agent.set_config(configuration.alu_out_agent_config);
    alu_pred = alu_pred_t::type_id::create("alu_pred",this);
    alu_pred.configuration = configuration;
    alu_sb = alu_sb_t::type_id::create("alu_sb",this);
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
    alu_in_agent.monitored_ap.connect(alu_pred.alu_in_agent_ae);
    alu_pred.alu_sb_ap.connect(alu_sb.expected_analysis_export);
    alu_out_agent.monitored_ap.connect(alu_sb.actual_analysis_export);
    // pragma uvmf custom reg_model_connect_phase begin
    // pragma uvmf custom reg_model_connect_phase end
  endfunction

endclass

