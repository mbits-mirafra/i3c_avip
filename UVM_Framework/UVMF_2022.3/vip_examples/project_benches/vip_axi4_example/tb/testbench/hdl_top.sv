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
// Unit            : hdl_top
// File            : hdl_top.svh
//----------------------------------------------------------------------
// Created by      : student
// Creation Date   : 2014/11/03
//----------------------------------------------------------------------

// Description: This top level module instantiates all synthesizable
//    static content.  This and tb_top.sv are the two top level modules
//    of the simulation.  
//
//    This module instantiates the following:
//        DUT: The Design Under Test
//        Interfaces:  Signal bundles that contain signals connected to DUT
//        Driver BFM's: BFM's that actively drive interface signals
//        Monitor BFM's: BFM's that passively monitor interface signals
//
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import vip_axi4_bench_parameters_pkg::*;

module hdl_top; //pragma attribute hdl_top partition_module_xrtl

  bit clk;
  bit resetn;

  // tbx clkgen
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // tbx clkgen
  initial begin
    resetn = 0;
    #5000 resetn = 1'b1;
  end

  mgc_axi4_signal_if #(
    .ADDR_WIDTH(TEST_AXI4_ADDRESS_WIDTH),
    .RDATA_WIDTH(TEST_AXI4_RDATA_WIDTH),
    .WDATA_WIDTH(TEST_AXI4_WDATA_WIDTH),
    .ID_WIDTH(TEST_AXI4_ID_WIDTH),
    .USER_WIDTH(TEST_AXI4_USER_WIDTH),
    .REGION_MAP_SIZE(TEST_AXI4_REGION_MAP_SIZE)
  ) axi4_if (clk, resetn);

  mgc_axi4_master_hdl #(
    .ADDR_WIDTH(TEST_AXI4_ADDRESS_WIDTH),
    .RDATA_WIDTH(TEST_AXI4_RDATA_WIDTH),
    .WDATA_WIDTH(TEST_AXI4_WDATA_WIDTH),
    .ID_WIDTH(TEST_AXI4_ID_WIDTH),
    .USER_WIDTH(TEST_AXI4_USER_WIDTH),
    .REGION_MAP_SIZE(TEST_AXI4_REGION_MAP_SIZE),
    .VIP_IF_UVM_NAME(MASTER_INTERFACE_BFM),
    .VIP_IF_UVM_CONTEXT(UVMF_VIRTUAL_INTERFACES)
  ) axi4_master (.pin_if(axi4_if));

  mgc_axi4_slave_hdl #(
    .ADDR_WIDTH(TEST_AXI4_ADDRESS_WIDTH),
    .RDATA_WIDTH(TEST_AXI4_RDATA_WIDTH),
    .WDATA_WIDTH(TEST_AXI4_WDATA_WIDTH),
    .ID_WIDTH(TEST_AXI4_ID_WIDTH),
    .USER_WIDTH(TEST_AXI4_USER_WIDTH),
    .REGION_MAP_SIZE(TEST_AXI4_REGION_MAP_SIZE),
    .VIP_IF_UVM_NAME(SLAVE_INTERFACE_BFM),
    .VIP_IF_UVM_CONTEXT(UVMF_VIRTUAL_INTERFACES)
  ) DUT (.pin_if(axi4_if));

  mgc_axi4_monitor_hdl #(
    .ADDR_WIDTH(TEST_AXI4_ADDRESS_WIDTH),
    .RDATA_WIDTH(TEST_AXI4_RDATA_WIDTH),
    .WDATA_WIDTH(TEST_AXI4_WDATA_WIDTH),
    .ID_WIDTH(TEST_AXI4_ID_WIDTH),
    .USER_WIDTH(TEST_AXI4_USER_WIDTH),
    .REGION_MAP_SIZE(TEST_AXI4_REGION_MAP_SIZE),
    .VIP_IF_UVM_NAME(MONITOR_INTERFACE_BFM),
    .VIP_IF_UVM_CONTEXT(UVMF_VIRTUAL_INTERFACES)
  ) axi4_monitor (.pin_if(axi4_if));

endmodule
