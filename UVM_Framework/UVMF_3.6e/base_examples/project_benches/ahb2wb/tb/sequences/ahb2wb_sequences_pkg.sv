//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 26
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb2wb Simulation Bench 
// Unit            : Sequences Package
// File            : ahb2wb_sequences_pkg.sv
//----------------------------------------------------------------------
//
// DESCRIPTION: This package includes all high level sequence classes used 
//     in the environment.  These include utility sequences and top
//     level sequences.
//
// CONTAINS:
//     -<ahb2wb_sequence_base>
//     -<example_derived_test_sequence>
//
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
//

package ahb2wb_sequences_pkg;

   import uvm_pkg::*;
   import questa_uvm_pkg::*;
   import uvmf_base_pkg::*;
   import ahb_pkg::*;
   import wb_pkg::*;
   import ahb2wb_parameters_pkg::*;

  
   `include "uvm_macros.svh"

   `include "src/ahb2wb_bench_sequence_base.svh"
   `include "src/infact_bench_sequence.svh"
   `include "src/example_derived_test_sequence.svh"

endpackage

