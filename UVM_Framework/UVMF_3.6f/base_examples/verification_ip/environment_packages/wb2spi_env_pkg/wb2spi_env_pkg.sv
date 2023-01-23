//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 09
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : wb2spi environment agent
// Unit            : Environment HVL package
// File            : wb2spi_pkg.sv
//----------------------------------------------------------------------
//     
// PACKAGE: This file defines all of the files contained in the
//    environment package that will run on the host simulator.
//
// CONTAINS:
//     - <wb2spi_configuration.svh"
//     - <wb2spi_environment.svh"
//     - <wb2spi_env_sequence_base.svh"
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
package wb2spi_env_pkg;

   import uvm_pkg::*;
   import questa_uvm_pkg::*;
   `include "uvm_macros.svh"

   import uvmf_base_pkg::*;
   import wb_pkg::*;
   import spi_pkg::*;
   import wb2spi_reg_pkg::*;

   `uvm_analysis_imp_decl(_wb_ae)

   `include "src/wb2spi_predictor.svh"
   `include "src/wb2spi_env_configuration.svh"
   `include "src/wb2spi_environment.svh"
   `include "src/wb2spi_env_sequence_base.svh"
   `include "src/wb2spi_infact_env_sequence.svh"
  
endpackage

