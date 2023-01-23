// Version '20200402'
// Library '2020.2:04/19/2020:18:58'
// block_c_configurator.cmd
// replay file for generating qvip sub-env for block_c example
// Usage: $(QUESTA_MVC_HOME)/bin/qvip_configurator -commands block_c_configurator.cmd
// Address Map
"Configurator" address_map create block_c_addr_map
"Configurator" address_map block_c_addr_map add MAP_NORMAL,"AXI4_SLAVE",0,MAP_NS,4'h0,64'h0,64'h100000000,MEM_NORMAL,MAP_NORM_SEC_DATA
// PCIe EP
"Configurator" create VIP_instance pcie/pcie /top/pcie_ep pcie_ep_serial
// AXI4 Master
"Configurator" create VIP_instance amba/axi4 /top/axi4_master_0 axi4_master
"Configurator" change variable vip_config.addr_map block_c_addr_map
// AXI4 Master
"Configurator" create VIP_instance amba/axi4 /top/axi4_master_1 axi4_master
"Configurator" change variable vip_config.addr_map block_c_addr_map
// AXI4 Slave
"Configurator" create VIP_instance amba/axi4 /top/axi4_slave axi4_slave
"Configurator" change variable vip_config.addr_map block_c_addr_map
"Configurator" change variable vip_config.slave_id 0
// APB3 master
"Configurator" create VIP_instance amba/apb3 /top/apb3_config_master apb_master
"Configurator" change variable vip_config.addr_map block_c_addr_map
"Configurator" change variable agent.if_type APB3
"Configurator" change test qvip_agents
// "Configurator" generate
// Mon Dec 21 2020 07:52:07
