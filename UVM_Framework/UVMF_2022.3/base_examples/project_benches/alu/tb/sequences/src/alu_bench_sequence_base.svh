//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
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
    alu_in_random_sequence #(ALU_IN_OP_WIDTH) alu_in_random_s;
  // pragma uvmf custom sequences end

  // Sequencer handles for each active interface in the environment
  typedef alu_in_transaction  alu_in_agent_transaction_t;
  uvm_sequencer #(alu_in_agent_transaction_t)  alu_in_agent_sequencer; 


  // Top level environment configuration handle
  typedef alu_env_configuration  alu_env_configuration_t;
  alu_env_configuration_t top_configuration;

  // Configuration handles to access interface BFM's
  alu_in_configuration  alu_in_agent_config;
  alu_out_configuration  alu_out_agent_config;

  // pragma uvmf custom class_item_additional begin
  virtual task setup();
     alu_in_agent_config.wait_for_reset();
     alu_in_agent_config.wait_for_num_clocks(2); 
  endtask

  virtual task flush();
     alu_in_agent_config.wait_for_num_clocks(50);  // 50 = 1000ns/20ns
  endtask


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
    if( !uvm_config_db #( alu_in_configuration )::get( null , UVMF_CONFIGURATIONS , alu_in_agent_BFM , alu_in_agent_config ) ) 
      `uvm_fatal("CFG" , "uvm_config_db #( alu_in_configuration )::get cannot find resource alu_in_agent_BFM" )
    if( !uvm_config_db #( alu_out_configuration )::get( null , UVMF_CONFIGURATIONS , alu_out_agent_BFM , alu_out_agent_config ) ) 
      `uvm_fatal("CFG" , "uvm_config_db #( alu_out_configuration )::get cannot find resource alu_out_agent_BFM" )

    // Assign the sequencer handles from the handles within agent configurations
    alu_in_agent_sequencer = alu_in_agent_config.get_sequencer();



  // pragma uvmf custom new begin
  // pragma uvmf custom new end

  endfunction

  // ****************************************************************************
  virtual task body();
    // pragma uvmf custom body begin
     alu_in_random_s = alu_in_random_sequence#(ALU_IN_OP_WIDTH)::type_id::create("alu_in_random_s");

     setup();
     repeat (100) alu_in_random_s.start(alu_in_agent_sequencer);
     flush();


    // pragma uvmf custom body end
  endtask

endclass

