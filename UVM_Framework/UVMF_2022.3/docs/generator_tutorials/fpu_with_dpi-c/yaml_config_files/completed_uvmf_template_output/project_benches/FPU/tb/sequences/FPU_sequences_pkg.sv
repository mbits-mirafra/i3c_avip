//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU Simulation Bench 
// Unit            : Sequences Package
// File            : FPU_sequences_pkg.sv
//----------------------------------------------------------------------
//
// DESCRIPTION: This package includes all high level sequence classes used 
//     in the environment.  These include utility sequences and top
//     level sequences.
//
// CONTAINS:
//     -<FPU_sequence_base>
//     -<example_derived_test_sequence>
//
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
//

package FPU_sequences_pkg;

   import uvm_pkg::*;
   import questa_uvm_pkg::*;
   import uvmf_base_pkg::*;
   import FPU_in_pkg::*;
   import FPU_out_pkg::*;
   import FPU_parameters_pkg::*;
   import FPU_env_pkg::*;

  
   `include "uvm_macros.svh"

   `include "src/FPU_bench_sequence_base.svh"
   `include "src/example_derived_test_sequence.svh"

endpackage

