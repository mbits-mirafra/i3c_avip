//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU Simulation Bench 
// Unit            : Test package
// File            : FPU_tests_pkg.sv
//----------------------------------------------------------------------
//
// DESCRIPTION: This package contains all tests currently written for
//     the simulation project.  Once compiled, any test can be selected
//     from the vsim command line using +UVM_TESTNAME=yourTestNameHere
//
// CONTAINS:
//     -<test_top>
//     -<example_derived_test>
//
//----------------------------------------------------------------------
//

package FPU_tests_pkg;

   import uvm_pkg::*;
   import questa_uvm_pkg::*;
   import uvmf_base_pkg::*;
   import FPU_parameters_pkg::*;
   import FPU_env_pkg::*;
   import FPU_sequences_pkg::*;


   `include "uvm_macros.svh"

   `include "src/test_top.svh"
   `include "src/example_derived_test.svh"

endpackage

