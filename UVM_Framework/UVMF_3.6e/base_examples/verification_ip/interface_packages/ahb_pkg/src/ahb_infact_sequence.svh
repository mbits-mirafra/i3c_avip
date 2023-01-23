//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 15
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb interface agent
// Unit            : Interface infact sequence
// File            : ahb_infact_sequence.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This sequences is a place holder for the infact sequence which will 
// reach full coverage for the ahb transaction without redundancy.
//
// ****************************************************************************
// 
class ahb_infact_sequence extends ahb_sequence_base;

  // declaration macros
  `uvm_object_utils(ahb_infact_sequence)

//*****************************************************************
  function new(string name = "");
    super.new(name);
  endfunction: new

endclass: ahb_infact_sequence
//----------------------------------------------------------------------
//
