// Version '20160818'
// Library '10_5b:09/04/2016:09:24'
"Configurator" address_map create axi4_2x2_fabric_addr_map
"Configurator" address_map axi4_2x2_fabric_addr_map add MAP_NORMAL,"SLAVE_0",0,MAP_NS,4'h0,64'h0,64'h80000000,MEM_NORMAL,MAP_NORM_SEC_DATA
"Configurator" address_map axi4_2x2_fabric_addr_map add MAP_NORMAL,"SLAVE_1",1,MAP_NS,4'h0,64'h80000000,64'h80000000,MEM_NORMAL,MAP_NORM_SEC_DATA
"Configurator" create VIP_instance amba/axi4
"Configurator" change name mgc_axi4_m0
"Configurator" change hash_param ID_WIDTH 4
"Configurator" change hash_param ADDR_WIDTH 32
"Configurator" change variable agent.en_sb 0
"Configurator" change variable agent.en_logger.txn_log 1
"Configurator" change variable agent.en_logger.txn_log_name "mgc_axi4_m0_txn.log"
"Configurator" change variable agent.en_txn_ltnr 1
"Configurator" change variable vip_config.addr_map axi4_2x2_fabric_addr_map
"Configurator" create VIP_instance amba/axi4
"Configurator" change name mgc_axi4_m1
"Configurator" change hash_param ID_WIDTH 4
"Configurator" change hash_param ADDR_WIDTH 32
"Configurator" change variable agent.en_sb 0
"Configurator" change variable agent.en_logger.txn_log 1
"Configurator" change variable agent.en_logger.txn_log_name "mgc_axi4_m1_txn.log"
"Configurator" change variable agent.en_txn_ltnr 1
"Configurator" change variable vip_config.addr_map axi4_2x2_fabric_addr_map
"Configurator" create VIP_instance amba/axi4
"Configurator" change name mgc_axi4_s0
"Configurator" change type axi4_slave
"Configurator" change hash_param ID_WIDTH 5
"Configurator" change hash_param ADDR_WIDTH 32
"Configurator" change variable agent.en_sb 0
"Configurator" change variable agent.en_txn_ltnr 1
"Configurator" change variable vip_config.slave_id 0
"Configurator" change variable vip_config.addr_map axi4_2x2_fabric_addr_map
"Configurator" create VIP_instance amba/axi4
"Configurator" change name mgc_axi4_s1
"Configurator" change type axi4_slave
"Configurator" change hash_param ID_WIDTH 5
"Configurator" change hash_param ADDR_WIDTH 32
"Configurator" change variable agent.en_sb 0
"Configurator" change variable agent.en_txn_ltnr 1
"Configurator" change variable vip_config.slave_id 1
"Configurator" change variable vip_config.addr_map axi4_2x2_fabric_addr_map
"Configurator" create module DUT top/DUT
"Configurator" change position right /top/mgc_axi4_s0
"Configurator" change position right /top/mgc_axi4_s1
"Configurator" change test axi4_2x2_fabric_qvip
// reset default_reset_gen ns <Start edge> <Active cycles> <1> <1> <Active> <Sync edge> <Sync to clock>
change reset default_reset_gen ns 0 5 1 1 0 0 1
"Configurator" generate
exit
