//
// File: qvip_agents_params_pkg.sv
//
// Generated from Mentor VIP Configurator (20200402)
// Generated using Mentor VIP Library ( 2020.2 : 04/19/2020:18:58 )
//
package qvip_agents_params_pkg;
    import addr_map_pkg::*;
    import rw_delay_db_pkg::*;
    //
    // Import the necessary QVIP packages:
    //
    import mgc_pcie_v2_0_pkg::*;
    import mgc_axi4_v1_0_pkg::*;
    import mgc_apb3_v1_0_pkg::*;
    class pcie_ep_params;
        localparam int LANES                   = 8;
        localparam int PIPE_BYTES_MAX          = 1;
        localparam int CONFIG_NUM_OF_FUNCTIONS = 1;
    endclass: pcie_ep_params
    
    typedef pcie_vip_config #(pcie_ep_params::LANES,pcie_ep_params::PIPE_BYTES_MAX,pcie_ep_params::CONFIG_NUM_OF_FUNCTIONS) pcie_ep_cfg_t;
    
    typedef pcie_agent #(pcie_ep_params::LANES,pcie_ep_params::PIPE_BYTES_MAX,pcie_ep_params::CONFIG_NUM_OF_FUNCTIONS) pcie_ep_agent_t;
    
    typedef virtual mgc_pcie #(pcie_ep_params::LANES,pcie_ep_params::PIPE_BYTES_MAX,pcie_ep_params::CONFIG_NUM_OF_FUNCTIONS) pcie_ep_bfm_t;
    
    class axi4_master_0_params;
        localparam int AXI4_ADDRESS_WIDTH   = 32;
        localparam int AXI4_RDATA_WIDTH     = 32;
        localparam int AXI4_WDATA_WIDTH     = 32;
        localparam int AXI4_ID_WIDTH        = 4;
        localparam int AXI4_USER_WIDTH      = 4;
        localparam int AXI4_REGION_MAP_SIZE = 16;
    endclass: axi4_master_0_params
    
    typedef axi4_vip_config #(axi4_master_0_params::AXI4_ADDRESS_WIDTH,axi4_master_0_params::AXI4_RDATA_WIDTH,axi4_master_0_params::AXI4_WDATA_WIDTH,axi4_master_0_params::AXI4_ID_WIDTH,axi4_master_0_params::AXI4_USER_WIDTH,axi4_master_0_params::AXI4_REGION_MAP_SIZE) axi4_master_0_cfg_t;
    
    typedef axi4_agent #(axi4_master_0_params::AXI4_ADDRESS_WIDTH,axi4_master_0_params::AXI4_RDATA_WIDTH,axi4_master_0_params::AXI4_WDATA_WIDTH,axi4_master_0_params::AXI4_ID_WIDTH,axi4_master_0_params::AXI4_USER_WIDTH,axi4_master_0_params::AXI4_REGION_MAP_SIZE) axi4_master_0_agent_t;
    
    typedef virtual mgc_axi4 #(axi4_master_0_params::AXI4_ADDRESS_WIDTH,axi4_master_0_params::AXI4_RDATA_WIDTH,axi4_master_0_params::AXI4_WDATA_WIDTH,axi4_master_0_params::AXI4_ID_WIDTH,axi4_master_0_params::AXI4_USER_WIDTH,axi4_master_0_params::AXI4_REGION_MAP_SIZE) axi4_master_0_bfm_t;
    
    class axi4_master_1_params;
        localparam int AXI4_ADDRESS_WIDTH   = 32;
        localparam int AXI4_RDATA_WIDTH     = 32;
        localparam int AXI4_WDATA_WIDTH     = 32;
        localparam int AXI4_ID_WIDTH        = 4;
        localparam int AXI4_USER_WIDTH      = 4;
        localparam int AXI4_REGION_MAP_SIZE = 16;
    endclass: axi4_master_1_params
    
    typedef axi4_vip_config #(axi4_master_1_params::AXI4_ADDRESS_WIDTH,axi4_master_1_params::AXI4_RDATA_WIDTH,axi4_master_1_params::AXI4_WDATA_WIDTH,axi4_master_1_params::AXI4_ID_WIDTH,axi4_master_1_params::AXI4_USER_WIDTH,axi4_master_1_params::AXI4_REGION_MAP_SIZE) axi4_master_1_cfg_t;
    
    typedef axi4_agent #(axi4_master_1_params::AXI4_ADDRESS_WIDTH,axi4_master_1_params::AXI4_RDATA_WIDTH,axi4_master_1_params::AXI4_WDATA_WIDTH,axi4_master_1_params::AXI4_ID_WIDTH,axi4_master_1_params::AXI4_USER_WIDTH,axi4_master_1_params::AXI4_REGION_MAP_SIZE) axi4_master_1_agent_t;
    
    typedef virtual mgc_axi4 #(axi4_master_1_params::AXI4_ADDRESS_WIDTH,axi4_master_1_params::AXI4_RDATA_WIDTH,axi4_master_1_params::AXI4_WDATA_WIDTH,axi4_master_1_params::AXI4_ID_WIDTH,axi4_master_1_params::AXI4_USER_WIDTH,axi4_master_1_params::AXI4_REGION_MAP_SIZE) axi4_master_1_bfm_t;
    
    class axi4_slave_params;
        localparam int AXI4_ADDRESS_WIDTH   = 32;
        localparam int AXI4_RDATA_WIDTH     = 32;
        localparam int AXI4_WDATA_WIDTH     = 32;
        localparam int AXI4_ID_WIDTH        = 4;
        localparam int AXI4_USER_WIDTH      = 4;
        localparam int AXI4_REGION_MAP_SIZE = 16;
    endclass: axi4_slave_params
    
    typedef axi4_vip_config #(axi4_slave_params::AXI4_ADDRESS_WIDTH,axi4_slave_params::AXI4_RDATA_WIDTH,axi4_slave_params::AXI4_WDATA_WIDTH,axi4_slave_params::AXI4_ID_WIDTH,axi4_slave_params::AXI4_USER_WIDTH,axi4_slave_params::AXI4_REGION_MAP_SIZE) axi4_slave_cfg_t;
    
    typedef axi4_agent #(axi4_slave_params::AXI4_ADDRESS_WIDTH,axi4_slave_params::AXI4_RDATA_WIDTH,axi4_slave_params::AXI4_WDATA_WIDTH,axi4_slave_params::AXI4_ID_WIDTH,axi4_slave_params::AXI4_USER_WIDTH,axi4_slave_params::AXI4_REGION_MAP_SIZE) axi4_slave_agent_t;
    
    typedef virtual mgc_axi4 #(axi4_slave_params::AXI4_ADDRESS_WIDTH,axi4_slave_params::AXI4_RDATA_WIDTH,axi4_slave_params::AXI4_WDATA_WIDTH,axi4_slave_params::AXI4_ID_WIDTH,axi4_slave_params::AXI4_USER_WIDTH,axi4_slave_params::AXI4_REGION_MAP_SIZE) axi4_slave_bfm_t;
    
    class apb3_config_master_params;
        localparam int APB3_SLAVE_COUNT      = 1;
        localparam int APB3_PADDR_BIT_WIDTH  = 32;
        localparam int APB3_PWDATA_BIT_WIDTH = 32;
        localparam int APB3_PRDATA_BIT_WIDTH = 32;
    endclass: apb3_config_master_params
    
    typedef apb3_vip_config #(apb3_config_master_params::APB3_SLAVE_COUNT,apb3_config_master_params::APB3_PADDR_BIT_WIDTH,apb3_config_master_params::APB3_PWDATA_BIT_WIDTH,apb3_config_master_params::APB3_PRDATA_BIT_WIDTH) apb3_config_master_cfg_t;
    
    typedef apb_agent #(apb3_config_master_params::APB3_SLAVE_COUNT,apb3_config_master_params::APB3_PADDR_BIT_WIDTH,apb3_config_master_params::APB3_PWDATA_BIT_WIDTH,apb3_config_master_params::APB3_PRDATA_BIT_WIDTH) apb3_config_master_agent_t;
    
    typedef virtual mgc_apb3 #(apb3_config_master_params::APB3_SLAVE_COUNT,apb3_config_master_params::APB3_PADDR_BIT_WIDTH,apb3_config_master_params::APB3_PWDATA_BIT_WIDTH,apb3_config_master_params::APB3_PRDATA_BIT_WIDTH) apb3_config_master_bfm_t;
    
    //
    // `includes for the config policy classes:
    //
    `include "axi4_master_1_config_policy.svh"
    `include "pcie_ep_config_policy.svh"
    `include "axi4_master_0_config_policy.svh"
    `include "axi4_slave_config_policy.svh"
    `include "apb3_config_master_config_policy.svh"
endpackage: qvip_agents_params_pkg
