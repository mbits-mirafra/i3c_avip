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
// Project         : AHB interface agent
// Unit            : AHB hvl package definition
// File            : ahb_pkg.sv
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This file defines all of the files contained in the 
//    interface package that need to be compiled for running on
//    the host server when using Veloce. 
//
//----------------------------------------------------------------------

package ahb_pkg;

   import uvm_pkg::*;
   import uvmf_base_pkg_hdl::*;
   import uvmf_base_pkg::*;
   import ahb_pkg_hdl::*;
   `include "uvm_macros.svh"
 
   export ahb_pkg_hdl::*;

   `include "src/ahb_typedefs.svh"
   `include "src/ahb_transaction.svh"

   `include "src/ahb_configuration.svh"
   `include "src/ahb_driver.svh"
   `include "src/ahb_monitor.svh"

   `include "src/ahb_transaction_coverage.svh"
   `include "src/ahb_sequence_base.svh"
   `include "src/ahb_reset_sequence.svh"
   `include "src/ahb_random_sequence.svh"
   `include "src/ahb_master_access_sequence.svh"
   `include "src/ahb2reg_adapter.svh"

   typedef uvmf_parameterized_agent #(ahb_configuration, ahb_driver, ahb_monitor, ahb_transaction_coverage, ahb_transaction) ahb_agent_t;

endpackage
