//
// File: qvip_agents_params_pkg.sv
//
// Generated from Mentor VIP Configurator (20200115)
// Generated using Mentor VIP Library ( 2020.1 : 01/23/2020:13:29 )
//
package qvip_agents_params_pkg;
    import addr_map_pkg::*;
    //
    // Import the necessary QVIP packages:
    //
    import mgc_apb3_v1_0_pkg::*;
    class apb_master_0_params;
        localparam int APB3_SLAVE_COUNT      = 1;
        localparam int APB3_PADDR_BIT_WIDTH  = 32;
        localparam int APB3_PWDATA_BIT_WIDTH = 32;
        localparam int APB3_PRDATA_BIT_WIDTH = 32;
    endclass: apb_master_0_params
    
    typedef apb3_vip_config #(apb_master_0_params::APB3_SLAVE_COUNT,apb_master_0_params::APB3_PADDR_BIT_WIDTH,apb_master_0_params::APB3_PWDATA_BIT_WIDTH,apb_master_0_params::APB3_PRDATA_BIT_WIDTH) apb_master_0_cfg_t;
    
    typedef apb_agent #(apb_master_0_params::APB3_SLAVE_COUNT,apb_master_0_params::APB3_PADDR_BIT_WIDTH,apb_master_0_params::APB3_PWDATA_BIT_WIDTH,apb_master_0_params::APB3_PRDATA_BIT_WIDTH) apb_master_0_agent_t;
    
    typedef virtual mgc_apb3 #(apb_master_0_params::APB3_SLAVE_COUNT,apb_master_0_params::APB3_PADDR_BIT_WIDTH,apb_master_0_params::APB3_PWDATA_BIT_WIDTH,apb_master_0_params::APB3_PRDATA_BIT_WIDTH) apb_master_0_bfm_t;
    
    //
    // `includes for the config policy classes:
    //
    `include "apb_master_0_config_policy.svh"
endpackage: qvip_agents_params_pkg
