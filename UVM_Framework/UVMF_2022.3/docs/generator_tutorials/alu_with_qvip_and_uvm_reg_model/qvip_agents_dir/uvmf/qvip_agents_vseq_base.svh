//
// File: qvip_agents_vseq_base.svh
//
// Generated from Mentor VIP Configurator (20200115)
// Generated using Mentor VIP Library ( 2020.1 : 01/23/2020:13:29 )
//
class qvip_agents_vseq_base extends mvc_sequence;
    `uvm_object_utils(qvip_agents_vseq_base)
    // Handles for each of the target (QVIP) sequencers
    
    mvc_sequencer apb_master_0_sqr;
    function new
    (
        string name = "qvip_agents_vseq_base"
    );
        super.new(name);
        if ( !uvm_config_db #(mvc_sequencer)::get(null,UVMF_SEQUENCERS,"apb_master_0", apb_master_0_sqr) )
        begin
            `uvm_error("Config Error" , "uvm_config_db #( mvc_sequencer )::get cannot find resource 'apb_master_0'" )
        end
    endfunction
    
    extern task body;
    
endclass: qvip_agents_vseq_base

task qvip_agents_vseq_base::body;
endtask: body

