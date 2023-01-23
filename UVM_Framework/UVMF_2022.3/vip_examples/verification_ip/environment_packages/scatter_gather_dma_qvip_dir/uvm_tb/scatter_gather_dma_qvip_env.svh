//
// File: scatter_gather_dma_qvip_env.svh
//
// Generated from Mentor VIP Configurator (20201007)
// Generated using Mentor VIP Library ( 2020.4 : 10/16/2020:13:17 )
//
`include "uvm_macros.svh"
class scatter_gather_dma_qvip_env extends uvm_component;
    `uvm_component_utils(scatter_gather_dma_qvip_env)
    scatter_gather_dma_qvip_env_config cfg;
    // Agent handles
    
    mgc_axi4_m0_agent_t mgc_axi4_m0;
    mgc_axi4_s0_agent_t mgc_axi4_s0;
    function new
    (
        string name = "scatter_gather_dma_qvip_env",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction
    
    extern function void build_phase
    (
        uvm_phase phase
    );
    
endclass: scatter_gather_dma_qvip_env

function void scatter_gather_dma_qvip_env::build_phase
(
    uvm_phase phase
);
    if ( cfg == null )
    begin
        if ( !uvm_config_db #(scatter_gather_dma_qvip_env_config)::get(this, "", "env_config", cfg) )
        begin
            `uvm_error("build_phase", "Unable to find the env config object in the uvm_config_db")
        end
    end
    mgc_axi4_m0 = mgc_axi4_m0_agent_t::type_id::create("mgc_axi4_m0", this );
    mgc_axi4_m0.set_mvc_config(cfg.mgc_axi4_m0_cfg);
    
    mgc_axi4_s0 = mgc_axi4_s0_agent_t::type_id::create("mgc_axi4_s0", this );
    mgc_axi4_s0.set_mvc_config(cfg.mgc_axi4_s0_cfg);
    
endfunction: build_phase

