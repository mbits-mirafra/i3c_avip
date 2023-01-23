//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU Simulation Bench 
// Unit            : Bench Sequence Base
// File            : FPU_bench_sequence_base.svh
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

class FPU_bench_sequence_base extends uvmf_sequence_base #(uvm_sequence_item);

  `uvm_object_utils( FPU_bench_sequence_base );

  // UVMF_CHANGE_ME : Instantiate, construct, and start sequences as needed to create stimulus scenarios.

  // Instantiate sequences here
typedef FPU_in_random_sequence  FPU_in_agent_random_seq_t;
FPU_in_agent_random_seq_t FPU_in_agent_random_seq;
typedef FPU_out_random_sequence  FPU_out_agent_random_seq_t;
FPU_out_agent_random_seq_t FPU_out_agent_random_seq;

  // Sequencer handles for each active interface in the environment
typedef FPU_in_transaction  FPU_in_agent_transaction_t;
uvm_sequencer #(FPU_in_agent_transaction_t)  FPU_in_agent_sequencer; 

// Sequencer handles for each QVIP interface

// Top level environment configuration handle
typedef FPU_env_configuration FPU_env_configuration_t;
FPU_env_configuration_t top_configuration;


// Configuration handles to access interface BFM's
FPU_in_configuration   FPU_in_agent_config;
FPU_out_configuration   FPU_out_agent_config;




// ****************************************************************************
  function new( string name = "" );
     super.new( name );

  // Retrieve the configuration handles from the uvm_config_db

  // Retrieve top level configuration handle
  if ( !uvm_config_db#(FPU_env_configuration_t)::get(null,UVMF_CONFIGURATIONS, "TOP_ENV_CONFIG",top_configuration) ) begin
    `uvm_fatal("CFG", "uvm_config_db#(FPU_env_configuration_t)::get cannot find resource TOP_ENV_CONFIG");
  end

  // Retrieve config handles for all agents
if( !uvm_config_db #( FPU_in_configuration )::get( null , UVMF_CONFIGURATIONS , FPU_in_agent_BFM , FPU_in_agent_config ) ) 
`uvm_fatal("CFG" , "uvm_config_db #( FPU_in_configuration )::get cannot find resource FPU_in_agent_BFM" )
if( !uvm_config_db #( FPU_out_configuration )::get( null , UVMF_CONFIGURATIONS , FPU_out_agent_BFM , FPU_out_agent_config ) ) 
`uvm_fatal("CFG" , "uvm_config_db #( FPU_out_configuration )::get cannot find resource FPU_out_agent_BFM" )

  // Retrieve the sequencer handles from the uvm_config_db
if( !uvm_config_db #( uvm_sequencer #(FPU_in_agent_transaction_t) )::get( null , UVMF_SEQUENCERS , FPU_in_agent_BFM , FPU_in_agent_sequencer ) ) 
`uvm_fatal("CFG" , "uvm_config_db #( uvm_sequencer #(FPU_in_transaction) )::get cannot find resource FPU_in_agent_BFM" ) 

  // Retrieve QVIP sequencer handles from the uvm_config_db



  endfunction


// ****************************************************************************
  virtual task body();

  // Construct sequences here
   FPU_in_agent_random_seq     = FPU_in_agent_random_seq_t::type_id::create("FPU_in_agent_random_seq");

   fork
    FPU_in_agent_config.wait_for_reset();
    FPU_out_agent_config.wait_for_reset();
   join

  // Start RESPONDER sequences here
   fork
   join_none

  // Start INITIATOR sequences here
   fork
       repeat (25) FPU_in_agent_random_seq.start(FPU_in_agent_sequencer);
   join


   // UVMF_CHANGE_ME : Extend the simulation XXX number of clocks after 
   // the last sequence to allow for the last sequence item to flow 
   // through the design.

  fork
    FPU_in_agent_config.wait_for_num_clocks(400);
    FPU_out_agent_config.wait_for_num_clocks(400);
  join

  endtask

endclass

