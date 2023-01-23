//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 14
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb2spi environment agent
// Unit            : Environment HVL package
// File            : ahb2spi_pkg.sv
//----------------------------------------------------------------------
//     
// PACKAGE: This file defines all of the files contained in the
//    environment package that will run on the host simulator.
//
// CONTAINS:
//     - <ahb2spi_configuration.svh"
//     - <ahb2spi_environment.svh"
//     - <ahb2spi_env_sequence_base.svh"
//     - <ahb2spi_infact_env_sequence.svh"
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
package ahb2spi_env_pkg;

   import uvm_pkg::*;
   import questa_uvm_pkg::*;
   `include "uvm_macros.svh"

   import uvmf_base_pkg::*;
   import ahb_pkg::*;
   import wb_pkg::*;

    import ahb2spi_reg_pkg::*;
    import ahb2wb_env_pkg::*;
    import wb2spi_env_pkg::*;



   `include "src/ahb2spi_env_configuration.svh"
   `include "src/ahb2spi_environment.svh"
   `include "src/ahb2spi_env_sequence_base.svh"
   `include "src/ahb2spi_infact_env_sequence.svh"
  
endpackage

