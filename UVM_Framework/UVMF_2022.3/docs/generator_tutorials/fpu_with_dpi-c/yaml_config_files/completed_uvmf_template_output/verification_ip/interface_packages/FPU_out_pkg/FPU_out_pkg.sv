//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU_out interface agent
// Unit            : Interface HVL package
// File            : FPU_out_pkg.sv
//----------------------------------------------------------------------
//     
// PACKAGE: This file defines all of the files contained in the
//    interface package that will run on the host simulator.
//
// CONTAINS:
//    - <FPU_out_typedefs_hdl>
//    - <FPU_out_typedefs.svh>
//    - <FPU_out_transaction.svh>

//    - <FPU_out_configuration.svh>
//    - <FPU_out_driver.svh>
//    - <FPU_out_monitor.svh>

//    - <FPU_out_transaction_coverage.svh>
//    - <FPU_out_sequence_base.svh>
//    - <FPU_out_random_sequence.svh>

//    - <FPU_out_responder_sequence.svh>
//    - <FPU_out2reg_adapter.svh>
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
package FPU_out_pkg;
  
   import uvm_pkg::*;
   import questa_uvm_pkg::*;
   import uvmf_base_pkg_hdl::*;
   import uvmf_base_pkg::*;
   import FPU_out_pkg_hdl::*;

   `include "uvm_macros.svh"
   
   export FPU_out_pkg_hdl::*;
   
 
   `include "src/FPU_out_typedefs.svh"
   `include "src/FPU_out_transaction.svh"

   `include "src/FPU_out_configuration.svh"
   `include "src/FPU_out_driver.svh"
   `include "src/FPU_out_monitor.svh"

   `include "src/FPU_out_transaction_coverage.svh"
   `include "src/FPU_out_sequence_base.svh"
   `include "src/FPU_out_random_sequence.svh"

   `include "src/FPU_out_responder_sequence.svh"
   `include "src/FPU_out2reg_adapter.svh"

   `include "src/FPU_out_agent.svh"

   typedef uvm_reg_predictor #(FPU_out_transaction) FPU_out2reg_predictor;


endpackage

