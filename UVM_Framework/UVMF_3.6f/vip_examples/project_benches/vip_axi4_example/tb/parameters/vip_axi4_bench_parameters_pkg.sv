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
// Unit            : vip_axi4_bench_parameters_pkg
// File            : vip_axi4_bench_parameters_pkg.svh
//----------------------------------------------------------------------
// Created by      : student
// Creation Date   : 2014/11/03
//----------------------------------------------------------------------

// Description: This package contains all parameterss currently written for
//     the simulation project. 
//
package vip_axi4_bench_parameters_pkg;

  // Constant: AXI4_ADDRESS_WIDTH
  // The AXI4 read and write address bus widths (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.2)
  parameter TEST_AXI4_ADDRESS_WIDTH = 32;

  // Constant: AXI4_RDATA_WIDTH
  // The width of the RDATA signals (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.6).
  parameter TEST_AXI4_RDATA_WIDTH   = 32;

  // Constant: AXI4_WDATA_WIDTH
  // The width of the WDATA signals (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.6).
  parameter TEST_AXI4_WDATA_WIDTH   = 32;

  // Constant: AXI4_ID_WIDTH
  // The width of the AWID/ARID signals (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.2).
  parameter TEST_AXI4_ID_WIDTH      = 8;

  // Constant: AXI4_USER_WIDTH
  // The width of the AWUSER, ARUSER, WUSER, RUSER and BUSER signals (see AMBA AXI and ACE Protocol Specification IHI0022D section A8.3)
  parameter TEST_AXI4_USER_WIDTH    = 2;

  // Constant: AXI4_REGION_MAP_SIZE
  // The number of address-decode entries in the region map (see AMBA AXI and ACE Protocol Specification IHI0022D section A8.2.1)
  // The address-decode function is done by the interconnect, generating a value for AWREGION/AREGION from the transaction address.
  // This parameter defines the size of the entries in the region map array, where each entry defines a mapping from address-range to region value.
  // See <config_region> for details of how it is used.

  parameter TEST_AXI4_REGION_MAP_SIZE = 16;

  // Constant: s_axi4_master_if_id 
  // A string used in registration and look-up of the <mgc_axi4> in the ~axi4_master_module~ during testbench configuration.
  parameter string MASTER_INTERFACE_BFM = "axi4_master_IF";

  // Constant: s_axi4_slave_if_id 
  // A string used in registration and look-up of the <mgc_axi4> in the ~axi4_slave_module~ during testbench configuration.
  parameter string SLAVE_INTERFACE_BFM = "axi4_slave_IF";

  // Constant: s_axi4_monitor_if_id 
  // A string used in registration and look-up of the <mgc_axi4> in the ~axi4_slave_module~ during testbench configuration.
  parameter string MONITOR_INTERFACE_BFM = "axi4_monitor_IF";

endpackage

