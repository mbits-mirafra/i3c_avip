//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : daerne
// Creation Date   : 2016 Oct 16
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : axi4_2x2_fabric Environment 
// Unit            : axi4_2x2_fabric Environment
// File            : axi4_2x2_fabric_environment.svh
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This environment contains all agents, predictors and
// scoreboards required for the block level design.
//----------------------------------------------------------------------
//



class axi4_2x2_fabric_environment 
      #(
      int AXI4_ADDRESS_WIDTH = 32,                                
      int AXI4_RDATA_WIDTH = 32,                                
      int AXI4_WDATA_WIDTH = 32,                                
      int AXI4_MASTER_ID_WIDTH = 4,                                
      int AXI4_SLAVE_ID_WIDTH = 5,                                
      int AXI4_USER_WIDTH = 4,                                
      int AXI4_REGION_MAP_SIZE = 16                                
      )
extends uvmf_environment_base #(.CONFIG_T( axi4_2x2_fabric_env_configuration
                              #(
                             .AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),                                
                             .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),                                
                             .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),                                
                             .AXI4_MASTER_ID_WIDTH(AXI4_MASTER_ID_WIDTH),                                
                             .AXI4_SLAVE_ID_WIDTH(AXI4_SLAVE_ID_WIDTH),                                
                             .AXI4_USER_WIDTH(AXI4_USER_WIDTH),                                
                             .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)                                
                             )
                             ));

  `uvm_component_param_utils( axi4_2x2_fabric_environment #(
                              AXI4_ADDRESS_WIDTH,
                              AXI4_RDATA_WIDTH,
                              AXI4_WDATA_WIDTH,
                              AXI4_MASTER_ID_WIDTH,
                              AXI4_SLAVE_ID_WIDTH,
                              AXI4_USER_WIDTH,
                              AXI4_REGION_MAP_SIZE
                            ))


   axi4_2x2_fabric_qvip_environment  qvip_env;

   uvm_analysis_port #( mvc_sequence_item_base ) qvip_env_mgc_axi4_m0_ap [string];
   uvm_analysis_port #( mvc_sequence_item_base ) qvip_env_mgc_axi4_m1_ap [string];
   uvm_analysis_port #( mvc_sequence_item_base ) qvip_env_mgc_axi4_s0_ap [string];
   uvm_analysis_port #( mvc_sequence_item_base ) qvip_env_mgc_axi4_s1_ap [string];


typedef master_axi4_txn_adapter  #(
                             .AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),                                
                             .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),                                
                             .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),                                
                             .AXI4_MASTER_ID_WIDTH(AXI4_MASTER_ID_WIDTH),                                
                             .AXI4_SLAVE_ID_WIDTH(AXI4_SLAVE_ID_WIDTH),                                
                             .AXI4_USER_WIDTH(AXI4_USER_WIDTH),                                
                             .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)                                
                             )  m0_axi4_txn_pred_t;
m0_axi4_txn_pred_t m0_axi4_txn_pred;

typedef master_axi4_txn_adapter  #(
                             .AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),                                
                             .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),                                
                             .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),                                
                             .AXI4_MASTER_ID_WIDTH(AXI4_MASTER_ID_WIDTH),                                
                             .AXI4_SLAVE_ID_WIDTH(AXI4_SLAVE_ID_WIDTH),                                
                             .AXI4_USER_WIDTH(AXI4_USER_WIDTH),                                
                             .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)                                
                             )  m1_axi4_txn_pred_t;
m1_axi4_txn_pred_t m1_axi4_txn_pred;

typedef slave_axi4_txn_predictor  #(
                             .AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),                                
                             .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),                                
                             .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),                                
                             .AXI4_MASTER_ID_WIDTH(AXI4_MASTER_ID_WIDTH),                                
                             .AXI4_SLAVE_ID_WIDTH(AXI4_SLAVE_ID_WIDTH),                                
                             .AXI4_USER_WIDTH(AXI4_USER_WIDTH),                                
                             .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)                                
                             )  slave_axi4_txn_pred_t;
slave_axi4_txn_pred_t slave_axi4_txn_pred;

typedef axi4_rw_adapter  #(
                             .AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),                                
                             .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),                                
                             .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),                                
                             // .AXI4_MASTER_ID_WIDTH(AXI4_MASTER_ID_WIDTH),                                
                             // .AXI4_SLAVE_ID_WIDTH(AXI4_SLAVE_ID_WIDTH),                                
                             .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH),                                
                             .AXI4_USER_WIDTH(AXI4_USER_WIDTH),                                
                             .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)                                
                             )  m0_rw_txn_pred_t;
m0_rw_txn_pred_t m0_rw_txn_pred;

typedef axi4_rw_adapter  #(
                             .AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),                                
                             .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),                                
                             .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),                                
                             // .AXI4_MASTER_ID_WIDTH(AXI4_MASTER_ID_WIDTH),                                
                             // .AXI4_SLAVE_ID_WIDTH(AXI4_SLAVE_ID_WIDTH),                                
                             .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH),                                
                             .AXI4_USER_WIDTH(AXI4_USER_WIDTH),                                
                             .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)                                
                             )  m1_rw_txn_pred_t;
m1_rw_txn_pred_t m1_rw_txn_pred;

typedef slave_axi4_rw_adapter  #(
                             .AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),                                
                             .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),                                
                             .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),                                
                             // .AXI4_MASTER_ID_WIDTH(AXI4_MASTER_ID_WIDTH),                                
                             // .AXI4_SLAVE_ID_WIDTH(AXI4_SLAVE_ID_WIDTH),                                
                             .AXI4_ID_WIDTH(AXI4_SLAVE_ID_WIDTH),                                
                             .AXI4_USER_WIDTH(AXI4_USER_WIDTH),                                
                             .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)                                
                             )  slave_rw_txn_pred_t;
slave_rw_txn_pred_t slave_rw_txn_pred;


   typedef uvmf_in_order_race_scoreboard #(axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)))  axi4_txn_m0_sb_t;
   axi4_txn_m0_sb_t axi4_txn_m0_sb;

   typedef uvmf_in_order_race_scoreboard #(axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)))  axi4_txn_m1_sb_t;
   axi4_txn_m1_sb_t axi4_txn_m1_sb;

   typedef uvmf_in_order_race_scoreboard #(rw_txn)  rw_txn_m0_sb_t;
   rw_txn_m0_sb_t rw_txn_m0_sb;

   typedef uvmf_in_order_race_scoreboard #(rw_txn)  rw_txn_m1_sb_t;
   rw_txn_m1_sb_t rw_txn_m1_sb;



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



   qvip_env = axi4_2x2_fabric_qvip_environment::type_id::create("qvip_env",this);
   qvip_env.set_config(configuration.qvip_env_config);


  m0_axi4_txn_pred = m0_axi4_txn_pred_t::type_id::create("m0_axi4_txn_pred",this);
  m0_axi4_txn_pred.configuration = configuration;

  m1_axi4_txn_pred = m1_axi4_txn_pred_t::type_id::create("m1_axi4_txn_pred",this);
  m1_axi4_txn_pred.configuration = configuration;

  slave_axi4_txn_pred = slave_axi4_txn_pred_t::type_id::create("slave_axi4_txn_pred",this);
  slave_axi4_txn_pred.configuration = configuration;

  m0_rw_txn_pred = m0_rw_txn_pred_t::type_id::create("m0_rw_txn_pred",this);
  // the following assignment was automatically (and erronously) created as part of the python script output. 
  // It will not be generated in future version thus for now comment it out...
  // m0_rw_txn_pred.configuration = configuration;

  m1_rw_txn_pred = m1_rw_txn_pred_t::type_id::create("m1_rw_txn_pred",this);
  // the following assignment was automatically (and erronously) created as part of the python script output. 
  // It will not be generated in future version thus for now comment it out...
  // m1_rw_txn_pred.configuration = configuration;

  slave_rw_txn_pred = slave_rw_txn_pred_t::type_id::create("slave_rw_txn_pred",this);
  // the following assignment was automatically (and erronously) created as part of the python script output. 
  // It will not be generated in future version thus for now comment it out...
  // slave_rw_txn_pred.configuration = configuration;


  axi4_txn_m0_sb = axi4_txn_m0_sb_t::type_id::create("axi4_txn_m0_sb",this);
  axi4_txn_m1_sb = axi4_txn_m1_sb_t::type_id::create("axi4_txn_m1_sb",this);
  rw_txn_m0_sb = rw_txn_m0_sb_t::type_id::create("rw_txn_m0_sb",this);
  rw_txn_m1_sb = rw_txn_m1_sb_t::type_id::create("rw_txn_m1_sb",this);


  endfunction

// ****************************************************************************
// FUNCTION: connect_phase()
// This function makes all connections within this environment.  Connections
// typically inclue agent to predictor, predictor to scoreboard and scoreboard
// to agent.
//
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

   m0_axi4_txn_pred.master_axi4_txn_ap.connect(axi4_txn_m0_sb.expected_analysis_export);
   m1_axi4_txn_pred.master_axi4_txn_ap.connect(axi4_txn_m1_sb.expected_analysis_export);
   slave_axi4_txn_pred.slave_axi4_txn_m0_ap.connect(axi4_txn_m0_sb.actual_analysis_export);
   slave_axi4_txn_pred.slave_axi4_txn_m1_ap.connect(axi4_txn_m1_sb.actual_analysis_export);
   m0_rw_txn_pred.port_rw.connect(rw_txn_m0_sb.expected_analysis_export);
   m1_rw_txn_pred.port_rw.connect(rw_txn_m1_sb.expected_analysis_export);
   slave_rw_txn_pred.port_rw_m0.connect(rw_txn_m0_sb.actual_analysis_export);
   slave_rw_txn_pred.port_rw_m1.connect(rw_txn_m1_sb.actual_analysis_export);

    qvip_env_mgc_axi4_m0_ap = qvip_env.mgc_axi4_m0.ap; 
    qvip_env_mgc_axi4_m1_ap = qvip_env.mgc_axi4_m1.ap; 
    qvip_env_mgc_axi4_s0_ap = qvip_env.mgc_axi4_s0.ap; 
    qvip_env_mgc_axi4_s1_ap = qvip_env.mgc_axi4_s1.ap; 

    qvip_env_mgc_axi4_m0_ap["trans_ap"].connect(m0_axi4_txn_pred.master_axi4_txn_ae);
    qvip_env_mgc_axi4_m1_ap["trans_ap"].connect(m1_axi4_txn_pred.master_axi4_txn_ae);
    qvip_env_mgc_axi4_s0_ap["trans_ap"].connect(slave_axi4_txn_pred.slave_axi4_txn_ae);
    qvip_env_mgc_axi4_s1_ap["trans_ap"].connect(slave_axi4_txn_pred.slave_axi4_txn_ae);
    qvip_env_mgc_axi4_m0_ap["trans_ap"].connect(m0_rw_txn_pred.analysis_export);
    qvip_env_mgc_axi4_m1_ap["trans_ap"].connect(m1_rw_txn_pred.analysis_export);
    qvip_env_mgc_axi4_s0_ap["trans_ap"].connect(slave_rw_txn_pred.analysis_export);
    qvip_env_mgc_axi4_s1_ap["trans_ap"].connect(slave_rw_txn_pred.analysis_export);

  endfunction

endclass

