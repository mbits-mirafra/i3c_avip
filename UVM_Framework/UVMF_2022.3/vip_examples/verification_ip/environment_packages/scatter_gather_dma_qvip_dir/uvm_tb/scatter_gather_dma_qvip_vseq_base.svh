//
// File: scatter_gather_dma_qvip_vseq_base.svh
//
// Generated from Mentor VIP Configurator (20201007)
// Generated using Mentor VIP Library ( 2020.4 : 10/16/2020:13:17 )
//
class scatter_gather_dma_qvip_vseq_base extends mvc_sequence;
    `uvm_object_utils(scatter_gather_dma_qvip_vseq_base)
    // Handles for each of the target (QVIP) sequencers
    
    mvc_sequencer mgc_axi4_m0;
    mvc_sequencer mgc_axi4_s0;
    function new
    (
        string name = "scatter_gather_dma_qvip_vseq_base"
    );
        super.new(name);
    endfunction
    
    task body;
    endtask: body
    
endclass: scatter_gather_dma_qvip_vseq_base

