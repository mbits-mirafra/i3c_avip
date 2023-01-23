//
// File: axi4_2x2_fabric_qvip_test_base.svh
//
// Generated from Mentor VIP Configurator (20191003)
// Generated using Mentor VIP Library ( 2019.4 : 10/16/2019:13:47 )
//
class axi4_2x2_fabric_qvip_test_base extends uvm_test;
    `uvm_component_utils(axi4_2x2_fabric_qvip_test_base)
    // QVIP Configuration objects = As defined in the axi4_2x2_fabric_qvip_params_pkg
    
    mgc_axi4_m0_cfg_t mgc_axi4_m0_cfg;
    mgc_axi4_m1_cfg_t mgc_axi4_m1_cfg;
    mgc_axi4_s0_cfg_t mgc_axi4_s0_cfg;
    mgc_axi4_s1_cfg_t mgc_axi4_s1_cfg;
    // Environment configuration object
    axi4_2x2_fabric_qvip_env_config env_cfg;
    
    // Environment component
    axi4_2x2_fabric_qvip_env env;
    function new
    (
        string name = "axi4_2x2_fabric_qvip_test_base_test_base",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction
    
    extern function void init_vseq
    (
        axi4_2x2_fabric_qvip_vseq_base vseq
    );
    
    extern function void build_phase
    (
        uvm_phase phase
    );
    
    extern task run_phase
    (
        uvm_phase phase
    );
    
endclass: axi4_2x2_fabric_qvip_test_base

function void axi4_2x2_fabric_qvip_test_base::init_vseq
(
    axi4_2x2_fabric_qvip_vseq_base vseq
);
    vseq.mgc_axi4_m0 = env.mgc_axi4_m0.m_sequencer;
    vseq.mgc_axi4_m1 = env.mgc_axi4_m1.m_sequencer;
    vseq.mgc_axi4_s0 = env.mgc_axi4_s0.m_sequencer;
    vseq.mgc_axi4_s1 = env.mgc_axi4_s1.m_sequencer;
endfunction: init_vseq

function void axi4_2x2_fabric_qvip_test_base::build_phase
(
    uvm_phase phase
);
    env_cfg = axi4_2x2_fabric_qvip_env_config::type_id::create("env_cfg");
    env_cfg.initialize();
    
    mgc_axi4_m0_cfg = mgc_axi4_m0_cfg_t::type_id::create("mgc_axi4_m0_cfg" );
    if ( !uvm_config_db #(mgc_axi4_m0_bfm_t)::get(this, "", "mgc_axi4_m0", mgc_axi4_m0_cfg.m_bfm) )
    begin
        `uvm_error("build_phase", "Unable to get virtual interface mgc_axi4_m0 for mgc_axi4_m0_cfg from uvm_config_db")
    end
    mgc_axi4_m0_config_policy::configure(mgc_axi4_m0_cfg, env_cfg.axi4_2x2_fabric_addr_map);
    env_cfg.mgc_axi4_m0_cfg = mgc_axi4_m0_cfg;
    mgc_axi4_m1_cfg = mgc_axi4_m1_cfg_t::type_id::create("mgc_axi4_m1_cfg" );
    if ( !uvm_config_db #(mgc_axi4_m1_bfm_t)::get(this, "", "mgc_axi4_m1", mgc_axi4_m1_cfg.m_bfm) )
    begin
        `uvm_error("build_phase", "Unable to get virtual interface mgc_axi4_m1 for mgc_axi4_m1_cfg from uvm_config_db")
    end
    mgc_axi4_m1_config_policy::configure(mgc_axi4_m1_cfg, env_cfg.axi4_2x2_fabric_addr_map);
    env_cfg.mgc_axi4_m1_cfg = mgc_axi4_m1_cfg;
    mgc_axi4_s0_cfg = mgc_axi4_s0_cfg_t::type_id::create("mgc_axi4_s0_cfg" );
    if ( !uvm_config_db #(mgc_axi4_s0_bfm_t)::get(this, "", "mgc_axi4_s0", mgc_axi4_s0_cfg.m_bfm) )
    begin
        `uvm_error("build_phase", "Unable to get virtual interface mgc_axi4_s0 for mgc_axi4_s0_cfg from uvm_config_db")
    end
    mgc_axi4_s0_config_policy::configure(mgc_axi4_s0_cfg, env_cfg.axi4_2x2_fabric_addr_map);
    env_cfg.mgc_axi4_s0_cfg = mgc_axi4_s0_cfg;
    mgc_axi4_s1_cfg = mgc_axi4_s1_cfg_t::type_id::create("mgc_axi4_s1_cfg" );
    if ( !uvm_config_db #(mgc_axi4_s1_bfm_t)::get(this, "", "mgc_axi4_s1", mgc_axi4_s1_cfg.m_bfm) )
    begin
        `uvm_error("build_phase", "Unable to get virtual interface mgc_axi4_s1 for mgc_axi4_s1_cfg from uvm_config_db")
    end
    mgc_axi4_s1_config_policy::configure(mgc_axi4_s1_cfg, env_cfg.axi4_2x2_fabric_addr_map);
    env_cfg.mgc_axi4_s1_cfg = mgc_axi4_s1_cfg;
    
    // Once the agent configuration objects are done build the env
    env = axi4_2x2_fabric_qvip_env::type_id::create("env", this);
    env.cfg = env_cfg;
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
        `uvm_fatal(get_type_name(), {"Virtual sequence '",sequence_name,"' is not derived from axi4_2x2_fabric_qvip_vseq_base"})
    end
    
    //The sequence is OK to run
    `uvm_info(get_type_name(), {"Running virtual sequence '",sequence_name,"'"}, UVM_LOW)
    
    phase.raise_objection(this);
    init_vseq(vseq);
    vseq.start(null);
    phase.drop_objection(this);
endtask: run_phase

