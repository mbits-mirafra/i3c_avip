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
// Project         : UVMF_Templates
// Unit            : vip_axi4_env_pkg
// File            : vip_axi4_env_pkg.svh
//----------------------------------------------------------------------
// Created by      : student
// Creation Date   : 2014/11/03
//----------------------------------------------------------------------


// DESCRIPTION: This package contains all files that define the 
//   environment and its configuration.  These components are 
//   reusable from block to chip level simulation without modification.
//
// CONTAINS:
//   -<vip_axi4_configuration>
//   -<vip_axi4_environment>
//
package vip_axi4_env_pkg;

  import uvm_pkg::*;
  
  `include "uvm_macros.svh"

  import mvc_pkg::*;
  import mgc_axi4_v1_0_pkg::*;
  import addr_map_pkg::*;

  import uvmf_base_pkg_hdl::*;
  import uvmf_base_pkg::*;

  `include "src/vip_axi4_configuration.svh"
  `include "src/vip_axi4_environment.svh"
  `include "src/vip_axi4_env_sequence_base.svh"

endpackage

