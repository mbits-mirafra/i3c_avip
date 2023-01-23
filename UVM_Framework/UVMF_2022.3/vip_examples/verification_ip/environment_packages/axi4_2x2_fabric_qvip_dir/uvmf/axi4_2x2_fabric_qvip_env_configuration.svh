//
// File: axi4_2x2_fabric_qvip_env_configuration.svh
//
// Generated from Mentor VIP Configurator (20191003)
// Generated using Mentor VIP Library ( 2019.4 : 10/16/2019:13:47 )
//
class axi4_2x2_fabric_qvip_env_configuration extends uvmf_environment_configuration_base;
    `uvm_object_utils(axi4_2x2_fabric_qvip_env_configuration)
    // Handles for vip config for each of the QVIP instances
    
    mgc_axi4_m0_cfg_t mgc_axi4_m0_cfg;
    mgc_axi4_m1_cfg_t mgc_axi4_m1_cfg;
    mgc_axi4_s0_cfg_t mgc_axi4_s0_cfg;
    mgc_axi4_s1_cfg_t mgc_axi4_s1_cfg;
    // Handles for address maps
    
    address_map axi4_2x2_fabric_addr_map;
    
    function new
    (
        string name = "axi4_2x2_fabric_qvip_env_configuration"
    );
        super.new(name);
        mgc_axi4_m0_cfg = mgc_axi4_m0_cfg_t::type_id::create("mgc_axi4_m0_cfg");
        mgc_axi4_m1_cfg = mgc_axi4_m1_cfg_t::type_id::create("mgc_axi4_m1_cfg");
        mgc_axi4_s0_cfg = mgc_axi4_s0_cfg_t::type_id::create("mgc_axi4_s0_cfg");
        mgc_axi4_s1_cfg = mgc_axi4_s1_cfg_t::type_id::create("mgc_axi4_s1_cfg");
    endfunction
    
    virtual function string convert2string;
        return {"axi4_2x2_fabric_qvip_env_configuration:",mgc_axi4_m0_cfg.convert2string(),mgc_axi4_m1_cfg.convert2string(),mgc_axi4_s0_cfg.convert2string(),mgc_axi4_s1_cfg.convert2string()};
    endfunction: convert2string
    
    extern function void initialize
    (
        uvmf_sim_level_t sim_level,
        string environment_path,
        string interface_names[],
        uvm_reg_block register_model = null,
        uvmf_active_passive_t interface_activity[] = null
    );
    
endclass: axi4_2x2_fabric_qvip_env_configuration

function void axi4_2x2_fabric_qvip_env_configuration::initialize
(
    uvmf_sim_level_t sim_level,
    string environment_path,
    string interface_names[],
    uvm_reg_block register_model = null,
    uvmf_active_passive_t interface_activity[] = null
);
    super.initialize(sim_level, environment_path, interface_names, register_model, interface_activity);
    
    if ( !uvm_config_db #(mgc_axi4_m0_bfm_t)::get( null, "UVMF_VIRTUAL_INTERFACES", interface_names[0], mgc_axi4_m0_cfg.m_bfm ) )
    begin
        `uvm_fatal("Config Error", $sformatf("uvm_config_db #(mgc_axi4_m0_bfm_t)::get() cannot find bfm vif handle for agent with interface_name '%s'", interface_names[0]))
    end
    
    if ( !uvm_config_db #(mgc_axi4_m1_bfm_t)::get( null, "UVMF_VIRTUAL_INTERFACES", interface_names[1], mgc_axi4_m1_cfg.m_bfm ) )
    begin
        `uvm_fatal("Config Error", $sformatf("uvm_config_db #(mgc_axi4_m1_bfm_t)::get() cannot find bfm vif handle for agent with interface_name '%s'", interface_names[1]))
    end
    
    if ( !uvm_config_db #(mgc_axi4_s0_bfm_t)::get( null, "UVMF_VIRTUAL_INTERFACES", interface_names[2], mgc_axi4_s0_cfg.m_bfm ) )
    begin
        `uvm_fatal("Config Error", $sformatf("uvm_config_db #(mgc_axi4_s0_bfm_t)::get() cannot find bfm vif handle for agent with interface_name '%s'", interface_names[2]))
    end
    
    if ( !uvm_config_db #(mgc_axi4_s1_bfm_t)::get( null, "UVMF_VIRTUAL_INTERFACES", interface_names[3], mgc_axi4_s1_cfg.m_bfm ) )
    begin
        `uvm_fatal("Config Error", $sformatf("uvm_config_db #(mgc_axi4_s1_bfm_t)::get() cannot find bfm vif handle for agent with interface_name '%s'", interface_names[3]))
    end
    
    begin
        addr_map_entry_s addr_map_entries[] = new [2];
        addr_map_entries = '{'{MAP_NORMAL,"SLAVE_0",0,MAP_NS,4'h0,64'h0,64'h80000000,MEM_NORMAL,MAP_NORM_SEC_DATA},'{MAP_NORMAL,"SLAVE_1",1,MAP_NS,4'h0,64'h80000000,64'h80000000,MEM_NORMAL,MAP_NORM_SEC_DATA}};
        axi4_2x2_fabric_addr_map = address_map::type_id::create("axi4_2x2_fabric_addr_map_addr_map");
        axi4_2x2_fabric_addr_map.addr_mask = 64'hFFF;
        axi4_2x2_fabric_addr_map.set( addr_map_entries );
    end
    
    mgc_axi4_m0_config_policy::configure(mgc_axi4_m0_cfg, axi4_2x2_fabric_addr_map);
    mgc_axi4_m1_config_policy::configure(mgc_axi4_m1_cfg, axi4_2x2_fabric_addr_map);
    mgc_axi4_s0_config_policy::configure(mgc_axi4_s0_cfg, axi4_2x2_fabric_addr_map);
    mgc_axi4_s1_config_policy::configure(mgc_axi4_s1_cfg, axi4_2x2_fabric_addr_map);
    if ( interface_activity.size() > 0 )
    begin
        case ( interface_activity[0] )
            ACTIVE :
                mgc_axi4_m0_cfg.agent_cfg.is_active = 1;
            PASSIVE :
                mgc_axi4_m0_cfg.agent_cfg.is_active = 0;
        endcase
        case ( interface_activity[1] )
            ACTIVE :
                mgc_axi4_m1_cfg.agent_cfg.is_active = 1;
            PASSIVE :
                mgc_axi4_m1_cfg.agent_cfg.is_active = 0;
        endcase
        case ( interface_activity[2] )
            ACTIVE :
                mgc_axi4_s0_cfg.agent_cfg.is_active = 1;
            PASSIVE :
                mgc_axi4_s0_cfg.agent_cfg.is_active = 0;
        endcase
        case ( interface_activity[3] )
            ACTIVE :
                mgc_axi4_s1_cfg.agent_cfg.is_active = 1;
            PASSIVE :
                mgc_axi4_s1_cfg.agent_cfg.is_active = 0;
        endcase
    end
endfunction: initialize

