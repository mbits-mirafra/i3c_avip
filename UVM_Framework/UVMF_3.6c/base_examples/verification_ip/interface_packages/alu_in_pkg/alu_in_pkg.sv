//----------------------------------------------------------------------
//   Copyright 2013 Mentor Graphics Corporation
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//                   Mentor Graphics Inc
//----------------------------------------------------------------------
// Project         : alu_in interface agent
// Unit            : package definition
// File            : alu_in_pkg.sv
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This file defines all of the files contained in the 
//    interface package. It lists all class based content in the
//    package then lists the interfaces. Interfaces and other static
//    components can not be defined in a package. This package is 
//    used when running simulation only without use of Veloce.
//----------------------------------------------------------------------
package alu_in_pkg;

   import uvm_pkg::*;
   import uvmf_base_pkg_hdl::*;
   import uvmf_base_pkg::*;
   import alu_in_pkg_hdl::*;
   `include "uvm_macros.svh"
   
   export alu_in_pkg_hdl::*;

   `include "src/alu_in_typedefs.svh"
   `include "src/alu_in_transaction.svh"

   `include "src/alu_in_configuration.svh"
   `include "src/alu_in_driver.svh"
   `include "src/alu_in_monitor.svh"

   `include "src/alu_in_transaction_coverage.svh"
   `include "src/alu_in_sequence_base.svh"
   `include "src/alu_in_reset_sequence.svh"
   `include "src/alu_in_random_sequence.svh"
   // For Vista Stimulus Generator
   `ifdef USE_VISTA
       `include "src/uvmc_vista_stimulus_bridge.svh"
       `include "src/alu_vista_in_sequence.svh"
   `endif


   typedef uvmf_parameterized_agent #(alu_in_configuration, alu_in_driver, alu_in_monitor, alu_in_transaction_coverage, alu_in_transaction) alu_in_agent_t;

endpackage
