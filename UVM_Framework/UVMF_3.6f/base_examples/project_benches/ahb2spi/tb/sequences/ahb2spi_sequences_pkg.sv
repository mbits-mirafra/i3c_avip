//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 26
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb2spi Simulation Bench 
// Unit            : Sequences Package
// File            : ahb2spi_sequences_pkg.sv
//----------------------------------------------------------------------
//
// DESCRIPTION: This package includes all high level sequence classes used 
//     in the environment.  These include utility sequences and top
//     level sequences.
//
// CONTAINS:
//     -<ahb2spi_sequence_base>
//     -<example_derived_test_sequence>
//
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
//

package ahb2spi_sequences_pkg;

   import uvm_pkg::*;
   import questa_uvm_pkg::*;
   import uvmf_base_pkg::*;
   import ahb_pkg::*;
   import wb_pkg::*;
   import spi_pkg::*;
   import ahb2spi_parameters_pkg::*;
   import ahb2spi_reg_pkg::*;

  
   `include "uvm_macros.svh"

   `include "src/ahb2spi_bench_sequence_base.svh"
   `include "src/ahb2spi_regmodel_sequence.svh"
   `include "src/infact_bench_sequence.svh"
   `include "src/example_derived_test_sequence.svh"

endpackage

