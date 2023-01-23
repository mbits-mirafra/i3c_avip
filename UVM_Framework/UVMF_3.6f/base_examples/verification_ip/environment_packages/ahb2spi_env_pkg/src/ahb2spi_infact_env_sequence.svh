//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 14
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb2spi Environment
// Unit            : Environment infact sequence
// File            : ahb2spi_infact_env_sequence.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This sequences is a place holder for the infact sequence at the 
// environment level which will generated desired scenarios without redundancy.
//
// ****************************************************************************
// 
class ahb2spi_infact_env_sequence extends ahb2spi_env_sequence_base;

  // declaration macros
  `uvm_object_utils(ahb2spi_infact_env_sequence)

//*****************************************************************
  function new(string name = "");
    super.new(name);
  endfunction: new

endclass: ahb2spi_infact_env_sequence
//----------------------------------------------------------------------
//
