//
// File: qvip_agents_env_config.svh
//
// Generated from Mentor VIP Configurator (20200402)
// Generated using Mentor VIP Library ( 2020.2 : 04/19/2020:18:58 )
//
class qvip_agents_env_config extends uvm_object;
    `uvm_object_utils(qvip_agents_env_config)
    // Handles for vip config for each of the QVIP instances
    
    pcie_ep_cfg_t pcie_ep_cfg;
    axi4_master_0_cfg_t axi4_master_0_cfg;
    axi4_master_1_cfg_t axi4_master_1_cfg;
    axi4_slave_cfg_t axi4_slave_cfg;
    apb3_config_master_cfg_t apb3_config_master_cfg;
    // Handles for address maps
    
    address_map block_c_addr_map;
    
    function new
    (
        string name = "qvip_agents_env_config"
    );
        super.new(name);
    endfunction
    
    extern function void initialize;
    
endclass: qvip_agents_env_config

function void qvip_agents_env_config::initialize;
    begin
        addr_map_entry_s addr_map_entries[] = new [1];
        addr_map_entries = '{1{'{MAP_NORMAL,"AXI4_SLAVE",0,MAP_NS,4'h0,64'h0,64'h100000000,MEM_NORMAL,MAP_NORM_SEC_DATA}}};
        block_c_addr_map = address_map::type_id::create("block_c_addr_map_addr_map");
        block_c_addr_map.addr_mask = 64'hFFF;
        block_c_addr_map.set( addr_map_entries );
    end
endfunction: initialize

