//
// File: qvip_agents_vseq_base.svh
//
// Generated from Mentor VIP Configurator (20200402)
// Generated using Mentor VIP Library ( 2020.2 : 04/19/2020:18:58 )
//
class qvip_agents_vseq_base extends mvc_sequence;
    `uvm_object_utils(qvip_agents_vseq_base)
    // Handles for each of the target (QVIP) sequencers
    
    mvc_sequencer pcie_ep;
    mvc_sequencer axi4_master_0;
    mvc_sequencer axi4_master_1;
    mvc_sequencer axi4_slave;
    mvc_sequencer apb3_config_master;
    function new
    (
        string name = "qvip_agents_vseq_base"
    );
        super.new(name);
    endfunction
    
    task body;
    endtask: body
    
endclass: qvip_agents_vseq_base

