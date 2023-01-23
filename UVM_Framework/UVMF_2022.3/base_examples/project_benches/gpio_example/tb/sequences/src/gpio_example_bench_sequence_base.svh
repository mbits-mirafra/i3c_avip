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

class gpio_example_bench_sequence_base extends uvmf_sequence_base #(uvm_sequence_item);

  `uvm_object_utils( gpio_example_bench_sequence_base );

  // pragma uvmf custom sequences begin
typedef gpio_gpio_sequence #(.WRITE_PORT_WIDTH(32),.READ_PORT_WIDTH(16))  gpio_a_seq_t;
gpio_a_seq_t gpio_a_wr_seq;
gpio_a_seq_t gpio_a_rd_seq;
typedef gpio_gpio_sequence #(.WRITE_PORT_WIDTH(16),.READ_PORT_WIDTH(32))  gpio_b_seq_t;
gpio_b_seq_t gpio_b_wr_seq;
gpio_b_seq_t gpio_b_rd_seq;
  // pragma uvmf custom sequences end

  // Sequencer handles for each active interface in the environment
  typedef gpio_transaction #(
        .WRITE_PORT_WIDTH(32),
        .READ_PORT_WIDTH(16)
        ) gpio_a_transaction_t;
  uvm_sequencer #(gpio_a_transaction_t)  gpio_a_sequencer; 
  typedef gpio_transaction #(
        .WRITE_PORT_WIDTH(16),
        .READ_PORT_WIDTH(32)
        ) gpio_b_transaction_t;
  uvm_sequencer #(gpio_b_transaction_t)  gpio_b_sequencer; 


  // Top level environment configuration handle
  typedef gpio_example_env_configuration  gpio_example_env_configuration_t;
  gpio_example_env_configuration_t top_configuration;

  // Configuration handles to access interface BFM's
  gpio_configuration #(
        .WRITE_PORT_WIDTH(32),
        .READ_PORT_WIDTH(16)
        ) gpio_a_config;
  gpio_configuration #(
        .WRITE_PORT_WIDTH(16),
        .READ_PORT_WIDTH(32)
        ) gpio_b_config;

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end

  // ****************************************************************************
  function new( string name = "" );
    super.new( name );
    // Retrieve the configuration handles from the uvm_config_db

    // Retrieve top level configuration handle
    if ( !uvm_config_db#(gpio_example_env_configuration_t)::get(null,UVMF_CONFIGURATIONS, "TOP_ENV_CONFIG",top_configuration) ) begin
      `uvm_info("CFG", "*** FATAL *** uvm_config_db::get can not find TOP_ENV_CONFIG.  Are you using an older UVMF release than what was used to generate this bench?",UVM_NONE);
      `uvm_fatal("CFG", "uvm_config_db#(gpio_example_env_configuration_t)::get cannot find resource TOP_ENV_CONFIG");
    end

    // Retrieve config handles for all agents
    if( !uvm_config_db #( gpio_configuration#(
        .WRITE_PORT_WIDTH(32),
        .READ_PORT_WIDTH(16)
        ) )::get( null , UVMF_CONFIGURATIONS , gpio_a_BFM , gpio_a_config ) ) 
      `uvm_fatal("CFG" , "uvm_config_db #( gpio_configuration )::get cannot find resource gpio_a_BFM" )
    if( !uvm_config_db #( gpio_configuration#(
        .WRITE_PORT_WIDTH(16),
        .READ_PORT_WIDTH(32)
        ) )::get( null , UVMF_CONFIGURATIONS , gpio_b_BFM , gpio_b_config ) ) 
      `uvm_fatal("CFG" , "uvm_config_db #( gpio_configuration )::get cannot find resource gpio_b_BFM" )

    // Assign the sequencer handles from the handles within agent configurations
    gpio_a_sequencer = gpio_a_config.get_sequencer();
    gpio_b_sequencer = gpio_b_config.get_sequencer();



  // pragma uvmf custom new begin
  // pragma uvmf custom new end

  endfunction

  // ****************************************************************************
  virtual task body();
    // pragma uvmf custom body begin
   gpio_a_wr_seq     = gpio_a_seq_t::type_id::create("gpio_a_wr_seq");
   gpio_a_rd_seq     = gpio_a_seq_t::type_id::create("gpio_a_rd_seq");
   gpio_b_wr_seq     = gpio_b_seq_t::type_id::create("gpio_b_wr_seq");
   gpio_b_rd_seq     = gpio_b_seq_t::type_id::create("gpio_b_rd_seq");

   gpio_a_wr_seq.set_sequencer(gpio_a_sequencer);
   gpio_a_rd_seq.set_sequencer(gpio_a_sequencer);
   gpio_a_rd_seq.start(gpio_a_sequencer);

   gpio_b_wr_seq.set_sequencer(gpio_b_sequencer);
   gpio_b_rd_seq.set_sequencer(gpio_b_sequencer);
   gpio_b_rd_seq.start(gpio_b_sequencer);

   gpio_a_config.wait_for_num_clocks(2);
   gpio_a_wr_seq.bus_a = 16'h1234;
   gpio_a_wr_seq.bus_b = 16'h5678;
   gpio_a_wr_seq.write_gpio();
   gpio_b_config.wait_for_num_clocks(2);
   gpio_b_wr_seq.bus_a = 8'hab;
   gpio_b_wr_seq.bus_b = 8'hcd;
   gpio_b_wr_seq.write_gpio();

   gpio_a_config.wait_for_num_clocks(2);
   gpio_a_rd_seq.read_gpio();

   gpio_b_config.wait_for_num_clocks(2);
   gpio_b_rd_seq.read_gpio();

   gpio_a_config.wait_for_num_clocks(10);
    // pragma uvmf custom body end
  endtask

endclass

