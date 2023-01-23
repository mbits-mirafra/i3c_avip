//
// File: axi4_2x2_fabric_qvip_env.svh
//
// Generated from Mentor VIP Configurator (20191003)
// Generated using Mentor VIP Library ( 2019.4 : 10/16/2019:13:47 )
//
`include "uvm_macros.svh"
class axi4_2x2_fabric_qvip_env extends uvm_component;
    `uvm_component_utils(axi4_2x2_fabric_qvip_env)
    axi4_2x2_fabric_qvip_env_config cfg;
    // Agent handles
    
    mgc_axi4_m0_agent_t mgc_axi4_m0;
    mgc_axi4_m1_agent_t mgc_axi4_m1;
    mgc_axi4_s0_agent_t mgc_axi4_s0;
    mgc_axi4_s1_agent_t mgc_axi4_s1;
    function new
    (
        string name = "axi4_2x2_fabric_qvip_env",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction
    
    extern function void build_phase
    (
        uvm_phase phase
    );
    
endclass: axi4_2x2_fabric_qvip_env

function void axi4_2x2_fabric_qvip_env::build_phase
(
    uvm_phase phase
);
    if ( cfg == null )
    begin
        if ( !uvm_config_db #(axi4_2x2_fabric_qvip_env_config)::get(this, "", "env_config", cfg) )
        begin
            `uvm_error("build_phase", "Unable to find the env config object in the uvm_config_db")
        end
    end
    mgc_axi4_m0 = mgc_axi4_m0_agent_t::type_id::create("mgc_axi4_m0", this );
    mgc_axi4_m0.set_mvc_config(cfg.mgc_axi4_m0_cfg);
    
    mgc_axi4_m1 = mgc_axi4_m1_agent_t::type_id::create("mgc_axi4_m1", this );
    mgc_axi4_m1.set_mvc_config(cfg.mgc_axi4_m1_cfg);
    
    mgc_axi4_s0 = mgc_axi4_s0_agent_t::type_id::create("mgc_axi4_s0", this );
    mgc_axi4_s0.set_mvc_config(cfg.mgc_axi4_s0_cfg);
    
    mgc_axi4_s1 = mgc_axi4_s1_agent_t::type_id::create("mgc_axi4_s1", this );
    mgc_axi4_s1.set_mvc_config(cfg.mgc_axi4_s1_cfg);
    
endfunction: build_phase

