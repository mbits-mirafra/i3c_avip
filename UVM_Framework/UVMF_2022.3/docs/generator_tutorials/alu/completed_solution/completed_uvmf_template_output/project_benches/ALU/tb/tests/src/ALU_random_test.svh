// ==============================================================================
// =====            Mentor Graphics UK Ltd                                  =====
// =====            Rivergate, London Road, Newbury BERKS RG14 2QB          =====
// ==============================================================================
//! @file
//  Project                : alu_2019_4
//  Unit                   : ALU_random_test
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


`ifndef __ALU_RANDOM_TEST
`define __ALU_RANDOM_TEST

`include "uvm_macros.svh"

class ALU_random_test extends test_top;

  `uvm_component_utils(ALU_random_test) 
  
  // constructor
  function new(string name = "", uvm_component parent = null );
    super.new(name, parent);
    // Insert Constructor Code Here
  endfunction : new


  virtual function void build_phase(uvm_phase phase );
    // UVM Factory override. Override ALU_bench_sequence_base with ALU_random_sequence
    ALU_bench_sequence_base::type_id::set_type_override(ALU_random_sequence #(8)::get_type());
    super.build_phase(phase);
  endfunction : build_phase

endclass : ALU_random_test

`endif
