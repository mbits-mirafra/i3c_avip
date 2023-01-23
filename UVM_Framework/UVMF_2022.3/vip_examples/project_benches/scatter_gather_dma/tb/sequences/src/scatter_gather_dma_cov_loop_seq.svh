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

class scatter_gather_dma_cov_loop_seq extends scatter_gather_dma_cmd_base_seq;

  `uvm_object_utils( scatter_gather_dma_cov_loop_seq );

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end

  // ****************************************************************************
  function new( string name = "" );
    super.new( name );

    // pragma uvmf custom new begin
    // pragma uvmf custom new end

  endfunction

  // ****************************************************************************
  virtual task body();
    // pragma uvmf custom body begin

    // Construct sequences here
    dma_done_rsc_responder_seq  = dma_done_rsc_responder_seq_t::type_id::create("dma_done_rsc_responder_seq");
    axi4_m0_dma_cmd_seq = dma_cmd_seq_t::type_id::create("axi4_m0_dma_cmd_seq");
    axi4_s0_dma_util_seq = dma_util_seq_t::type_id::create("axi4_s0_dma_util_seq");

    axi4_m0_cfg = mgc_axi4_m0_cfg_t::get_config(uvm_test_top_environment_scatter_gather_dma_qvip_subenv_mgc_axi4_m0_sqr);
    axi4_s0_cfg = mgc_axi4_s0_cfg_t::get_config(uvm_test_top_environment_scatter_gather_dma_qvip_subenv_mgc_axi4_s0_sqr);

    // wait for init... reset deasserted plus 1 clock
    fork
      dma_done_rsc_config.wait_for_reset();
      axi4_m0_cfg.wait_for_reset();
    join
      axi4_m0_cfg.wait_for_clock();

    // Start RESPONDER sequences here
    fork
      dma_done_rsc_responder_seq.start(dma_done_rsc_sequencer);
    join_none

    // Start INITIATOR sequences here
    fork

      begin //{
        ///////////////////////////////////////////
        // Sequences run in the following order
        ///////////////////////////////////////////

        //
        // 1. do scatter/gather operation followed by compare
        //

        // first PRELOAD via backdoor...
        axi4_s0_dma_util_seq.axi4_s0_cfg = axi4_s0_cfg;
        axi4_s0_dma_util_seq.image_source_address = image_source_address;
        axi4_s0_dma_util_seq.image_total_len      = image_total_len;
        axi4_s0_dma_util_seq.util_cmd             = UTIL_PRELOAD;
        axi4_s0_dma_util_seq.preload_mode         = PRELOAD_RANDOM;
        axi4_s0_dma_util_seq.start(null);
        repeat(1) axi4_m0_cfg.wait_for_clock();

        // now SCATTER...
        fork
        monitor_dma_done();
        begin
          axi4_m0_dma_cmd_seq.image_source_address = image_source_address;
          axi4_m0_dma_cmd_seq.image_target_address = image_scatter_address;
          axi4_m0_dma_cmd_seq.image_total_len      = image_total_len;
          axi4_m0_dma_cmd_seq.dma_mode             = DMA_SCATTER;
          axi4_m0_dma_cmd_seq.start(uvm_test_top_environment_scatter_gather_dma_qvip_subenv_mgc_axi4_m0_sqr);
        end
        join

        repeat(1) axi4_m0_cfg.wait_for_clock();

        // then GATHER...
        fork
        monitor_dma_done();
        begin
          axi4_m0_dma_cmd_seq.image_source_address = image_scatter_address;
          axi4_m0_dma_cmd_seq.image_target_address = image_target_address;
          axi4_m0_dma_cmd_seq.image_total_len      = image_total_len;
          axi4_m0_dma_cmd_seq.dma_mode             = DMA_GATHER;
          axi4_m0_dma_cmd_seq.start(uvm_test_top_environment_scatter_gather_dma_qvip_subenv_mgc_axi4_m0_sqr);
        end
        join

        repeat(1) axi4_m0_cfg.wait_for_clock();

        // and finally COMPARE...
        axi4_s0_dma_util_seq.image_source_address = image_source_address;
        axi4_s0_dma_util_seq.image_target_address = image_target_address;
        axi4_s0_dma_util_seq.image_total_len      = image_total_len;
        axi4_s0_dma_util_seq.util_cmd             = UTIL_COMPARE;
        axi4_s0_dma_util_seq.start(null);
        repeat(1) axi4_m0_cfg.wait_for_clock();
      
        //
        // 2. Now do a copy operation including compare...
        //    which purposely crosses/straddles a 4k boundary...
        //

        // first PRELOAD via backdoor...
        axi4_s0_dma_util_seq.axi4_s0_cfg = axi4_s0_cfg;
        axi4_s0_dma_util_seq.image_source_address = 32'h0001_0800;
        axi4_s0_dma_util_seq.image_total_len      = 32'h2000;
        axi4_s0_dma_util_seq.util_cmd             = UTIL_PRELOAD;
        axi4_s0_dma_util_seq.preload_mode         = PRELOAD_ADDRESS;
        axi4_s0_dma_util_seq.start(null);
        repeat(1) axi4_m0_cfg.wait_for_clock();

        // now COPY...
        fork
        monitor_dma_done();
        begin
          axi4_m0_dma_cmd_seq.image_source_address = 32'h0001_0800;
          axi4_m0_dma_cmd_seq.image_target_address = 32'h89ab_0800;
          axi4_m0_dma_cmd_seq.image_total_len      = 32'h2000;
          axi4_m0_dma_cmd_seq.dma_mode             = DMA_COPY;
          axi4_m0_dma_cmd_seq.start(uvm_test_top_environment_scatter_gather_dma_qvip_subenv_mgc_axi4_m0_sqr);
        end
        join

        repeat(1) axi4_m0_cfg.wait_for_clock();

        // and finally COMPARE...
        axi4_s0_dma_util_seq.image_source_address = 32'h0001_0800;
        axi4_s0_dma_util_seq.image_target_address = 32'h89ab_0800;
        axi4_s0_dma_util_seq.image_total_len      = 32'h2000;
        axi4_s0_dma_util_seq.util_cmd             = UTIL_COMPARE;
        axi4_s0_dma_util_seq.start(null);
        repeat(1) axi4_m0_cfg.wait_for_clock();

        //
        // 3. Now do addtl various directed testing within a loop
        //

        begin //{
          int unsigned test_total_len = image_total_len;
          int unsigned test_scatter_groups = 2;
          int unsigned test_scatter_stride;
          int unsigned test_scatter_len;
          int unsigned test_copy_mode;
          int unsigned test_iterations = 8;
  
          for (int unsigned i = 0; i < test_iterations; i++) begin //{
            test_copy_mode = i & 1;
            test_scatter_len = test_total_len / test_scatter_groups;
            test_scatter_stride = test_scatter_len * 2;
  
            // first PRELOAD via backdoor...
            axi4_s0_dma_util_seq.axi4_s0_cfg = axi4_s0_cfg;
            axi4_s0_dma_util_seq.image_source_address = image_source_address;
            axi4_s0_dma_util_seq.image_total_len      = image_total_len;
            axi4_s0_dma_util_seq.util_cmd             = UTIL_PRELOAD;
            axi4_s0_dma_util_seq.preload_mode         = PRELOAD_RANDOM;
            axi4_s0_dma_util_seq.start(null);
            repeat(1) axi4_m0_cfg.wait_for_clock();
  
            if (test_copy_mode) begin //{
              // first do (intermediate) COPY...
              fork
              monitor_dma_done();
              begin //{
                axi4_m0_dma_cmd_seq.image_source_address = image_source_address;
                axi4_m0_dma_cmd_seq.image_target_address = image_scatter_address;
                axi4_m0_dma_cmd_seq.image_total_len      = image_total_len;
                axi4_m0_dma_cmd_seq.dma_mode             = DMA_COPY;
                axi4_m0_dma_cmd_seq.start(uvm_test_top_environment_scatter_gather_dma_qvip_subenv_mgc_axi4_m0_sqr);
              end //}
              join
              repeat(1) axi4_m0_cfg.wait_for_clock();

              // then second (final) COPY...
              fork
              monitor_dma_done();
              begin //{
                axi4_m0_dma_cmd_seq.image_source_address = image_scatter_address;
                axi4_m0_dma_cmd_seq.image_target_address = image_target_address;
                axi4_m0_dma_cmd_seq.image_total_len      = image_total_len;
                axi4_m0_dma_cmd_seq.dma_mode             = DMA_COPY;
                axi4_m0_dma_cmd_seq.start(uvm_test_top_environment_scatter_gather_dma_qvip_subenv_mgc_axi4_m0_sqr);
              end //}
              join
              repeat(1) axi4_m0_cfg.wait_for_clock();
            end //}

            else begin //{
              // first do SCATTER...
              fork
              monitor_dma_done();
              begin //{
                axi4_m0_dma_cmd_seq.image_source_address = image_source_address;
                axi4_m0_dma_cmd_seq.image_target_address = image_scatter_address;
                axi4_m0_dma_cmd_seq.image_total_len      = image_total_len;
                axi4_m0_dma_cmd_seq.scatter_stride       = test_scatter_stride;
                axi4_m0_dma_cmd_seq.scatter_len          = test_scatter_len;
                axi4_m0_dma_cmd_seq.scatter_groups       = test_scatter_groups;
                axi4_m0_dma_cmd_seq.dma_mode             = DMA_SCATTER;
                axi4_m0_dma_cmd_seq.start(uvm_test_top_environment_scatter_gather_dma_qvip_subenv_mgc_axi4_m0_sqr);
              end //}
              join
      
              repeat(1) axi4_m0_cfg.wait_for_clock();
      
              // then GATHER...
              fork
              monitor_dma_done();
              begin //{
                axi4_m0_dma_cmd_seq.image_source_address = image_scatter_address;
                axi4_m0_dma_cmd_seq.image_target_address = image_target_address;
                axi4_m0_dma_cmd_seq.image_total_len      = image_total_len;
                axi4_m0_dma_cmd_seq.scatter_stride       = test_scatter_stride;
                axi4_m0_dma_cmd_seq.scatter_len          = test_scatter_len;
                axi4_m0_dma_cmd_seq.scatter_groups       = test_scatter_groups;
                axi4_m0_dma_cmd_seq.dma_mode             = DMA_GATHER;
                axi4_m0_dma_cmd_seq.start(uvm_test_top_environment_scatter_gather_dma_qvip_subenv_mgc_axi4_m0_sqr);
              end //}
              join
      
              repeat(1) axi4_m0_cfg.wait_for_clock();
            end //}
  
            // and finally COMPARE...
            axi4_s0_dma_util_seq.image_source_address = image_source_address;
            axi4_s0_dma_util_seq.image_target_address = image_target_address;
            axi4_s0_dma_util_seq.image_total_len      = image_total_len;
            axi4_s0_dma_util_seq.util_cmd             = UTIL_COMPARE;
            axi4_s0_dma_util_seq.start(null);
            repeat(1) axi4_m0_cfg.wait_for_clock();

            if (i == 4) test_scatter_groups *= 2;
  
          end //}
        end //}
      end //}

    join

    // UVMF_CHANGE_ME : Extend the simulation XXX number of clocks after 
    // the last sequence to allow for the last sequence item to flow 
    // through the design.
    fork
      dma_done_rsc_config.wait_for_num_clocks(400);
        repeat(100) axi4_m0_cfg.wait_for_clock();
    join

    // pragma uvmf custom body end
  endtask

endclass

