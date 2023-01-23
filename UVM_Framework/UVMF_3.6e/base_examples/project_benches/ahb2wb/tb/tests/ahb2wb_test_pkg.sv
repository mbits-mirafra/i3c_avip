//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 26
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb2wb Simulation Bench 
// Unit            : Test package
// File            : ahb2wb_test_pkg.sv
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

package ahb2wb_test_pkg;

   import uvm_pkg::*;
   import questa_uvm_pkg::*;
   import uvmf_base_pkg::*;
   import ahb2wb_parameters_pkg::*;
   import ahb2wb_env_pkg::*;
   import ahb2wb_sequences_pkg::*;


   `include "uvm_macros.svh"

   `include "src/test_top.svh"
   `include "src/example_derived_test.svh"

endpackage

