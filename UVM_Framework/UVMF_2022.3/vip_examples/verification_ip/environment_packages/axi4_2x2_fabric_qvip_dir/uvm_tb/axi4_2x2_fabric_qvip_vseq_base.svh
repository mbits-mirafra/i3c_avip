//
// File: axi4_2x2_fabric_qvip_vseq_base.svh
//
// Generated from Mentor VIP Configurator (20191003)
// Generated using Mentor VIP Library ( 2019.4 : 10/16/2019:13:47 )
//
class axi4_2x2_fabric_qvip_vseq_base extends mvc_sequence;
    `uvm_object_utils(axi4_2x2_fabric_qvip_vseq_base)
    // Handles for each of the target (QVIP) sequencers
    
    mvc_sequencer mgc_axi4_m0;
    mvc_sequencer mgc_axi4_m1;
    mvc_sequencer mgc_axi4_s0;
    mvc_sequencer mgc_axi4_s1;
    function new
    (
        string name = "axi4_2x2_fabric_qvip_vseq_base"
    );
        super.new(name);
    endfunction
    
    task body;
    endtask: body
    
endclass: axi4_2x2_fabric_qvip_vseq_base

