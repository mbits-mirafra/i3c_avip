//----------------------------------------------------------------------
// Created with uvmf_gen version 2020.2
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
//    - <ALU_in_typedefs_hdl>
//    - <ALU_in_typedefs.svh>
//    - <ALU_in_transaction.svh>

//    - <ALU_in_configuration.svh>
//    - <ALU_in_driver.svh>
//    - <ALU_in_monitor.svh>

//    - <ALU_in_transaction_coverage.svh>
//    - <ALU_in_sequence_base.svh>
//    - <ALU_in_random_sequence.svh>

//    - <ALU_in_responder_sequence.svh>
//    - <ALU_in2reg_adapter.svh>
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
package ALU_in_pkg;
  
   import uvm_pkg::*;
   import uvmf_base_pkg_hdl::*;
   import uvmf_base_pkg::*;
   import ALU_in_pkg_hdl::*;

   `include "uvm_macros.svh"
   `include "src/ALU_in_macros.svh"
   
   export ALU_in_pkg_hdl::*;
   
 

   // Parameters defined as HVL parameters

   `include "src/ALU_in_typedefs.svh"
   `include "src/ALU_in_transaction.svh"

   `include "src/ALU_in_configuration.svh"
   `include "src/ALU_in_driver.svh"
   `include "src/ALU_in_monitor.svh"

   `include "src/ALU_in_transaction_coverage.svh"
   `include "src/ALU_in_sequence_base.svh"
   `include "src/ALU_in_random_sequence.svh"
   `include "src/ALU_in_reset_sequence.svh" 

   `include "src/ALU_in_responder_sequence.svh"
   `include "src/ALU_in2reg_adapter.svh"

   `include "src/ALU_in_agent.svh"

   // pragma uvmf custom package_item_additional begin
   // UVMF_CHANGE_ME : When adding new interface sequences to the src directory
   //    be sure to add the sequence file here so that it will be
   //    compiled as part of the interface package.  Be sure to place
   //    the new sequence after any base sequences of the new sequence.
   // pragma uvmf custom package_item_additional end

endpackage

