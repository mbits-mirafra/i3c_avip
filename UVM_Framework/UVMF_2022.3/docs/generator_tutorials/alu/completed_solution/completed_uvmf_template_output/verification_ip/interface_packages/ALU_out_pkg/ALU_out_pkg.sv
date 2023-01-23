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
//    - <ALU_out_typedefs_hdl>
//    - <ALU_out_typedefs.svh>
//    - <ALU_out_transaction.svh>

//    - <ALU_out_configuration.svh>
//    - <ALU_out_driver.svh>
//    - <ALU_out_monitor.svh>

//    - <ALU_out_transaction_coverage.svh>
//    - <ALU_out_sequence_base.svh>
//    - <ALU_out_random_sequence.svh>

//    - <ALU_out_responder_sequence.svh>
//    - <ALU_out2reg_adapter.svh>
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
package ALU_out_pkg;
  
   import uvm_pkg::*;
   import uvmf_base_pkg_hdl::*;
   import uvmf_base_pkg::*;
   import ALU_out_pkg_hdl::*;

   `include "uvm_macros.svh"
   `include "src/ALU_out_macros.svh"
   
   export ALU_out_pkg_hdl::*;
   
 

   // Parameters defined as HVL parameters

   `include "src/ALU_out_typedefs.svh"
   `include "src/ALU_out_transaction.svh"

   `include "src/ALU_out_configuration.svh"
   `include "src/ALU_out_driver.svh"
   `include "src/ALU_out_monitor.svh"

   `include "src/ALU_out_transaction_coverage.svh"
   `include "src/ALU_out_sequence_base.svh"
   `include "src/ALU_out_random_sequence.svh"

   `include "src/ALU_out_responder_sequence.svh"
   `include "src/ALU_out2reg_adapter.svh"

   `include "src/ALU_out_agent.svh"

   // pragma uvmf custom package_item_additional begin
   // UVMF_CHANGE_ME : When adding new interface sequences to the src directory
   //    be sure to add the sequence file here so that it will be
   //    compiled as part of the interface package.  Be sure to place
   //    the new sequence after any base sequences of the new sequence.
   // pragma uvmf custom package_item_additional end

endpackage

