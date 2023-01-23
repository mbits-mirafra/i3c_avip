//
// File: qvip_agents_env.svh
//
// Generated from Mentor VIP Configurator (20200402)
// Generated using Mentor VIP Library ( 2020.2 : 04/19/2020:18:58 )
//
`include "uvm_macros.svh"
class qvip_agents_env extends uvm_component;
    `uvm_component_utils(qvip_agents_env)
    qvip_agents_env_config cfg;
    // Agent handles
    
    pcie_ep_agent_t pcie_ep;
    axi4_master_0_agent_t axi4_master_0;
    axi4_master_1_agent_t axi4_master_1;
    axi4_slave_agent_t axi4_slave;
    apb3_config_master_agent_t apb3_config_master;
    function new
    (
        string name = "qvip_agents_env",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction
    
    extern function void build_phase
    (
        uvm_phase phase
    );
    
endclass: qvip_agents_env

function void qvip_agents_env::build_phase
(
    uvm_phase phase
);
    if ( cfg == null )
    begin
        if ( !uvm_config_db #(qvip_agents_env_config)::get(this, "", "env_config", cfg) )
        begin
            `uvm_error("build_phase", "Unable to find the env config object in the uvm_config_db")
        end
    end
    pcie_ep = pcie_ep_agent_t::type_id::create("pcie_ep", this );
    pcie_ep.set_mvc_config(cfg.pcie_ep_cfg);
    
    axi4_master_0 = axi4_master_0_agent_t::type_id::create("axi4_master_0", this );
    axi4_master_0.set_mvc_config(cfg.axi4_master_0_cfg);
    
    axi4_master_1 = axi4_master_1_agent_t::type_id::create("axi4_master_1", this );
    axi4_master_1.set_mvc_config(cfg.axi4_master_1_cfg);
    
    axi4_slave = axi4_slave_agent_t::type_id::create("axi4_slave", this );
    axi4_slave.set_mvc_config(cfg.axi4_slave_cfg);
    
    apb3_config_master = apb3_config_master_agent_t::type_id::create("apb3_config_master", this );
    apb3_config_master.set_mvc_config(cfg.apb3_config_master_cfg);
    
endfunction: build_phase

