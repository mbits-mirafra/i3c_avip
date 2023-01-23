//
// File: qvip_agents_env.svh
//
// Generated from Mentor VIP Configurator (20200115)
// Generated using Mentor VIP Library ( 2020.1 : 01/23/2020:13:29 )
//
`include "uvm_macros.svh"
class qvip_agents_env extends uvm_component;
    `uvm_component_utils(qvip_agents_env)
    qvip_agents_env_config cfg;
    // Agent handles
    
    apb_master_0_agent_t apb_master_0;
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
    apb_master_0 = apb_master_0_agent_t::type_id::create("apb_master_0", this );
    apb_master_0.set_mvc_config(cfg.apb_master_0_cfg);
    
endfunction: build_phase

