//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 14
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb2spi Environment 
// Unit            : Environment Sequence Base
// File            : ahb2spi_env_sequence_base.svh
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This file contains environment level sequences that will
//    be reused from block to top level simulations.
//
//----------------------------------------------------------------------
//
class ahb2spi_env_sequence_base extends uvmf_sequence_base #(uvm_sequence_item);

  `uvm_object_utils( ahb2spi_env_sequence_base );

  function new(string name = "" );
    super.new(name);
  endfunction

endclass

