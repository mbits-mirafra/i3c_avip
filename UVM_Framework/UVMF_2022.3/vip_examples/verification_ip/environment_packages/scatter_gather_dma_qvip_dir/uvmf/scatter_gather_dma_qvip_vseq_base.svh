//
// File: scatter_gather_dma_qvip_vseq_base.svh
//
// Generated from Mentor VIP Configurator (20201007)
// Generated using Mentor VIP Library ( 2020.4 : 10/16/2020:13:17 )
//
class scatter_gather_dma_qvip_vseq_base extends mvc_sequence;
    `uvm_object_utils(scatter_gather_dma_qvip_vseq_base)
    // Handles for each of the target (QVIP) sequencers
    
    mvc_sequencer mgc_axi4_m0_sqr;
    mvc_sequencer mgc_axi4_s0_sqr;
    function new
    (
        string name = "scatter_gather_dma_qvip_vseq_base"
    );
        super.new(name);
        if ( !uvm_config_db #(mvc_sequencer)::get(null,UVMF_SEQUENCERS,"mgc_axi4_m0", mgc_axi4_m0_sqr) )
        begin
            `uvm_error("Config Error" , "uvm_config_db #( mvc_sequencer )::get cannot find resource 'mgc_axi4_m0'" )
        end
        if ( !uvm_config_db #(mvc_sequencer)::get(null,UVMF_SEQUENCERS,"mgc_axi4_s0", mgc_axi4_s0_sqr) )
        begin
            `uvm_error("Config Error" , "uvm_config_db #( mvc_sequencer )::get cannot find resource 'mgc_axi4_s0'" )
        end
    endfunction
    
    extern task body;
    
endclass: scatter_gather_dma_qvip_vseq_base

task scatter_gather_dma_qvip_vseq_base::body;
endtask: body

