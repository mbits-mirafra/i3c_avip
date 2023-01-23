//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 15
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb interface agent
// Unit            : Interface HVL package
// File            : ahb_pkg.sv
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
//    - <ahb_infact_sequence.svh>
//    - <ahb_random_sequence.svh>
//    - <ahb_master_access_sequence.svh>
//    - <ahb2reg_adapter.svh>
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
package ahb_pkg;
  
   import uvm_pkg::*;
   import questa_uvm_pkg::*;
   import uvmf_base_pkg_hdl::*;
   import uvmf_base_pkg::*;
   import ahb_pkg_hdl::*;
   `include "uvm_macros.svh"
   
   export ahb_pkg_hdl::*;

   `include "src/ahb_typedefs.svh"
   `include "src/ahb_transaction.svh"

   `include "src/ahb_configuration.svh"
   `include "src/ahb_driver.svh"
   `include "src/ahb_monitor.svh"

   `include "src/ahb_transaction_coverage.svh"
   `include "src/ahb_sequence_base.svh"
   `include "src/ahb_infact_sequence.svh"
   `include "src/ahb_random_sequence.svh"
   `include "src/ahb_master_access_sequence.svh"
   `include "src/ahb2reg_adapter.svh"

   typedef uvm_reg_predictor #(ahb_transaction) ahb2reg_predictor;
   typedef uvmf_parameterized_agent #(ahb_configuration, ahb_driver, ahb_monitor, ahb_transaction_coverage, ahb_transaction) ahb_agent_t;


endpackage

