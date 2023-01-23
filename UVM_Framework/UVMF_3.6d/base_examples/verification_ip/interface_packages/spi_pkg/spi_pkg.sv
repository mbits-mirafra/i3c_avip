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
// Project         : spi interface agent
// Unit            : package definition
// File            : spi_pkg.sv
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This file defines all of the files contained in the 
//    interface package that need to be compiled for running on
//    the host server when using Veloce. 
//----------------------------------------------------------------------
//
package spi_pkg;

   import uvm_pkg::*;
   import uvmf_base_pkg_hdl::*;
   import uvmf_base_pkg::*;
   import spi_pkg_hdl::*;

   `include "uvm_macros.svh"

   export spi_pkg_hdl::*;

   `include "src/spi_typedefs.svh"
   `include "src/spi_transaction.svh"
   `include "src/spi_mem_slave_transaction.svh"

   `include "src/spi_configuration.svh"
   `include "src/spi_driver.svh"
   `include "src/spi_monitor.svh"

   `include "src/spi_transaction_coverage.svh"
   `include "src/spi_mem_slave_transaction_coverage.svh"
   `include "src/spi_mem_slave_transaction_viewer.svh"

   `include "src/spi_sequence_base.svh"
   `include "src/spi_master_seq.svh"
   `include "src/spi_mem_slave_seq.svh"

   typedef uvmf_parameterized_agent #(spi_configuration, spi_driver, spi_monitor, spi_transaction_coverage, spi_transaction) spi_agent_t;


endpackage
