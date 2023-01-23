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
// Project         : GPIO Example
// Unit            : GPIO Example environment package declaration
// File            : gpio_example_env_pkg.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This package contains the gpio example environment and
//     configuration.  These classes are reusable from block to chip
//     level simulations.
//
//----------------------------------------------------------------------
//
package gpio_example_env_pkg;

import uvm_pkg::*;
import questa_uvm_pkg::*;
`include "uvm_macros.svh"

import uvmf_base_pkg::*;
import gpio_pkg::*;

   `include "src/gpio_example_configuration.svh"
   `include "src/gpio_example_environment.svh"
   `include  "src/gpio_example_env_sequence_base.svh"

endpackage
