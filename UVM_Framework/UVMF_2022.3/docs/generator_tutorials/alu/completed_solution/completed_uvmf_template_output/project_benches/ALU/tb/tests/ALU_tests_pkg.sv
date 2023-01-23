//----------------------------------------------------------------------
// Created with uvmf_gen version 2020.2
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

package ALU_tests_pkg;

  import uvm_pkg::*;
  import uvmf_base_pkg::*;
  import ALU_parameters_pkg::*;
  import ALU_env_pkg::*;
  import ALU_sequences_pkg::*;
  import ALU_in_pkg::*;
  import ALU_in_pkg_hdl::*;
  import ALU_out_pkg::*;
  import ALU_out_pkg_hdl::*;

   `include "uvm_macros.svh"

   `include "src/test_top.svh"
   `include "src/register_test.svh"
   `include "src/example_derived_test.svh"
   `include "src/ALU_random_test.svh" 

endpackage

