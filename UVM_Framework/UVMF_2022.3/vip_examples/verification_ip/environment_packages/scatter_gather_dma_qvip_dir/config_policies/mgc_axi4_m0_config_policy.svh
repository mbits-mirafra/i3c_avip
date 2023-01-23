//
// File: mgc_axi4_m0_config_policy.sv
//
// Generated from Mentor VIP Configurator (20201007)
// Generated using Mentor VIP Library ( 2020.4 : 10/16/2020:13:17 )
//
class mgc_axi4_m0_config_policy;
    static function void configure
    (
        input mgc_axi4_m0_cfg_t cfg,
        input address_map addrm
    );
        //
        // Agent setup configurations:
        //
        cfg.agent_cfg.is_active = 1;
        cfg.agent_cfg.agent_type = mgc_axi4_v1_0_pkg::AXI4_MASTER;
        // Interface type
        cfg.agent_cfg.if_type = mgc_axi4_v1_0_pkg::AXI4_LITE;
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
        cfg.agent_cfg.en_logger.txn_log = 1;
        // Enable beat logger
        cfg.agent_cfg.en_logger.beat_log = 1;
        // Transaction logger file name
        cfg.agent_cfg.en_logger.txn_log_name = "mgc_axi4_m0_txn.log";
        // Beat logger file name
        cfg.agent_cfg.en_logger.beat_log_name = "mgc_axi4_m0_beat.log";
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
        cfg.agent_cfg.en_sb = 0;
        // Enable transaction listener
        cfg.agent_cfg.en_txn_ltnr = 1;
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
        if ( addrm != null )
        begin
            cfg.addr_map = addrm;
        end
        cfg.master_delay = new();
        cfg.master_delay.set_config( cfg );
        if ( addrm != null )
        begin
            cfg.master_delay.set_address_map( addrm );
        end
        cfg.master_delay.set_ready_delay_mode( .random_delay(1'b0), .valid2ready(1'b0));
        
        
        
        
        
        cfg.cov_enable.raddr_user = 1'b0;
        cfg.cov_enable.wdata_user = 1'b0;
        cfg.cov_enable.wresp_user = 1'b0;
        cfg.cov_enable.waddr_user = 1'b0;
        cfg.cov_enable.rdata_user = 1'b0;
        //
        // VIP Config setup configurations at default value:
        //    cfg.slave_id = -1;
        //    cfg.m_fixed_burst_mem_norm = 1'b0;
        //    cfg.config_id_cov_bin_count = 2;
        //
        
        //
        // BFM setup configurations:
        //
        //
        //
        // Set all write strobes enabled
        cfg.m_bfm.config_set_all_write_strobes = 1;
        // Enable ID signals
        cfg.m_bfm.config_enable_id = 0;
        //
        // BFM setup configurations at default value:
        //    cfg.m_bfm.config_write_ctrl_first_ratio = 1;
        //    cfg.m_bfm.config_write_data_first_ratio = 0;
        //    cfg.m_bfm.config_enable_all_assertions = 1'b1;
        //    cfg.m_bfm.config_enable_assertion = 214'h3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        //    cfg.m_bfm.config_enable_warnings = 1'b1;
        //    cfg.m_bfm.config_error_on_deleted_valid_cycles = 1'b1;
        //    cfg.m_bfm.config_max_transaction_time_factor = 100000;
        //    cfg.m_bfm.config_burst_timeout_factor = 10000;
        //    cfg.m_bfm.config_max_latency_AWVALID_assertion_to_AWREADY = 10000;
        //    cfg.m_bfm.config_max_latency_ARVALID_assertion_to_ARREADY = 10000;
        //    cfg.m_bfm.config_max_latency_WVALID_assertion_to_WREADY = 10000;
        //    cfg.m_bfm.config_protect_ready = 1'b1;
        //    cfg.m_bfm.config_num_max_outstanding_reads = -1;
        //    cfg.m_bfm.config_num_max_outstanding_writes = -1;
        //    cfg.m_bfm.check_addr_map = AXI4_CHK_LEGAL;
        //
        
    endfunction: configure
    
endclass: mgc_axi4_m0_config_policy

