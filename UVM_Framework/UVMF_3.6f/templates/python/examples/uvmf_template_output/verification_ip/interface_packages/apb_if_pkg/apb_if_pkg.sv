//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : shwetapatil
// Creation Date   : 2022 Jun 06
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : apb_if interface agent
// Unit            : Interface HVL package
// File            : apb_if_pkg.sv
//----------------------------------------------------------------------
//     
// PACKAGE: This file defines all of the files contained in the
//    interface package that will run on the host simulator.
//
// CONTAINS:
//    - <apb_if_typedefs_hdl>
//    - <apb_if_typedefs.svh>
//    - <apb_if_transaction.svh>

//    - <apb_if_configuration.svh>
//    - <apb_if_driver.svh>
//    - <apb_if_monitor.svh>

//    - <apb_if_transaction_coverage.svh>
//    - <apb_if_sequence_base.svh>
//    - <apb_if_random_sequence.svh>
 
//    - <apb_if_infact_sequence.svh>

//    - <apb_if_responder_sequence.svh>
//    - <apb_if2reg_adapter.svh>
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
package apb_if_pkg;
  
   import uvm_pkg::*;
   import questa_uvm_pkg::*;
   import uvmf_base_pkg_hdl::*;
   import uvmf_base_pkg::*;
   import apb_if_pkg_hdl::*;
   `include "uvm_macros.svh"
   
   export apb_if_pkg_hdl::*;
   

   `include "src/apb_if_typedefs.svh"
   `include "src/apb_if_transaction.svh"

   `include "src/apb_if_configuration.svh"
   `include "src/apb_if_driver.svh"
   `include "src/apb_if_monitor.svh"

   `include "src/apb_if_transaction_coverage.svh"
   `include "src/apb_if_sequence_base.svh"
   `include "src/apb_if_random_sequence.svh"
 
   `include "apb_if_infact_sequence.svh"

   `include "src/apb_if_responder_sequence.svh"
   `include "src/apb_if2reg_adapter.svh"

   `include "src/apb_if_agent.svh"

   typedef uvm_reg_predictor #(apb_if_transaction) apb_if2reg_predictor;


endpackage

