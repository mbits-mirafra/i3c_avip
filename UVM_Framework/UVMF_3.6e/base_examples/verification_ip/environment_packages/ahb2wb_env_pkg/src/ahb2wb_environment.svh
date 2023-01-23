//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 06
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb2wb Environment 
// Unit            : ahb2wb Environment
// File            : ahb2wb_environment.svh
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This environment contains all agents, predictors and
// scoreboards required for the block level design.
//----------------------------------------------------------------------
//


class ahb2wb_environment extends uvmf_environment_base #(.CONFIG_T( ahb2wb_env_configuration));

  `uvm_component_utils( ahb2wb_environment );





   ahb_agent_t ahb;
   wb_agent_t wb;

   ahb2wb_predictor ahb2wb_pred;
   wb2ahb_predictor wb2ahb_pred;

   typedef uvmf_in_order_scoreboard #(wb_transaction)  ahb2wb_sb_t;
   ahb2wb_sb_t ahb2wb_sb;
   typedef uvmf_in_order_scoreboard #(ahb_transaction)  wb2ahb_sb_t;
   wb2ahb_sb_t wb2ahb_sb;


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




  ahb = ahb_agent_t::type_id::create("ahb",this);
  wb = wb_agent_t::type_id::create("wb",this);

  ahb2wb_pred = ahb2wb_predictor::type_id::create("ahb2wb_pred",this);
  wb2ahb_pred = wb2ahb_predictor::type_id::create("wb2ahb_pred",this);

  ahb2wb_sb = ahb2wb_sb_t::type_id::create("ahb2wb_sb",this);
  wb2ahb_sb = wb2ahb_sb_t::type_id::create("wb2ahb_sb",this);


  endfunction

// ****************************************************************************
// FUNCTION: connect_phase()
// This function makes all connections within this environment.  Connections
// typically inclue agent to predictor, predictor to scoreboard and scoreboard
// to agent.
//
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

   ahb.monitored_ap.connect(ahb2wb_pred.ahb_ae);
   ahb2wb_pred.wb_ap.connect(ahb2wb_sb.expected_analysis_export);
   ahb2wb_pred.ahb_ap.connect(wb2ahb_sb.actual_analysis_export);
   wb.monitored_ap.connect(wb2ahb_pred.wb_ae);
   wb2ahb_pred.wb_ap.connect(ahb2wb_sb.actual_analysis_export);
   wb2ahb_pred.ahb_ap.connect(wb2ahb_sb.expected_analysis_export);



  endfunction

endclass

