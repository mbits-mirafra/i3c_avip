//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU Environment 
// Unit            : Environment Sequence Base
// File            : FPU_env_sequence_base.svh
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This file contains environment level sequences that will
//    be reused from block to top level simulations.
//
//----------------------------------------------------------------------
//
class FPU_env_sequence_base extends uvmf_sequence_base #(uvm_sequence_item);

  `uvm_object_utils( FPU_env_sequence_base );

  
  function new(string name = "" );
    super.new(name);
  endfunction

endclass

