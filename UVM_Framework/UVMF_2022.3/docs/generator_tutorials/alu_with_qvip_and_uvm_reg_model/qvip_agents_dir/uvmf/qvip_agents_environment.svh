//
// File: qvip_agents_environment.svh
//
// Generated from Mentor VIP Configurator (20200115)
// Generated using Mentor VIP Library ( 2020.1 : 01/23/2020:13:29 )
//
`include "uvm_macros.svh"
class qvip_agents_environment
#(
    string UNIQUE_ID = ""
) extends uvmf_environment_base #(.CONFIG_T(qvip_agents_env_configuration));
    `uvm_component_param_utils(qvip_agents_environment #(UNIQUE_ID))
    // Agent handles
    
    apb_master_0_agent_t apb_master_0;
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
    apb_master_0 = apb_master_0_agent_t::type_id::create("apb_master_0", this );
    apb_master_0.set_mvc_config(configuration.apb_master_0_cfg);
    
endfunction: build_phase

function void qvip_agents_environment::connect_phase
(
    uvm_phase phase
);
    uvm_config_db #(mvc_sequencer)::set(null,UVMF_SEQUENCERS,{UNIQUE_ID,"apb_master_0"},apb_master_0.m_sequencer);
endfunction: connect_phase

