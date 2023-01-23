//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU_in interface agent
// Unit            : Interface HVL package
// File            : FPU_in_pkg.sv
//----------------------------------------------------------------------
//     
// PACKAGE: This file defines all of the files contained in the
//    interface package that will run on the host simulator.
//
// CONTAINS:
//    - <FPU_in_typedefs_hdl>
//    - <FPU_in_typedefs.svh>
//    - <FPU_in_transaction.svh>

//    - <FPU_in_configuration.svh>
//    - <FPU_in_driver.svh>
//    - <FPU_in_monitor.svh>

//    - <FPU_in_transaction_coverage.svh>
//    - <FPU_in_sequence_base.svh>
//    - <FPU_in_random_sequence.svh>

//    - <FPU_in_responder_sequence.svh>
//    - <FPU_in2reg_adapter.svh>
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
package FPU_in_pkg;
  
   import uvm_pkg::*;
   import questa_uvm_pkg::*;
   import uvmf_base_pkg_hdl::*;
   import uvmf_base_pkg::*;
   import FPU_in_pkg_hdl::*;

   `include "uvm_macros.svh"
   
   export FPU_in_pkg_hdl::*;
   export FPU_in_pkg_hdl::reqstruct;
   export FPU_in_pkg_hdl::rspstruct;   
 
   `include "src/FPU_in_typedefs.svh"
   `include "src/FPU_in_transaction.svh"

   `include "src/FPU_in_configuration.svh"
   `include "src/FPU_in_driver.svh"
   `include "src/FPU_in_monitor.svh"

   `include "src/FPU_in_transaction_coverage.svh"
   `include "src/FPU_in_sequence_base.svh"
   `include "src/FPU_in_random_sequence.svh"

   `include "src/FPU_in_responder_sequence.svh"
   `include "src/FPU_in2reg_adapter.svh"

   `include "src/FPU_in_agent.svh"

   typedef uvm_reg_predictor #(FPU_in_transaction) FPU_in2reg_predictor;


endpackage

