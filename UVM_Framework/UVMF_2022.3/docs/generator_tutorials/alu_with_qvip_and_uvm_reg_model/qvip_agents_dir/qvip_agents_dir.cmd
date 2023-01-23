// Version '20200115'
// Library '2020.1:01/23/2020:13:29'
"Configurator" create VIP_instance 2020.1/amba/apb3
"Configurator" change variable agent.en_cvg 1
"Configurator" change variable agent.en_sb 0
"Configurator" change variable agent.en_txn_ltnr 1
"Configurator" change variable agent.en_rw_adapter 1
"Configurator" change variable agent.en_logger.txn_log_name "apb_txn.log"
"Configurator" change variable agent.en_logger.txn_log 1
"Configurator" address_map create mem_map
"Configurator" address_map mem_map add MAP_NORMAL,"RANGE_1",0,MAP_NS,4'h0,64'h0,64'h1000,MEM_NORMAL,MAP_NORM_SEC_DATA
"Configurator" change variable vip_config.addr_map mem_map
"Configurator" change test qvip_agents
// "Configurator" generate
// Fri Nov 6 2020 11:06:35
