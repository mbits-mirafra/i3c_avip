//----------------------------------------------------------------------
// Created with uvmf_gen version 2022.3
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// PACKAGE: This file defines all of the files contained in the
//    interface package that will run on the host simulator.
//
// CONTAINS:
//    - <nand_in_typedefs_hdl>
//    - <nand_in_typedefs.svh>
//    - <nand_in_transaction.svh>

//    - <nand_in_configuration.svh>
//    - <nand_in_driver.svh>
//    - <nand_in_monitor.svh>

//    - <nand_in_transaction_coverage.svh>
//    - <nand_in_sequence_base.svh>
//    - <nand_in_random_sequence.svh>

//    - <nand_in_responder_sequence.svh>
//    - <nand_in2reg_adapter.svh>
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
package nand_in_pkg;
  
   import uvm_pkg::*;
   import uvmf_base_pkg_hdl::*;
   import uvmf_base_pkg::*;
   import nand_in_pkg_hdl::*;

   `include "uvm_macros.svh"

   // pragma uvmf custom package_imports_additional begin 
   // pragma uvmf custom package_imports_additional end

   export nand_in_pkg_hdl::*;
   
 

   // Parameters defined as HVL parameters

   `include "src/nand_in_typedefs.svh"
   `include "src/nand_in_transaction.svh"

   `include "src/nand_in_configuration.svh"
   `include "src/nand_in_driver.svh"
   `include "src/nand_in_monitor.svh"

   `include "src/nand_in_transaction_coverage.svh"
   `include "src/nand_in_sequence_base.svh"
   `include "src/nand_in_random_sequence.svh"

   `include "src/nand_in_responder_sequence.svh"
   `include "src/nand_in2reg_adapter.svh"

   `include "src/nand_in_agent.svh"

   // pragma uvmf custom package_item_additional begin
   `include "src/nand_in_fixed_sequence.sv"
   // UVMF_CHANGE_ME : When adding new interface sequences to the src directory
   //    be sure to add the sequence file here so that it will be
   //    compiled as part of the interface package.  Be sure to place
   //    the new sequence after any base sequences of the new sequence.
   // pragma uvmf custom package_item_additional end

endpackage

// pragma uvmf custom external begin
// pragma uvmf custom external end

