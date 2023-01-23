//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 06
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb2wb environment agent
// Unit            : Environment HVL package
// File            : ahb2wb_pkg.sv
//----------------------------------------------------------------------
//     
// PACKAGE: This file defines all of the files contained in the
//    environment package that will run on the host simulator.
//
// CONTAINS:
//     - <ahb2wb_configuration.svh"
//     - <ahb2wb_environment.svh"
//     - <ahb2wb_env_sequence_base.svh"
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
package ahb2wb_env_pkg;

   import uvm_pkg::*;
   import questa_uvm_pkg::*;
   `include "uvm_macros.svh"

   import uvmf_base_pkg::*;
   import ahb_pkg::*;
   import wb_pkg::*;



   `uvm_analysis_imp_decl(_ahb_ae)
   `uvm_analysis_imp_decl(_wb_ae)

   `include "src/ahb2wb_predictor.svh"
   `include "src/wb2ahb_predictor.svh"
   `include "src/ahb2wb_env_configuration.svh"
   `include "src/ahb2wb_environment.svh"
   `include "src/ahb2wb_env_sequence_base.svh"
   `include "src/ahb2wb_infact_env_sequence.svh"
  
endpackage

