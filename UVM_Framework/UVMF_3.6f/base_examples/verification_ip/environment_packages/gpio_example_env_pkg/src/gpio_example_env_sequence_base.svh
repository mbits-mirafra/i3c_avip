//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Nov 30
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : gpio_example Environment 
// Unit            : Environment Sequence Base
// File            : gpio_example_env_sequence_base.svh
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This file contains environment level sequences that will
//    be reused from block to top level simulations.
//
//----------------------------------------------------------------------
//
class gpio_example_env_sequence_base extends uvmf_sequence_base #(uvm_sequence_item);

  `uvm_object_utils( gpio_example_env_sequence_base );

  function new(string name = "" );
    super.new(name);
  endfunction

endclass

