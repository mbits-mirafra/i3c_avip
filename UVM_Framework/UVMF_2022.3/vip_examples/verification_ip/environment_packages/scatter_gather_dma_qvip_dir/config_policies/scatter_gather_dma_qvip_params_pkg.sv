//
// File: scatter_gather_dma_qvip_params_pkg.sv
//
// Generated from Mentor VIP Configurator (20201007)
// Generated using Mentor VIP Library ( 2020.4 : 10/16/2020:13:17 )
//
package scatter_gather_dma_qvip_params_pkg;
    import addr_map_pkg::*;
    import rw_delay_db_pkg::*;
    //
    // Import the necessary QVIP packages:
    //
    import mgc_axi4_v1_0_pkg::*;
    class mgc_axi4_m0_params;
        localparam int AXI4_ADDRESS_WIDTH   = 32;
        localparam int AXI4_RDATA_WIDTH     = 32;
        localparam int AXI4_WDATA_WIDTH     = 32;
        localparam int AXI4_ID_WIDTH        = 1;
        localparam int AXI4_USER_WIDTH      = 4;
        localparam int AXI4_REGION_MAP_SIZE = 16;
    endclass: mgc_axi4_m0_params
    
    typedef axi4_vip_config #(mgc_axi4_m0_params::AXI4_ADDRESS_WIDTH,mgc_axi4_m0_params::AXI4_RDATA_WIDTH,mgc_axi4_m0_params::AXI4_WDATA_WIDTH,mgc_axi4_m0_params::AXI4_ID_WIDTH,mgc_axi4_m0_params::AXI4_USER_WIDTH,mgc_axi4_m0_params::AXI4_REGION_MAP_SIZE) mgc_axi4_m0_cfg_t;
    
    typedef axi4_agent #(mgc_axi4_m0_params::AXI4_ADDRESS_WIDTH,mgc_axi4_m0_params::AXI4_RDATA_WIDTH,mgc_axi4_m0_params::AXI4_WDATA_WIDTH,mgc_axi4_m0_params::AXI4_ID_WIDTH,mgc_axi4_m0_params::AXI4_USER_WIDTH,mgc_axi4_m0_params::AXI4_REGION_MAP_SIZE) mgc_axi4_m0_agent_t;
    
    typedef virtual mgc_axi4 #(mgc_axi4_m0_params::AXI4_ADDRESS_WIDTH,mgc_axi4_m0_params::AXI4_RDATA_WIDTH,mgc_axi4_m0_params::AXI4_WDATA_WIDTH,mgc_axi4_m0_params::AXI4_ID_WIDTH,mgc_axi4_m0_params::AXI4_USER_WIDTH,mgc_axi4_m0_params::AXI4_REGION_MAP_SIZE) mgc_axi4_m0_bfm_t;
    
    class mgc_axi4_s0_params;
        localparam int AXI4_ADDRESS_WIDTH   = 32;
        localparam int AXI4_RDATA_WIDTH     = 64;
        localparam int AXI4_WDATA_WIDTH     = 64;
        localparam int AXI4_ID_WIDTH        = 4;
        localparam int AXI4_USER_WIDTH      = 4;
        localparam int AXI4_REGION_MAP_SIZE = 16;
    endclass: mgc_axi4_s0_params
    
    typedef axi4_vip_config #(mgc_axi4_s0_params::AXI4_ADDRESS_WIDTH,mgc_axi4_s0_params::AXI4_RDATA_WIDTH,mgc_axi4_s0_params::AXI4_WDATA_WIDTH,mgc_axi4_s0_params::AXI4_ID_WIDTH,mgc_axi4_s0_params::AXI4_USER_WIDTH,mgc_axi4_s0_params::AXI4_REGION_MAP_SIZE) mgc_axi4_s0_cfg_t;
    
    typedef axi4_agent #(mgc_axi4_s0_params::AXI4_ADDRESS_WIDTH,mgc_axi4_s0_params::AXI4_RDATA_WIDTH,mgc_axi4_s0_params::AXI4_WDATA_WIDTH,mgc_axi4_s0_params::AXI4_ID_WIDTH,mgc_axi4_s0_params::AXI4_USER_WIDTH,mgc_axi4_s0_params::AXI4_REGION_MAP_SIZE) mgc_axi4_s0_agent_t;
    
    typedef virtual mgc_axi4 #(mgc_axi4_s0_params::AXI4_ADDRESS_WIDTH,mgc_axi4_s0_params::AXI4_RDATA_WIDTH,mgc_axi4_s0_params::AXI4_WDATA_WIDTH,mgc_axi4_s0_params::AXI4_ID_WIDTH,mgc_axi4_s0_params::AXI4_USER_WIDTH,mgc_axi4_s0_params::AXI4_REGION_MAP_SIZE) mgc_axi4_s0_bfm_t;
    
    //
    // `includes for the config policy classes:
    //
    `include "mgc_axi4_s0_config_policy.svh"
    `include "mgc_axi4_m0_config_policy.svh"
endpackage: scatter_gather_dma_qvip_params_pkg
