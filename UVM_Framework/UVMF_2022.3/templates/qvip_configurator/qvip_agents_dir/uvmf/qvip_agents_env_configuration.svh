//
// File: qvip_agents_env_configuration.svh
//
// Generated from Mentor VIP Configurator (20200402)
// Generated using Mentor VIP Library ( 2020.2 : 04/19/2020:18:58 )
//
class qvip_agents_env_configuration extends uvmf_environment_configuration_base;
    `uvm_object_utils(qvip_agents_env_configuration)
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
        string name = "qvip_agents_env_configuration"
    );
        super.new(name);
        pcie_ep_cfg = pcie_ep_cfg_t::type_id::create("pcie_ep_cfg");
        axi4_master_0_cfg = axi4_master_0_cfg_t::type_id::create("axi4_master_0_cfg");
        axi4_master_1_cfg = axi4_master_1_cfg_t::type_id::create("axi4_master_1_cfg");
        axi4_slave_cfg = axi4_slave_cfg_t::type_id::create("axi4_slave_cfg");
        apb3_config_master_cfg = apb3_config_master_cfg_t::type_id::create("apb3_config_master_cfg");
    endfunction
    
    virtual function string convert2string;
        return {"qvip_agents_env_configuration:",pcie_ep_cfg.convert2string(),axi4_master_0_cfg.convert2string(),axi4_master_1_cfg.convert2string(),axi4_slave_cfg.convert2string(),apb3_config_master_cfg.convert2string()};
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
    
    if ( !uvm_config_db #(pcie_ep_bfm_t)::get( null, "UVMF_VIRTUAL_INTERFACES", interface_names[0], pcie_ep_cfg.m_bfm ) )
    begin
        `uvm_fatal("Config Error", $sformatf("uvm_config_db #(pcie_ep_bfm_t)::get() cannot find bfm vif handle for agent with interface_name '%s'", interface_names[0]))
    end
    
    if ( !uvm_config_db #(axi4_master_0_bfm_t)::get( null, "UVMF_VIRTUAL_INTERFACES", interface_names[1], axi4_master_0_cfg.m_bfm ) )
    begin
        `uvm_fatal("Config Error", $sformatf("uvm_config_db #(axi4_master_0_bfm_t)::get() cannot find bfm vif handle for agent with interface_name '%s'", interface_names[1]))
    end
    
    if ( !uvm_config_db #(axi4_master_1_bfm_t)::get( null, "UVMF_VIRTUAL_INTERFACES", interface_names[2], axi4_master_1_cfg.m_bfm ) )
    begin
        `uvm_fatal("Config Error", $sformatf("uvm_config_db #(axi4_master_1_bfm_t)::get() cannot find bfm vif handle for agent with interface_name '%s'", interface_names[2]))
    end
    
    if ( !uvm_config_db #(axi4_slave_bfm_t)::get( null, "UVMF_VIRTUAL_INTERFACES", interface_names[3], axi4_slave_cfg.m_bfm ) )
    begin
        `uvm_fatal("Config Error", $sformatf("uvm_config_db #(axi4_slave_bfm_t)::get() cannot find bfm vif handle for agent with interface_name '%s'", interface_names[3]))
    end
    
    if ( !uvm_config_db #(apb3_config_master_bfm_t)::get( null, "UVMF_VIRTUAL_INTERFACES", interface_names[4], apb3_config_master_cfg.m_bfm ) )
    begin
        `uvm_fatal("Config Error", $sformatf("uvm_config_db #(apb3_config_master_bfm_t)::get() cannot find bfm vif handle for agent with interface_name '%s'", interface_names[4]))
    end
    
    begin
        addr_map_entry_s addr_map_entries[] = new [1];
        addr_map_entries = '{1{'{MAP_NORMAL,"AXI4_SLAVE",0,MAP_NS,4'h0,64'h0,64'h100000000,MEM_NORMAL,MAP_NORM_SEC_DATA}}};
        block_c_addr_map = address_map::type_id::create("block_c_addr_map_addr_map");
        block_c_addr_map.addr_mask = 64'hFFF;
        block_c_addr_map.set( addr_map_entries );
    end
    
    pcie_ep_config_policy::configure(pcie_ep_cfg);
    axi4_master_0_config_policy::configure(axi4_master_0_cfg, block_c_addr_map);
    axi4_master_1_config_policy::configure(axi4_master_1_cfg, block_c_addr_map);
    axi4_slave_config_policy::configure(axi4_slave_cfg, block_c_addr_map);
    apb3_config_master_config_policy::configure(apb3_config_master_cfg, block_c_addr_map);
    if ( interface_activity.size() > 0 )
    begin
        case ( interface_activity[1] )
            ACTIVE :
                axi4_master_0_cfg.agent_cfg.is_active = 1;
            PASSIVE :
                axi4_master_0_cfg.agent_cfg.is_active = 0;
        endcase
        case ( interface_activity[2] )
            ACTIVE :
                axi4_master_1_cfg.agent_cfg.is_active = 1;
            PASSIVE :
                axi4_master_1_cfg.agent_cfg.is_active = 0;
        endcase
        case ( interface_activity[3] )
            ACTIVE :
                axi4_slave_cfg.agent_cfg.is_active = 1;
            PASSIVE :
                axi4_slave_cfg.agent_cfg.is_active = 0;
        endcase
        case ( interface_activity[4] )
            ACTIVE :
                apb3_config_master_cfg.agent_cfg.is_active = 1;
            PASSIVE :
                apb3_config_master_cfg.agent_cfg.is_active = 0;
        endcase
    end
endfunction: initialize

