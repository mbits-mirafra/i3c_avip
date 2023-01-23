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
// Project         : AHB to WB Block Level Environment
// Unit            : Package definition
// File            : ahb2wb_env_pkg.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This package includes all class definitions used in 
//    the ahb to wb environment package.  This environment is reusable
//    from block to chip to system level simulatins without modification.
//
//----------------------------------------------------------------------
//
package ahb2wb_env_pkg;

   import uvm_pkg::*;
   import questa_uvm_pkg::*;
   `include "uvm_macros.svh"

   import uvmf_base_pkg::*;
   import wb_pkg::*;
   import ahb_pkg::*;
   export ahb_pkg::ahb2reg_adapter;

   `include "src/ahb2wb_configuration.svh"
   `include "src/ahb2wb_predictor.svh"
   `include "src/wb2ahb_predictor.svh"
   `include "src/ahb2wb_environment.svh"
   `include  "src/ahb2wb_env_sequence_base.svh"

endpackage
