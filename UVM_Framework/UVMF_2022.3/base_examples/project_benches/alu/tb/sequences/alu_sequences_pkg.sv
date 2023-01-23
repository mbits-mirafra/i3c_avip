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
//     -<alu_sequence_base>
//     -<example_derived_test_sequence>
//
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
//

package alu_sequences_pkg;
  import uvm_pkg::*;
  import uvmf_base_pkg::*;
  import alu_in_pkg::*;
  import alu_in_pkg_hdl::*;
  import alu_out_pkg::*;
  import alu_out_pkg_hdl::*;
  import alu_parameters_pkg::*;
  import alu_env_pkg::*;
  `include "uvm_macros.svh"

  // pragma uvmf custom package_imports_additional begin 
  // pragma uvmf custom package_imports_additional end

  `include "src/alu_bench_sequence_base.svh"
  `include "src/register_test_sequence.svh"
  `include "src/example_derived_test_sequence.svh"

  // pragma uvmf custom package_item_additional begin
   `include "src/alu_directed_sequence.svh"  
  // pragma uvmf custom package_item_additional end

endpackage




