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
// PACKAGE: This file defines all of the files contained in the
//    environment package that will run on the host simulator.
//
// CONTAINS:
//     - <axi4_2x2_fabric_configuration.svh>
//     - <axi4_2x2_fabric_environment.svh>
//     - <axi4_2x2_fabric_env_sequence_base.svh>
//     - <axi4_master_predictor.svh>
//     - <axi4_slave_predictor.svh>
//     - <axi4_slave_rw_predictor.svh>
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
package axi4_2x2_fabric_env_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import uvmf_base_pkg::*;
  import mvc_pkg::*;
  import mgc_axi4_v1_0_pkg::*;
  import rw_txn_pkg::*;
  import axi4_2x2_fabric_qvip_pkg::*;
  import axi4_2x2_fabric_qvip_params_pkg::*;
 
  `uvm_analysis_imp_decl(_axi4_ae)
  `uvm_analysis_imp_decl(_axi4_s1_ae)
  `uvm_analysis_imp_decl(_axi4_s0_ae)

  // pragma uvmf custom package_imports_additional begin
  // pragma uvmf custom package_imports_additional end

  // Parameters defined as HVL parameters

  `include "src/axi4_2x2_fabric_env_typedefs.svh"
  `include "src/axi4_2x2_fabric_env_configuration.svh"
  `include "src/axi4_master_predictor.svh"
  `include "src/axi4_slave_predictor.svh"
  `include "src/axi4_slave_rw_predictor.svh"
  `include "src/axi4_2x2_fabric_environment.svh"
  `include "src/axi4_2x2_fabric_env_sequence_base.svh"

  // pragma uvmf custom package_item_additional begin
  //    When adding new environment level sequences to the src directory
  //    be sure to add the sequence file here so that it will be
  //    compiled as part of the environment package.  Be sure to place
  //    the new sequence after any base sequence of the new sequence.
  // pragma uvmf custom package_item_additional end

endpackage

