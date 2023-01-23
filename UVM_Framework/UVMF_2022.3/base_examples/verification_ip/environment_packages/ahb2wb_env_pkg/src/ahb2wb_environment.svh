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

class ahb2wb_environment #(
  int WB_DATA_WIDTH = 16,
  int WB_ADDR_WIDTH = 32
  ) extends uvmf_environment_base #(
    .CONFIG_T( ahb2wb_env_configuration #(
                      .WB_DATA_WIDTH(WB_DATA_WIDTH),
                      .WB_ADDR_WIDTH(WB_ADDR_WIDTH)
                      )
  ));
  `uvm_component_param_utils( ahb2wb_environment #(
                              WB_DATA_WIDTH,
                              WB_ADDR_WIDTH
                              ))





  typedef wb_agent #(
                .WB_DATA_WIDTH(WB_DATA_WIDTH),
                .WB_ADDR_WIDTH(WB_ADDR_WIDTH)
                ) wb_agent_t;
  wb_agent_t wb;

  typedef ahb_agent  ahb_agent_t;
  ahb_agent_t ahb;




  typedef ahb2wb_predictor #(
                .CONFIG_T(CONFIG_T),
                .WB_DATA_WIDTH(WB_DATA_WIDTH),
                .WB_ADDR_WIDTH(WB_ADDR_WIDTH)
                ) ahb2wb_pred_t;
  ahb2wb_pred_t ahb2wb_pred;
  typedef wb2ahb_predictor #(
                .CONFIG_T(CONFIG_T),
                .WB_DATA_WIDTH(WB_DATA_WIDTH),
                .WB_ADDR_WIDTH(WB_ADDR_WIDTH)
                ) wb2ahb_pred_t;
  wb2ahb_pred_t wb2ahb_pred;

  typedef uvmf_in_order_scoreboard #(.T(wb_transaction #(.WB_DATA_WIDTH(WB_DATA_WIDTH), .WB_ADDR_WIDTH(WB_ADDR_WIDTH))))  ahb2wb_sb_t;
  ahb2wb_sb_t ahb2wb_sb;
  typedef uvmf_in_order_scoreboard #(.T(ahb_transaction))  wb2ahb_sb_t;
  wb2ahb_sb_t wb2ahb_sb;


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
    wb = wb_agent_t::type_id::create("wb",this);
    wb.set_config(configuration.wb_config);
    ahb = ahb_agent_t::type_id::create("ahb",this);
    ahb.set_config(configuration.ahb_config);
    ahb2wb_pred = ahb2wb_pred_t::type_id::create("ahb2wb_pred",this);
    ahb2wb_pred.configuration = configuration;
    wb2ahb_pred = wb2ahb_pred_t::type_id::create("wb2ahb_pred",this);
    wb2ahb_pred.configuration = configuration;
    ahb2wb_sb = ahb2wb_sb_t::type_id::create("ahb2wb_sb",this);
    wb2ahb_sb = wb2ahb_sb_t::type_id::create("wb2ahb_sb",this);
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
    ahb.monitored_ap.connect(ahb2wb_pred.ahb_ae);
    ahb2wb_pred.wb_ap.connect(ahb2wb_sb.expected_analysis_export);
    ahb2wb_pred.ahb_ap.connect(wb2ahb_sb.actual_analysis_export);
    wb.monitored_ap.connect(wb2ahb_pred.wb_ae);
    wb2ahb_pred.wb_ap.connect(ahb2wb_sb.actual_analysis_export);
    wb2ahb_pred.ahb_ap.connect(wb2ahb_sb.expected_analysis_export);
    // pragma uvmf custom reg_model_connect_phase begin
    // pragma uvmf custom reg_model_connect_phase end
  endfunction

endclass

