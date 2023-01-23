//----------------------------------------------------------------------
// Created with uvmf_gen version 2021.1
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
//     -<scatter_gather_dma_sequence_base>
//     -<example_derived_test_sequence>
//
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
//

package scatter_gather_dma_sequences_pkg;
  import uvm_pkg::*;
  import uvmf_base_pkg::*;
  import mvc_pkg::*;
  import mgc_axi4_v1_0_pkg::*;
  import ccs_pkg::*;
  import ccs_pkg_hdl::*;
  import scatter_gather_dma_parameters_pkg::*;
  import scatter_gather_dma_env_pkg::*;
  import scatter_gather_dma_qvip_params_pkg::*;
  `include "uvm_macros.svh"

  // pragma uvmf custom package_imports_additional begin
  // pragma uvmf custom package_imports_additional end

  `include "src/scatter_gather_dma_bench_sequence_base.svh"
  `include "src/register_test_sequence.svh"
  `include "src/example_derived_test_sequence.svh"

  // pragma uvmf custom package_item_additional begin
  // UVMF_CHANGE_ME : When adding new sequences to the src directory
  //    be sure to add the sequence file here so that it will be
  //    compiled as part of the sequence package.  Be sure to place
  //    the new sequence after any base sequences of the new sequence.
  `include "src/dma_cmd_seq.svh"
  `include "src/dma_util_seq.svh"
  `include "src/scatter_gather_dma_cmd_base_seq.svh"
  `include "src/scatter_gather_dma_cp_seq.svh"
  `include "src/scatter_gather_dma_sg_seq.svh"
  `include "src/scatter_gather_dma_cov_seq.svh"
  `include "src/scatter_gather_dma_cov_loop_seq.svh"
  `include "src/scatter_gather_dma_err_seq.svh"
  // pragma uvmf custom package_item_additional end

endpackage




