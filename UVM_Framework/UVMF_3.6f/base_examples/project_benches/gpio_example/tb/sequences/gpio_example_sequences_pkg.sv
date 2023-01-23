//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Nov 30
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : gpio_example Simulation Bench 
// Unit            : Sequences Package
// File            : gpio_example_sequences_pkg.sv
//----------------------------------------------------------------------
//
// DESCRIPTION: This package includes all high level sequence classes used 
//     in the environment.  These include utility sequences and top
//     level sequences.
//
// CONTAINS:
//     -<gpio_example_sequence_base>
//     -<example_derived_test_sequence>
//
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
//

package gpio_example_sequences_pkg;

   import uvm_pkg::*;
   import questa_uvm_pkg::*;
   import uvmf_base_pkg::*;
   import gpio_pkg::*;
   import gpio_example_parameters_pkg::*;

  
   `include "uvm_macros.svh"

   `include "src/gpio_gpio_sequence.svh"
   `include "src/gpio_example_bench_sequence_base.svh"
   `include "src/infact_bench_sequence.svh"
   `include "src/example_derived_test_sequence.svh"

endpackage

