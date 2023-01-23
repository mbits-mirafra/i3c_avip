//----------------------------------------------------------------------
//   Copyright 2013 Mentor Graphics Corporation
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//                   Mentor Graphics Inc
//----------------------------------------------------------------------
// Project         : AHB to WB Simulation Bench
// Unit            : Sequence base
// File            : ahb2wb_sequence_base.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: this class defines the base top level sequence used
//    for ahb to wb block level simulations. It is used as the top
//    level sequence for test_top. It is extended to create
//    specific test scenarios.
//
//----------------------------------------------------------------------
//
class ahb2wb_sequence_base extends uvm_sequence #(uvm_sequence_item);

  `uvm_object_utils( ahb2wb_sequence_base );

  ahb_reset_sequence  ahb_reset_s;
  ahb_master_access_sequence ahb_master_access_s;
  wb_memory_slave_sequence   wb_memory_slave_s;

  uvm_sequencer #(ahb_transaction) ahb_sequencer;
  uvm_sequencer #(wb_transaction ) wb_sequencer;

  bit [7:0]  ahb_read_data;

  uvm_status_e status;
  string report_id;

  wb_configuration wb_config;

// ****************************************************************************
  function new( string name = "" );
     super.new( name );
     report_id = get_full_name();

    if( !uvm_config_db #( uvm_sequencer #(ahb_transaction) )::get( null , UVMF_SEQUENCERS , AHB_BFM , ahb_sequencer ) )
            `uvm_error("Config Error" , "uvm_config_db #( uvm_sequencer#(ahb_transaction) )::get cannot find resource ahb_sequencer" )
    if( !uvm_config_db #( uvm_sequencer #(wb_transaction) )::get( null , UVMF_SEQUENCERS , WB_BFM , wb_sequencer ) )
            `uvm_error("Config Error" , "uvm_config_db #( uvm_sequencer#(wb_transaction) )::get cannot find resource wb_sequencer" )
    if( !uvm_config_db #( wb_configuration )::get( null ,UVMF_CONFIGURATIONS, WB_BFM, wb_config ) ) 
            `uvm_error("Config Error" , "uvm_config_db #( wb_configuration )::get cannot find resource wb_config" )

  endfunction

// ****************************************************************************
  virtual task body();
     ahb_reset_s = ahb_reset_sequence::type_id::create("ahb_reset_s");
     ahb_master_access_s = ahb_master_access_sequence::type_id::create("ahb_master_access_s");
     wb_memory_slave_s = wb_memory_slave_sequence::type_id::create("wb_memory_slave_s");


     ahb_reset_s.start(ahb_sequencer);

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
