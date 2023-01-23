//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Nov 30
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : gpio_example Environment
// Unit            : Environment infact sequence
// File            : gpio_example_infact_env_sequence.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This sequences is a place holder for the infact sequence at the 
// environment level which will generated desired scenarios without redundancy.
//
// ****************************************************************************
// 
class gpio_example_infact_env_sequence extends gpio_example_env_sequence_base;

  // declaration macros
  `uvm_object_utils(gpio_example_infact_env_sequence)

//*****************************************************************
  function new(string name = "");
    super.new(name);
  endfunction: new

endclass: gpio_example_infact_env_sequence
//----------------------------------------------------------------------
//
