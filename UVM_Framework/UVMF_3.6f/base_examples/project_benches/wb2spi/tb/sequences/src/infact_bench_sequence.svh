//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 26
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : wb2spi Simulation Bench 
// Unit            : Sequence for infact stimulus at the bench level
// File            : infact_bench_sequence.svh
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This file contains the infact sequence for generating 
//    all specified scenarios without redundancy.
//
//----------------------------------------------------------------------
//

class infact_bench_sequence extends wb2spi_bench_sequence_base;

  `uvm_object_utils( infact_bench_sequence );

  function new(string name = "" );
    super.new(name);
  endfunction

endclass

