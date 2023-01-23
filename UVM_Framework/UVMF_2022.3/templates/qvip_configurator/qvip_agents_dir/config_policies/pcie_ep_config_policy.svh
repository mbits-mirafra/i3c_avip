//
// File: pcie_ep_config_policy.sv
//
// Generated from Mentor VIP Configurator (20200402)
// Generated using Mentor VIP Library ( 2020.2 : 04/19/2020:18:58 )
//
class pcie_ep_config_policy;
    static function void configure
    (
        input pcie_ep_cfg_t cfg
    );
        //
        // Agent setup configurations:
        //
        //
        // Specification Version
        cfg.agent_descriptor.pcie_details.version = mgc_pcie_v2_0_pkg::PCIE_4_0;
        // Max speed
        cfg.agent_descriptor.pcie_details.gen = mgc_pcie_v2_0_pkg::PCIE_GEN4;
        // Interface type
        cfg.agent_descriptor.pcie_details.if_type = mgc_pcie_v2_0_pkg::PCIE_SERIAL;
        // PCIE Application Mode
        cfg.agent_descriptor.mode = mgc_pcie_v2_0_pkg::PCIE_NATIVE;
        // Device type
        cfg.agent_descriptor.bfm_node.node_type = mgc_pcie_v2_0_pkg::PCIE_NEP;
        // Device type
        cfg.agent_descriptor.dut_node.node_type = mgc_pcie_v2_0_pkg::PCIE_RC;
        // Use external clock
        cfg.agent_descriptor.options.ext_clock = 1'b0;
        // Use external reset
        cfg.agent_descriptor.options.ext_reset = 1'b0;
        // Enable scoreboard
        cfg.agent_descriptor.options.en_sb = 1'b0;
        // Enable PM coverage
        cfg.agent_descriptor.options.en_pm_cvg = 1'b0;
        // Enable PL coverage
        cfg.agent_descriptor.options.en_pl_cvg = 1'b0;
        // Enable DLL coverage
        cfg.agent_descriptor.options.en_dl_cvg = 1'b0;
        // Enable TL coverage
        cfg.agent_descriptor.options.en_tl_cvg = 1'b0;
        // Enable transactions in log file
        cfg.agent_descriptor.options.log_txns = 1'b0;
        // Enable Tracker for TL and DLL packets information
        cfg.agent_descriptor.options.log_txns_in_tracker = 1'b0;
        // Enable Symbol logger for PL
        cfg.agent_descriptor.options.log_symbol = 1'b0;
        // Negotiate auto max speed
        cfg.agent_descriptor.options.negotiate_max_speed = 1'b1;
        // Monitor mode
        cfg.agent_descriptor.options.monitor = 1'b0;
        // Enable PIPE logger
        cfg.agent_descriptor.options.log_pipe = 1'b0;
        // Enable assertion logging in Loggers
        cfg.agent_descriptor.options.log_assr = 1'b0;
        // Enable byte logger for PL
        cfg.agent_descriptor.options.log_byte = 1'b0;
        // Enable Bring Up
        cfg.agent_descriptor.auto_bring_up.en = 1;
        // Bus Enumeration Mode
        cfg.agent_descriptor.auto_bring_up.enum_mode = mgc_pcie_v2_0_pkg::PCIE_FULL_ENUM;
        // Disable completer sequence
        cfg.agent_descriptor.auto_bring_up.dsbl_cmpl_seq = 1'b0;
        // Disable Enumeration log
        cfg.agent_descriptor.auto_bring_up.dsbl_enum_log = 1'b0;
        // Set Skew in Detect state
        cfg.agent_descriptor.auto_bring_up.set_skew_dtct = 1'b0;
        // Print Back Door Enum settings
        cfg.agent_descriptor.auto_bring_up.bus_enum_setting.print_bk_door_enum_setting = 1'b0;
        // Print Fast Enum settings
        cfg.agent_descriptor.auto_bring_up.bus_enum_setting.print_fast_bus_enum_setting = 1'b0;
        // Num of DS ports in switch
        cfg.agent_descriptor.auto_bring_up.bus_enum_setting.num_of_ds_in_sw = 1'b0;
        // Max Payload Size
        cfg.agent_descriptor.auto_bring_up.bus_enum_setting.mps = 3'hx;
        // Max Read req Size
        cfg.agent_descriptor.auto_bring_up.bus_enum_setting.mrs = 3'hx;
        // Discover base capability
        cfg.agent_descriptor.auto_bring_up.bus_enum_setting.discover_base_cap_only = 1'b0;
        // EP functions non consecutive
        cfg.agent_descriptor.auto_bring_up.bus_enum_setting.ep_func_non_consecutive = 1'b0;
        // Read Cfg space fields
        cfg.agent_descriptor.auto_bring_up.bus_enum_setting.read_cfg_space_fld = 1'b0;
        // first_bus_num
        cfg.agent_descriptor.auto_bring_up.bus_enum_setting.first_bus_num = 8'h00;
        // Enable External Memory used by Completer Sequence
        cfg.agent_descriptor.addr_settings.en_external_mem = 1'b0;
        // Enable Equalization
        cfg.agent_descriptor.eq_options.en_eq = 1'b1;
        // Enable Equalization Phase 2 and 3
        cfg.agent_descriptor.eq_options.en_ph2_3 = 1'b1;
        // Debug options(See pcie_en_debug_e for index meaning)
        cfg.agent_descriptor.en_debug = 26'h0000000;
        // Enable CDR
        cfg.agent_descriptor.en_cdr = 0;
        // Enable CDR per lane
        cfg.agent_descriptor.en_cdr_per_lane = 0;
        // Enables Transaction Layer Callback on request level
        cfg.agent_descriptor.cb_en.en_req = 1'b0;
        // Enables Transaction Layer Callback
        cfg.agent_descriptor.cb_en.en_tlp = 1'b0;
        // Enables Transaction Layer Callback at DL
        cfg.agent_descriptor.cb_en.en_tl_to_dll = 1'b0;
        // Enables Data Link Layer Callback
        cfg.agent_descriptor.cb_en.en_dllp = 1'b0;
        // Enables Completion Callback
        cfg.agent_descriptor.cb_en.en_cmpl = 1'b0;
        // Enables Ordered Sets Callback
        cfg.agent_descriptor.cb_en.en_os_plp = 1'b0;
        // Enable SRIOV
        cfg.agent_descriptor.en_sriov = 1'b0;
        // Disable Print
        cfg.agent_descriptor.disable_print = 1'b0;
        // Debug options(See pcie_dsbl_log_e for index meaning)
        cfg.agent_descriptor.dsbl_log_feat = 25'h0000000;
        //
        // BFM setup configurations at default value:
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_EN_ALL_ASSR,1'b1);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_EN_ALL_ASSR,1'b1);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_EN_ASSR,1424'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_EN_ASSR,1424'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_FPGA_USER,1'b0);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_RST_ASSRT_NUM_CLK,20);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_EN_CLK_REC,1'b0);
        //    cfg.m_bfm.config_enable_clock_recovery_per_lane = 1'b0;
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_CLK_INIT_VAL,1'b0);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_CLK_INIT_VAL,1'b0);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_CLK_PH_SHIFT,0);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_CLK_PH_SHIFT,0);
        //    cfg.m_bfm.config_rx_eq_train = 1'b0;
        //    cfg.m_bfm.config_io_recal = 1'b0;
        //    cfg.m_bfm.config_short_chnl_pwr_ctrl_before_linkup = 1'b0;
        //    cfg.m_bfm.config_short_chnl_pwr_ctrl = 2'h0;
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_DSBL_ECRC,1'b0);
        //    cfg.m_bfm.config_auto_bus_enum_aftr_dtct = 1'b0;
        //    cfg.m_bfm.config_bar_rng_updt_on_rst = 768'h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_BYPSS_CREDIT_CHK,1'b0);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_BYPSS_CREDIT_CHK,1'b0);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_CPL_TIMEOUT,100000);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_CPL_TIMEOUT,100000);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_PIPE_GLOBAL_TIMEOUT,600000);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_PIPE_GLOBAL_TIMEOUT,600000);
        //    cfg.m_bfm.config_pipe_wr_buff_dep = '{LANES{8}};
        //    cfg.m_bfm.config_err_pipe_msg = '{LANES{1'b0}};
        //    cfg.m_bfm.config_pipe_dly_ack_wr_comm = '{LANES{0}};
        //    cfg.m_bfm.config_pipe_dly_cmpl_rd = '{LANES{0}};
        //    cfg.m_bfm.config_pipe_no_idl_aftr_cmd = 16'h0000;
        //    cfg.m_bfm.config_lane_mrgn_typ_sampler = '{LANES{1'b1}};
        //    cfg.m_bfm.config_speed_change_fail = 1'b0;
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HFC_P_VC,8'h00,0);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HFC_P_VC,8'h00,1);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HFC_P_VC,8'h00,2);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HFC_P_VC,8'h00,3);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HFC_P_VC,8'h00,4);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HFC_P_VC,8'h00,5);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HFC_P_VC,8'h00,6);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HFC_P_VC,8'h00,7);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HFC_P_VC,8'h00,0);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HFC_P_VC,8'h00,1);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HFC_P_VC,8'h00,2);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HFC_P_VC,8'h00,3);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HFC_P_VC,8'h00,4);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HFC_P_VC,8'h00,5);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HFC_P_VC,8'h00,6);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HFC_P_VC,8'h00,7);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HFC_NP_VC,8'h00,0);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HFC_NP_VC,8'h00,1);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HFC_NP_VC,8'h00,2);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HFC_NP_VC,8'h00,3);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HFC_NP_VC,8'h00,4);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HFC_NP_VC,8'h00,5);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HFC_NP_VC,8'h00,6);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HFC_NP_VC,8'h00,7);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HFC_NP_VC,8'h00,0);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HFC_NP_VC,8'h00,1);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HFC_NP_VC,8'h00,2);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HFC_NP_VC,8'h00,3);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HFC_NP_VC,8'h00,4);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HFC_NP_VC,8'h00,5);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HFC_NP_VC,8'h00,6);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HFC_NP_VC,8'h00,7);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HFC_CPL_VC,8'h00,0);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HFC_CPL_VC,8'h00,1);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HFC_CPL_VC,8'h00,2);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HFC_CPL_VC,8'h00,3);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HFC_CPL_VC,8'h00,4);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HFC_CPL_VC,8'h00,5);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HFC_CPL_VC,8'h00,6);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HFC_CPL_VC,8'h00,7);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HFC_CPL_VC,8'h00,0);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HFC_CPL_VC,8'h00,1);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HFC_CPL_VC,8'h00,2);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HFC_CPL_VC,8'h00,3);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HFC_CPL_VC,8'h00,4);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HFC_CPL_VC,8'h00,5);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HFC_CPL_VC,8'h00,6);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HFC_CPL_VC,8'h00,7);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DFC_P_VC,12'h000,0);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DFC_P_VC,12'h000,1);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DFC_P_VC,12'h000,2);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DFC_P_VC,12'h000,3);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DFC_P_VC,12'h000,4);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DFC_P_VC,12'h000,5);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DFC_P_VC,12'h000,6);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DFC_P_VC,12'h000,7);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DFC_P_VC,12'h000,0);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DFC_P_VC,12'h000,1);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DFC_P_VC,12'h000,2);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DFC_P_VC,12'h000,3);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DFC_P_VC,12'h000,4);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DFC_P_VC,12'h000,5);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DFC_P_VC,12'h000,6);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DFC_P_VC,12'h000,7);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DFC_NP_VC,12'h000,0);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DFC_NP_VC,12'h000,1);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DFC_NP_VC,12'h000,2);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DFC_NP_VC,12'h000,3);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DFC_NP_VC,12'h000,4);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DFC_NP_VC,12'h000,5);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DFC_NP_VC,12'h000,6);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DFC_NP_VC,12'h000,7);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DFC_NP_VC,12'h000,0);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DFC_NP_VC,12'h000,1);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DFC_NP_VC,12'h000,2);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DFC_NP_VC,12'h000,3);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DFC_NP_VC,12'h000,4);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DFC_NP_VC,12'h000,5);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DFC_NP_VC,12'h000,6);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DFC_NP_VC,12'h000,7);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DFC_CPL_VC,12'h000,0);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DFC_CPL_VC,12'h000,1);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DFC_CPL_VC,12'h000,2);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DFC_CPL_VC,12'h000,3);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DFC_CPL_VC,12'h000,4);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DFC_CPL_VC,12'h000,5);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DFC_CPL_VC,12'h000,6);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DFC_CPL_VC,12'h000,7);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DFC_CPL_VC,12'h000,0);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DFC_CPL_VC,12'h000,1);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DFC_CPL_VC,12'h000,2);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DFC_CPL_VC,12'h000,3);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DFC_CPL_VC,12'h000,4);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DFC_CPL_VC,12'h000,5);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DFC_CPL_VC,12'h000,6);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DFC_CPL_VC,12'h000,7);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HSCALE_P_VC,2'h3,0);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HSCALE_P_VC,2'h3,1);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HSCALE_P_VC,2'h3,2);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HSCALE_P_VC,2'h3,3);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HSCALE_P_VC,2'h3,4);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HSCALE_P_VC,2'h3,5);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HSCALE_P_VC,2'h3,6);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HSCALE_P_VC,2'h3,7);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HSCALE_P_VC,2'h3,0);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HSCALE_P_VC,2'h3,1);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HSCALE_P_VC,2'h3,2);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HSCALE_P_VC,2'h3,3);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HSCALE_P_VC,2'h3,4);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HSCALE_P_VC,2'h3,5);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HSCALE_P_VC,2'h3,6);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HSCALE_P_VC,2'h3,7);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HSCALE_NP_VC,2'h3,0);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HSCALE_NP_VC,2'h3,1);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HSCALE_NP_VC,2'h3,2);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HSCALE_NP_VC,2'h3,3);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HSCALE_NP_VC,2'h3,4);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HSCALE_NP_VC,2'h3,5);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HSCALE_NP_VC,2'h3,6);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HSCALE_NP_VC,2'h3,7);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HSCALE_NP_VC,2'h3,0);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HSCALE_NP_VC,2'h3,1);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HSCALE_NP_VC,2'h3,2);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HSCALE_NP_VC,2'h3,3);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HSCALE_NP_VC,2'h3,4);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HSCALE_NP_VC,2'h3,5);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HSCALE_NP_VC,2'h3,6);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HSCALE_NP_VC,2'h3,7);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HSCALE_P_VC,2'h3,0);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HSCALE_P_VC,2'h3,1);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HSCALE_P_VC,2'h3,2);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HSCALE_P_VC,2'h3,3);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HSCALE_P_VC,2'h3,4);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HSCALE_P_VC,2'h3,5);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HSCALE_P_VC,2'h3,6);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_HSCALE_P_VC,2'h3,7);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HSCALE_P_VC,2'h3,0);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HSCALE_P_VC,2'h3,1);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HSCALE_P_VC,2'h3,2);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HSCALE_P_VC,2'h3,3);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HSCALE_P_VC,2'h3,4);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HSCALE_P_VC,2'h3,5);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HSCALE_P_VC,2'h3,6);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_HSCALE_P_VC,2'h3,7);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DSCALE_P_VC,2'h3,0);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DSCALE_P_VC,2'h3,1);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DSCALE_P_VC,2'h3,2);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DSCALE_P_VC,2'h3,3);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DSCALE_P_VC,2'h3,4);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DSCALE_P_VC,2'h3,5);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DSCALE_P_VC,2'h3,6);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DSCALE_P_VC,2'h3,7);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DSCALE_P_VC,2'h3,0);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DSCALE_P_VC,2'h3,1);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DSCALE_P_VC,2'h3,2);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DSCALE_P_VC,2'h3,3);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DSCALE_P_VC,2'h3,4);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DSCALE_P_VC,2'h3,5);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DSCALE_P_VC,2'h3,6);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DSCALE_P_VC,2'h3,7);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DSCALE_NP_VC,2'h3,0);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DSCALE_NP_VC,2'h3,1);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DSCALE_NP_VC,2'h3,2);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DSCALE_NP_VC,2'h3,3);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DSCALE_NP_VC,2'h3,4);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DSCALE_NP_VC,2'h3,5);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DSCALE_NP_VC,2'h3,6);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DSCALE_NP_VC,2'h3,7);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DSCALE_NP_VC,2'h3,0);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DSCALE_NP_VC,2'h3,1);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DSCALE_NP_VC,2'h3,2);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DSCALE_NP_VC,2'h3,3);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DSCALE_NP_VC,2'h3,4);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DSCALE_NP_VC,2'h3,5);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DSCALE_NP_VC,2'h3,6);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DSCALE_NP_VC,2'h3,7);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DSCALE_CPL_VC,2'h3,0);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DSCALE_CPL_VC,2'h3,1);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DSCALE_CPL_VC,2'h3,2);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DSCALE_CPL_VC,2'h3,3);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DSCALE_CPL_VC,2'h3,4);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DSCALE_CPL_VC,2'h3,5);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DSCALE_CPL_VC,2'h3,6);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_INIT_DSCALE_CPL_VC,2'h3,7);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DSCALE_CPL_VC,2'h3,0);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DSCALE_CPL_VC,2'h3,1);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DSCALE_CPL_VC,2'h3,2);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DSCALE_CPL_VC,2'h3,3);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DSCALE_CPL_VC,2'h3,4);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DSCALE_CPL_VC,2'h3,5);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DSCALE_CPL_VC,2'h3,6);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_INIT_DSCALE_CPL_VC,2'h3,7);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_UFC_AFTR_EACH_TLP,1'b1);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_UFC_AFTR_EACH_TLP,1'b1);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_UFC_FOR_INFINIT_CREDIT,1'b0);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_UFC_FOR_INFINIT_CREDIT,1'b0);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_BYPASS_FC,1'b0);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_BYPASS_FC,1'b0);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_DSBL_FLW_CTRL,1'b0);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_DSBL_FLW_CTRL,1'b0);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_BYPASS_TX_INIT_FC2,1'b0);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_BYPASS_TX_INIT_FC2,1'b0);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_BLCK_INIT_FC1,1'b0);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_BLCK_INIT_FC1,1'b0);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_BLCK_INIT_FC2,1'b0);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_BLCK_INIT_FC2,1'b0);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_REPLAY_OFF,1'b0);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_REPLAY_OFF,1'b0);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_REPLAY,25000);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_REPLAY,25000);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_UPDATE_TIMER,30000,0,0);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_UPDATE_TIMER,30000,0,1);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_UPDATE_TIMER,30000,0,2);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_UPDATE_TIMER,30000,1,0);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_UPDATE_TIMER,30000,1,1);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_UPDATE_TIMER,30000,1,2);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_UPDATE_TIMER,30000,2,0);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_UPDATE_TIMER,30000,2,1);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_UPDATE_TIMER,30000,2,2);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_UPDATE_TIMER,30000,3,0);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_UPDATE_TIMER,30000,3,1);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_UPDATE_TIMER,30000,3,2);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_UPDATE_TIMER,30000,4,0);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_UPDATE_TIMER,30000,4,1);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_UPDATE_TIMER,30000,4,2);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_UPDATE_TIMER,30000,5,0);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_UPDATE_TIMER,30000,5,1);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_UPDATE_TIMER,30000,5,2);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_UPDATE_TIMER,30000,6,0);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_UPDATE_TIMER,30000,6,1);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_UPDATE_TIMER,30000,6,2);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_UPDATE_TIMER,30000,7,0);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_UPDATE_TIMER,30000,7,1);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_UPDATE_TIMER,30000,7,2);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_UPDATE_TIMER,30000,0,0);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_UPDATE_TIMER,30000,0,1);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_UPDATE_TIMER,30000,0,2);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_UPDATE_TIMER,30000,1,0);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_UPDATE_TIMER,30000,1,1);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_UPDATE_TIMER,30000,1,2);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_UPDATE_TIMER,30000,2,0);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_UPDATE_TIMER,30000,2,1);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_UPDATE_TIMER,30000,2,2);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_UPDATE_TIMER,30000,3,0);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_UPDATE_TIMER,30000,3,1);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_UPDATE_TIMER,30000,3,2);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_UPDATE_TIMER,30000,4,0);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_UPDATE_TIMER,30000,4,1);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_UPDATE_TIMER,30000,4,2);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_UPDATE_TIMER,30000,5,0);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_UPDATE_TIMER,30000,5,1);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_UPDATE_TIMER,30000,5,2);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_UPDATE_TIMER,30000,6,0);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_UPDATE_TIMER,30000,6,1);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_UPDATE_TIMER,30000,6,2);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_UPDATE_TIMER,30000,7,0);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_UPDATE_TIMER,30000,7,1);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_UPDATE_TIMER,30000,7,2);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_ACK_NAK_LATENCY,0);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_ACK_NAK_LATENCY,0);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_LINK_NUM,8'h00);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_LINK_NUM,8'h00);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_EIEOS_16GT_FMT_16_0_1,1'b0);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_DSBL_CTRL_SKP,1'b0);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_LANE_REV,1'b1);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_LANE_REV,1'b1);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_LANE_PLRTY_INV,8'h00);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_LANE_PLRTY_INV,8'h00);
        //    cfg.m_bfm.config_auto_speed_chg_aftr_dtct = 2'h0;
        //    cfg.m_bfm.config_disable_scrambling = 2'h0;
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_EN_AUTO_EQ,1'b1);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_EN_AUTO_EQ,1'b1);
        //    cfg.m_bfm.config_sync_hdr_bypass = 1'b0;
        //    cfg.m_bfm.config_lane_under_test = '{2{0}};
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_BEACON_SUPP,1'b1);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_BEACON_SUPP,1'b1);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_BEACON_SYMB,10'h305);
        //    cfg.set_cfg(PCIE_US_PORT,PCIE_BEACON_SYMB,10'h305);
        //    cfg.set_cfg(PCIE_DS_PORT,PCIE_BEACON_TX_TIME,3000);
        //    cfg.m_bfm.config_ordering_rule = 16'h6777;
        //    cfg.m_bfm.g_rcvry_prst_gen3 = 32'hXXXXXXXX;
        //    cfg.m_bfm.g_rcvry_prst_gen4 = 32'hXXXXXXXX;
        //    cfg.m_bfm.g_rcvry_prst_gen5 = 32'hXXXXXXXX;
        //    cfg.m_bfm.g_stop_pipe_msg_recog = 16'h0000;
        //    cfg.m_bfm.g_init_eb_rst_seq = 32'h00000000;
        //    cfg.m_bfm.my_id = 144'h000001000101010201030104010501060107;
        //    cfg.m_bfm.curr_cfg_cmpl = '{2{'{PCIE_CPL,'{3{1'b0}},1'b0,PCIE_DEFAULT,'{3{1'b0}},1'b0,1'b0,'{10{1'b0}},'{16{1'b0}},'{10{1'b0}},'{16{1'b0}},PCIE_SC,1'b0,'{12{1'b0}},'{7{1'b0}},'{32{1'b0}},'{7{1'b0}},1'b0,'{12{1'b0}},'{3{1'b0}},'{8{1'b0}},1'b0}}};
        //    cfg.m_bfm.g_actual_cmpl_data = '{2{0}};
        //    cfg.m_bfm.g_device_type_sv = PCIE_RC;
        //    cfg.m_bfm.update_os_fields = '{2{'{8{'{1'b0,'{8{1'b0}},1'b0,'{8{1'b0}},'{8{1'b0}},'{8{1'b0}},1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,'{2{1'b0}},1'b0,1'b0,'{8{1'b0}},0,0,0,'{3{1'b0}},PCIE_RX_NUM_BROADCAST,'{8{1'b0}},1'b0,1'b0,1'b0,1'b0,'{8{1'b0}},'{8{1'b0}},'{8{1'b0}},'{8{1'b0}},'{16{1'b0}},'{16{'{8{1'b0}}}},1'b0,1'b0,1'b0}}}}};
        //    cfg.m_bfm.g_upconfig_capable = 2'h0;
        //    cfg.m_bfm.g_stop_reco_lpbk_10b = 1'b0;
        //    cfg.m_bfm.pcie_ts_mode = '{2{PCIE_STD_TS}};
        //    cfg.m_bfm.eq_bypass_mode = '{2{PCIE_FULL_EQ}};
        //
        
    endfunction: configure
    
endclass: pcie_ep_config_policy

