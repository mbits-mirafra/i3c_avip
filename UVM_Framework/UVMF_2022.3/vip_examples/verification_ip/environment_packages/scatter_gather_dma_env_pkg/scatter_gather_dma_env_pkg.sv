//----------------------------------------------------------------------
// Created with uvmf_gen version 2021.1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// PACKAGE: This file defines all of the files contained in the
//    environment package that will run on the host simulator.
//
// CONTAINS:
//     - <scatter_gather_dma_configuration.svh>
//     - <scatter_gather_dma_environment.svh>
//     - <scatter_gather_dma_env_sequence_base.svh>
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
package scatter_gather_dma_env_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import uvmf_base_pkg::*;
  import mvc_pkg::*;
  import mgc_axi4_v1_0_pkg::*;
  import ccs_pkg::*;
  import ccs_pkg_hdl::*;
  import scatter_gather_dma_qvip_pkg::*;
  import scatter_gather_dma_qvip_params_pkg::*;
 

  // pragma uvmf custom package_imports_additional begin
  // pragma uvmf custom package_imports_additional end

  // Parameters defined as HVL parameters

  `include "src/scatter_gather_dma_env_typedefs.svh"
  `include "src/scatter_gather_dma_env_configuration.svh"
  `include "src/scatter_gather_dma_environment.svh"
  `include "src/scatter_gather_dma_env_sequence_base.svh"

  // pragma uvmf custom package_item_additional begin
  // UVMF_CHANGE_ME : When adding new environment level sequences to the src directory
  //    be sure to add the sequence file here so that it will be
  //    compiled as part of the environment package.  Be sure to place
  //    the new sequence after any base sequence of the new sequence.
  // pragma uvmf custom package_item_additional end

endpackage

