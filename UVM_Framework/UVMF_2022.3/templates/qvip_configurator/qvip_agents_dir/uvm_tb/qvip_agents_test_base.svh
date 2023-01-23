//
// File: qvip_agents_test_base.svh
//
// Generated from Mentor VIP Configurator (20200402)
// Generated using Mentor VIP Library ( 2020.2 : 04/19/2020:18:58 )
//
class qvip_agents_test_base extends uvm_test;
    `uvm_component_utils(qvip_agents_test_base)
    // QVIP Configuration objects = As defined in the qvip_agents_params_pkg
    
    pcie_ep_cfg_t pcie_ep_cfg;
    axi4_master_0_cfg_t axi4_master_0_cfg;
    axi4_master_1_cfg_t axi4_master_1_cfg;
    axi4_slave_cfg_t axi4_slave_cfg;
    apb3_config_master_cfg_t apb3_config_master_cfg;
    // Environment configuration object
    qvip_agents_env_config env_cfg;
    
    // Environment component
    qvip_agents_env env;
    function new
    (
        string name = "qvip_agents_test_base_test_base",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction
    
    extern function void init_vseq
    (
        qvip_agents_vseq_base vseq
    );
    
    extern function void build_phase
    (
        uvm_phase phase
    );
    
    extern task run_phase
    (
        uvm_phase phase
    );
    
endclass: qvip_agents_test_base

function void qvip_agents_test_base::init_vseq
(
    qvip_agents_vseq_base vseq
);
    vseq.pcie_ep = env.pcie_ep.m_sequencer;
    vseq.axi4_master_0 = env.axi4_master_0.m_sequencer;
    vseq.axi4_master_1 = env.axi4_master_1.m_sequencer;
    vseq.axi4_slave = env.axi4_slave.m_sequencer;
    vseq.apb3_config_master = env.apb3_config_master.m_sequencer;
endfunction: init_vseq

function void qvip_agents_test_base::build_phase
(
    uvm_phase phase
);
    env_cfg = qvip_agents_env_config::type_id::create("env_cfg");
    env_cfg.initialize();
    
    pcie_ep_cfg = pcie_ep_cfg_t::type_id::create("pcie_ep_cfg" );
    if ( !uvm_config_db #(pcie_ep_bfm_t)::get(this, "", "pcie_ep", pcie_ep_cfg.m_bfm) )
    begin
        `uvm_error("build_phase", "Unable to get virtual interface pcie_ep for pcie_ep_cfg from uvm_config_db")
    end
    pcie_ep_config_policy::configure(pcie_ep_cfg);
    env_cfg.pcie_ep_cfg = pcie_ep_cfg;
    axi4_master_0_cfg = axi4_master_0_cfg_t::type_id::create("axi4_master_0_cfg" );
    if ( !uvm_config_db #(axi4_master_0_bfm_t)::get(this, "", "axi4_master_0", axi4_master_0_cfg.m_bfm) )
    begin
        `uvm_error("build_phase", "Unable to get virtual interface axi4_master_0 for axi4_master_0_cfg from uvm_config_db")
    end
    axi4_master_0_config_policy::configure(axi4_master_0_cfg, env_cfg.block_c_addr_map);
    env_cfg.axi4_master_0_cfg = axi4_master_0_cfg;
    axi4_master_1_cfg = axi4_master_1_cfg_t::type_id::create("axi4_master_1_cfg" );
    if ( !uvm_config_db #(axi4_master_1_bfm_t)::get(this, "", "axi4_master_1", axi4_master_1_cfg.m_bfm) )
    begin
        `uvm_error("build_phase", "Unable to get virtual interface axi4_master_1 for axi4_master_1_cfg from uvm_config_db")
    end
    axi4_master_1_config_policy::configure(axi4_master_1_cfg, env_cfg.block_c_addr_map);
    env_cfg.axi4_master_1_cfg = axi4_master_1_cfg;
    axi4_slave_cfg = axi4_slave_cfg_t::type_id::create("axi4_slave_cfg" );
    if ( !uvm_config_db #(axi4_slave_bfm_t)::get(this, "", "axi4_slave", axi4_slave_cfg.m_bfm) )
    begin
        `uvm_error("build_phase", "Unable to get virtual interface axi4_slave for axi4_slave_cfg from uvm_config_db")
    end
    axi4_slave_config_policy::configure(axi4_slave_cfg, env_cfg.block_c_addr_map);
    env_cfg.axi4_slave_cfg = axi4_slave_cfg;
    apb3_config_master_cfg = apb3_config_master_cfg_t::type_id::create("apb3_config_master_cfg" );
    if ( !uvm_config_db #(apb3_config_master_bfm_t)::get(this, "", "apb3_config_master", apb3_config_master_cfg.m_bfm) )
    begin
        `uvm_error("build_phase", "Unable to get virtual interface apb3_config_master for apb3_config_master_cfg from uvm_config_db")
    end
    apb3_config_master_config_policy::configure(apb3_config_master_cfg, env_cfg.block_c_addr_map);
    env_cfg.apb3_config_master_cfg = apb3_config_master_cfg;
    
    // Once the agent configuration objects are done build the env
    env = qvip_agents_env::type_id::create("env", this);
    env.cfg = env_cfg;
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
        `uvm_fatal(get_type_name(), {"Virtual sequence '",sequence_name,"' is not derived from qvip_agents_vseq_base"})
    end
    
    //The sequence is OK to run
    `uvm_info(get_type_name(), {"Running virtual sequence '",sequence_name,"'"}, UVM_LOW)
    
    phase.raise_objection(this);
    init_vseq(vseq);
    vseq.start(null);
    phase.drop_objection(this);
endtask: run_phase

