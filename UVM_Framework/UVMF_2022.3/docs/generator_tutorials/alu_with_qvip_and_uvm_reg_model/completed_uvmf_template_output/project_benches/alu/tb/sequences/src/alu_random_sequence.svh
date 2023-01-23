//----------------------------------------------------------------------
// Created with uvmf_gen version 2020.1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
// Description: This file contains the top level and utility sequences
//     used by test_top. It can be extended to create derivative top
//     level sequences.
//
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
//

class alu_random_sequence extends alu_bench_sequence_base;

  `uvm_object_utils( alu_random_sequence )

  // Instantiate sequences here
  typedef alu_in_reset_sequence #(
        .ALU_IN_OP_WIDTH(TEST_ALU_IN_OP_WIDTH)
        ) alu_in_agent_reset_seq_t;
  alu_in_agent_reset_seq_t alu_in_agent_reset_seq;

  typedef apb3_random_sequence #(.SLAVE_COUNT    (1),
                                 .ADDRESS_WIDTH  (TEST_APB_ADDR_WIDTH),
                                 .WDATA_WIDTH    (TEST_APB_WDATA_WIDTH),
                                 .RDATA_WIDTH    (TEST_APB_RDATA_WIDTH) ) apb3_random_seq_t;
  apb3_random_seq_t apb3_random_seq;

  typedef apb3_alu_random_sequence #(.SLAVE_COUNT    (1),
                                     .ADDRESS_WIDTH  (TEST_APB_ADDR_WIDTH),
                                     .WDATA_WIDTH    (TEST_APB_WDATA_WIDTH),
                                     .RDATA_WIDTH    (TEST_APB_RDATA_WIDTH) ) apb3_alu_random_seq_t;
  apb3_alu_random_seq_t apb3_alu_random_seq;

  // ****************************************************************************
  function new( string name = "" );
    super.new( name );
  endfunction

  // ****************************************************************************
  virtual task body();

    // Construct sequences here
    alu_in_agent_random_seq = alu_in_agent_random_seq_t::type_id::create("alu_in_agent_random_seq");
    alu_in_agent_reset_seq  = alu_in_agent_reset_seq_t::type_id::create("alu_in_agent_reset_seq");
    apb3_random_seq         = apb3_random_seq_t::type_id::create("apb3_random_seq");
    apb3_alu_random_seq     = apb3_alu_random_seq_t::type_id::create("apb3_alu_random_seq");



    // Delay start of sequence until reset has ended and then wait a few clocks after that
    alu_in_agent_config.wait_for_reset();
    alu_in_agent_config.wait_for_num_clocks(10);

    repeat (10) alu_in_agent_random_seq.start(alu_in_agent_sequencer);
    alu_in_agent_reset_seq.start(alu_in_agent_sequencer);
    repeat (5) alu_in_agent_random_seq.start(alu_in_agent_sequencer);
   
    // Test the ALU memory 
    repeat (5) apb3_random_seq.start(uvm_test_top_environment_qvip_agents_env_apb_master_0_sqr);

    // Test the ALU APB operand and operation interface 
    repeat (5) apb3_alu_random_seq.start(uvm_test_top_environment_qvip_agents_env_apb_master_0_sqr);

    // UVMF_CHANGE_ME : Extend the simulation XXX number of clocks after 
    // the last sequence to allow for the last sequence item to flow 
    // through the design.
    alu_in_agent_config.wait_for_num_clocks(50);

  endtask

endclass

