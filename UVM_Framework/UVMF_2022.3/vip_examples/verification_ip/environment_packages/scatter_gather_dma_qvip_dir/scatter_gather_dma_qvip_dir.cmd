// Version '20201007'
// Library '2020.4:10/16/2020:13:17'
// Version '20200402'
// Library '2020.2:04/19/2020:18:58'
// import DUT
// "Configurator" import scatter_gather_dma_wrap.sv
// create address map
"Configurator" address_map create scatter_gather_dma_addr_map
"Configurator" address_map scatter_gather_dma_addr_map add MAP_NORMAL,"SLAVE_0",0,MAP_NS,4'h0,64'h0,64'h100000000,MEM_NORMAL,MAP_NORM_SEC_DATA
// clk default_clk_gen <Time unit> <Phase Shift> <Initial Value> <Mark duration> <Space duration>
"Configurator" change clock default_clk_gen ps 0 0 5000 5000
// reset default_reset_gen ps <Start edge> <Active cycles> <1> <1> <Active> <Sync edge> <Sync to clock>
change reset default_reset_gen ps 0 5 1 1 0 0 default_clk_gen
// axi4 lite master instance
"Configurator" create VIP_instance amba/axi4 /top/mgc_axi4_m0 axi4_master
"Configurator" change hash_param ID_WIDTH 1
"Configurator" change hash_param ADDR_WIDTH 32
"Configurator" change hash_param RDATA_WIDTH 32
"Configurator" change hash_param WDATA_WIDTH 32
"Configurator" change variable agent.if_type AXI4_LITE
"Configurator" change variable agent.en_sb 0
"Configurator" change variable agent.en_cvg.func 1
"Configurator" change variable agent.en_logger.txn_log 1
"Configurator" change variable agent.en_logger.txn_log_name "mgc_axi4_m0_txn.log"
"Configurator" change variable agent.en_logger.txn_column.addr_user 0
"Configurator" change variable agent.en_logger.txn_column.data_user 0
"Configurator" change variable agent.en_logger.txn_column.resp_user 0
"Configurator" change variable agent.en_logger.beat_log 1
"Configurator" change variable agent.en_logger.beat_log_name "mgc_axi4_m0_beat.log"
"Configurator" change variable agent.en_logger.beat_column.addr_user 0
"Configurator" change variable agent.en_logger.beat_column.data_user 0
"Configurator" change variable agent.en_logger.beat_column.resp_user 0
"Configurator" change variable agent.en_txn_ltnr 1
"Configurator" change variable config_enable_id 0
"Configurator" change variable config_set_all_write_strobes 1
"Configurator" change variable vip_config.addr_map scatter_gather_dma_addr_map
// axi4 slave instance
"Configurator" create VIP_instance amba/axi4 /top/mgc_axi4_s0 axi4_slave
"Configurator" change hash_param ID_WIDTH 4
"Configurator" change hash_param ADDR_WIDTH 32
"Configurator" change hash_param RDATA_WIDTH 64
"Configurator" change hash_param WDATA_WIDTH 64
"Configurator" change variable agent.en_sb 1
"Configurator" change variable agent.en_cvg.func 1
"Configurator" change variable agent.en_txn_ltnr 1
// pre QVIP 2020.x workaround re: disabling txn and beat _user field entries
"Configurator" change variable agent.en_logger.txn_column.addr_user 0
"Configurator" change variable agent.en_logger.txn_column.data_user 0
"Configurator" change variable agent.en_logger.txn_column.resp_user 0
"Configurator" change variable agent.en_logger.beat_log 1
"Configurator" change variable agent.en_logger.beat_log_name "mgc_axi4_s0_beat.log"
"Configurator" change variable agent.en_logger.beat_column.addr_user 0
"Configurator" change variable agent.en_logger.beat_column.data_user 0
"Configurator" change variable agent.en_logger.beat_column.resp_user 0
"Configurator" change variable vip_config.slave_id 0
"Configurator" change variable vip_config.addr_map scatter_gather_dma_addr_map
"Configurator" change variable vip_config.m_warn_on_uninitialized_read 1
// 
"Configurator" change instance /top/mgc_axi4_m0
//
"Configurator" change port connection /top/mgc_axi4_m0/BUSER 4'b0
"Configurator" change port connection /top/mgc_axi4_m0/RUSER 4'b0
"Configurator" change port connection /top/mgc_axi4_s0/ARPROT 3'b0
"Configurator" change port connection /top/mgc_axi4_s0/ARREGION 4'b0
"Configurator" change port connection /top/mgc_axi4_s0/ARSIZE 3'b011
"Configurator" change port connection /top/mgc_axi4_s0/ARBURST 2'b01
"Configurator" change port connection /top/mgc_axi4_s0/ARLOCK 1'b0
"Configurator" change port connection /top/mgc_axi4_s0/ARCACHE 4'b0
"Configurator" change port connection /top/mgc_axi4_s0/ARQOS 4'b0
"Configurator" change port connection /top/mgc_axi4_s0/ARUSER 4'b0
"Configurator" change port connection /top/mgc_axi4_s0/AWPROT 3'b0
"Configurator" change port connection /top/mgc_axi4_s0/AWREGION 4'b0
"Configurator" change port connection /top/mgc_axi4_s0/AWSIZE 3'b011
"Configurator" change port connection /top/mgc_axi4_s0/AWBURST 2'b01
"Configurator" change port connection /top/mgc_axi4_s0/AWLOCK 1'b0
"Configurator" change port connection /top/mgc_axi4_s0/AWCACHE 4'b0
"Configurator" change port connection /top/mgc_axi4_s0/AWQOS 4'b0
"Configurator" change port connection /top/mgc_axi4_s0/AWUSER 4'b0
"Configurator" change port connection /top/mgc_axi4_s0/WUSER 4'b0
//
"Configurator" change position right /top/mgc_axi4_s0
"Configurator" change test scatter_gather_dma_qvip
// "Configurator" generate
// Thu Jan 14 2021 16:58:09
