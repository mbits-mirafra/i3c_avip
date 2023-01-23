//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 26
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb2spi Simulation Bench 
// Unit            : Sequence for example derived test
// File            : example_derived_test_sequence.svh
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This file contains the top level sequence used in  example_derived_test.
// It is an example of a sequence that is extended from %(benchName)_bench_sequence_base
// and can override %(benchName)_bench_sequence_base.
//
//----------------------------------------------------------------------
//

class example_derived_test_sequence extends ahb2spi_bench_sequence_base;

  `uvm_object_utils( example_derived_test_sequence );

  function new(string name = "" );
    super.new(name);
  endfunction

endclass

