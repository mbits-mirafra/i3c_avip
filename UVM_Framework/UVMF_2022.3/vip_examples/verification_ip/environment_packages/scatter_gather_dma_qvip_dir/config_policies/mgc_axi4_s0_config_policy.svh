//
// File: mgc_axi4_s0_config_policy.sv
//
// Generated from Mentor VIP Configurator (20201007)
// Generated using Mentor VIP Library ( 2020.4 : 10/16/2020:13:17 )
//
class mgc_axi4_s0_config_policy;
    static function void configure
    (
        input mgc_axi4_s0_cfg_t cfg,
        input address_map addrm
    );
        //
        // Agent setup configurations:
        //
        cfg.agent_cfg.is_active = 1;
        cfg.agent_cfg.agent_type = mgc_axi4_v1_0_pkg::AXI4_SLAVE;
        // Interface type
        cfg.agent_cfg.if_type = mgc_axi4_v1_0_pkg::AXI4;
        // Use external clock
        cfg.agent_cfg.ext_clock = 1;
        // Use external reset
        cfg.agent_cfg.ext_reset = 1;
        // Enable functional coverage
        cfg.agent_cfg.en_cvg.func = 1;
        // Enable write ch toggle coverage
        cfg.agent_cfg.en_cvg.wr_ch_toggle = 1'b0;
        // Enable read ch toggle coverage
        cfg.agent_cfg.en_cvg.rd_ch_toggle = 1'b0;
        // Enable transaction logger
        cfg.agent_cfg.en_logger.txn_log = 0;
        // Enable beat logger
        cfg.agent_cfg.en_logger.beat_log = 1;
        // Transaction logger file name
        cfg.agent_cfg.en_logger.txn_log_name = "txn.log";
        // Beat logger file name
        cfg.agent_cfg.en_logger.beat_log_name = "mgc_axi4_s0_beat.log";
        cfg.agent_cfg.en_logger.txn_column.tr = 1;
        cfg.agent_cfg.en_logger.txn_column.id = 1;
        cfg.agent_cfg.en_logger.txn_column.addr = 1;
        cfg.agent_cfg.en_logger.txn_column.addr_time = 1;
        cfg.agent_cfg.en_logger.txn_column.data = 1;
        cfg.agent_cfg.en_logger.txn_column.strb = 1;
        cfg.agent_cfg.en_logger.txn_column.data_time = 1;
        cfg.agent_cfg.en_logger.txn_column.resp = 1;
        cfg.agent_cfg.en_logger.txn_column.resp_time = 1;
        cfg.agent_cfg.en_logger.txn_column.len = 1;
        cfg.agent_cfg.en_logger.txn_column.burst_type = 1;
        cfg.agent_cfg.en_logger.txn_column.burst_size = 1;
        cfg.agent_cfg.en_logger.txn_column.addr_user = 0;
        cfg.agent_cfg.en_logger.txn_column.data_user = 0;
        cfg.agent_cfg.en_logger.txn_column.resp_user = 0;
        cfg.agent_cfg.en_logger.beat_column.id = 1;
        cfg.agent_cfg.en_logger.beat_column.valid_time = 1;
        cfg.agent_cfg.en_logger.beat_column.ready_time = 1;
        cfg.agent_cfg.en_logger.beat_column.dir_ph = 1;
        cfg.agent_cfg.en_logger.beat_column.addr = 1;
        cfg.agent_cfg.en_logger.beat_column.beat_num = 1;
        cfg.agent_cfg.en_logger.beat_column.len = 1;
        cfg.agent_cfg.en_logger.beat_column.strb = 1;
        cfg.agent_cfg.en_logger.beat_column.data = 1;
        cfg.agent_cfg.en_logger.beat_column.resp = 1;
        cfg.agent_cfg.en_logger.beat_column.last = 1;
        cfg.agent_cfg.en_logger.beat_column.burst_type = 1;
        cfg.agent_cfg.en_logger.beat_column.burst_size = 1;
        cfg.agent_cfg.en_logger.beat_column.lock = 1;
        cfg.agent_cfg.en_logger.beat_column.cache = 1;
        cfg.agent_cfg.en_logger.beat_column.prot = 1;
        cfg.agent_cfg.en_logger.beat_column.qos = 1;
        cfg.agent_cfg.en_logger.beat_column.region = 1;
        cfg.agent_cfg.en_logger.beat_column.addr_user = 0;
        cfg.agent_cfg.en_logger.beat_column.data_user = 0;
        cfg.agent_cfg.en_logger.beat_column.resp_user = 0;
        // Transaction logger data mask
        cfg.agent_cfg.en_logger.txn_data_mask = 1;
        // Beat logger data mask
        cfg.agent_cfg.en_logger.beat_data_mask = 1;
        // Enable clock period change logging
        cfg.agent_cfg.en_logger.clk_mon = 0;
        // Enable error reporting in logger
        // following supported after QVIP 2020.2
        // cfg.agent_cfg.en_logger.en_assertions_log = 0;
        // Enable scoreboard
        cfg.agent_cfg.en_sb = 1;
        // Enable transaction listener
        cfg.agent_cfg.en_txn_ltnr = 1;
        // Enable slave sequence
        cfg.agent_cfg.en_slv_seq = 1;
        // Enable generic payload adapter
        cfg.agent_cfg.en_rw_adapter = 1'b0;
        cfg.agent_cfg.en_perf_stats.enable = 1'b0;
        cfg.agent_cfg.en_perf_stats.step = 0;
        cfg.agent_cfg.en_perf_stats.multiple = 0;
        // following supported after QVIP 2020.2
        // cfg.agent_cfg.en_debug.master_seq = 1'b0;
        // cfg.agent_cfg.en_debug.slave_seq = 1'b0;
        // cfg.agent_cfg.en_debug.vip_config = 1'b0;
        //
        // VIP Config setup configurations:
        //
        //
        //
        // Slave ID
        cfg.slave_id = 0;
        if ( addrm != null )
        begin
            cfg.addr_map = addrm;
        end
        cfg.slave_delay = new();
        if ( addrm != null )
        begin
            cfg.slave_delay.set_address_map( addrm );
        end
        cfg.slave_delay.set_ready_delay_mode( .random_delay(1'b0), .valid2ready(1'b0));
        
        
        
        
        
        // Enable warning for uninitialized reads
        cfg.m_warn_on_uninitialized_read = 1;
        cfg.cov_enable.raddr_user = 1'b0;
        cfg.cov_enable.wdata_user = 1'b0;
        cfg.cov_enable.wresp_user = 1'b0;
        cfg.cov_enable.waddr_user = 1'b0;
        cfg.cov_enable.rdata_user = 1'b0;
        //
        // VIP Config setup configurations at default value:
        //    cfg.m_dec_err_rate = 0;
        //    cfg.m_slv_err_rate = 0;
        //    cfg.m_extended_rw_error_rate_enable = 1'b0;
        //    cfg.m_ok_for_exclusive_rate = 0;
        //    cfg.m_ok_for_non_exclusive_rate = 0;
        //    cfg.m_read_addr_outstanding_resp = 1;
        //    cfg.m_write_addr_outstanding_resp = 1;
        //    cfg.m_max_outstanding_read_addrs = 16;
        //    cfg.m_max_outstanding_write_addrs = 16;
        //    cfg.m_max_outstanding_wdata = 16;
        //    cfg.m_order_overlapping_rw = 1'b0;
        //    cfg.m_read_resp_out_of_order = 1;
        //    cfg.m_read_interleaved_resp_enable = 1;
        //    cfg.m_write_resp_out_of_order = 1;
        //    cfg.m_random_data_value = 1'b0;
        //    cfg.m_default_value_for_uninitialized_read = 8'b0;
        //    cfg.m_fixed_burst_mem_norm = 1'b0;
        //    cfg.buser_def_val = 0;
        //    cfg.config_id_cov_bin_count = 16;
        //
        
        //
        // BFM setup configurations:
        //
        //
        //
        // Read data reordering depth
        cfg.m_bfm.config_read_data_reordering_depth = 16;
        // Read interleaving depth
        cfg.m_bfm.config_rd_interleave_depth = 1073741824;
        //
        // BFM setup configurations at default value:
        //    cfg.m_bfm.config_enable_rlast = 1'b1;
        //    cfg.m_bfm.config_enable_all_assertions = 1'b1;
        //    cfg.m_bfm.config_enable_assertion = 214'h3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        //    cfg.m_bfm.config_enable_warnings = 1'b1;
        //    cfg.m_bfm.config_error_on_deleted_valid_cycles = 1'b1;
        //    cfg.m_bfm.config_enable_slave_exclusive = 1'b1;
        //    cfg.m_bfm.config_rd_num_interleave_beats = 1;
        //    cfg.m_bfm.config_wready_after_addr = 0;
        //    cfg.m_bfm.config_awready_after_wvalid = 0;
        //    cfg.m_bfm.config_max_transaction_time_factor = 100000;
        //    cfg.m_bfm.config_burst_timeout_factor = 10000;
        //    cfg.m_bfm.config_max_latency_RVALID_assertion_to_RREADY = 10000;
        //    cfg.m_bfm.config_max_latency_BVALID_assertion_to_BREADY = 10000;
        //    cfg.m_bfm.config_enable_qos = 1'b1;
        //    cfg.m_bfm.config_enable_region_support = 1'b0;
        //    cfg.m_bfm.config_protect_ready = 1'b1;
        //
        
    endfunction: configure
    
endclass: mgc_axi4_s0_config_policy

