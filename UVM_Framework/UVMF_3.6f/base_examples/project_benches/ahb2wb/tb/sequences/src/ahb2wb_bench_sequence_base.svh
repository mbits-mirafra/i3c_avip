//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 26
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb2wb Simulation Bench 
// Unit            : Bench Sequence Base
// File            : ahb2wb_bench_sequence_base.svh
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

  // Instantiate sequences here
  ahb_master_access_sequence ahb_master_access_s;
  wb_memory_slave_sequence#(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH))   wb_memory_slave_s;

  bit [7:0]  ahb_read_data;

  // Sequencer handles for each active interface in the environment
uvm_sequencer #(ahb_transaction)  ahb_sequencer; 
uvm_sequencer #(wb_transaction#(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH)))  wb_sequencer; 

// Sequencer handles for each QVIP interface

// Configuration handles to access interface BFM's
ahb_configuration                 ahb_config;
wb_configuration#(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH))                 wb_config;




// ****************************************************************************
  function new( string name = "" );
     super.new( name );

  // Retrieve the configuration handles from the uvm_config_db
if( !uvm_config_db #( ahb_configuration )::get( null , UVMF_CONFIGURATIONS , ahb_pkg_ahb_BFM , ahb_config ) ) 
`uvm_error("Config Error" , "uvm_config_db #( ahb_configuration )::get cannot find resource ahb_pkg_ahb_BFM" )
if( !uvm_config_db #( wb_configuration#(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH)) )::get( null , UVMF_CONFIGURATIONS , wb_pkg_wb_BFM , wb_config ) ) 
`uvm_error("Config Error" , "uvm_config_db #( wb_configuration )::get cannot find resource wb_pkg_wb_BFM" )

  // Retrieve the sequencer handles from the uvm_config_db
if( !uvm_config_db #( uvm_sequencer #(ahb_transaction) )::get( null , UVMF_SEQUENCERS , ahb_pkg_ahb_BFM , ahb_sequencer ) ) 
`uvm_error("Config Error" , "uvm_config_db #( uvm_sequencer #(ahb_transaction) )::get cannot find resource ahb_pkg_ahb_BFM" ) 
if( !uvm_config_db #( uvm_sequencer #(wb_transaction#(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH))) )::get( null , UVMF_SEQUENCERS , wb_pkg_wb_BFM , wb_sequencer ) ) 
`uvm_error("Config Error" , "uvm_config_db #( uvm_sequencer #(wb_transaction) )::get cannot find resource wb_pkg_wb_BFM" ) 

  // Retrieve QVIP sequencer handles from the uvm_config_db



  endfunction


// ****************************************************************************
  virtual task body();

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

  endtask

endclass

