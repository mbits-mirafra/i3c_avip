//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : daerne
// Creation Date   : 2016 Oct 16
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : axi4_2x2_fabric Environment
// Unit            : Environment infact sequence
// File            : axi4_2x2_fabric_infact_env_sequence.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This sequences is a place holder for the infact sequence at the 
// environment level which will generated desired scenarios without redundancy.
//
// ****************************************************************************
// 
class axi4_2x2_fabric_infact_env_sequence extends axi4_2x2_fabric_env_sequence_base;

  // declaration macros
  `uvm_object_utils(axi4_2x2_fabric_infact_env_sequence)

//*****************************************************************
  function new(string name = "");
    super.new(name);
  endfunction: new

endclass: axi4_2x2_fabric_infact_env_sequence
//----------------------------------------------------------------------
//
