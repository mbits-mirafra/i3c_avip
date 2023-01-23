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
// Project         : QVIP Utilities Package
// Unit            : Package definition
// File            : qvip_utils_pkg.sv
//----------------------------------------------------------------------
// Creation Date   : 01.21.2013
//----------------------------------------------------------------------
// Description: This package includes all class definitions used to
//     encapsulate Questa VIP and provide adapters to custom environment
//     tranactions and components.
//
//----------------------------------------------------------------------
//
package qvip_utils_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

import mvc_pkg::*;

import uvmf_base_pkg::*;

   `include "src/qvip_agent_adapter.svh"
   `include "src/qvip_memory_agent.svh"
   `include "src/qvip_report_catcher.svh"

endpackage
