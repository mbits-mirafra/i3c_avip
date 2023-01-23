//
// File: axi4_2x2_fabric_qvip_test_base.svh
//
// Generated from Mentor VIP Configurator (20191003)
// Generated using Mentor VIP Library ( 2019.4 : 10/16/2019:13:47 )
//
class axi4_2x2_fabric_qvip_test_base extends uvmf_test_base #(.CONFIG_T(axi4_2x2_fabric_qvip_env_configuration),.ENV_T(axi4_2x2_fabric_qvip_environment),.TOP_LEVEL_SEQ_T(axi4_2x2_fabric_qvip_vseq_base));
    `uvm_component_utils(axi4_2x2_fabric_qvip_test_base)
    function new
    (
        string name = "axi4_2x2_fabric_qvip_test_base_test_base",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction
    
    extern function void build_phase
    (
        uvm_phase phase
    );
    
    extern task run_phase
    (
        uvm_phase phase
    );
    
endclass: axi4_2x2_fabric_qvip_test_base

function void axi4_2x2_fabric_qvip_test_base::build_phase
(
    uvm_phase phase
);
    string interface_names[] = { "mgc_axi4_m0", "mgc_axi4_m1", "mgc_axi4_s0", "mgc_axi4_s1" };
    super.build_phase( phase );
    configuration.initialize( BLOCK, "uvm_test_top.axi4_2x2_fabric_qvip", interface_names );
endfunction: build_phase

task axi4_2x2_fabric_qvip_test_base::run_phase
(
    uvm_phase phase
);
    string sequence_name;
    axi4_2x2_fabric_qvip_vseq_base vseq;
    uvm_object obj;
    uvm_cmdline_processor clp;
    clp = uvm_cmdline_processor::get_inst();
    if ( clp.get_arg_value("+SEQ=", sequence_name) == 0 )
    begin
        `uvm_fatal(get_type_name(), "You must specify a virtual sequence to run using the +SEQ plusarg")
    end
    obj = factory.create_object_by_name(sequence_name);
    if ( obj == null )
    begin
        factory.print();
        `uvm_fatal(get_type_name(), {"Virtual sequence '",sequence_name,"' not found in factory"})
    end
    
    if ( !$cast(vseq, obj) )
    begin
        factory.print();
        `uvm_fatal(get_type_name(), {"Virtual sequence '",sequence_name,"' is not derived from axi4_2x2_fabric_qvip_vseq_base"})
    end
    
    //The sequence is OK to run
    `uvm_info(get_type_name(), {"Running virtual sequence '",sequence_name,"'"}, UVM_LOW)
    
    phase.raise_objection(this);
    vseq.start(null);
    phase.drop_objection(this);
endtask: run_phase

