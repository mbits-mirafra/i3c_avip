//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : daerne
// Creation Date   : 2016 Oct 16
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : axi4_2x2_fabric Simulation Bench 
// Unit            : Test package
// File            : axi4_2x2_fabric_test_pkg.sv
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

package axi4_2x2_fabric_test_pkg;

   import uvm_pkg::*;
   import questa_uvm_pkg::*;
   import uvmf_base_pkg::*;
   import axi4_2x2_fabric_parameters_pkg::*;
   import axi4_2x2_fabric_env_pkg::*;
   import axi4_2x2_fabric_sequences_pkg::*;
   import axi4_2x2_fabric_qvip_pkg::*;


   `include "uvm_macros.svh"

   `include "src/test_top.svh"
   `include "src/example_derived_test.svh"

endpackage

