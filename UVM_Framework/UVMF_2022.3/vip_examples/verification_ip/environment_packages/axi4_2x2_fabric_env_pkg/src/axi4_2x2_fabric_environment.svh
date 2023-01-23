//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_5
//----------------------------------------------------------------------
// Created by: Vijay Gill
// E-mail:     vijay_gill@mentor.com
// Date:       2019/11/05
// pragma uvmf custom header begin
// Created by      : vgill
// Creation Date   : 2019 Aug 8
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

class axi4_2x2_fabric_environment  extends uvmf_environment_base #(
    .CONFIG_T( axi4_2x2_fabric_env_configuration 
  ));
  `uvm_component_utils( axi4_2x2_fabric_environment )


  axi4_2x2_fabric_qvip_environment #()  axi4_qvip_subenv;



  uvm_analysis_port #( mvc_sequence_item_base ) axi4_qvip_subenv_mgc_axi4_m0_ap [string];
  uvm_analysis_port #( mvc_sequence_item_base ) axi4_qvip_subenv_mgc_axi4_m1_ap [string];
  uvm_analysis_port #( mvc_sequence_item_base ) axi4_qvip_subenv_mgc_axi4_s0_ap [string];
  uvm_analysis_port #( mvc_sequence_item_base ) axi4_qvip_subenv_mgc_axi4_s1_ap [string];




  typedef axi4_master_predictor #(
                .CONFIG_T(CONFIG_T),
                .axi4_master_rw_transaction_t(axi4_master_rw_transaction 
                   #(.AXI4_ADDRESS_WIDTH(mgc_axi4_m0_params::AXI4_ADDRESS_WIDTH), 
                     .AXI4_RDATA_WIDTH(mgc_axi4_m0_params::AXI4_RDATA_WIDTH), 
                     .AXI4_WDATA_WIDTH(mgc_axi4_m0_params::AXI4_WDATA_WIDTH), 
                     .AXI4_ID_WIDTH(mgc_axi4_m0_params::AXI4_ID_WIDTH), 
                     .AXI4_USER_WIDTH(mgc_axi4_m0_params::AXI4_USER_WIDTH), 
                     .AXI4_REGION_MAP_SIZE(mgc_axi4_m0_params::AXI4_REGION_MAP_SIZE)))
                ) axi4_m0_pred_t;
  axi4_m0_pred_t axi4_m0_pred;
  typedef axi4_master_predictor #(
                .CONFIG_T(CONFIG_T),
                .axi4_master_rw_transaction_t(axi4_master_rw_transaction 
                   #(.AXI4_ADDRESS_WIDTH(mgc_axi4_m1_params::AXI4_ADDRESS_WIDTH), 
                     .AXI4_RDATA_WIDTH(mgc_axi4_m1_params::AXI4_RDATA_WIDTH), 
                     .AXI4_WDATA_WIDTH(mgc_axi4_m1_params::AXI4_WDATA_WIDTH), 
                     .AXI4_ID_WIDTH(mgc_axi4_m1_params::AXI4_ID_WIDTH), 
                     .AXI4_USER_WIDTH(mgc_axi4_m1_params::AXI4_USER_WIDTH), 
                     .AXI4_REGION_MAP_SIZE(mgc_axi4_m1_params::AXI4_REGION_MAP_SIZE)))
                ) axi4_m1_pred_t;
  axi4_m1_pred_t axi4_m1_pred;
  typedef axi4_slave_predictor #(
                .CONFIG_T(CONFIG_T),
                .AXI4_ADDRESS_WIDTH(mgc_axi4_s0_params::AXI4_ADDRESS_WIDTH),
                .AXI4_RDATA_WIDTH(mgc_axi4_s0_params::AXI4_RDATA_WIDTH),
                .AXI4_WDATA_WIDTH(mgc_axi4_s0_params::AXI4_WDATA_WIDTH),
                .AXI4_ID_WIDTH(mgc_axi4_s0_params::AXI4_ID_WIDTH),
                .AXI4_USER_WIDTH(mgc_axi4_s0_params::AXI4_USER_WIDTH),
                .AXI4_REGION_MAP_SIZE(mgc_axi4_s0_params::AXI4_REGION_MAP_SIZE)
                ) axi4_s0_pred_t;
  axi4_s0_pred_t axi4_s0_pred;
  typedef axi4_slave_predictor #(
                .CONFIG_T(CONFIG_T),
                .AXI4_ADDRESS_WIDTH(mgc_axi4_s1_params::AXI4_ADDRESS_WIDTH),
                .AXI4_RDATA_WIDTH(mgc_axi4_s1_params::AXI4_RDATA_WIDTH),
                .AXI4_WDATA_WIDTH(mgc_axi4_s1_params::AXI4_WDATA_WIDTH),
                .AXI4_ID_WIDTH(mgc_axi4_s1_params::AXI4_ID_WIDTH),
                .AXI4_USER_WIDTH(mgc_axi4_s1_params::AXI4_USER_WIDTH),
                .AXI4_REGION_MAP_SIZE(mgc_axi4_s1_params::AXI4_REGION_MAP_SIZE)
                ) axi4_s1_pred_t;
  axi4_s1_pred_t axi4_s1_pred;
  typedef axi4_slave_rw_predictor #(
                .CONFIG_T(CONFIG_T)
                ) axi4_slave_rw_pred_t;
  axi4_slave_rw_pred_t axi4_slave_rw_pred;

  typedef uvmf_in_order_race_scoreboard #(.T(axi4_master_rw_transaction 
            #(.AXI4_ADDRESS_WIDTH(mgc_axi4_m0_params::AXI4_ADDRESS_WIDTH), 
              .AXI4_RDATA_WIDTH(mgc_axi4_m0_params::AXI4_RDATA_WIDTH), 
              .AXI4_WDATA_WIDTH(mgc_axi4_m0_params::AXI4_WDATA_WIDTH), 
              .AXI4_ID_WIDTH(mgc_axi4_m0_params::AXI4_ID_WIDTH), 
              .AXI4_USER_WIDTH(mgc_axi4_m0_params::AXI4_USER_WIDTH), 
              .AXI4_REGION_MAP_SIZE(mgc_axi4_m0_params::AXI4_REGION_MAP_SIZE))))  axi4_m0_sb_t;
  axi4_m0_sb_t axi4_m0_sb;
  typedef uvmf_in_order_race_scoreboard #(.T(axi4_master_rw_transaction 
            #(.AXI4_ADDRESS_WIDTH(mgc_axi4_m1_params::AXI4_ADDRESS_WIDTH), 
              .AXI4_RDATA_WIDTH(mgc_axi4_m1_params::AXI4_RDATA_WIDTH), 
              .AXI4_WDATA_WIDTH(mgc_axi4_m1_params::AXI4_WDATA_WIDTH), 
              .AXI4_ID_WIDTH(mgc_axi4_m1_params::AXI4_ID_WIDTH), 
              .AXI4_USER_WIDTH(mgc_axi4_m1_params::AXI4_USER_WIDTH), 
              .AXI4_REGION_MAP_SIZE(mgc_axi4_m1_params::AXI4_REGION_MAP_SIZE))))  axi4_m1_sb_t;
  axi4_m1_sb_t axi4_m1_sb;
  typedef uvmf_in_order_race_scoreboard #(.T(rw_txn))  axi4_m0_rw_sb_t;
  axi4_m0_rw_sb_t axi4_m0_rw_sb;
  typedef uvmf_in_order_race_scoreboard #(.T(rw_txn))  axi4_m1_rw_sb_t;
  axi4_m1_rw_sb_t axi4_m1_rw_sb;


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
    axi4_qvip_subenv = axi4_2x2_fabric_qvip_environment#()::type_id::create("axi4_qvip_subenv",this);
    axi4_qvip_subenv.set_config(configuration.axi4_qvip_subenv_config);
    axi4_m0_pred = axi4_m0_pred_t::type_id::create("axi4_m0_pred",this);
    axi4_m0_pred.configuration = configuration;
    axi4_m1_pred = axi4_m1_pred_t::type_id::create("axi4_m1_pred",this);
    axi4_m1_pred.configuration = configuration;
    axi4_s0_pred = axi4_s0_pred_t::type_id::create("axi4_s0_pred",this);
    axi4_s0_pred.configuration = configuration;
    axi4_s1_pred = axi4_s1_pred_t::type_id::create("axi4_s1_pred",this);
    axi4_s1_pred.configuration = configuration;
    axi4_slave_rw_pred = axi4_slave_rw_pred_t::type_id::create("axi4_slave_rw_pred",this);
    axi4_slave_rw_pred.configuration = configuration;
    axi4_m0_sb = axi4_m0_sb_t::type_id::create("axi4_m0_sb",this);
    axi4_m1_sb = axi4_m1_sb_t::type_id::create("axi4_m1_sb",this);
    axi4_m0_rw_sb = axi4_m0_rw_sb_t::type_id::create("axi4_m0_rw_sb",this);
    axi4_m1_rw_sb = axi4_m1_rw_sb_t::type_id::create("axi4_m1_rw_sb",this);
    // pragma uvmf custom build_phase begin
    axi4_m0_rw_sb.use_sprint_to_display_compare_results = 1;
    axi4_m1_rw_sb.use_sprint_to_display_compare_results = 1;
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
    axi4_m0_pred.axi4_ap.connect(axi4_m0_sb.expected_analysis_export);
    axi4_m1_pred.axi4_ap.connect(axi4_m1_sb.expected_analysis_export);
    axi4_s0_pred.axi4_m0_ap.connect(axi4_m0_sb.actual_analysis_export);
    axi4_s1_pred.axi4_m0_ap.connect(axi4_m0_sb.actual_analysis_export);
    axi4_s0_pred.axi4_m1_ap.connect(axi4_m1_sb.actual_analysis_export);
    axi4_s1_pred.axi4_m1_ap.connect(axi4_m1_sb.actual_analysis_export);
    axi4_qvip_subenv.mgc_axi4_m0.export_rw.connect(axi4_m0_rw_sb.expected_analysis_export);
    axi4_qvip_subenv.mgc_axi4_m1.export_rw.connect(axi4_m1_rw_sb.expected_analysis_export);
    axi4_qvip_subenv.mgc_axi4_s0.export_rw.connect(axi4_slave_rw_pred.axi4_s0_ae);
    axi4_qvip_subenv.mgc_axi4_s1.export_rw.connect(axi4_slave_rw_pred.axi4_s1_ae);
    axi4_slave_rw_pred.axi4_m0_ap.connect(axi4_m0_rw_sb.actual_analysis_export);
    axi4_slave_rw_pred.axi4_m1_ap.connect(axi4_m1_rw_sb.actual_analysis_export);
    axi4_qvip_subenv_mgc_axi4_m0_ap = axi4_qvip_subenv.mgc_axi4_m0.ap; 
    axi4_qvip_subenv_mgc_axi4_m1_ap = axi4_qvip_subenv.mgc_axi4_m1.ap; 
    axi4_qvip_subenv_mgc_axi4_s0_ap = axi4_qvip_subenv.mgc_axi4_s0.ap; 
    axi4_qvip_subenv_mgc_axi4_s1_ap = axi4_qvip_subenv.mgc_axi4_s1.ap; 
    axi4_qvip_subenv_mgc_axi4_m0_ap["trans_ap"].connect(axi4_m0_pred.axi4_ae);
    axi4_qvip_subenv_mgc_axi4_m1_ap["trans_ap"].connect(axi4_m1_pred.axi4_ae);
    axi4_qvip_subenv_mgc_axi4_s0_ap["trans_ap"].connect(axi4_s0_pred.axi4_ae);
    axi4_qvip_subenv_mgc_axi4_s1_ap["trans_ap"].connect(axi4_s1_pred.axi4_ae);
    if ( configuration.axi4_qvip_subenv_interface_activity[0] == ACTIVE )
       uvm_config_db #(mvc_sequencer)::set(null,UVMF_SEQUENCERS,configuration.axi4_qvip_subenv_interface_names[0],axi4_qvip_subenv.mgc_axi4_m0.m_sequencer  );
    if ( configuration.axi4_qvip_subenv_interface_activity[1] == ACTIVE )
       uvm_config_db #(mvc_sequencer)::set(null,UVMF_SEQUENCERS,configuration.axi4_qvip_subenv_interface_names[1],axi4_qvip_subenv.mgc_axi4_m1.m_sequencer  );
    if ( configuration.axi4_qvip_subenv_interface_activity[2] == ACTIVE )
       uvm_config_db #(mvc_sequencer)::set(null,UVMF_SEQUENCERS,configuration.axi4_qvip_subenv_interface_names[2],axi4_qvip_subenv.mgc_axi4_s0.m_sequencer  );
    if ( configuration.axi4_qvip_subenv_interface_activity[3] == ACTIVE )
       uvm_config_db #(mvc_sequencer)::set(null,UVMF_SEQUENCERS,configuration.axi4_qvip_subenv_interface_names[3],axi4_qvip_subenv.mgc_axi4_s1.m_sequencer  );
    // pragma uvmf custom reg_model_connect_phase begin
    // pragma uvmf custom reg_model_connect_phase end
  endfunction

endclass

