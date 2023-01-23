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
//    - <gpio_typedefs_hdl>
//    - <gpio_typedefs.svh>
//    - <gpio_transaction.svh>

//    - <gpio_configuration.svh>
//    - <gpio_driver.svh>
//    - <gpio_monitor.svh>

//    - <gpio_transaction_coverage.svh>
//    - <gpio_sequence_base.svh>
//    - <gpio_random_sequence.svh>

//    - <gpio_responder_sequence.svh>
//    - <gpio2reg_adapter.svh>
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
package gpio_pkg;
  
   import uvm_pkg::*;
   import uvmf_base_pkg_hdl::*;
   import uvmf_base_pkg::*;
   import gpio_pkg_hdl::*;

   `include "uvm_macros.svh"

   // pragma uvmf custom package_imports_additional begin 
   // pragma uvmf custom package_imports_additional end

   `include "src/gpio_macros.svh"
   
   export gpio_pkg_hdl::*;
   
 

   // Parameters defined as HVL parameters

   `include "src/gpio_typedefs.svh"
   `include "src/gpio_transaction.svh"

   `include "src/gpio_configuration.svh"
   `include "src/gpio_driver.svh"
   `include "src/gpio_monitor.svh"

   `include "src/gpio_transaction_coverage.svh"
   `include "src/gpio_sequence_base.svh"
   `include "src/gpio_random_sequence.svh"

   `include "src/gpio_responder_sequence.svh"
   `include "src/gpio2reg_adapter.svh"

   `include "src/gpio_agent.svh"

   // pragma uvmf custom package_item_additional begin
   // UVMF_CHANGE_ME : When adding new interface sequences to the src directory
   //    be sure to add the sequence file here so that it will be
   //    compiled as part of the interface package.  Be sure to place
   //    the new sequence after any base sequences of the new sequence.
   `include "src/gpio_sequence.svh"
   // pragma uvmf custom package_item_additional end

endpackage

