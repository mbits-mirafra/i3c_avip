// ==============================================================================
// =====            Mentor Graphics UK Ltd                                  =====
// =====            Rivergate, London Road, Newbury BERKS RG14 2QB          =====
// ==============================================================================
//! @file
//  Project                : alu_2019_4
//  Unit                   : ALU_random_sequence
//! @brief  Add Class Description Here... 
//-------------------------------------------------------------------------------
//  Created by             : graemej
//  Creation Date          : 2019/09/10
//-------------------------------------------------------------------------------
// Revision History:
//  URL of HEAD            : $HeadURL$
//  Revision of last commit: $Rev$  
//  Author of last commit  : $Author$
//  Date of last commit    : $Date$  
//
// ==============================================================================
// This unpublished work contains proprietary information.
// All right reserved. Supplied in confidence and must not be copied, used or disclosed 
// for any purpose without express written permission.
// 2019 @ Copyright Mentor Graphics UK Ltd
// ==============================================================================


`ifndef __ALU_RANDOM_SEQUENCE
`define __ALU_RANDOM_SEQUENCE

`include "uvm_macros.svh"

class ALU_random_sequence #(int ALU_IN_OP_WIDTH = 8) extends ALU_bench_sequence_base;

  `uvm_object_utils(ALU_random_sequence) 

  // Define type and handle for reset sequence
  typedef ALU_in_reset_sequence #(ALU_IN_OP_WIDTH) ALU_in_reset_sequence_t;
  ALU_in_reset_sequence_t ALU_in_reset_s;
  
  // constructor
  function new(string name = "");
    super.new(name);
  endfunction : new

  virtual task body();
    ALU_in_agent_random_seq = ALU_in_random_sequence#()::type_id::create("ALU_in_agent_random_seq");
    ALU_in_reset_s = ALU_in_reset_sequence#()::type_id::create("ALU_in_reset_seq");
    
    ALU_in_agent_config.wait_for_reset();
    ALU_in_agent_config.wait_for_num_clocks(10);

    repeat (10) ALU_in_agent_random_seq.start(ALU_in_agent_sequencer);
    ALU_in_reset_s.start(ALU_in_agent_sequencer);
    repeat (5) ALU_in_agent_random_seq.start(ALU_in_agent_sequencer);

    ALU_in_agent_config.wait_for_num_clocks(50);    
    
  endtask


endclass : ALU_random_sequence

`endif
