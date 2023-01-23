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
// Project         : AHB to SPI Project Bench
// Unit            : Sequence Package
// File            : ahb2spi_sequences_pkg.sv
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This package includes all high level sequence classes used 
//     in the environment.  These include utility sequences and top
//     level sequences.
//
//----------------------------------------------------------------------
//
package ahb2spi_sequences_pkg;

   import uvm_pkg::*;
   import questa_uvm_pkg::*;
   import uvmf_base_pkg::*;
   import ahb_pkg::*;
   import spi_pkg::*;
   import ahb2spi_parameters_pkg::*;
   import ahb2spi_env_pkg::*;
   import ahb2spi_reg_pkg::*;
  
   `include "uvm_macros.svh"

   `include "src/ahb2spi_sequence_base.svh"
   `include "src/example_derived_test_sequence.svh"
   `include "src/ahb2spi_regmodel_sequence.svh"

endpackage
