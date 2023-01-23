//
// File: qvip_agents_env_config.svh
//
// Generated from Mentor VIP Configurator (20200115)
// Generated using Mentor VIP Library ( 2020.1 : 01/23/2020:13:29 )
//
class qvip_agents_env_config extends uvm_object;
    `uvm_object_utils(qvip_agents_env_config)
    // Handles for vip config for each of the QVIP instances
    
    apb_master_0_cfg_t apb_master_0_cfg;
    // Handles for address maps
    
    address_map mem_map;
    
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
        addr_map_entries = '{1{'{MAP_NORMAL,"RANGE_1",0,MAP_NS,4'h0,64'h0,64'h1000,MEM_NORMAL,MAP_NORM_SEC_DATA}}};
        mem_map = address_map::type_id::create("mem_map_addr_map");
        mem_map.addr_mask = 64'hFFF;
        mem_map.set( addr_map_entries );
    end
endfunction: initialize

