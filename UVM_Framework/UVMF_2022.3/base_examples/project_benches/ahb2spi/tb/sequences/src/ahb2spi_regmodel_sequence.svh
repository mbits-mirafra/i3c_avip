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
// File            : ahb2spi_regmodel_sequence.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This file contains the top level and utility sequences
//     used by test_top. It can be extended to create new test stimulus
//     scenarios.
//
//----------------------------------------------------------------------
//
class ahb2spi_regmodel_sequence extends ahb2spi_bench_sequence_base;

  `uvm_object_utils( ahb2spi_regmodel_sequence );

  //ahb_master_access_sequence ahb_master_access_s;

  spi_mem_slave_seq  spi_mem_slave_s;

  bit [7:0]  ahb_read_data;

  uvm_status_e status;
  string report_id;

// ****************************************************************************
  function new( string name = "" );
     super.new( name );
  endfunction

// ****************************************************************************
  virtual task spi_read_via_ahb(input bit[2:0] addr);

    //ahb_master_access_s = ahb_master_access_sequence::type_id::create("ahb_master_access_s");
    //ahb_master_access_s.write(2,{1'b0,addr,4'h0},ahb_sequencer);
    reg_model.wb2spi_rm.spdr.write(status, {1'b0,addr,4'h0}, .parent(this));
    if (status != UVM_IS_OK) `uvm_fatal("SEQ", "Register return is not OK")

     // Poll DUT status register until read fifo not empty
     //ahb_master_access_s = ahb_master_access_sequence::type_id::create("ahb_master_access_s");
     //do  ahb_master_access_s.read(1,ahb_read_data,ahb_sequencer);  while (ahb_read_data[0] == 1'b1);
    do begin
      reg_model.wb2spi_rm.spsr.read(status,ahb_read_data, .parent(this));
      if (status != UVM_IS_OK) `uvm_fatal("SEQ", "Register return is not OK")
    end while (ahb_read_data[0] == 1'b1);

    //ahb_master_access_s.read(2,ahb_read_data,ahb_sequencer);
    reg_model.wb2spi_rm.spdr.read(status, ahb_read_data, .parent(this));
    if (status != UVM_IS_OK) `uvm_fatal("SEQ", "Register return is not OK")

  endtask

// ****************************************************************************
  virtual task spi_write_via_ahb(input bit[2:0] addr, input bit [3:0] spi_write_data);
    //ahb_master_access_s = ahb_master_access_sequence::type_id::create("ahb_master_access_s");
    //ahb_master_access_s.write(2,{1'b1,addr,spi_write_data},ahb_sequencer);
    reg_model.wb2spi_rm.spdr.write(status, {1'b1,addr,spi_write_data}, .parent(this));

    // Poll DUT status register until read fifo not empty
    //ahb_master_access_s = ahb_master_access_sequence::type_id::create("ahb_master_access_s");
    //do  ahb_master_access_s.read(1,ahb_read_data,ahb_sequencer);  while (ahb_read_data[0] == 1'b1);
    do begin
      reg_model.wb2spi_rm.spsr.read(status,ahb_read_data, .parent(this));
      if (status != UVM_IS_OK) `uvm_fatal("SEQ", "Register return is not OK")
    end while (ahb_read_data[0] == 1'b1);

    //ahb_master_access_s.read(2,ahb_read_data,ahb_sequencer);
    reg_model.wb2spi_rm.spdr.read(status, ahb_read_data, .parent(this));
    if (status != UVM_IS_OK) `uvm_fatal("SEQ", "Register return is not OK")

  endtask

endclass
