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
// Project         : AHB to SPI Example
// Unit            : Package declaration
// File            : ahb2spi_env_pkg.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This package contains the reusable environment for the
//     AHB to SPI example.  This example demonstrates BLOCK to CHIP 
//     environment reuse of the ahb2wb and wb2spi environments.
//
//----------------------------------------------------------------------
//
package ahb2spi_env_pkg;

import uvm_pkg::*;
import questa_uvm_pkg::*;
`include "uvm_macros.svh"

import uvmf_base_pkg::*;
import wb_pkg::*;
import ahb2wb_env_pkg::*;
import wb2spi_env_pkg::*;
import ahb2spi_reg_pkg::*;

   `include "src/ahb2spi_configuration.svh"
   `include "src/ahb2spi_environment.svh"
   `include  "src/ahb2spi_env_sequence_base.svh"

endpackage
