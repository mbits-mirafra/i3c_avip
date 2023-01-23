/*****************************************************************************
 *
 * Copyright 2007-2016 Mentor Graphics Corporation
 * All Rights Reserved.
 *
 * THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE
 * PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT
 * TO LICENSE TERMS.
 *
 *****************************************************************************/

// CLASS: axi4_simple_rd_wr_seq
//
// This sequence repeats a loop in which it executes an AXI4 write transaction
// followed by a read transaction with the same address, burst length and 
// burst type.
//
// It uses <axi4_master_read> and <axi4_master_write> transaction sequence items
// to generate stimulus.
// 
// No exclusive transactions are generated in this sequence.

class axi4_simple_rd_wr_seq #( int AXI4_ADDRESS_WIDTH   = 32, 
                               int AXI4_RDATA_WIDTH     = 32, 
                               int AXI4_WDATA_WIDTH     = 32,
                               int AXI4_ID_WIDTH        = 4 ,
                               int AXI4_USER_WIDTH      = 4 ,
                               int AXI4_REGION_MAP_SIZE = 16
                               ) extends mvc_sequence;

  typedef axi4_simple_rd_wr_seq #(  AXI4_ADDRESS_WIDTH, 
                                        AXI4_RDATA_WIDTH,
                                        AXI4_WDATA_WIDTH,
                                        AXI4_ID_WIDTH,
                                        AXI4_USER_WIDTH,
                                        AXI4_REGION_MAP_SIZE
                                        ) this_t;

  `uvm_object_param_utils(this_t)

  function new (string name = "axi4_simple_rd_wr_seq");
    super.new( name );
  endfunction

  extern task body();
endclass

// Task: body
//
// This is standard UVM body task.
//
// It executes a number of write transactions followed by read transactions
// with the same address, burst length and burst type.
//
// (begin inline source)

task axi4_simple_rd_wr_seq::body();

  typedef axi4_master_read #( AXI4_ADDRESS_WIDTH, 
                              AXI4_RDATA_WIDTH,
                              AXI4_WDATA_WIDTH,
                              AXI4_ID_WIDTH,
                              AXI4_USER_WIDTH,
                              AXI4_REGION_MAP_SIZE
                              ) read_item_t;

  typedef axi4_master_write #( AXI4_ADDRESS_WIDTH, 
                               AXI4_RDATA_WIDTH,
                               AXI4_WDATA_WIDTH,
                               AXI4_ID_WIDTH,
                               AXI4_USER_WIDTH,
                               AXI4_REGION_MAP_SIZE
                               ) write_item_t;
    
  read_item_t  read_item  = read_item_t::type_id::create("read_item");
  write_item_t write_item = write_item_t::type_id::create("write_item");

  // Get the config object so that you can wait for a clock after reset
  // to issue the first sequence_item.

  mvc_config_base  cfg = mvc_config_base::get_config(m_sequencer);

  cfg.wait_for_reset();
  cfg.wait_for_clock();

  // for(int i=0;i<50;++i)
  for(int i=0;i<10;++i)
  begin

    start_item( write_item );
    if(!write_item.randomize() with
        {
          write_item.lock         != AXI4_EXCLUSIVE;
        }
      ) `uvm_error("SEQ","Randomisation failure");
    finish_item( write_item );

    start_item( read_item );
    if(!read_item.randomize() with
        {
          read_item.burst_length == write_item.burst_length;
          read_item.burst        == write_item.burst;
          read_item.addr         == write_item.addr;
          read_item.lock         != AXI4_EXCLUSIVE;
        }
       ) `uvm_error("SEQ","Randomisation failure");
    finish_item( read_item );
  end
endtask
// (end inline source)
