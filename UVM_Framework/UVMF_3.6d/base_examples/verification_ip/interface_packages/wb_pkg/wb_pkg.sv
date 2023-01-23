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
// Project         : Wishbone interface agent
// Unit            : WB hvl package definition
// File            : wb_pkg.sv
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This file defines all of the files contained in the 
//    interface package that need to be compiled for running on
//    the host server when using Veloce. 
//
//----------------------------------------------------------------------

package wb_pkg;

   import uvm_pkg::*;
   import questa_uvm_pkg::*;
   import uvmf_base_pkg_hdl::*;
   import uvmf_base_pkg::*;
   import wb_pkg_hdl::*;
   `include "uvm_macros.svh"
   
   export wb_pkg_hdl::*;

   `include "src/wb_typedefs.svh"
   `include "src/wb_transaction.svh"

   `include "src/wb_configuration.svh"
   `include "src/wb_driver.svh"
   `include "src/wb_monitor.svh"

   `include "src/wb_transaction_coverage.svh"
   `include "src/wb_sequence_base.svh"
   `include "src/wb_reset_sequence.svh"
   `include "src/wb_master_access_sequence.svh"
   `include "src/wb_slave_access_sequence.svh"
   `include "src/wb_memory_slave_sequence.svh"
   `include "src/wb2reg_adapter.svh"

   typedef uvm_reg_predictor #(wb_transaction) wb2reg_predictor;
   typedef uvmf_parameterized_agent #(wb_configuration, wb_driver, wb_monitor, wb_transaction_coverage, wb_transaction) wb_agent_t;

endpackage
