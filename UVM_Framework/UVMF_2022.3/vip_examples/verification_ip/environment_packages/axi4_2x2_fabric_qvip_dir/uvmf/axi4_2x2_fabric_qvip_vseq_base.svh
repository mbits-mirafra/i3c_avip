//
// File: axi4_2x2_fabric_qvip_vseq_base.svh
//
// Generated from Mentor VIP Configurator (20191003)
// Generated using Mentor VIP Library ( 2019.4 : 10/16/2019:13:47 )
//
class axi4_2x2_fabric_qvip_vseq_base extends mvc_sequence;
    `uvm_object_utils(axi4_2x2_fabric_qvip_vseq_base)
    // Handles for each of the target (QVIP) sequencers
    
    mvc_sequencer mgc_axi4_m0_sqr;
    mvc_sequencer mgc_axi4_m1_sqr;
    mvc_sequencer mgc_axi4_s0_sqr;
    mvc_sequencer mgc_axi4_s1_sqr;
    function new
    (
        string name = "axi4_2x2_fabric_qvip_vseq_base"
    );
        super.new(name);
        if ( !uvm_config_db #(mvc_sequencer)::get(null,UVMF_SEQUENCERS,"mgc_axi4_m0", mgc_axi4_m0_sqr) )
        begin
            `uvm_error("Config Error" , "uvm_config_db #( mvc_sequencer )::get cannot find resource 'mgc_axi4_m0'" )
        end
        if ( !uvm_config_db #(mvc_sequencer)::get(null,UVMF_SEQUENCERS,"mgc_axi4_m1", mgc_axi4_m1_sqr) )
        begin
            `uvm_error("Config Error" , "uvm_config_db #( mvc_sequencer )::get cannot find resource 'mgc_axi4_m1'" )
        end
        if ( !uvm_config_db #(mvc_sequencer)::get(null,UVMF_SEQUENCERS,"mgc_axi4_s0", mgc_axi4_s0_sqr) )
        begin
            `uvm_error("Config Error" , "uvm_config_db #( mvc_sequencer )::get cannot find resource 'mgc_axi4_s0'" )
        end
        if ( !uvm_config_db #(mvc_sequencer)::get(null,UVMF_SEQUENCERS,"mgc_axi4_s1", mgc_axi4_s1_sqr) )
        begin
            `uvm_error("Config Error" , "uvm_config_db #( mvc_sequencer )::get cannot find resource 'mgc_axi4_s1'" )
        end
    endfunction
    
    extern task body;
    
endclass: axi4_2x2_fabric_qvip_vseq_base

task axi4_2x2_fabric_qvip_vseq_base::body;
endtask: body

