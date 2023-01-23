//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 06
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb2wb Environment
// Unit            : Environment infact sequence
// File            : ahb2wb_infact_env_sequence.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This sequences is a place holder for the infact sequence at the 
// environment level which will generated desired scenarios without redundancy.
//
// ****************************************************************************
// 
class ahb2wb_infact_env_sequence extends ahb2wb_env_sequence_base;

  // declaration macros
  `uvm_object_utils(ahb2wb_infact_env_sequence)

//*****************************************************************
  function new(string name = "");
    super.new(name);
  endfunction: new

endclass: ahb2wb_infact_env_sequence
//----------------------------------------------------------------------
//
