//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : daerne
// Creation Date   : 2016 Oct 16
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : axi4_2x2_fabric Environment 
// Unit            : Environment Sequence Base
// File            : axi4_2x2_fabric_env_sequence_base.svh
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This file contains environment level sequences that will
//    be reused from block to top level simulations.
//
//----------------------------------------------------------------------
//
class axi4_2x2_fabric_env_sequence_base extends uvmf_sequence_base #(uvm_sequence_item);

  `uvm_object_utils( axi4_2x2_fabric_env_sequence_base );

  function new(string name = "" );
    super.new(name);
  endfunction

endclass

