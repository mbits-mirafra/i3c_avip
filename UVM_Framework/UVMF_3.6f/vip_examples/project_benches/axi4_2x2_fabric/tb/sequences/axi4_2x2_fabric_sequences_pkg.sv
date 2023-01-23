//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : daerne
// Creation Date   : 2016 Oct 12
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : axi4_2x2_fabric Simulation Bench 
// Unit            : Sequences Package
// File            : axi4_2x2_fabric_sequences_pkg.sv
//----------------------------------------------------------------------
//
// DESCRIPTION: This package includes all high level sequence classes used 
//     in the environment.  These include utility sequences and top
//     level sequences.
//
// CONTAINS:
//     -<axi4_2x2_fabric_sequence_base>
//     -<example_derived_test_sequence>
//
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
//

package axi4_2x2_fabric_sequences_pkg;

   import uvm_pkg::*;
   import questa_uvm_pkg::*;
   import uvmf_base_pkg::*;
   import axi4_2x2_fabric_parameters_pkg::*;
   import axi4_2x2_fabric_qvip_params_pkg::*;
   import mvc_pkg::*;
   import mgc_axi4_v1_0_pkg::*;

  
   `include "uvm_macros.svh"

   `include "src/ex1_simple_rd_wr.svh"
   `include "src/axi4_2x2_fabric_bench_sequence_base.svh"
   `include "src/infact_bench_sequence.svh"
   `include "src/example_derived_test_sequence.svh"

endpackage

