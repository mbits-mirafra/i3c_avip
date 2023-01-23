//----------------------------------------------------------------------
// Created with uvmf_gen version 2020.1
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

class alu_bench_sequence_base extends uvmf_sequence_base #(uvm_sequence_item);

  `uvm_object_utils( alu_bench_sequence_base );

  // pragma uvmf custom sequences begin
  // UVMF_CHANGE_ME : Instantiate, construct, and start sequences as needed to create stimulus scenarios.
  // Instantiate sequences here
  typedef alu_in_random_sequence #(
        .ALU_IN_OP_WIDTH(TEST_ALU_IN_OP_WIDTH)
        ) alu_in_agent_random_seq_t;
  alu_in_agent_random_seq_t alu_in_agent_random_seq;
  // pragma uvmf custom sequences end

  // Sequencer handles for each active interface in the environment
  typedef alu_in_transaction #(
        .ALU_IN_OP_WIDTH(TEST_ALU_IN_OP_WIDTH)
        ) alu_in_agent_transaction_t;
  uvm_sequencer #(alu_in_agent_transaction_t)  alu_in_agent_sequencer; 

  // Sequencer handles for each QVIP interface
  mvc_sequencer uvm_test_top_environment_qvip_agents_env_apb_master_0_sqr;

  // Top level environment configuration handle
  typedef alu_env_configuration #(
        .APB_RDATA_WIDTH(TEST_APB_RDATA_WIDTH),
        .APB_WDATA_WIDTH(TEST_APB_WDATA_WIDTH),
        .APB_ADDR_WIDTH(TEST_APB_ADDR_WIDTH),
        .ALU_OUT_RESULT_WIDTH(TEST_ALU_OUT_RESULT_WIDTH),
        .ALU_IN_OP_WIDTH(TEST_ALU_IN_OP_WIDTH)
        ) alu_env_configuration_t;
  alu_env_configuration_t top_configuration;

  // Configuration handles to access interface BFM's
  alu_in_configuration #(
        .ALU_IN_OP_WIDTH(TEST_ALU_IN_OP_WIDTH)
        ) alu_in_agent_config;
  alu_out_configuration #(
        .ALU_OUT_RESULT_WIDTH(TEST_ALU_OUT_RESULT_WIDTH)
        ) alu_out_agent_config;
  // Local handle to register model for convenience
  alu_reg_model reg_model;
  uvm_status_e status;

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end

  // ****************************************************************************
  function new( string name = "" );
    super.new( name );
    // Retrieve the configuration handles from the uvm_config_db

    // Retrieve top level configuration handle
    if ( !uvm_config_db#(alu_env_configuration_t)::get(null,UVMF_CONFIGURATIONS, "TOP_ENV_CONFIG",top_configuration) ) begin
      `uvm_info("CFG", "*** FATAL *** uvm_config_db::get can not find TOP_ENV_CONFIG.  Are you using an older UVMF release than what was used to generate this bench?",UVM_NONE);
      `uvm_fatal("CFG", "uvm_config_db#(alu_env_configuration_t)::get cannot find resource TOP_ENV_CONFIG");
    end

    // Retrieve config handles for all agents
    if( !uvm_config_db #( alu_in_configuration#(
        .ALU_IN_OP_WIDTH(TEST_ALU_IN_OP_WIDTH)
        ) )::get( null , UVMF_CONFIGURATIONS , alu_in_agent_BFM , alu_in_agent_config ) ) 
      `uvm_fatal("CFG" , "uvm_config_db #( alu_in_configuration )::get cannot find resource alu_in_agent_BFM" )
    if( !uvm_config_db #( alu_out_configuration#(
        .ALU_OUT_RESULT_WIDTH(TEST_ALU_OUT_RESULT_WIDTH)
        ) )::get( null , UVMF_CONFIGURATIONS , alu_out_agent_BFM , alu_out_agent_config ) ) 
      `uvm_fatal("CFG" , "uvm_config_db #( alu_out_configuration )::get cannot find resource alu_out_agent_BFM" )

    // Assign the sequencer handles from the handles within agent configurations
    alu_in_agent_sequencer = alu_in_agent_config.get_sequencer();

    // Retrieve QVIP sequencer handles from the uvm_config_db
    if( !uvm_config_db #(mvc_sequencer)::get( null,UVMF_SEQUENCERS,"uvm_test_top.environment.qvip_agents_env.apb_master_0", uvm_test_top_environment_qvip_agents_env_apb_master_0_sqr) ) 
      `uvm_warning("CFG" , "uvm_config_db #( mvc_sequencer )::get cannot find resource apb_master_0" ) 
    reg_model = top_configuration.alu_rm;


    // pragma uvmf custom new begin
    // pragma uvmf custom new end

  endfunction

  // ****************************************************************************
  virtual task body();
    // pragma uvmf custom body begin

    // Construct sequences here
    alu_in_agent_random_seq     = alu_in_agent_random_seq_t::type_id::create("alu_in_agent_random_seq");

    // Delay start of sequence until reset has ended and then wait a few clocks after that
    alu_in_agent_config.wait_for_reset();
    alu_in_agent_config.wait_for_num_clocks(10);

    reg_model.reset();
    // Start RESPONDER sequences here
    fork
    join_none
    // Start INITIATOR sequences here
    fork
      repeat (25) alu_in_agent_random_seq.start(alu_in_agent_sequencer);
    join
    // UVMF_CHANGE_ME : Extend the simulation XXX number of clocks after 
    // the last sequence to allow for the last sequence item to flow 
    // through the design.
    fork
      alu_in_agent_config.wait_for_num_clocks(400);
      alu_out_agent_config.wait_for_num_clocks(400);
    join

    // pragma uvmf custom body end
  endtask

endclass

