/*****************************************************************************
 *
 * Copyright 2007-2019 Mentor Graphics Corporation
 * All Rights Reserved.
 *
 * THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE
 * PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT
 * TO LICENSE TERMS.
 *
 *****************************************************************************/
import rw_txn_pkg::*;


// Class: dma_cmd_seq
//
// The body of this sequences executes various-width writes and reads.
//
// See also:
//
// - <axi4_master_deparam_seq> - the sequence providing generic read/write APIs
// - <address_map>            - the address map class used to define memory regions
// - <test>                   - the top-level test that sets up the address map and
//                              starts this sequence

class dma_cmd_seq extends axi4_master_deparam_seq;

  `uvm_object_utils(dma_cmd_seq)

  // default values which can/should be overwritten from test before starting this sequence
  logic [1:0] dma_mode;    // default value is x, thus must be overwritten
  int unsigned image_source_address  = 32'h0000_1000;
  int unsigned image_target_address  = 32'h0000_4000;
  int unsigned image_total_len       = 32'h0000_0200;
  int unsigned scatter_stride        = 32'h0000_0100;
  int unsigned scatter_len           = 32'h0000_0080;
  int unsigned scatter_groups        = 32'h0000_0004;

  function new(string name="");
    super.new(name);
  endfunction


  // Task: body
  //
  // This is standard UVM body task.
  // This calls the task to choose the transaction to be started on the
  // address channel.
  //
  // (begin inline source)
  
  virtual task body();
  
    rw_txn txn;

    bit [31:0]      wr_data_32;
    bit [31:0]      rd_data_32;
  
    super.body();

/*
struct dma_address_map
{
  uint32_t  ar_addr;        // source address (byte address as per AXI)
  uint32_t  aw_addr;        // target address (byte address as per AXI)
  uint32_t  total_len;      // total length to be copied in bytes
  uint32_t  scatter_stride; // stride between each scatter group, in bytes
  uint32_t  scatter_len;    // length of each scatter group, in bytes
  uint32_t  scatter_groups; // number of scatter groups
  uint32_t  dma_mode;       // COPY, SCATTER, GATHER
  uint32_t  start;          // DMA command is complete, cause it to be queued to start
};
*/
    
    // write dma0_cmd.source_addr
    wr_data_32 = image_source_address;
    write32('h0, wr_data_32);

    // write dma0_cmd.target_addr
    wr_data_32 = image_target_address;
    write32('h4, wr_data_32);

    // write dma0_cmd.total_len
    wr_data_32 = image_total_len;
    write32('h8, wr_data_32);

    // write dma0_cmd.scatter_stride
    // int scatter_stride = scatter_len * 2;
    wr_data_32 = scatter_stride;
    write32('hc, wr_data_32);

    // write dma0_cmd.scatter_len
    // int scatter_len = total_len / scatter_groups;
    wr_data_32 = scatter_len;
    write32('h10, wr_data_32);

    // write dma0_cmd.scatter_groups
    wr_data_32 = scatter_groups;
    write32('h14, wr_data_32);

    // write dma0_cmd.dma_mode
    // enum dma_mode_t {COPY=0, SCATTER=1, GATHER=2};
    wr_data_32 = dma_mode;
    write32('h18, wr_data_32);

    // write dma0_cmd.start
    wr_data_32 = 32'h1;
    write32('h1c, wr_data_32);

  endtask
  // (end inline source)
  
endclass
