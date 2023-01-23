//
// File: qvip_agents_environment.svh
//
// Generated from Mentor VIP Configurator (20200402)
// Generated using Mentor VIP Library ( 2020.2 : 04/19/2020:18:58 )
//
`include "uvm_macros.svh"
class qvip_agents_environment
#(
    string UNIQUE_ID = ""
) extends uvmf_environment_base #(.CONFIG_T(qvip_agents_env_configuration));
    `uvm_component_param_utils(qvip_agents_environment #(UNIQUE_ID))
    // Agent handles
    
    pcie_ep_agent_t pcie_ep;
    axi4_master_0_agent_t axi4_master_0;
    axi4_master_1_agent_t axi4_master_1;
    axi4_slave_agent_t axi4_slave;
    apb3_config_master_agent_t apb3_config_master;
    function new
    (
        string name = "qvip_agents_environment",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction
    
    extern function void build_phase
    (
        uvm_phase phase
    );
    
    extern function void connect_phase
    (
        uvm_phase phase
    );
    
endclass: qvip_agents_environment

function void qvip_agents_environment::build_phase
(
    uvm_phase phase
);
    pcie_ep = pcie_ep_agent_t::type_id::create("pcie_ep", this );
    pcie_ep.set_mvc_config(configuration.pcie_ep_cfg);
    
    axi4_master_0 = axi4_master_0_agent_t::type_id::create("axi4_master_0", this );
    axi4_master_0.set_mvc_config(configuration.axi4_master_0_cfg);
    
    axi4_master_1 = axi4_master_1_agent_t::type_id::create("axi4_master_1", this );
    axi4_master_1.set_mvc_config(configuration.axi4_master_1_cfg);
    
    axi4_slave = axi4_slave_agent_t::type_id::create("axi4_slave", this );
    axi4_slave.set_mvc_config(configuration.axi4_slave_cfg);
    
    apb3_config_master = apb3_config_master_agent_t::type_id::create("apb3_config_master", this );
    apb3_config_master.set_mvc_config(configuration.apb3_config_master_cfg);
    
endfunction: build_phase

function void qvip_agents_environment::connect_phase
(
    uvm_phase phase
);
    uvm_config_db #(mvc_sequencer)::set(null,UVMF_SEQUENCERS,{UNIQUE_ID,"pcie_ep"},pcie_ep.m_sequencer);
    uvm_config_db #(mvc_sequencer)::set(null,UVMF_SEQUENCERS,{UNIQUE_ID,"axi4_master_0"},axi4_master_0.m_sequencer);
    uvm_config_db #(mvc_sequencer)::set(null,UVMF_SEQUENCERS,{UNIQUE_ID,"axi4_master_1"},axi4_master_1.m_sequencer);
    uvm_config_db #(mvc_sequencer)::set(null,UVMF_SEQUENCERS,{UNIQUE_ID,"axi4_slave"},axi4_slave.m_sequencer);
    uvm_config_db #(mvc_sequencer)::set(null,UVMF_SEQUENCERS,{UNIQUE_ID,"apb3_config_master"},apb3_config_master.m_sequencer);
endfunction: connect_phase

