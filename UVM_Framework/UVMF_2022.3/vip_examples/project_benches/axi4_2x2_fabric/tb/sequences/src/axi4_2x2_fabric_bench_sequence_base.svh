//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_5
//----------------------------------------------------------------------
// Created by: Vijay Gill
// E-mail:     vijay_gill@mentor.com
// Date:       2019/11/05
// pragma uvmf custom header begin
// Created by      : vgill
// Creation Date   : 2019 Aug 06
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
// Description: This file contains the top level and utility sequences
//     used by test_top. It can be extended to create derivative top
//     level sequences.
//
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
//

class axi4_2x2_fabric_bench_sequence_base extends uvmf_sequence_base #(uvm_sequence_item);

  `uvm_object_utils( axi4_2x2_fabric_bench_sequence_base );

  // pragma uvmf custom sequences begin
  // Instantiate sequences here
  typedef axi4_simple_rd_wr_seq #(mgc_axi4_m0_params::AXI4_ADDRESS_WIDTH,
                                  mgc_axi4_m0_params::AXI4_RDATA_WIDTH,
                                  mgc_axi4_m0_params::AXI4_WDATA_WIDTH,
                                  mgc_axi4_m0_params::AXI4_ID_WIDTH,
                                  mgc_axi4_m0_params::AXI4_USER_WIDTH,
                                  mgc_axi4_m0_params::AXI4_REGION_MAP_SIZE
                                 ) axi4_m0_simple_rd_wr_seq_t;

  typedef axi4_simple_rd_wr_seq #(mgc_axi4_m1_params::AXI4_ADDRESS_WIDTH,
                                  mgc_axi4_m1_params::AXI4_RDATA_WIDTH,
                                  mgc_axi4_m1_params::AXI4_WDATA_WIDTH,
                                  mgc_axi4_m1_params::AXI4_ID_WIDTH,
                                  mgc_axi4_m1_params::AXI4_USER_WIDTH,
                                  mgc_axi4_m1_params::AXI4_REGION_MAP_SIZE
                                 ) axi4_m1_simple_rd_wr_seq_t;

  axi4_m0_simple_rd_wr_seq_t axi4_m0_seq;
  axi4_m1_simple_rd_wr_seq_t axi4_m1_seq;
  // pragma uvmf custom sequences end

  // Sequencer handles for each active interface in the environment

  // Sequencer handles for each QVIP interface
  mvc_sequencer uvm_test_top_environment_axi4_qvip_subenv_mgc_axi4_m0_sqr;
  mvc_sequencer uvm_test_top_environment_axi4_qvip_subenv_mgc_axi4_m1_sqr;
  mvc_sequencer uvm_test_top_environment_axi4_qvip_subenv_mgc_axi4_s0_sqr;
  mvc_sequencer uvm_test_top_environment_axi4_qvip_subenv_mgc_axi4_s1_sqr;

  // Top level environment configuration handle
  typedef axi4_2x2_fabric_env_configuration  axi4_2x2_fabric_env_configuration_t;
  axi4_2x2_fabric_env_configuration_t top_configuration;

  // Configuration handles to access interface BFM's

  // pragma uvmf custom class_item_additional begin
  mgc_axi4_m0_cfg_t  mgc_axi4_m0_cfg;
  mgc_axi4_m1_cfg_t  mgc_axi4_m1_cfg;
  mgc_axi4_s0_cfg_t  mgc_axi4_s0_cfg;
  mgc_axi4_s1_cfg_t  mgc_axi4_s1_cfg;
  // pragma uvmf custom class_item_additional end

  // ****************************************************************************
  function new( string name = "" );
    super.new( name );
    // Retrieve the configuration handles from the uvm_config_db

    // Retrieve top level configuration handle
    if ( !uvm_config_db#(axi4_2x2_fabric_env_configuration_t)::get(null,UVMF_CONFIGURATIONS, "TOP_ENV_CONFIG",top_configuration) ) begin
      `uvm_info("CFG", "*** FATAL *** uvm_config_db::get can not find TOP_ENV_CONFIG.  Are you using an older UVMF release than what was used to generate this bench?",UVM_NONE);
      `uvm_fatal("CFG", "uvm_config_db#(axi4_2x2_fabric_env_configuration_t)::get cannot find resource TOP_ENV_CONFIG");
    end

    // Retrieve config handles for all agents

    // Assign the sequencer handles from the handles within agent configurations

    // Retrieve QVIP sequencer handles from the uvm_config_db
    if( !uvm_config_db #(mvc_sequencer)::get( null,UVMF_SEQUENCERS,"uvm_test_top.environment.axi4_qvip_subenv.mgc_axi4_m0", uvm_test_top_environment_axi4_qvip_subenv_mgc_axi4_m0_sqr) ) 
      `uvm_warning("CFG" , "uvm_config_db #( mvc_sequencer )::get cannot find resource mgc_axi4_m0" ) 
    if( !uvm_config_db #(mvc_sequencer)::get( null,UVMF_SEQUENCERS,"uvm_test_top.environment.axi4_qvip_subenv.mgc_axi4_m1", uvm_test_top_environment_axi4_qvip_subenv_mgc_axi4_m1_sqr) ) 
      `uvm_warning("CFG" , "uvm_config_db #( mvc_sequencer )::get cannot find resource mgc_axi4_m1" ) 
    if( !uvm_config_db #(mvc_sequencer)::get( null,UVMF_SEQUENCERS,"uvm_test_top.environment.axi4_qvip_subenv.mgc_axi4_s0", uvm_test_top_environment_axi4_qvip_subenv_mgc_axi4_s0_sqr) ) 
      `uvm_warning("CFG" , "uvm_config_db #( mvc_sequencer )::get cannot find resource mgc_axi4_s0" ) 
    if( !uvm_config_db #(mvc_sequencer)::get( null,UVMF_SEQUENCERS,"uvm_test_top.environment.axi4_qvip_subenv.mgc_axi4_s1", uvm_test_top_environment_axi4_qvip_subenv_mgc_axi4_s1_sqr) ) 
      `uvm_warning("CFG" , "uvm_config_db #( mvc_sequencer )::get cannot find resource mgc_axi4_s1" ) 


  // pragma uvmf custom new begin
  // pragma uvmf custom new end

  endfunction

  // ****************************************************************************
  virtual task body();
    // pragma uvmf custom body begin
    mgc_axi4_m0_cfg = mgc_axi4_m0_cfg_t::get_config(uvm_test_top_environment_axi4_qvip_subenv_mgc_axi4_m0_sqr);

    // Construct sequences here
    axi4_m0_seq = axi4_m0_simple_rd_wr_seq_t::type_id::create("axi4_m0_seq");
    axi4_m1_seq = axi4_m1_simple_rd_wr_seq_t::type_id::create("axi4_m1_seq");
    fork
      axi4_m0_seq.start(uvm_test_top_environment_axi4_qvip_subenv_mgc_axi4_m0_sqr);
      axi4_m1_seq.start(uvm_test_top_environment_axi4_qvip_subenv_mgc_axi4_m1_sqr);
    join
    // Start RESPONDER sequences here
    //fork
    //join_none
    // Start INITIATOR sequences here
    //fork
    //join
    // Extend the simulation XXX number of clocks after 
    // the last sequence to allow for the last sequence item to flow 
    // through the design.
    repeat(100) mgc_axi4_m0_cfg.wait_for_clock();
    //fork
    //join
    // pragma uvmf custom body end
  endtask

endclass

