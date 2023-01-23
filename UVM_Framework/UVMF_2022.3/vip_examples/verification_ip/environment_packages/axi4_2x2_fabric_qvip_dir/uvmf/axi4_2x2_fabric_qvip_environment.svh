//
// File: axi4_2x2_fabric_qvip_environment.svh
//
// Generated from Mentor VIP Configurator (20191003)
// Generated using Mentor VIP Library ( 2019.4 : 10/16/2019:13:47 )
//
`include "uvm_macros.svh"
class axi4_2x2_fabric_qvip_environment
#(
    string UNIQUE_ID = ""
) extends uvmf_environment_base #(.CONFIG_T(axi4_2x2_fabric_qvip_env_configuration));
    `uvm_component_param_utils(axi4_2x2_fabric_qvip_environment #(UNIQUE_ID))
    // Agent handles
    
    mgc_axi4_m0_agent_t mgc_axi4_m0;
    mgc_axi4_m1_agent_t mgc_axi4_m1;
    mgc_axi4_s0_agent_t mgc_axi4_s0;
    mgc_axi4_s1_agent_t mgc_axi4_s1;
    function new
    (
        string name = "axi4_2x2_fabric_qvip_environment",
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
    
endclass: axi4_2x2_fabric_qvip_environment

function void axi4_2x2_fabric_qvip_environment::build_phase
(
    uvm_phase phase
);
    mgc_axi4_m0 = mgc_axi4_m0_agent_t::type_id::create("mgc_axi4_m0", this );
    mgc_axi4_m0.set_mvc_config(configuration.mgc_axi4_m0_cfg);
    
    mgc_axi4_m1 = mgc_axi4_m1_agent_t::type_id::create("mgc_axi4_m1", this );
    mgc_axi4_m1.set_mvc_config(configuration.mgc_axi4_m1_cfg);
    
    mgc_axi4_s0 = mgc_axi4_s0_agent_t::type_id::create("mgc_axi4_s0", this );
    mgc_axi4_s0.set_mvc_config(configuration.mgc_axi4_s0_cfg);
    
    mgc_axi4_s1 = mgc_axi4_s1_agent_t::type_id::create("mgc_axi4_s1", this );
    mgc_axi4_s1.set_mvc_config(configuration.mgc_axi4_s1_cfg);
    
endfunction: build_phase

function void axi4_2x2_fabric_qvip_environment::connect_phase
(
    uvm_phase phase
);
    uvm_config_db #(mvc_sequencer)::set(null,UVMF_SEQUENCERS,{UNIQUE_ID,"mgc_axi4_m0"},mgc_axi4_m0.m_sequencer);
    uvm_config_db #(mvc_sequencer)::set(null,UVMF_SEQUENCERS,{UNIQUE_ID,"mgc_axi4_m1"},mgc_axi4_m1.m_sequencer);
    uvm_config_db #(mvc_sequencer)::set(null,UVMF_SEQUENCERS,{UNIQUE_ID,"mgc_axi4_s0"},mgc_axi4_s0.m_sequencer);
    uvm_config_db #(mvc_sequencer)::set(null,UVMF_SEQUENCERS,{UNIQUE_ID,"mgc_axi4_s1"},mgc_axi4_s1.m_sequencer);
endfunction: connect_phase

