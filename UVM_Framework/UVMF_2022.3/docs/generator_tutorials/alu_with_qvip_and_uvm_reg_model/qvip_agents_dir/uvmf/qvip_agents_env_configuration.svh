//
// File: qvip_agents_env_configuration.svh
//
// Generated from Mentor VIP Configurator (20200115)
// Generated using Mentor VIP Library ( 2020.1 : 01/23/2020:13:29 )
//
class qvip_agents_env_configuration extends uvmf_environment_configuration_base;
    `uvm_object_utils(qvip_agents_env_configuration)
    // Handles for vip config for each of the QVIP instances
    
    apb_master_0_cfg_t apb_master_0_cfg;
    // Handles for address maps
    
    address_map mem_map;
    
    function new
    (
        string name = "qvip_agents_env_configuration"
    );
        super.new(name);
        apb_master_0_cfg = apb_master_0_cfg_t::type_id::create("apb_master_0_cfg");
    endfunction
    
    virtual function string convert2string;
        return {"qvip_agents_env_configuration:",apb_master_0_cfg.convert2string()};
    endfunction: convert2string
    
    extern function void initialize
    (
        uvmf_sim_level_t sim_level,
        string environment_path,
        string interface_names[],
        uvm_reg_block register_model = null,
        uvmf_active_passive_t interface_activity[] = null
    );
    
endclass: qvip_agents_env_configuration

function void qvip_agents_env_configuration::initialize
(
    uvmf_sim_level_t sim_level,
    string environment_path,
    string interface_names[],
    uvm_reg_block register_model = null,
    uvmf_active_passive_t interface_activity[] = null
);
    super.initialize(sim_level, environment_path, interface_names, register_model, interface_activity);
    
    if ( !uvm_config_db #(apb_master_0_bfm_t)::get( null, "UVMF_VIRTUAL_INTERFACES", interface_names[0], apb_master_0_cfg.m_bfm ) )
    begin
        `uvm_fatal("Config Error", $sformatf("uvm_config_db #(apb_master_0_bfm_t)::get() cannot find bfm vif handle for agent with interface_name '%s'", interface_names[0]))
    end
    
    begin
        addr_map_entry_s addr_map_entries[] = new [1];
        addr_map_entries = '{1{'{MAP_NORMAL,"RANGE_1",0,MAP_NS,4'h0,64'h0,64'h1000,MEM_NORMAL,MAP_NORM_SEC_DATA}}};
        mem_map = address_map::type_id::create("mem_map_addr_map");
        mem_map.addr_mask = 64'hFFF;
        mem_map.set( addr_map_entries );
    end
    
    apb_master_0_config_policy::configure(apb_master_0_cfg, mem_map);
    if ( interface_activity.size() > 0 )
    begin
        case ( interface_activity[0] )
            ACTIVE :
                apb_master_0_cfg.agent_cfg.is_active = 1;
            PASSIVE :
                apb_master_0_cfg.agent_cfg.is_active = 0;
        endcase
    end
endfunction: initialize

