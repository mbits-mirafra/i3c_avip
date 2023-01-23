//----------------------------------------------------------------------
// Created with uvmf_gen version 2022.3
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: THis is the configuration for the env environment.
//  it contains configuration classes for each agent.  It also contains
//  environment level configuration variables.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class env_env_configuration 
extends uvmf_environment_configuration_base;

  `uvm_object_utils( env_env_configuration )

  bit has_scoreboard = 1'b1;
  int no_of_masters;
  int no_of_slaves;

//Constraints for the configuration variables:


  covergroup env_configuration_cg;
    // pragma uvmf custom covergroup begin
    option.auto_bin_max=1024;
    coverpoint has_scoreboard;
    coverpoint no_of_masters;
    coverpoint no_of_slaves;
    // pragma uvmf custom covergroup end
  endgroup


    typedef i3c_m_configuration m_agent_config_t;
    rand m_agent_config_t m_agent_config;

    typedef i3c_s_configuration s_agent_config_t;
    rand s_agent_config_t s_agent_config;




  typedef uvmf_virtual_sequencer_base #(.CONFIG_T(env_env_configuration)) env_vsqr_t;
  env_vsqr_t vsqr;

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
// This function constructs the configuration object for each agent in the environment.
//
  function new( string name = "" );
    super.new( name );


    m_agent_config = m_agent_config_t::type_id::create("m_agent_config");
    s_agent_config = s_agent_config_t::type_id::create("s_agent_config");


    env_configuration_cg=new;
    `uvm_warning("COVERAGE_MODEL_REVIEW", "A covergroup has been constructed which may need review because of either generation or re-generation with merging.  Please note that configuration variables added as a result of re-generation and merging are not automatically added to the covergroup.  Remove this warning after the covergroup has been reviewed.")

  // pragma uvmf custom new begin
  // pragma uvmf custom new end
  endfunction

// ****************************************************************************
// FUNCTION : set_vsqr()
// This function is used to assign the vsqr handle.
  virtual function void set_vsqr( env_vsqr_t vsqr);
     this.vsqr = vsqr;
  endfunction : set_vsqr

// ****************************************************************************
// FUNCTION: post_randomize()
// This function is automatically called after the randomize() function 
// is executed.
//
  function void post_randomize();
    super.post_randomize();
    // pragma uvmf custom post_randomize begin
    // pragma uvmf custom post_randomize end
  endfunction
  
// ****************************************************************************
// FUNCTION: convert2string()
// This function converts all variables in this class to a single string for
// logfile reporting. This function concatenates the convert2string result for
// each agent configuration in this configuration class.
//
  virtual function string convert2string();
    // pragma uvmf custom convert2string begin
    return {
     $sformatf("has_scoreboard:0x%x no_of_masters:0x%x no_of_slaves:0x%x ",has_scoreboard,no_of_masters,no_of_slaves),
     "\n", m_agent_config.convert2string,
     "\n", s_agent_config.convert2string


       };
    // pragma uvmf custom convert2string end
  endfunction
// ****************************************************************************
// FUNCTION: initialize();
// This function configures each interface agents configuration class.  The 
// sim level determines the active/passive state of the agent.  The environment_path
// identifies the hierarchy down to and including the instantiation name of the
// environment for this configuration class.  Each instance of the environment 
// has its own configuration class.  The string interface names are used by 
// the agent configurations to identify the virtual interface handle to pull from
// the uvm_config_db.  
//
  function void initialize(uvmf_sim_level_t sim_level, 
                                      string environment_path,
                                      string interface_names[],
                                      uvm_reg_block register_model = null,
                                      uvmf_active_passive_t interface_activity[] = {}
                                     );

    super.initialize(sim_level, environment_path, interface_names, register_model, interface_activity);



  // Interface initialization for local agents
     m_agent_config.initialize( interface_activity[0], {environment_path,".m_agent"}, interface_names[0]);
     m_agent_config.initiator_responder = INITIATOR;
     // m_agent_config.has_coverage = 1;
     s_agent_config.initialize( interface_activity[1], {environment_path,".s_agent"}, interface_names[1]);
     s_agent_config.initiator_responder = INITIATOR;
     // s_agent_config.has_coverage = 1;





  // pragma uvmf custom initialize begin
  // pragma uvmf custom initialize end

  endfunction

endclass

// pragma uvmf custom external begin
// pragma uvmf custom external end

