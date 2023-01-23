//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Nov 30
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : gpio_example Simulation Bench 
// Unit            : Bench Sequence Base
// File            : gpio_example_bench_sequence_base.svh
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

  // Instantiate sequences here
typedef gpio_gpio_sequence #(.WRITE_PORT_WIDTH(32),.READ_PORT_WIDTH(16))  gpio_a_seq_t;
gpio_a_seq_t gpio_a_seq;
typedef gpio_gpio_sequence #(.WRITE_PORT_WIDTH(16),.READ_PORT_WIDTH(32))  gpio_b_seq_t;
gpio_b_seq_t gpio_b_seq;

  // Sequencer handles for each active interface in the environment
typedef gpio_transaction #(.WRITE_PORT_WIDTH(32),.READ_PORT_WIDTH(16))  gpio_a_transaction_t;
uvm_sequencer #(gpio_a_transaction_t)  gpio_a_sequencer; 
typedef gpio_transaction #(.WRITE_PORT_WIDTH(16),.READ_PORT_WIDTH(32))  gpio_b_transaction_t;
uvm_sequencer #(gpio_b_transaction_t)  gpio_b_sequencer; 

// Sequencer handles for each QVIP interface

// Configuration handles to access interface BFM's
gpio_configuration  #(.WRITE_PORT_WIDTH(32),.READ_PORT_WIDTH(16))  gpio_a_config;
gpio_configuration  #(.WRITE_PORT_WIDTH(16),.READ_PORT_WIDTH(32))  gpio_b_config;




// ****************************************************************************
  function new( string name = "" );
     super.new( name );

  // Retrieve the configuration handles from the uvm_config_db
if( !uvm_config_db #( gpio_configuration #(.WRITE_PORT_WIDTH(32),.READ_PORT_WIDTH(16)) )::get( null , UVMF_CONFIGURATIONS , gpio_pkg_gpio_a_BFM , gpio_a_config ) ) 
`uvm_error("Config Error" , "uvm_config_db #( gpio_configuration )::get cannot find resource gpio_pkg_gpio_a_BFM" )
if( !uvm_config_db #( gpio_configuration #(.WRITE_PORT_WIDTH(16),.READ_PORT_WIDTH(32)) )::get( null , UVMF_CONFIGURATIONS , gpio_pkg_gpio_b_BFM , gpio_b_config ) ) 
`uvm_error("Config Error" , "uvm_config_db #( gpio_configuration )::get cannot find resource gpio_pkg_gpio_b_BFM" )

  // Retrieve the sequencer handles from the uvm_config_db
if( !uvm_config_db #( uvm_sequencer #(gpio_a_transaction_t) )::get( null , UVMF_SEQUENCERS , gpio_pkg_gpio_a_BFM , gpio_a_sequencer ) ) 
`uvm_error("Config Error" , "uvm_config_db #( uvm_sequencer #(gpio_transaction) )::get cannot find resource gpio_pkg_gpio_a_BFM" ) 
if( !uvm_config_db #( uvm_sequencer #(gpio_b_transaction_t) )::get( null , UVMF_SEQUENCERS , gpio_pkg_gpio_b_BFM , gpio_b_sequencer ) ) 
`uvm_error("Config Error" , "uvm_config_db #( uvm_sequencer #(gpio_transaction) )::get cannot find resource gpio_pkg_gpio_b_BFM" ) 

  // Retrieve QVIP sequencer handles from the uvm_config_db



  endfunction


// ****************************************************************************
  virtual task body();

  // Construct sequences here
   gpio_a_seq     = gpio_a_seq_t::type_id::create("gpio_a_seq");
   gpio_b_seq     = gpio_b_seq_t::type_id::create("gpio_b_seq");

   gpio_a_seq.set_sequencer(gpio_a_sequencer);
   gpio_b_seq.set_sequencer(gpio_b_sequencer);

   gpio_a_config.wait_for_num_clocks(2);
   gpio_a_seq.bus_a = 16'h1234;
   gpio_a_seq.bus_b = 16'h5678;
   gpio_a_seq.write_gpio();
   gpio_b_config.wait_for_num_clocks(2);
   gpio_b_seq.bus_a = 8'hab;
   gpio_b_seq.bus_b = 8'hcd;
   gpio_b_seq.write_gpio();

   gpio_a_config.wait_for_num_clocks(2);
   gpio_a_seq.read_gpio();

   gpio_b_config.wait_for_num_clocks(2);
   gpio_b_seq.read_gpio();

   gpio_a_config.wait_for_num_clocks(10);

  endtask

endclass

