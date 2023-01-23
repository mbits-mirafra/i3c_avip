//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 26
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb2spi Simulation Bench 
// Unit            : Bench Sequence Base
// File            : ahb2spi_bench_sequence_base.svh
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

class ahb2spi_bench_sequence_base extends uvmf_sequence_base #(uvm_sequence_item);

  `uvm_object_utils( ahb2spi_bench_sequence_base );

  // Instantiate sequences here
  ahb_master_access_sequence ahb_master_access_s;

  spi_mem_slave_seq  spi_mem_slave_s;

  bit [7:0]  ahb_read_data;
  uvm_status_e status;
  string report_id;

  // Sequencer handles for each active interface in the environment
uvm_sequencer #(ahb_transaction)  ahb_sequencer; 
uvm_sequencer #(spi_transaction)  spi_sequencer; 

// Sequencer handles for each QVIP interface

// Configuration handles to access interface BFM's
ahb_configuration                 ahb_config;
wb_configuration                 wb_config;
spi_configuration                 spi_config;




// ****************************************************************************
  function new( string name = "" );
     super.new( name );

  // Retrieve the configuration handles from the uvm_config_db
if( !uvm_config_db #( ahb_configuration )::get( null , UVMF_CONFIGURATIONS , ahb_pkg_ahb_BFM , ahb_config ) ) 
`uvm_error("Config Error" , "uvm_config_db #( ahb_configuration )::get cannot find resource ahb_pkg_ahb_BFM" )
if( !uvm_config_db #( wb_configuration )::get( null , UVMF_CONFIGURATIONS , wb_pkg_wb_BFM , wb_config ) ) 
`uvm_error("Config Error" , "uvm_config_db #( wb_configuration )::get cannot find resource wb_pkg_wb_BFM" )
if( !uvm_config_db #( spi_configuration )::get( null , UVMF_CONFIGURATIONS , spi_pkg_spi_BFM , spi_config ) ) 
`uvm_error("Config Error" , "uvm_config_db #( spi_configuration )::get cannot find resource spi_pkg_spi_BFM" )

  // Retrieve the sequencer handles from the uvm_config_db
if( !uvm_config_db #( uvm_sequencer #(ahb_transaction) )::get( null , UVMF_SEQUENCERS , ahb_pkg_ahb_BFM , ahb_sequencer ) ) 
`uvm_error("Config Error" , "uvm_config_db #( uvm_sequencer #(ahb_transaction) )::get cannot find resource ahb_pkg_ahb_BFM" ) 
if( !uvm_config_db #( uvm_sequencer #(spi_transaction) )::get( null , UVMF_SEQUENCERS , spi_pkg_spi_BFM , spi_sequencer ) ) 
`uvm_error("Config Error" , "uvm_config_db #( uvm_sequencer #(spi_transaction) )::get cannot find resource spi_pkg_spi_BFM" ) 

  // Retrieve QVIP sequencer handles from the uvm_config_db



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
     ahb_master_access_s = ahb_master_access_sequence::type_id::create("ahb_master_access_s");

     spi_mem_slave_s = spi_mem_slave_seq::type_id::create("spi_mem_slave_s");

    wb_config.wait_for_num_clocks(5);

     fork spi_mem_slave_s.start(spi_sequencer); join_none


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

    wb_config.wait_for_num_clocks(100);

  endtask

endclass

