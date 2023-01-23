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
// Project         : Self contained AHB memory slave
// Unit            : AHB Memory slave
// File            : ahb_memory_slave.svh
//----------------------------------------------------------------------
// Creation Date   : 01.09.2013
//----------------------------------------------------------------------
// Description: 
// This module is a self-contained MVC slave module for AHB. The user 
// can connect this module to an AHB bus and use it to stimulate the 
// bus for the slave side. 
//
// This module creates an AHB MVC interface and connects the interface 
// to the ports of the module.  It also creates the mvc_agent and the 
// ahb_vip_config for the agent.
//
// This module automatically starts the ahb_slave_sequence on the 
// sequencer in the agent to model memory slave behavior.
//
//----------------------------------------------------------------------
//

module ahb_memory_slave_module_hdl(mgc_ahb_signal_if ahb_if);
//pragma attribute ahb_memory_slave_module_hdl partition_module_xrtl

  parameter AHB_NUM_MASTERS     = 1;
  parameter AHB_NUM_MASTER_BITS = 1;
  parameter AHB_NUM_SLAVES      = 1;
  parameter AHB_ADDRESS_WIDTH   = 32;
  parameter AHB_WDATA_WIDTH     = 32;
  parameter AHB_RDATA_WIDTH     = 32;
  parameter AHB_SLAVE_INDEX     = 0;

  mgc_ahb_slave_hdl #(
    .NUM_MASTERS(AHB_NUM_MASTERS),
    .NUM_MASTER_BITS(AHB_NUM_MASTER_BITS),
    .NUM_SLAVES(AHB_NUM_SLAVES),
    .ADDRESS_WIDTH(AHB_ADDRESS_WIDTH),
    .WDATA_WIDTH(AHB_WDATA_WIDTH),
    .RDATA_WIDTH(AHB_RDATA_WIDTH),
    .VIP_IF_UVM_NAME(""/*VIP_AHB_BFM_SLV*/),
    .VIP_IF_UVM_CONTEXT(""/*UVMF_VIRTUAL_INTERFACES*/)
  ) slave (.pin_if(ahb_if));

  assign ahb_if.decoder_HSEL[AHB_SLAVE_INDEX] = 1'b1;

`ifdef AHB_MEMORY_SLAVE_QVL_MONITOR

  qvl_ahb_target_monitor #(0, AHB_WDATA_WIDTH, 1, 0)  tar_mon_0
  (
    .hselx(ahb_if.slave_HSEL[AHB_SLAVE_INDEX]),
    .haddr(ahb_if.master_HADDR[AHB_SLAVE_INDEX]),
    .hwrite(ahb_if.master_HWRITE[AHB_SLAVE_INDEX]),
    .htrans(ahb_if.master_HTRANS[AHB_SLAVE_INDEX]),
    .hsize(ahb_if.master_HSIZE[AHB_SLAVE_INDEX]),
    .hburst(ahb_if.master_HBURST[AHB_SLAVE_INDEX]),
    .hwdata(ahb_if.master_HWDATA[AHB_SLAVE_INDEX]),
    .hresetn(ahb_if.HRESETn),
    .hclk(ahb_if.HCLK),
    .hmaster({3'b000, ahb_if.HMASTER}),
    .hmastlock(ahb_if.arbiter_HMASTLOCK),
    .hready_in(ahb_if.HREADY),
    .hready_out(ahb_if.slave_HREADY[AHB_SLAVE_INDEX]),
    .hresp(ahb_if.slave_HRESP[AHB_SLAVE_INDEX]),
    .hrdata(ahb_if.slave_HRDATA[AHB_SLAVE_INDEX]),
    .hsplitx(ahb_if.slave_HSPLIT[AHB_SLAVE_INDEX]) 
  );

`endif

endmodule
