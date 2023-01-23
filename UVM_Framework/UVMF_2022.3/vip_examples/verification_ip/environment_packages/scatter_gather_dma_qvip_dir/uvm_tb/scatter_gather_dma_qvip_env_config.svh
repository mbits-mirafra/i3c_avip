//
// File: scatter_gather_dma_qvip_env_config.svh
//
// Generated from Mentor VIP Configurator (20201007)
// Generated using Mentor VIP Library ( 2020.4 : 10/16/2020:13:17 )
//
class scatter_gather_dma_qvip_env_config extends uvm_object;
    `uvm_object_utils(scatter_gather_dma_qvip_env_config)
    // Handles for vip config for each of the QVIP instances
    
    mgc_axi4_m0_cfg_t mgc_axi4_m0_cfg;
    mgc_axi4_s0_cfg_t mgc_axi4_s0_cfg;
    // Handles for address maps
    
    address_map scatter_gather_dma_addr_map;
    
    function new
    (
        string name = "scatter_gather_dma_qvip_env_config"
    );
        super.new(name);
    endfunction
    
    extern function void initialize;
    
endclass: scatter_gather_dma_qvip_env_config

function void scatter_gather_dma_qvip_env_config::initialize;
    begin
        addr_map_entry_s addr_map_entries[] = new [1];
        addr_map_entries = '{1{'{MAP_NORMAL,"SLAVE_0",0,MAP_NS,4'h0,64'h0,64'h100000000,MEM_NORMAL,MAP_NORM_SEC_DATA}}};
        scatter_gather_dma_addr_map = address_map::type_id::create("scatter_gather_dma_addr_map_addr_map");
        scatter_gather_dma_addr_map.addr_mask = 64'hFFF;
        scatter_gather_dma_addr_map.set( addr_map_entries );
    end
endfunction: initialize

