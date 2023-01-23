//----------------------------------------------------------------------
// Created with uvmf_gen version 2020.2
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
//     -<ALU_sequence_base>
//     -<example_derived_test_sequence>
//
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
//

package ALU_sequences_pkg;
  import uvm_pkg::*;
  import uvmf_base_pkg::*;
  import ALU_in_pkg::*;
  import ALU_in_pkg_hdl::*;
  import ALU_out_pkg::*;
  import ALU_out_pkg_hdl::*;
  import ALU_parameters_pkg::*;
  import ALU_env_pkg::*;
  `include "uvm_macros.svh"
  `include "src/ALU_bench_sequence_base.svh"
  `include "src/register_test_sequence.svh"
  `include "src/example_derived_test_sequence.svh"
  `include "src/ALU_random_sequence.svh" 

  // pragma uvmf custom package_item_additional begin
  // UVMF_CHANGE_ME : When adding new sequences to the src directory
  //    be sure to add the sequence file here so that it will be
  //    compiled as part of the sequence package.  Be sure to place
  //    the new sequence after any base sequences of the new sequence.
  // pragma uvmf custom package_item_additional end

endpackage




