//
// File: qvip_agents_vseq_base.svh
//
// Generated from Mentor VIP Configurator (20200402)
// Generated using Mentor VIP Library ( 2020.2 : 04/19/2020:18:58 )
//
class qvip_agents_vseq_base extends mvc_sequence;
    `uvm_object_utils(qvip_agents_vseq_base)
    // Handles for each of the target (QVIP) sequencers
    
    mvc_sequencer pcie_ep_sqr;
    mvc_sequencer axi4_master_0_sqr;
    mvc_sequencer axi4_master_1_sqr;
    mvc_sequencer axi4_slave_sqr;
    mvc_sequencer apb3_config_master_sqr;
    function new
    (
        string name = "qvip_agents_vseq_base"
    );
        super.new(name);
        if ( !uvm_config_db #(mvc_sequencer)::get(null,UVMF_SEQUENCERS,"pcie_ep", pcie_ep_sqr) )
        begin
            `uvm_error("Config Error" , "uvm_config_db #( mvc_sequencer )::get cannot find resource 'pcie_ep'" )
        end
        if ( !uvm_config_db #(mvc_sequencer)::get(null,UVMF_SEQUENCERS,"axi4_master_0", axi4_master_0_sqr) )
        begin
            `uvm_error("Config Error" , "uvm_config_db #( mvc_sequencer )::get cannot find resource 'axi4_master_0'" )
        end
        if ( !uvm_config_db #(mvc_sequencer)::get(null,UVMF_SEQUENCERS,"axi4_master_1", axi4_master_1_sqr) )
        begin
            `uvm_error("Config Error" , "uvm_config_db #( mvc_sequencer )::get cannot find resource 'axi4_master_1'" )
        end
        if ( !uvm_config_db #(mvc_sequencer)::get(null,UVMF_SEQUENCERS,"axi4_slave", axi4_slave_sqr) )
        begin
            `uvm_error("Config Error" , "uvm_config_db #( mvc_sequencer )::get cannot find resource 'axi4_slave'" )
        end
        if ( !uvm_config_db #(mvc_sequencer)::get(null,UVMF_SEQUENCERS,"apb3_config_master", apb3_config_master_sqr) )
        begin
            `uvm_error("Config Error" , "uvm_config_db #( mvc_sequencer )::get cannot find resource 'apb3_config_master'" )
        end
    endfunction
    
    extern task body;
    
endclass: qvip_agents_vseq_base

task qvip_agents_vseq_base::body;
endtask: body

