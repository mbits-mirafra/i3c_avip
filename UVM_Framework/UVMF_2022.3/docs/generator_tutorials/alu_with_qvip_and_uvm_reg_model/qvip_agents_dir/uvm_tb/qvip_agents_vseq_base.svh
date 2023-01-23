//
// File: qvip_agents_vseq_base.svh
//
// Generated from Mentor VIP Configurator (20200115)
// Generated using Mentor VIP Library ( 2020.1 : 01/23/2020:13:29 )
//
class qvip_agents_vseq_base extends mvc_sequence;
    `uvm_object_utils(qvip_agents_vseq_base)
    // Handles for each of the target (QVIP) sequencers
    
    mvc_sequencer apb_master_0;
    function new
    (
        string name = "qvip_agents_vseq_base"
    );
        super.new(name);
    endfunction
    
    task body;
    endtask: body
    
endclass: qvip_agents_vseq_base

