//----------------------------------------------------------------------
// Created with uvmf_gen version 2020.1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
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

class scatter_gather_dma_cmd_base_seq extends scatter_gather_dma_bench_sequence_base;

  `uvm_object_utils( scatter_gather_dma_cmd_base_seq );

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end

  typedef dma_cmd_seq dma_cmd_seq_t;
  typedef dma_util_seq dma_util_seq_t;

  dma_cmd_seq_t axi4_m0_dma_cmd_seq;
  dma_util_seq_t axi4_s0_dma_util_seq;

  // matches following in scatter_gather_dma.h, enum dma_mode_t {COPY=0, SCATTER=1, GATHER=2};
  typedef enum bit[1:0] {DMA_COPY = 0, DMA_SCATTER = 1, DMA_GATHER = 2} dma_mode_t;
  typedef enum bit[1:0] {UTIL_PRELOAD = 0, UTIL_COMPARE = 1} util_cmd_t;
  typedef enum bit[1:0] {PRELOAD_ZEROS = 0, PRELOAD_RANDOM = 1, PRELOAD_ADDRESS = 2} util_mode_t;

  dma_mode_t dma_mode;
  util_cmd_t util_cmd;
  util_mode_t util_mode;

  // all addresses represent a byte address per AXI
  // total_len = numBeats * bytesPerBeat, e.g. 64 * 8 = 512 (0x200);
  parameter int unsigned image_source_address  = 32'h0000_1000;
  parameter int unsigned image_scatter_address = 32'h0000_4000;
  parameter int unsigned image_target_address  = 32'h0000_8000;
  parameter int unsigned image_total_len       = 32'h0000_0200;
  parameter int unsigned scatter_stride        = 32'h0000_0100;
  parameter int unsigned scatter_len           = 32'h0000_0080;
  parameter int unsigned scatter_groups        = 32'h0000_0004;

  virtual ccs_monitor_bfm #(.WIDTH(1)) dma_done_rsc_mon_bfm;

  // ****************************************************************************
  function new( string name = "" );
    super.new( name );

    if ( !uvm_config_db #( virtual ccs_monitor_bfm #(.WIDTH(1)) )::get( null , UVMF_VIRTUAL_INTERFACES , dma_done_rsc_BFM , dma_done_rsc_mon_bfm ))
       `uvm_fatal("CFG" , "uvm_config_db #( virtual ccs_monitor_bfm #(.WIDTH(1)) )::get cannot find resource dma_dones_rsc_BFM" )

    // pragma uvmf custom new begin
    // pragma uvmf custom new end

  endfunction

  task monitor_dma_done();
      fork
        dma_done_rsc_mon_bfm.wait_for_dma_done();
        begin
          repeat(10_000) axi4_m0_cfg.wait_for_clock();
          `uvm_error("SEQ", "wait_for_dma_done() timed-out!")
        end
      join_any
      disable fork; // kill the slower task
  endtask

  // ****************************************************************************
  virtual task body();
    // pragma uvmf custom body begin

    // pragma uvmf custom body end
  endtask

endclass

