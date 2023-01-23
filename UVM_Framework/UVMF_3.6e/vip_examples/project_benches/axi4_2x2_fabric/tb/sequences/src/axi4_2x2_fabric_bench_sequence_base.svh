//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : daerne
// Creation Date   : 2016 Oct 12
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : axi4_2x2_fabric Simulation Bench 
// Unit            : Bench Sequence Base
// File            : axi4_2x2_fabric_bench_sequence_base.svh
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

  typedef axi4_simple_rd_wr_seq #(  mgc_axi4_m0_params::AXI4_ADDRESS_WIDTH,
                                    mgc_axi4_m0_params::AXI4_RDATA_WIDTH,
                                    mgc_axi4_m0_params::AXI4_WDATA_WIDTH,
                                    mgc_axi4_m0_params::AXI4_ID_WIDTH,
                                    mgc_axi4_m0_params::AXI4_USER_WIDTH,
                                    mgc_axi4_m0_params::AXI4_REGION_MAP_SIZE
                                 ) axi4_simple_rd_wr_seq_t;

  typedef axi4_vip_config #(  mgc_axi4_m0_params::AXI4_ADDRESS_WIDTH,
                              mgc_axi4_m0_params::AXI4_RDATA_WIDTH,
                              mgc_axi4_m0_params::AXI4_WDATA_WIDTH,
                              mgc_axi4_m0_params::AXI4_ID_WIDTH,
                              mgc_axi4_m0_params::AXI4_USER_WIDTH,
                              mgc_axi4_m0_params::AXI4_REGION_MAP_SIZE
                           ) axi4_vip_config_t;

  // Instantiate sequences here
  axi4_simple_rd_wr_seq_t axi4_m0_seq;
  axi4_simple_rd_wr_seq_t axi4_m1_seq;


  // Sequencer handles for each active interface in the environment

  // Sequencer handles for each QVIP interface
  mvc_sequencer mgc_axi4_m0_sqr;
  mvc_sequencer mgc_axi4_m1_sqr;
  mvc_sequencer mgc_axi4_s0_sqr;
  mvc_sequencer mgc_axi4_s1_sqr;

  // Configuration handles to access interface BFM's
  axi4_vip_config_t  mgc_axi4_m0_cfg;




// ****************************************************************************
  function new( string name = "" );
     super.new( name );

  // Retrieve the configuration handles from the uvm_config_db

  // Retrieve the sequencer handles from the uvm_config_db

  // Retrieve QVIP sequencer handles from the uvm_config_db
if( !uvm_config_db #(mvc_sequencer)::get( null,UVMF_SEQUENCERS,"mgc_axi4_m0", mgc_axi4_m0_sqr) ) 
`uvm_error("Config Error" , "uvm_config_db #( mvc_sequencer )::get cannot find resource mgc_axi4_m0" ) 
if( !uvm_config_db #(mvc_sequencer)::get( null,UVMF_SEQUENCERS,"mgc_axi4_m1", mgc_axi4_m1_sqr) ) 
`uvm_error("Config Error" , "uvm_config_db #( mvc_sequencer )::get cannot find resource mgc_axi4_m1" ) 
if( !uvm_config_db #(mvc_sequencer)::get( null,UVMF_SEQUENCERS,"mgc_axi4_s0", mgc_axi4_s0_sqr) ) 
`uvm_error("Config Error" , "uvm_config_db #( mvc_sequencer )::get cannot find resource mgc_axi4_s0" ) 
if( !uvm_config_db #(mvc_sequencer)::get( null,UVMF_SEQUENCERS,"mgc_axi4_s1", mgc_axi4_s1_sqr) ) 
`uvm_error("Config Error" , "uvm_config_db #( mvc_sequencer )::get cannot find resource mgc_axi4_s1" ) 



  endfunction


// ****************************************************************************
  virtual task body();

   mgc_axi4_m0_cfg = axi4_vip_config_t::get_config(mgc_axi4_m0_sqr);

   // Construct sequences here
   axi4_m0_seq = axi4_simple_rd_wr_seq_t::type_id::create("axi4_m0_seq");
   axi4_m1_seq = axi4_simple_rd_wr_seq_t::type_id::create("axi4_m1_seq");

   // Start sequences here
   mgc_axi4_m0_cfg.wait_for_reset();
   mgc_axi4_m0_cfg.wait_for_clock();

   fork
     axi4_m0_seq.start(mgc_axi4_m0_sqr);
     axi4_m1_seq.start(mgc_axi4_m1_sqr);
   join

   // UVMF_CHANGE_ME : Extend the simulation XXX number of clocks after 
   // the last sequence to allow for the last sequence item to flow 
   // through the design.

   repeat(100) mgc_axi4_m0_cfg.wait_for_clock();

  endtask

endclass

