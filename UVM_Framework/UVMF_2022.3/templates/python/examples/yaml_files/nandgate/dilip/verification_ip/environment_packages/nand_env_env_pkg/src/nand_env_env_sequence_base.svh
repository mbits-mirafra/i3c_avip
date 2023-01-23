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
class nand_env_env_sequence_base #( 
      type CONFIG_T
      ) extends uvmf_virtual_sequence_base #(.CONFIG_T(CONFIG_T));


  `uvm_object_param_utils( nand_env_env_sequence_base #(
                           CONFIG_T
                           ));

  
// This nand_env_env_sequence_base contains a handle to a nand_env_env_configuration object 
// named configuration.  This configuration variable contains a handle to each 
// sequencer within each agent within this environment and any sub-environments.
// The configuration object handle is automatically assigned in the pre_body in the
// base class of this sequence.  The configuration handle is retrieved from the
// virtual sequencer that this sequence is started on.
// Available sequencer handles within the environment configuration:

  // Initiator agent sequencers in nand_env_environment:
    // configuration.nand_in_agent_config.sequencer

  // Responder agent sequencers in nand_env_environment:
    // configuration.nand_out_agent_config.sequencer


    typedef nand_in_random_sequence nand_in_agent_random_sequence_t;
    nand_in_agent_random_sequence_t nand_in_agent_rand_seq;





  // pragma uvmf custom class_item_additional begin

  // pragma uvmf custom class_item_additional end
  
  function new(string name = "" );
    super.new(name);
    nand_in_agent_rand_seq = nand_in_agent_random_sequence_t::type_id::create("nand_in_agent_rand_seq");


  endfunction

  virtual task body();

    if ( configuration.nand_in_agent_config.sequencer != null )
       repeat(1) nand_in_agent_rand_seq.start(configuration.nand_in_agent_config.sequencer);


  endtask

endclass

// pragma uvmf custom external begin
// pragma uvmf custom external end

