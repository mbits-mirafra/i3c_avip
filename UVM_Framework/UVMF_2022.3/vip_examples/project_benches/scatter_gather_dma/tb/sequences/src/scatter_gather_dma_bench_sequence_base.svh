//----------------------------------------------------------------------
// Created with uvmf_gen version 2021.1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
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

class scatter_gather_dma_bench_sequence_base extends uvmf_sequence_base #(uvm_sequence_item);

  `uvm_object_utils( scatter_gather_dma_bench_sequence_base );

  // pragma uvmf custom sequences begin
  // UVMF_CHANGE_ME : Instantiate, construct, and start sequences as needed to create stimulus scenarios.
  // Instantiate sequences here
  typedef ccs_responder_sequence #(
        .WIDTH(1)
        ) dma_done_rsc_responder_seq_t;
  dma_done_rsc_responder_seq_t dma_done_rsc_responder_seq;
  // pragma uvmf custom sequences end

  // Sequencer handles for each active interface in the environment
  typedef ccs_transaction #(
        .WIDTH(1)
        ) dma_done_rsc_transaction_t;
  uvm_sequencer #(dma_done_rsc_transaction_t)  dma_done_rsc_sequencer; 

  // Sequencer handles for each QVIP interface
  mvc_sequencer uvm_test_top_environment_scatter_gather_dma_qvip_subenv_mgc_axi4_m0_sqr;
  mvc_sequencer uvm_test_top_environment_scatter_gather_dma_qvip_subenv_mgc_axi4_s0_sqr;

  // Top level environment configuration handle
  typedef scatter_gather_dma_env_configuration  scatter_gather_dma_env_configuration_t;
  scatter_gather_dma_env_configuration_t top_configuration;

  // Configuration handles to access interface BFM's
  ccs_configuration #(
        .WIDTH(1)
        ) dma_done_rsc_config;

  // pragma uvmf custom class_item_additional begin
  mgc_axi4_m0_cfg_t  axi4_m0_cfg;
  mgc_axi4_s0_cfg_t  axi4_s0_cfg;
  // pragma uvmf custom class_item_additional end

  // ****************************************************************************
  function new( string name = "" );
    super.new( name );
    // Retrieve the configuration handles from the uvm_config_db

    // Retrieve top level configuration handle
    if ( !uvm_config_db#(scatter_gather_dma_env_configuration_t)::get(null,UVMF_CONFIGURATIONS, "TOP_ENV_CONFIG",top_configuration) ) begin
      `uvm_info("CFG", "*** FATAL *** uvm_config_db::get can not find TOP_ENV_CONFIG.  Are you using an older UVMF release than what was used to generate this bench?",UVM_NONE);
      `uvm_fatal("CFG", "uvm_config_db#(scatter_gather_dma_env_configuration_t)::get cannot find resource TOP_ENV_CONFIG");
    end

    // Retrieve config handles for all agents
    if( !uvm_config_db #( ccs_configuration#(
        .WIDTH(1)
        ) )::get( null , UVMF_CONFIGURATIONS , dma_done_rsc_BFM , dma_done_rsc_config ) ) 
      `uvm_fatal("CFG" , "uvm_config_db #( ccs_configuration )::get cannot find resource dma_done_rsc_BFM" )

    // Assign the sequencer handles from the handles within agent configurations
    dma_done_rsc_sequencer = dma_done_rsc_config.get_sequencer();

    // Retrieve QVIP sequencer handles from the uvm_config_db
    if( !uvm_config_db #(mvc_sequencer)::get( null,UVMF_SEQUENCERS,"uvm_test_top.environment.scatter_gather_dma_qvip_subenv.mgc_axi4_m0", uvm_test_top_environment_scatter_gather_dma_qvip_subenv_mgc_axi4_m0_sqr) ) 
      `uvm_warning("CFG" , "uvm_config_db #( mvc_sequencer )::get cannot find resource mgc_axi4_m0" ) 
    if( !uvm_config_db #(mvc_sequencer)::get( null,UVMF_SEQUENCERS,"uvm_test_top.environment.scatter_gather_dma_qvip_subenv.mgc_axi4_s0", uvm_test_top_environment_scatter_gather_dma_qvip_subenv_mgc_axi4_s0_sqr) ) 
      `uvm_warning("CFG" , "uvm_config_db #( mvc_sequencer )::get cannot find resource mgc_axi4_s0" ) 


    // pragma uvmf custom new begin
    // pragma uvmf custom new end

  endfunction

  // ****************************************************************************
  virtual task body();
    // pragma uvmf custom body begin

    // Construct sequences here
    dma_done_rsc_responder_seq  = dma_done_rsc_responder_seq_t::type_id::create("dma_done_rsc_responder_seq");
    fork
      dma_done_rsc_config.wait_for_reset();
    join
    // Start RESPONDER sequences here
    fork
      dma_done_rsc_responder_seq.start(dma_done_rsc_sequencer);
    join_none
    // Start INITIATOR sequences here
    fork
    join
    // UVMF_CHANGE_ME : Extend the simulation XXX number of clocks after 
    // the last sequence to allow for the last sequence item to flow 
    // through the design.
    fork
      dma_done_rsc_config.wait_for_num_clocks(400);
    join

    // pragma uvmf custom body end
  endtask

endclass

