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

class ahb2wb_bench_sequence_base extends uvmf_sequence_base #(uvm_sequence_item);

  `uvm_object_utils( ahb2wb_bench_sequence_base );

  // pragma uvmf custom sequences begin
  // Instantiate sequences here
  ahb_master_access_sequence ahb_master_access_s;
  wb_memory_slave_sequence#(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH))   wb_memory_slave_s;



  // pragma uvmf custom sequences end

  // Sequencer handles for each active interface in the environment
  typedef wb_transaction  wb_transaction_t;
  uvm_sequencer #(wb_transaction_t)  wb_sequencer; 
  typedef ahb_transaction  ahb_transaction_t;
  uvm_sequencer #(ahb_transaction_t)  ahb_sequencer; 


  // Top level environment configuration handle
  typedef ahb2wb_env_configuration  ahb2wb_env_configuration_t;
  ahb2wb_env_configuration_t top_configuration;

  // Configuration handles to access interface BFM's
  wb_configuration  wb_config;
  ahb_configuration  ahb_config;

  // pragma uvmf custom class_item_additional begin
  bit [7:0]  ahb_read_data;
  // pragma uvmf custom class_item_additional end

  // ****************************************************************************
  function new( string name = "" );
    super.new( name );
    // Retrieve the configuration handles from the uvm_config_db

    // Retrieve top level configuration handle
    if ( !uvm_config_db#(ahb2wb_env_configuration_t)::get(null,UVMF_CONFIGURATIONS, "TOP_ENV_CONFIG",top_configuration) ) begin
      `uvm_info("CFG", "*** FATAL *** uvm_config_db::get can not find TOP_ENV_CONFIG.  Are you using an older UVMF release than what was used to generate this bench?",UVM_NONE);
      `uvm_fatal("CFG", "uvm_config_db#(ahb2wb_env_configuration_t)::get cannot find resource TOP_ENV_CONFIG");
    end

    // Retrieve config handles for all agents
    if( !uvm_config_db #( wb_configuration )::get( null , UVMF_CONFIGURATIONS , wb_BFM , wb_config ) ) 
      `uvm_fatal("CFG" , "uvm_config_db #( wb_configuration )::get cannot find resource wb_BFM" )
    if( !uvm_config_db #( ahb_configuration )::get( null , UVMF_CONFIGURATIONS , ahb_BFM , ahb_config ) ) 
      `uvm_fatal("CFG" , "uvm_config_db #( ahb_configuration )::get cannot find resource ahb_BFM" )

    // Assign the sequencer handles from the handles within agent configurations
    wb_sequencer = wb_config.get_sequencer();
    ahb_sequencer = ahb_config.get_sequencer();



  // pragma uvmf custom new begin
  // pragma uvmf custom new end

  endfunction

  // ****************************************************************************
  virtual task body();
    // pragma uvmf custom body begin
     ahb_master_access_s = ahb_master_access_sequence::type_id::create("ahb_master_access_s");
     wb_memory_slave_s = wb_memory_slave_sequence#(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH))::type_id::create("wb_memory_slave_s");

     fork wb_memory_slave_s.start(wb_sequencer); join_none

     ahb_master_access_s.write(1, 8'hab,ahb_sequencer);
     ahb_master_access_s.write(2, 8'hcd,ahb_sequencer);
     ahb_master_access_s.write(3, 8'hef,ahb_sequencer);
     ahb_master_access_s.write(0, 8'h45,ahb_sequencer);
     ahb_master_access_s.read(2,ahb_read_data,ahb_sequencer);
     ahb_master_access_s.read(1,ahb_read_data,ahb_sequencer);
     ahb_master_access_s.read(0,ahb_read_data,ahb_sequencer);
     ahb_master_access_s.read(3,ahb_read_data,ahb_sequencer);
     ahb_master_access_s.write(0, 8'h69,ahb_sequencer);
     ahb_master_access_s.read(3,ahb_read_data,ahb_sequencer);
     ahb_master_access_s.read(0,ahb_read_data,ahb_sequencer);
     wb_config.wait_for_num_clocks(10);  // Wait for DUT latency to allow final traffic to flush



    // pragma uvmf custom body end
  endtask

endclass

