//
// File: axi4_2x2_fabric_qvip_env_config.svh
//
// Generated from Mentor VIP Configurator (20191003)
// Generated using Mentor VIP Library ( 2019.4 : 10/16/2019:13:47 )
//
class axi4_2x2_fabric_qvip_env_config extends uvm_object;
    `uvm_object_utils(axi4_2x2_fabric_qvip_env_config)
    // Handles for vip config for each of the QVIP instances
    
    mgc_axi4_m0_cfg_t mgc_axi4_m0_cfg;
    mgc_axi4_m1_cfg_t mgc_axi4_m1_cfg;
    mgc_axi4_s0_cfg_t mgc_axi4_s0_cfg;
    mgc_axi4_s1_cfg_t mgc_axi4_s1_cfg;
    // Handles for address maps
    
    address_map axi4_2x2_fabric_addr_map;
    
    function new
    (
        string name = "axi4_2x2_fabric_qvip_env_config"
    );
        super.new(name);
    endfunction
    
    extern function void initialize;
    
endclass: axi4_2x2_fabric_qvip_env_config

function void axi4_2x2_fabric_qvip_env_config::initialize;
    begin
        addr_map_entry_s addr_map_entries[] = new [2];
        addr_map_entries = '{'{MAP_NORMAL,"SLAVE_0",0,MAP_NS,4'h0,64'h0,64'h80000000,MEM_NORMAL,MAP_NORM_SEC_DATA},'{MAP_NORMAL,"SLAVE_1",1,MAP_NS,4'h0,64'h80000000,64'h80000000,MEM_NORMAL,MAP_NORM_SEC_DATA}};
        axi4_2x2_fabric_addr_map = address_map::type_id::create("axi4_2x2_fabric_addr_map_addr_map");
        axi4_2x2_fabric_addr_map.addr_mask = 64'hFFF;
        axi4_2x2_fabric_addr_map.set( addr_map_entries );
    end
endfunction: initialize

