//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Nov 30
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : gpio_example environment agent
// Unit            : Environment HVL package
// File            : gpio_example_pkg.sv
//----------------------------------------------------------------------
//     
// PACKAGE: This file defines all of the files contained in the
//    environment package that will run on the host simulator.
//
// CONTAINS:
//     - <gpio_example_configuration.svh>
//     - <gpio_example_environment.svh>
//     - <gpio_example_env_sequence_base.svh>
//     - <gpio_example_infact_env_sequence.svh>
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
package gpio_example_env_pkg;

   import uvm_pkg::*;
   import questa_uvm_pkg::*;
   `include "uvm_macros.svh"

   import uvmf_base_pkg::*;
   import gpio_pkg::*;




   `include "src/gpio_example_env_configuration.svh"
   `include "src/gpio_example_environment.svh"
   `include "src/gpio_example_env_sequence_base.svh"
   `include "src/gpio_example_infact_env_sequence.svh"
  
endpackage

