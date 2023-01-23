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
// Unit            : hvl_top
// File            : hvl_top.svh
//----------------------------------------------------------------------
// Created by      : 
// Creation Date   : 
//----------------------------------------------------------------------

// Description: This top level module 
//
//----------------------------------------------------------------------
//

import uvm_pkg::*;
import uvmf_base_pkg::*;
import vip_axi4_bench_parameters_pkg::*;
import vip_axi4_bench_test_pkg::*;

module hvl_top;

  mgc_axi4_master_hvl #(
    .ADDR_WIDTH(TEST_AXI4_ADDRESS_WIDTH),
    .RDATA_WIDTH(TEST_AXI4_RDATA_WIDTH),
    .WDATA_WIDTH(TEST_AXI4_WDATA_WIDTH),
    .ID_WIDTH(TEST_AXI4_ID_WIDTH),
    .USER_WIDTH(TEST_AXI4_USER_WIDTH),
    .REGION_MAP_SIZE(TEST_AXI4_REGION_MAP_SIZE),
    .VIP_IF_UVM_NAME(MASTER_INTERFACE_BFM),
    .VIP_IF_UVM_CONTEXT(UVMF_VIRTUAL_INTERFACES),
    .VIP_IF_HDL_PATH("hdl_top.axi4_master")
  ) axi4_master ();

  mgc_axi4_slave_hvl #(
    .ADDR_WIDTH(TEST_AXI4_ADDRESS_WIDTH),
    .RDATA_WIDTH(TEST_AXI4_RDATA_WIDTH),
    .WDATA_WIDTH(TEST_AXI4_WDATA_WIDTH),
    .ID_WIDTH(TEST_AXI4_ID_WIDTH),
    .USER_WIDTH(TEST_AXI4_USER_WIDTH),
    .REGION_MAP_SIZE(TEST_AXI4_REGION_MAP_SIZE),
    .VIP_IF_UVM_NAME(SLAVE_INTERFACE_BFM),
    .VIP_IF_UVM_CONTEXT(UVMF_VIRTUAL_INTERFACES),
    .VIP_IF_HDL_PATH("hdl_top.DUT")
  ) axi4_slave ();

  mgc_axi4_monitor_hvl #(
    .ADDR_WIDTH(TEST_AXI4_ADDRESS_WIDTH),
    .RDATA_WIDTH(TEST_AXI4_RDATA_WIDTH),
    .WDATA_WIDTH(TEST_AXI4_WDATA_WIDTH),
    .ID_WIDTH(TEST_AXI4_ID_WIDTH),
    .USER_WIDTH(TEST_AXI4_USER_WIDTH),
    .REGION_MAP_SIZE(TEST_AXI4_REGION_MAP_SIZE),
    .VIP_IF_UVM_NAME(MONITOR_INTERFACE_BFM),
    .VIP_IF_UVM_CONTEXT(UVMF_VIRTUAL_INTERFACES),
    .VIP_IF_HDL_PATH("hdl_top.axi4_monitor")
  ) axi4_monitor ();

initial run_test();

endmodule

