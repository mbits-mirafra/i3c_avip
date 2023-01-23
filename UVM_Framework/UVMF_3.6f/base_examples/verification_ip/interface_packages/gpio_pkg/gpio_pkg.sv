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
// Project         : gpio interface agent
// Unit            : package definition
// File            : gpio_pkg.sv
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
package gpio_pkg;

   import uvm_pkg::*;
   import questa_uvm_pkg::*;
   import uvmf_base_pkg_hdl::*;
   import uvmf_base_pkg::*;
   import gpio_pkg_hdl::*;

   `include "uvm_macros.svh"
   
   export gpio_pkg_hdl::*;

   `include "src/gpio_typedefs.svh"
   `include "src/gpio_transaction.svh"

   `include "src/gpio_configuration.svh"
   `include "src/gpio_driver.svh"
   `include "src/gpio_monitor.svh"
   `include "src/gpio_transaction_coverage.svh"
   `include "src/gpio_agent.svh"

   `include "src/gpio_sequence_base.svh"
   `include "src/gpio_random_sequence.svh"
   `include "src/gpio_sequence.svh"

endpackage
