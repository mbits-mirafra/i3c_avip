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
//    - <i3c_s_typedefs_hdl>
//    - <i3c_s_typedefs.svh>
//    - <i3c_s_transaction.svh>

//    - <i3c_s_configuration.svh>
//    - <i3c_s_driver.svh>
//    - <i3c_s_monitor.svh>

//    - <i3c_s_transaction_coverage.svh>
//    - <i3c_s_sequence_base.svh>
//    - <i3c_s_random_sequence.svh>

//    - <i3c_s_responder_sequence.svh>
//    - <i3c_s2reg_adapter.svh>
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
package i3c_s_pkg;
  
   import uvm_pkg::*;
   import uvmf_base_pkg_hdl::*;
   import uvmf_base_pkg::*;
   import i3c_s_pkg_hdl::*;

   `include "uvm_macros.svh"

   // pragma uvmf custom package_imports_additional begin 
   // pragma uvmf custom package_imports_additional end
   `include "src/i3c_s_macros.svh"

   export i3c_s_pkg_hdl::*;
   
 

   // Parameters defined as HVL parameters

   `include "src/i3c_s_typedefs.svh"
   `include "src/i3c_s_transaction.svh"

   `include "src/i3c_s_configuration.svh"
   `include "src/i3c_s_driver.svh"
   `include "src/i3c_s_monitor.svh"

   `include "src/i3c_s_transaction_coverage.svh"
   `include "src/i3c_s_sequence_base.svh"
   `include "src/i3c_s_random_sequence.svh"

   `include "src/i3c_s_responder_sequence.svh"
   `include "src/i3c_s2reg_adapter.svh"

   `include "src/i3c_s_agent.svh"

   // pragma uvmf custom package_item_additional begin
   // UVMF_CHANGE_ME : When adding new interface sequences to the src directory
   //    be sure to add the sequence file here so that it will be
   //    compiled as part of the interface package.  Be sure to place
   //    the new sequence after any base sequences of the new sequence.
   // pragma uvmf custom package_item_additional end

endpackage

// pragma uvmf custom external begin
// pragma uvmf custom external end

