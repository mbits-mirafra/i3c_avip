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
// Project         : AHB to SPI Project Bench
// Unit            : Top Level Sequences
// File            : ahb2spi_sequence_base.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This file contains the top level and utility sequences
//     used by test_top. It can be extended to create new test stimulus
//     scenarios.
//
//----------------------------------------------------------------------
//
class ahb2spi_sequence_base extends uvm_sequence #(uvm_sequence_item);

  `uvm_object_utils( ahb2spi_sequence_base );

  ahb_reset_sequence  ahb_reset_s;
  ahb_master_access_sequence ahb_master_access_s;

  spi_mem_slave_seq  spi_mem_slave_s;

  uvm_sequencer #(ahb_transaction)            ahb_sequencer;
  uvm_sequencer #(spi_transaction ) spi_sequencer;

  bit [7:0]  ahb_read_data;

  uvm_status_e status;
  string report_id;

  ahb_configuration ahb_config;

// ****************************************************************************
  function new( string name = "" );
     super.new( name );
     report_id = get_full_name();

    if( !uvm_config_db #( uvm_sequencer #(ahb_transaction) )::get( null , UVMF_SEQUENCERS , AHB_BFM , ahb_sequencer ) )
            `uvm_error("Config Error" , "uvm_config_db #( uvm_sequencer#(ahb_transaction) )::get cannot find resource ahb_sequencer" )
    if( !uvm_config_db #( uvm_sequencer #(spi_transaction) )::get( null , UVMF_SEQUENCERS , SPI_BFM , spi_sequencer ) )
            `uvm_error("Config Error" , "uvm_config_db #( uvm_sequencer#(spi_transaction) )::get cannot find resource spi_sequencer" )
    if( !uvm_config_db #( ahb_configuration )::get( null ,UVMF_CONFIGURATIONS, AHB_BFM, ahb_config ) )
            `uvm_error("Config Error" , "uvm_config_db #( ahb_configuration )::get cannot find resource ahb_config" )

  endfunction

// ****************************************************************************
  task spi_read_via_ahb(input bit[2:0] addr);

     ahb_master_access_s = ahb_master_access_sequence::type_id::create("ahb_master_access_s");
     ahb_master_access_s.write(2,{1'b0,addr,4'h0},ahb_sequencer);

     // Poll DUT status register until read fifo not empty
     ahb_master_access_s = ahb_master_access_sequence::type_id::create("ahb_master_access_s");
     do  ahb_master_access_s.read(1,ahb_read_data,ahb_sequencer);  while (ahb_read_data[0] == 1'b1);

     ahb_master_access_s.read(2,ahb_read_data,ahb_sequencer);

  endtask

// ****************************************************************************
  task spi_write_via_ahb(input bit[2:0] addr, input bit [3:0] spi_write_data);
     ahb_master_access_s = ahb_master_access_sequence::type_id::create("ahb_master_access_s");
     ahb_master_access_s.write(2,{1'b1,addr,spi_write_data},ahb_sequencer);

     // Poll DUT status register until read fifo not empty
     ahb_master_access_s = ahb_master_access_sequence::type_id::create("ahb_master_access_s");
     do  ahb_master_access_s.read(1,ahb_read_data,ahb_sequencer);  while (ahb_read_data[0] == 1'b1);

     ahb_master_access_s.read(2,ahb_read_data,ahb_sequencer);

  endtask

// ****************************************************************************
  virtual task body();
     ahb_reset_s = ahb_reset_sequence::type_id::create("ahb_reset_s");
     ahb_master_access_s = ahb_master_access_sequence::type_id::create("ahb_master_access_s");

     spi_mem_slave_s = spi_mem_slave_seq::type_id::create("spi_mem_slave_s");

     ahb_reset_s.start(ahb_sequencer);

     fork spi_mem_slave_s.start(spi_sequencer); join_none

     ahb_reset_s.start(ahb_sequencer);

     // Read the wb2spi status register
     ahb_master_access_s.read (0,ahb_read_data, ahb_sequencer);

     // Enable wb2spi device
     ahb_master_access_s.read (0,ahb_read_data, ahb_sequencer);
     ahb_master_access_s.write(0, 8'h50,ahb_sequencer);
     ahb_master_access_s.read (0,ahb_read_data, ahb_sequencer);

     spi_write_via_ahb(3'h1,4'hc); // Write and read DUT data register to send 0xc to addr 0x1 on SPI slave
     spi_write_via_ahb(3'h2,4'h3); // Write and read DUT data register to send 0x3 to addr 0x2 on SPI slave
     spi_read_via_ahb(3'h1);       // Write and read DUT data register to read addr 0x1 on SPI slave
     spi_read_via_ahb(3'h2);       // Write and read DUT data register to read addr 0x1 on SPI slave
     spi_write_via_ahb(3'h3,4'h5); // Write and read DUT data register to send 0x5 to addr 0x2 on SPI slave


     ahb_config.wait_for_num_clocks(20);  // Wait for DUT latency to allow final traffic to flush

  endtask

endclass
