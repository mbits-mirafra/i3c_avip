//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
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

package ahb2wb_tests_pkg;

   import uvm_pkg::*;
   import uvmf_base_pkg::*;
   import ahb2wb_parameters_pkg::*;
   import ahb2wb_env_pkg::*;
   import ahb2wb_sequences_pkg::*;
  import wb_pkg::*;
  import wb_pkg_hdl::*;
  import ahb_pkg::*;
  import ahb_pkg_hdl::*;


   `include "uvm_macros.svh"

  // pragma uvmf custom package_imports_additional begin 
  // pragma uvmf custom package_imports_additional end

   `include "src/test_top.svh"
   `include "src/register_test.svh"
   `include "src/example_derived_test.svh"

  // pragma uvmf custom package_item_additional begin
  // UVMF_CHANGE_ME : When adding new tests to the src directory
  //    be sure to add the test file here so that it will be
  //    compiled as part of the test package.  Be sure to place
  //    the new test after any base tests of the new test.



  // pragma uvmf custom package_item_additional end

endpackage

