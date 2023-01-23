//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU Environment 
// Unit            : FPU Environment
// File            : FPU_environment.svh
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This environment contains all agents, predictors and
// scoreboards required for the block level design.
//----------------------------------------------------------------------
//



class FPU_environment 
extends uvmf_environment_base #(.CONFIG_T( FPU_env_configuration
                             ));

  `uvm_component_utils( FPU_environment );





  typedef FPU_in_agent FPU_in_agent_agent_t;
  FPU_in_agent_agent_t FPU_in_agent;

  typedef FPU_out_agent FPU_out_agent_agent_t;
  FPU_out_agent_agent_t FPU_out_agent;


  typedef FPU_predictor  FPU_pred_t;
  FPU_pred_t FPU_pred;

  typedef uvmf_in_order_scoreboard #(FPU_in_transaction)  FPU_sb_t;
  FPU_sb_t FPU_sb;



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
    FPU_in_agent = FPU_in_agent_agent_t::type_id::create("FPU_in_agent",this);
    FPU_out_agent = FPU_out_agent_agent_t::type_id::create("FPU_out_agent",this);
    FPU_pred = FPU_pred_t::type_id::create("FPU_pred",this);
    FPU_pred.configuration = configuration;
    FPU_sb = FPU_sb_t::type_id::create("FPU_sb",this);


  endfunction

// ****************************************************************************
// FUNCTION: connect_phase()
// This function makes all connections within this environment.  Connections
// typically inclue agent to predictor, predictor to scoreboard and scoreboard
// to agent.
//
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    FPU_in_agent.monitored_ap.connect(FPU_pred.FPU_in_agent_ae);
    FPU_pred.FPU_sb_ap.connect(FPU_sb.expected_analysis_export);
    FPU_in_agent.monitored_ap.connect(FPU_sb.actual_analysis_export);





  endfunction

endclass

