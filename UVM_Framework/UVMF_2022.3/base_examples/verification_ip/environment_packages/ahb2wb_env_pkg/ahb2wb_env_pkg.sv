//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
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
//     - <ahb2wb_configuration.svh>
//     - <ahb2wb_environment.svh>
//     - <ahb2wb_env_sequence_base.svh>
//     - <ahb2wb_predictor.svh>
//     - <wb2ahb_predictor.svh>
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
package ahb2wb_env_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import uvmf_base_pkg::*;
  import wb_pkg::*;
  import wb_pkg_hdl::*;
  import ahb_pkg::*;
  import ahb_pkg_hdl::*;
 
  `uvm_analysis_imp_decl(_ahb_ae)
  `uvm_analysis_imp_decl(_wb_ae)

  // pragma uvmf custom package_imports_additional begin
  // pragma uvmf custom package_imports_additional end

  // Parameters defined as HVL parameters

  `include "src/ahb2wb_env_typedefs.svh"
  `include "src/ahb2wb_env_configuration.svh"
  `include "src/ahb2wb_predictor.svh"
  `include "src/wb2ahb_predictor.svh"
  `include "src/ahb2wb_environment.svh"
  `include "src/ahb2wb_env_sequence_base.svh"

  // pragma uvmf custom package_item_additional begin
  // UVMF_CHANGE_ME : When adding new environment level sequences to the src directory
  //    be sure to add the sequence file here so that it will be
  //    compiled as part of the environment package.  Be sure to place
  //    the new sequence after any base sequence of the new sequence.



  // pragma uvmf custom package_item_additional end

endpackage

