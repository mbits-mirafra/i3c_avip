//----------------------------------------------------------------------
// Created with uvmf_gen version 2021.1
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

package scatter_gather_dma_tests_pkg;

   import uvm_pkg::*;
   import uvmf_base_pkg::*;
   import scatter_gather_dma_parameters_pkg::*;
   import scatter_gather_dma_env_pkg::*;
   import scatter_gather_dma_sequences_pkg::*;
   import ccs_pkg::*;
   import ccs_pkg_hdl::*;
   import scatter_gather_dma_qvip_pkg::*;
   import QUESTA_MVC::*;
   import qvip_utils_pkg::*;
   import mvc_pkg::*;
   import mgc_axi4_v1_0_pkg::*;


   `include "uvm_macros.svh"

  // pragma uvmf custom package_imports_additional begin 
  import scatter_gather_dma_qvip_params_pkg::*;
  import addr_map_pkg::*;
  import rw_delay_db_pkg::*;
  // pragma uvmf custom package_imports_additional end

   `include "src/test_top.svh"
   `include "src/register_test.svh"
   `include "src/example_derived_test.svh"

  // pragma uvmf custom package_item_additional begin
  // UVMF_CHANGE_ME : When adding new tests to the src directory
  //    be sure to add the test file here so that it will be
  //    compiled as part of the test package.  Be sure to place
  //    the new test after any base tests of the new test.
  `include "src/mgc_axi4_s0_cov_config_policy.svh"
  `include "src/scatter_gather_dma_cp_test.svh"
  `include "src/scatter_gather_dma_sg_test.svh"
  `include "src/scatter_gather_dma_cov_test.svh"
  `include "src/scatter_gather_dma_cov_loop_test.svh"
  `include "src/scatter_gather_dma_err_test.svh"
  // pragma uvmf custom package_item_additional end

endpackage

