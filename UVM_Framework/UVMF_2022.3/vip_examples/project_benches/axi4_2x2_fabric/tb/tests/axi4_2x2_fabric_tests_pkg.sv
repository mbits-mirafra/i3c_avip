//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_5
//----------------------------------------------------------------------
// Created by: Vijay Gill
// E-mail:     vijay_gill@mentor.com
// Date:       2019/11/05
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
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
//----------------------------------------------------------------------
//

package axi4_2x2_fabric_tests_pkg;

   import uvm_pkg::*;
   import uvmf_base_pkg::*;
   import axi4_2x2_fabric_parameters_pkg::*;
   import axi4_2x2_fabric_env_pkg::*;
   import axi4_2x2_fabric_sequences_pkg::*;
   import axi4_2x2_fabric_qvip_pkg::*;
   import mvc_pkg::*;
   import mgc_axi4_v1_0_pkg::*;


   `include "uvm_macros.svh"

  // pragma uvmf custom package_imports_additional begin 
  // pragma uvmf custom package_imports_additional end

   `include "src/test_top.svh"
   `include "src/register_test.svh"
   `include "src/example_derived_test.svh"

  // pragma uvmf custom package_item_additional begin
  //   When adding new tests to the src directory
  //   be sure to add the test file here so that it will be
  //   compiled as part of the test package.  Be sure to place
  //   the new test after any base tests of the new test.
  // pragma uvmf custom package_item_additional end

endpackage

