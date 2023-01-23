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
// Project         : WB to SPI Project Bench
// Unit            : Top Level Sequences
// File            : wb2spi_regmodel_sequence.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This file contains the top level and utility sequences
//     used by test_top. It can be extended to create derivative top
//     level sequences.
//
//----------------------------------------------------------------------
//
class wb2spi_regmodel_sequence extends wb2spi_sequence_base;

  `uvm_object_utils( wb2spi_regmodel_sequence );

  wb_reset_sequence  wb_reset_s;
  //wb_master_access_sequence wb_master_access_s;
  spi_mem_slave_seq  spi_mem_slave_s;
  bit [63:0] wb_read_data;
  bit [3:0]  spi_read_data;

  wb2spi_reg_block reg_model;

  uvm_status_e status;
  bit [8:0]  temp_data;
  string     report_id;

  uvm_sequencer #(wb_transaction)            wb_sequencer;
  uvm_sequencer #(spi_transaction) spi_sequencer;

  wb_configuration wb_config;

  // ****************************************************************************
  function new( string name = "" );
    super.new( name );
    report_id = get_full_name();
    if( !uvm_config_db #( uvm_sequencer #(wb_transaction) )::get( null , UVMF_SEQUENCERS , "WB_BFM" , wb_sequencer ) ) 
      `uvm_error("Config Error" , "uvm_config_db #( uvm_sequencer#(wb_transaction) )::get cannot find resource wb_sequencer" )
    if( !uvm_config_db #( uvm_sequencer #(spi_transaction) )::get( null , UVMF_SEQUENCERS , "SPI_BFM" , spi_sequencer ) ) 
      `uvm_error("Config Error" , "uvm_config_db #( uvm_sequencer#(spi_transaction) )::get cannot find resource spi_sequencer" )
    if( !uvm_config_db #( wb_configuration )::get( null ,UVMF_CONFIGURATIONS, WB_BFM, wb_config ) )
      `uvm_error("Config Error" , "uvm_config_db #( wb_configuration )::get cannot find resource wb_config" )

    // Create transaction to be used with read and write operations
    wb_master_access_s = wb_master_access_sequence::type_id::create("wb_master_access_s");
  endfunction

  // ****************************************************************************
  task spi_read_via_wb(input bit[2:0] addr);
    //wb_master_access_s.write(2,{1'b0,addr,4'h0},wb_sequencer);
    reg_model.spdr.write(status, {1'b0,addr,4'h0}, .parent(this));
    if (status != UVM_IS_OK) `uvm_fatal(report_id, "Register return is not OK")
    
    // Poll DUT status register until read fifo not empty
    //wb_master_access_s = wb_master_access_sequence::type_id::create("wb_master_access_s");
    //do  wb_master_access_s.read(1,wb_read_data,wb_sequencer);  while (wb_read_data[0] == 1'b1);
    do begin
      reg_model.spsr.read(status,wb_read_data, .parent(this));
      if (status != UVM_IS_OK) `uvm_fatal(report_id, "Register return is not OK")
    end while (wb_read_data[0] == 1'b1);

    //wb_master_access_s.read(2,wb_read_data,wb_sequencer);
    reg_model.spdr.read(status, wb_read_data, .parent(this));
    if (status != UVM_IS_OK) `uvm_fatal(report_id, "Register return is not OK")
    this.spi_read_data = wb_read_data[3:0];

  endtask

  // ****************************************************************************
  task spi_write_via_wb(input bit[2:0] addr, input bit [3:0] spi_write_data);

    //wb_master_access_s.write(2,{1'b1,addr,spi_write_data},wb_sequencer);
    reg_model.spdr.write(status, {1'b1,addr,spi_write_data}, .parent(this));

    // Poll DUT status register until read fifo not empty
    //wb_master_access_s = wb_master_access_sequence::type_id::create("wb_master_access_s");
    //do  wb_master_access_s.read(1,wb_read_data,wb_sequencer);  while (wb_read_data[0] == 1'b1);
    do begin
      reg_model.spsr.read(status,wb_read_data, .parent(this));
      if (status != UVM_IS_OK) `uvm_fatal(report_id, "Register return is not OK")
    end while (wb_read_data[0] == 1'b1);

    //wb_master_access_s.read(2,wb_read_data,wb_sequencer);
    reg_model.spdr.read(status, wb_read_data, .parent(this));
    if (status != UVM_IS_OK) `uvm_fatal(report_id, "Register return is not OK")
    this.spi_read_data = wb_read_data[3:0];

  endtask

  // ****************************************************************************
  task spi_enable();

    //wb_master_access_s = wb_master_access_sequence::type_id::create("wb_master_access_s");
    //wb_master_access_s.write(0,'h50,wb_sequencer);
    reg_model.spcr.write(status, 'h50, .parent(this));

  endtask

  // ****************************************************************************
  virtual task body();
    wb_reset_s = wb_reset_sequence::type_id::create("wb_reset_s");
    spi_mem_slave_s = spi_mem_slave_seq::type_id::create("spi_mem_slave_s");

    if (reg_model == null)
      `uvm_fatal(report_id, "Register Model Handle is null.")
    
    fork spi_mem_slave_s.start(spi_sequencer); join_none

    wb_reset_s.start(wb_sequencer);
    wb_reset_s.start(wb_sequencer);

    spi_enable(); 

    spi_write_via_wb(3'h1,4'hc); // Write and read DUT data register to send 0xc to addr 0x1 on SPI slave
    spi_write_via_wb(3'h2,4'h3); // Write and read DUT data register to send 0x3 to addr 0x2 on SPI slave
    spi_read_via_wb(3'h1);       // Write and read DUT data register to read addr 0x1 on SPI slave
    spi_read_via_wb(3'h2);       // Write and read DUT data register to read addr 0x1 on SPI slave
    spi_write_via_wb(3'h3,4'h5); // Write and read DUT data register to send 0x5 to addr 0x2 on SPI slave

    wb_config.wait_for_num_clocks(100);  // Wait for DUT latency to allow final traffic to flush

  endtask

endclass
