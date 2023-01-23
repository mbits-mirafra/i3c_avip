//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// PACKAGE: This file defines all of the files contained in the
//    environment package that will run on the host simulator.
//
// CONTAINS:
//     - <ahb2spi_configuration.svh>
//     - <ahb2spi_environment.svh>
//     - <ahb2spi_env_sequence_base.svh>
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
package ahb2spi_env_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import uvmf_base_pkg::*;
  import ahb_pkg::*;
  import wb_pkg::*;
  import ahb2spi_reg_pkg::*;
  import ahb2wb_env_pkg::*;
  import wb2spi_env_pkg::*;
 

  // pragma uvmf custom package_imports_additional begin
  // pragma uvmf custom package_imports_additional end

  // Parameters defined as HVL parameters

  `include "src/ahb2spi_env_typedefs.svh"
  `include "src/ahb2spi_env_configuration.svh"
  `include "src/ahb2spi_environment.svh"
  `include "src/ahb2spi_env_sequence_base.svh"

  // pragma uvmf custom package_item_additional begin
  // UVMF_CHANGE_ME : When adding new environment level sequences to the src directory
  //    be sure to add the sequence file here so that it will be
  //    compiled as part of the environment package.  Be sure to place
  //    the new sequence after any base sequence of the new sequence.



  // pragma uvmf custom package_item_additional end

endpackage

