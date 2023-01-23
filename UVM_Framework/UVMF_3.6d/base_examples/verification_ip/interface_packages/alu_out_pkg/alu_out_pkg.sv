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
// Project         : alu_out outterface agent
// Unit            : package defoutition
// File            : alu_out_pkg.sv
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This file defines all of the files contained in the 
//    interface package. It lists all class based content in the
//    package then lists the interfaces. Interfaces and other static
//    components can not be defined in a package. This package is 
//    used when running simulation only without use of Veloce.
//----------------------------------------------------------------------
//
package alu_out_pkg;

   import uvm_pkg::*;
   import uvmf_base_pkg_hdl::*;
   import uvmf_base_pkg::*;
   import alu_out_pkg_hdl::*;
   `include "uvm_macros.svh"
 
   export alu_out_pkg_hdl::*;

   `include "src/alu_out_typedefs.svh"
   `include "src/alu_out_transaction.svh"

   `include "src/alu_out_configuration.svh"
   `include "src/alu_out_driver.svh"
   `include "src/alu_out_monitor.svh"

   `include "src/alu_out_transaction_coverage.svh"
   `include "src/alu_out_sequence_base.svh"

   typedef uvmf_parameterized_agent #(alu_out_configuration, alu_out_driver, alu_out_monitor, alu_out_transaction_coverage, alu_out_transaction) alu_out_agent_t;

endpackage
