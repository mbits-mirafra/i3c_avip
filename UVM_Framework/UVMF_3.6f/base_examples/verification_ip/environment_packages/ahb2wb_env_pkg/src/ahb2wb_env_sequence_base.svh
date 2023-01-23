//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 06
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb2wb Environment 
// Unit            : Environment Sequence Base
// File            : ahb2wb_env_sequence_base.svh
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This file contains environment level sequences that will
//    be reused from block to top level simulations.
//
//----------------------------------------------------------------------
//
class ahb2wb_env_sequence_base extends uvmf_sequence_base #(uvm_sequence_item);

  `uvm_object_utils( ahb2wb_env_sequence_base );

  function new(string name = "" );
    super.new(name);
  endfunction

endclass

