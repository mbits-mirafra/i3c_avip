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
  import uvmf_base_pkg::*;
  import mvc_pkg::*;
  import mgc_axi4_v1_0_pkg::*;
  import axi4_2x2_fabric_parameters_pkg::*;
  import axi4_2x2_fabric_env_pkg::*;
  import axi4_2x2_fabric_qvip_params_pkg::*;
  `include "uvm_macros.svh"

  // pragma uvmf custom package_imports_additional begin
  `include "src/ex1_simple_rd_wr.svh"
  // pragma uvmf custom package_imports_additional end

  `include "src/axi4_2x2_fabric_bench_sequence_base.svh"
  `include "src/register_test_sequence.svh"
  `include "src/example_derived_test_sequence.svh"

  // pragma uvmf custom package_item_additional begin
  //    When adding new sequences to the src directory
  //    be sure to add the sequence file here so that it will be
  //    compiled as part of the sequence package.  Be sure to place
  //    the new sequence after any base sequences of the new sequence.
  // pragma uvmf custom package_item_additional end

endpackage




