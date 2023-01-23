//----------------------------------------------------------------------
// Created with uvmf_gen version 2022.3
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This file contains environment level sequences that will
//    be reused from block to top level simulations.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class env_env_sequence_base #( 
      type CONFIG_T
      ) extends uvmf_virtual_sequence_base #(.CONFIG_T(CONFIG_T));


  `uvm_object_param_utils( env_env_sequence_base #(
                           CONFIG_T
                           ) );

  
// This env_env_sequence_base contains a handle to a env_env_configuration object 
// named configuration.  This configuration variable contains a handle to each 
// sequencer within each agent within this environment and any sub-environments.
// The configuration object handle is automatically assigned in the pre_body in the
// base class of this sequence.  The configuration handle is retrieved from the
// virtual sequencer that this sequence is started on.
// Available sequencer handles within the environment configuration:

  // Initiator agent sequencers in env_environment:
    // configuration.m_agent_config.sequencer
    // configuration.s_agent_config.sequencer

  // Responder agent sequencers in env_environment:


    typedef i3c_m_random_sequence m_agent_random_sequence_t;
    m_agent_random_sequence_t m_agent_rand_seq;

    typedef i3c_s_random_sequence s_agent_random_sequence_t;
    s_agent_random_sequence_t s_agent_rand_seq;




  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end
  
  function new(string name = "" );
    super.new(name);
    m_agent_rand_seq = m_agent_random_sequence_t::type_id::create("m_agent_rand_seq");
    s_agent_rand_seq = s_agent_random_sequence_t::type_id::create("s_agent_rand_seq");


  endfunction

  virtual task body();

    if ( configuration.m_agent_config.sequencer != null )
       repeat (25) m_agent_rand_seq.start(configuration.m_agent_config.sequencer);
    if ( configuration.s_agent_config.sequencer != null )
       repeat (25) s_agent_rand_seq.start(configuration.s_agent_config.sequencer);


  endtask

endclass

// pragma uvmf custom external begin
// pragma uvmf custom external end

