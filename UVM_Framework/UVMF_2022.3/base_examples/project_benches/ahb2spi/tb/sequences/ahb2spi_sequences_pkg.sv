//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
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
  import uvmf_base_pkg::*;
  import wb_pkg::*;
  import wb_pkg_hdl::*;
  import ahb_pkg::*;
  import ahb_pkg_hdl::*;
  import spi_pkg::*;
  import spi_pkg_hdl::*;
  import ahb2spi_parameters_pkg::*;
  import ahb2spi_env_pkg::*;
  import ahb2spi_reg_pkg::*;
  `include "uvm_macros.svh"

  // pragma uvmf custom package_imports_additional begin 
  // pragma uvmf custom package_imports_additional end

  `include "src/ahb2spi_bench_sequence_base.svh"
  `include "src/register_test_sequence.svh"
  `include "src/ahb2spi_regmodel_sequence.svh"
  `include "src/example_derived_test_sequence.svh"

  // pragma uvmf custom package_item_additional begin
  // UVMF_CHANGE_ME : When adding new sequences to the src directory
  //    be sure to add the sequence file here so that it will be
  //    compiled as part of the sequence package.  Be sure to place
  //    the new sequence after any base sequences of the new sequence.
   //`include "src/ahb2spi_regmodel_sequence.svh"

  // pragma uvmf custom package_item_additional end

endpackage




