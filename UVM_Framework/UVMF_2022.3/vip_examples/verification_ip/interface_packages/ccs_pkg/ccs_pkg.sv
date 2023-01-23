//----------------------------------------------------------------------
// Created with uvmf_gen version 2021.1
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
//    - <ccs_typedefs_hdl>
//    - <ccs_typedefs.svh>
//    - <ccs_transaction.svh>

//    - <ccs_configuration.svh>
//    - <ccs_driver.svh>
//    - <ccs_monitor.svh>

//    - <ccs_transaction_coverage.svh>
//    - <ccs_sequence_base.svh>
//    - <ccs_random_sequence.svh>

//    - <ccs_responder_sequence.svh>
//    - <ccs2reg_adapter.svh>
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
package ccs_pkg;
  
   import uvm_pkg::*;
   import uvmf_base_pkg_hdl::*;
   import uvmf_base_pkg::*;
   import ccs_pkg_hdl::*;

   `include "uvm_macros.svh"

   // pragma uvmf custom package_imports_additional begin 
   // pragma uvmf custom package_imports_additional end
   `include "src/ccs_macros.svh"

   export ccs_pkg_hdl::*;
   
 

   // Parameters defined as HVL parameters

   `include "src/ccs_typedefs.svh"
   `include "src/ccs_transaction.svh"

   `include "src/ccs_configuration.svh"
   `include "src/ccs_driver.svh"
   `include "src/ccs_monitor.svh"

   `include "src/ccs_transaction_coverage.svh"
   `include "src/ccs_sequence_base.svh"
   `include "src/ccs_random_sequence.svh"

   `include "src/ccs_responder_sequence.svh"
   `include "src/ccs2reg_adapter.svh"

   `include "src/ccs_agent.svh"

   // pragma uvmf custom package_item_additional begin
   // UVMF_CHANGE_ME : When adding new interface sequences to the src directory
   //    be sure to add the sequence file here so that it will be
   //    compiled as part of the interface package.  Be sure to place
   //    the new sequence after any base sequences of the new sequence.
   `include "src/ccs_transaction_wait_cycles.svh"
   // pragma uvmf custom package_item_additional end

endpackage

