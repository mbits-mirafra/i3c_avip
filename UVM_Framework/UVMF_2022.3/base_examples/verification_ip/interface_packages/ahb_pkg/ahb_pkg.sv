//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
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
//    - <ahb_typedefs_hdl>
//    - <ahb_typedefs.svh>
//    - <ahb_transaction.svh>

//    - <ahb_configuration.svh>
//    - <ahb_driver.svh>
//    - <ahb_monitor.svh>

//    - <ahb_transaction_coverage.svh>
//    - <ahb_sequence_base.svh>
//    - <ahb_random_sequence.svh>

//    - <ahb_responder_sequence.svh>
//    - <ahb2reg_adapter.svh>
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
package ahb_pkg;
  
   import uvm_pkg::*;
   import uvmf_base_pkg_hdl::*;
   import uvmf_base_pkg::*;
   import ahb_pkg_hdl::*;

   `include "uvm_macros.svh"

   // pragma uvmf custom package_imports_additional begin 
   // pragma uvmf custom package_imports_additional end

   `include "src/ahb_macros.svh"
   
   export ahb_pkg_hdl::*;
   
 

   // Parameters defined as HVL parameters

   `include "src/ahb_typedefs.svh"
   `include "src/ahb_transaction.svh"

   `include "src/ahb_configuration.svh"
   `include "src/ahb_driver.svh"
   `include "src/ahb_monitor.svh"

   `include "src/ahb_transaction_coverage.svh"
   `include "src/ahb_sequence_base.svh"
   `include "src/ahb_random_sequence.svh"

   `include "src/ahb_responder_sequence.svh"
   `include "src/ahb2reg_adapter.svh"

   `include "src/ahb_agent.svh"

   // pragma uvmf custom package_item_additional begin
   `include "src/ahb_master_access_sequence.svh"
   // pragma uvmf custom package_item_additional end

endpackage

