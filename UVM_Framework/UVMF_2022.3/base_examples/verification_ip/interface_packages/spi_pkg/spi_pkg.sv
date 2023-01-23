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
//    - <spi_typedefs_hdl>
//    - <spi_typedefs.svh>
//    - <spi_transaction.svh>

//    - <spi_configuration.svh>
//    - <spi_driver.svh>
//    - <spi_monitor.svh>

//    - <spi_transaction_coverage.svh>
//    - <spi_sequence_base.svh>
//    - <spi_random_sequence.svh>

//    - <spi_responder_sequence.svh>
//    - <spi2reg_adapter.svh>
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
package spi_pkg;
  
   import uvm_pkg::*;
   import uvmf_base_pkg_hdl::*;
   import uvmf_base_pkg::*;
   import spi_pkg_hdl::*;

   `include "uvm_macros.svh"

   // pragma uvmf custom package_imports_additional begin 
   // pragma uvmf custom package_imports_additional end

   `include "src/spi_macros.svh"
   
   export spi_pkg_hdl::*;
   
 

   // Parameters defined as HVL parameters

   `include "src/spi_typedefs.svh"
   `include "src/spi_transaction.svh"

   `include "src/spi_configuration.svh"
   `include "src/spi_driver.svh"
   `include "src/spi_monitor.svh"

   `include "src/spi_transaction_coverage.svh"
   `include "src/spi_sequence_base.svh"
   `include "src/spi_random_sequence.svh"

   `include "src/spi_responder_sequence.svh"
   `include "src/spi2reg_adapter.svh"

   `include "src/spi_agent.svh"

   // pragma uvmf custom package_item_additional begin
   `include "src/spi_mem_slave_transaction.svh"
   `include "src/spi_mem_slave_transaction_coverage.svh"
   `include "src/spi_mem_slave_transaction_viewer.svh"

   `include "src/spi_master_seq.svh"
   `include "src/spi_mem_slave_seq.svh"




   // pragma uvmf custom package_item_additional end

endpackage

