//
// File: qvip_agents_test_base.svh
//
// Generated from Mentor VIP Configurator (20200402)
// Generated using Mentor VIP Library ( 2020.2 : 04/19/2020:18:58 )
//
class qvip_agents_test_base extends uvmf_test_base #(.CONFIG_T(qvip_agents_env_configuration),.ENV_T(qvip_agents_environment),.TOP_LEVEL_SEQ_T(qvip_agents_vseq_base));
    `uvm_component_utils(qvip_agents_test_base)
    function new
    (
        string name = "qvip_agents_test_base_test_base",
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
    
endclass: qvip_agents_test_base

function void qvip_agents_test_base::build_phase
(
    uvm_phase phase
);
    string interface_names[] = { "pcie_ep", "axi4_master_0", "axi4_master_1", "axi4_slave", "apb3_config_master" };
    super.build_phase( phase );
    configuration.initialize( BLOCK, "uvm_test_top.qvip_agents", interface_names );
endfunction: build_phase

task qvip_agents_test_base::run_phase
(
    uvm_phase phase
);
    string sequence_name;
    qvip_agents_vseq_base vseq;
    uvm_object obj;
    uvm_cmdline_processor clp;
    uvm_factory factory;
    clp = uvm_cmdline_processor::get_inst();
    factory = uvm_factory::get();
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
        `uvm_fatal(get_type_name(), {"Virtual sequence '",sequence_name,"' is not derived from qvip_agents_vseq_base"})
    end
    
    //The sequence is OK to run
    `uvm_info(get_type_name(), {"Running virtual sequence '",sequence_name,"'"}, UVM_LOW)
    
    phase.raise_objection(this);
    vseq.start(null);
    phase.drop_objection(this);
endtask: run_phase

