//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU environment agent
// Unit            : Environment HVL package
// File            : FPU_pkg.sv
//----------------------------------------------------------------------
//     
// PACKAGE: This file defines all of the files contained in the
//    environment package that will run on the host simulator.
//
// CONTAINS:
//     - <FPU_configuration.svh>
//     - <FPU_environment.svh>
//     - <FPU_env_sequence_base.svh>
//     - <FPU_predictor.svh>
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
package FPU_env_pkg;

   import uvm_pkg::*;
   import questa_uvm_pkg::*;
   `include "uvm_macros.svh"

   import uvmf_base_pkg::*;
   import FPU_in_pkg::*;
   import FPU_out_pkg::*;




   import "DPI-C" context function void fpu_compute (input reqstruct req_data  ,output rspstruct rsp_data  );
 

   `uvm_analysis_imp_decl(_FPU_in_agent_ae)

   `include "src/FPU_env_typedefs.svh"

   `include "src/FPU_env_configuration.svh"
   `include "src/FPU_predictor.svh"
   `include "src/FPU_environment.svh"
   `include "src/FPU_env_sequence_base.svh"
  
endpackage

