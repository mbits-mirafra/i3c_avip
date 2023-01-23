//----------------------------------------------------------------------
// Created with uvmf_gen version 2020.2
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
//     - <ALU_configuration.svh>
//     - <ALU_environment.svh>
//     - <ALU_env_sequence_base.svh>
//     - <ALU_predictor.svh>
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
package ALU_env_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import uvmf_base_pkg::*;
  import ALU_in_pkg::*;
  import ALU_in_pkg_hdl::*;
  import ALU_out_pkg::*;
  import ALU_out_pkg_hdl::*;
 
  `uvm_analysis_imp_decl(_ALU_in_agent_ae)


  // Parameters defined as HVL parameters

  `include "src/ALU_env_typedefs.svh"
  `include "src/ALU_env_configuration.svh"
  `include "src/ALU_predictor.svh"
  `include "src/ALU_environment.svh"
  `include "src/ALU_env_sequence_base.svh"

  // pragma uvmf custom package_item_additional begin
  // UVMF_CHANGE_ME : When adding new environment level sequences to the src directory
  //    be sure to add the sequence file here so that it will be
  //    compiled as part of the environment package.  Be sure to place
  //    the new sequence after any base sequence of the new sequence.
  // pragma uvmf custom package_item_additional end

endpackage

