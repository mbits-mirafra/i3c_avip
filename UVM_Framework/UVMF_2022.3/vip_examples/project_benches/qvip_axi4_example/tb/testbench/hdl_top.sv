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
import uvm_pkg::*;
import uvmf_base_pkg_hdl::*;
import qvip_axi4_bench_parameters_pkg::*;

module hdl_top;

  bit clk;
  bit resetn;
  wire ACLK;
  wire ARESETn;
  wire AWVALID;
  wire [((TEST_AXI4_ADDRESS_WIDTH) - 1):0]  AWADDR;
  wire [2:0] AWPROT;
  wire [3:0] AWREGION;
  wire [7:0] AWLEN;
  wire [2:0] AWSIZE;
  wire [1:0] AWBURST;
  wire AWLOCK;
  wire [3:0] AWCACHE;
  wire [3:0] AWQOS;
  wire [((TEST_AXI4_ID_WIDTH) - 1):0]  AWID;
  wire [((TEST_AXI4_USER_WIDTH) - 1):0]  AWUSER;
  wire AWREADY;
  wire ARVALID;
  wire [((TEST_AXI4_ADDRESS_WIDTH) - 1):0]  ARADDR;
  wire [2:0] ARPROT;
  wire [3:0] ARREGION;
  wire [7:0] ARLEN;
  wire [2:0] ARSIZE;
  wire [1:0] ARBURST;
  wire ARLOCK;
  wire [3:0] ARCACHE;
  wire [3:0] ARQOS;
  wire [((TEST_AXI4_ID_WIDTH) - 1):0]  ARID;
  wire [((TEST_AXI4_USER_WIDTH) - 1):0]  ARUSER;
  wire ARREADY;
  wire RVALID;
  wire [((TEST_AXI4_RDATA_WIDTH) - 1):0]  RDATA;
  wire [1:0] RRESP;
  wire RLAST;
  wire [((TEST_AXI4_ID_WIDTH) - 1):0]  RID;
  wire [((TEST_AXI4_USER_WIDTH) - 1):0]  RUSER;
  wire RREADY;
  wire WVALID;
  wire [((TEST_AXI4_WDATA_WIDTH) - 1):0]  WDATA;
  wire [(((TEST_AXI4_WDATA_WIDTH / 8)) - 1):0]  WSTRB;
  wire WLAST;
  wire [((TEST_AXI4_USER_WIDTH) - 1):0]  WUSER;
  wire WREADY;
  wire BVALID;
  wire [1:0] BRESP;
  wire [((TEST_AXI4_ID_WIDTH) - 1):0]  BID;
  wire [((TEST_AXI4_USER_WIDTH) - 1):0]  BUSER;
  wire BREADY;

  assign ACLK = clk;
  assign ARESETn = resetn;

  typedef virtual mgc_axi4 #(TEST_AXI4_ADDRESS_WIDTH,TEST_AXI4_RDATA_WIDTH,TEST_AXI4_WDATA_WIDTH,TEST_AXI4_ID_WIDTH,TEST_AXI4_USER_WIDTH,TEST_AXI4_REGION_MAP_SIZE ) axi4_if_t;

  // Instantiating the axi4 interfaces, using the modules which export the wires of the interface to enable old-style Verilog connection 

  // QVIP AXI4 Master instance via instantiation of QVIP connectivity module "axi4_master"
  axi4_master #( .ADDR_WIDTH      (TEST_AXI4_ADDRESS_WIDTH),
                 .RDATA_WIDTH     (TEST_AXI4_RDATA_WIDTH),
                 .WDATA_WIDTH     (TEST_AXI4_WDATA_WIDTH),
                 .ID_WIDTH        (TEST_AXI4_ID_WIDTH),
                 .USER_WIDTH      (TEST_AXI4_USER_WIDTH),
                 .REGION_MAP_SIZE (TEST_AXI4_REGION_MAP_SIZE),
                 .PATH_NAME       (UVMF_VIRTUAL_INTERFACES),
                 .IF_NAME         (MASTER_INTERFACE_BFM) 
               )
                 master(.ACLK(ACLK),
                        .ARESETn(ARESETn),
                        .AWVALID(AWVALID), 
                        .AWADDR(AWADDR), 
                        .AWPROT(AWPROT), 
                        .AWREGION(AWREGION), 
                        .AWLEN(AWLEN), 
                        .AWSIZE(AWSIZE), 
                        .AWBURST(AWBURST), 
                        .AWLOCK(AWLOCK), 
                        .AWCACHE(AWCACHE), 
                        .AWQOS(AWQOS), 
                        .AWID(AWID), 
                        .AWUSER(AWUSER), 
                        .AWREADY(AWREADY),
                        .ARVALID(ARVALID), 
                        .ARADDR(ARADDR), 
                        .ARPROT(ARPROT), 
                        .ARREGION(ARREGION), 
                        .ARLEN(ARLEN), 
                        .ARSIZE(ARSIZE), 
                        .ARBURST(ARBURST), 
                        .ARLOCK(ARLOCK), 
                        .ARCACHE(ARCACHE), 
                        .ARQOS(ARQOS), 
                        .ARID(ARID), 
                        .ARUSER(ARUSER), 
                        .ARREADY(ARREADY),
                        .RVALID(RVALID),
                        .RDATA(RDATA),
                        .RRESP(RRESP), 
                        .RLAST(RLAST),
                        .RID(RID), 
                        .RUSER(RUSER), 
                        .RREADY(RREADY),
                        .WVALID(WVALID), 
                        .WDATA(WDATA), 
                        .WSTRB(WSTRB), 
                        .WLAST(WLAST), 
                        .WUSER(WUSER), 
                        .WREADY(WREADY),
                        .BVALID(BVALID), 
                        .BRESP(BRESP), 
                        .BID(BID), 
                        .BUSER(BUSER),
                        .BREADY(BREADY));

  // QVIP AXI4 Slave instance via instantiation of QVIP connectivity module "axi4_slave"
  axi4_slave #(  .ADDR_WIDTH      (TEST_AXI4_ADDRESS_WIDTH),
                 .RDATA_WIDTH     (TEST_AXI4_RDATA_WIDTH),
                 .WDATA_WIDTH     (TEST_AXI4_WDATA_WIDTH),
                 .ID_WIDTH        (TEST_AXI4_ID_WIDTH),
                 .USER_WIDTH      (TEST_AXI4_USER_WIDTH),
                 .REGION_MAP_SIZE (TEST_AXI4_REGION_MAP_SIZE),
                 .PATH_NAME       (UVMF_VIRTUAL_INTERFACES),
                 .IF_NAME         (SLAVE_INTERFACE_BFM)
              )
                DUT  ( .ACLK(ACLK),
                       .ARESETn(ARESETn),
                       .AWVALID(AWVALID),
                       .AWADDR(AWADDR),
                       .AWPROT(AWPROT),
                       .AWREGION(AWREGION),
                       .AWLEN(AWLEN),
                       .AWSIZE(AWSIZE),
                       .AWBURST(AWBURST),
                       .AWLOCK(AWLOCK),
                       .AWCACHE(AWCACHE),
                       .AWQOS(AWQOS),
                       .AWID(AWID),
                       .AWUSER(AWUSER),
                       .AWREADY(AWREADY),
                       .ARVALID(ARVALID),
                       .ARADDR(ARADDR),
                       .ARPROT(ARPROT),
                       .ARREGION(ARREGION),
                       .ARLEN(ARLEN),
                       .ARSIZE(ARSIZE),
                       .ARBURST(ARBURST),
                       .ARLOCK(ARLOCK),
                       .ARCACHE(ARCACHE),
                       .ARQOS(ARQOS),
                       .ARID(ARID),
                       .ARUSER(ARUSER),
                       .ARREADY(ARREADY),
                       .RVALID(RVALID),
                       .RDATA(RDATA),
                       .RRESP(RRESP),
                       .RLAST(RLAST),
                       .RID(RID),
                       .RUSER(RUSER),
                       .RREADY(RREADY),
                       .WVALID(WVALID),
                       .WDATA(WDATA),
                       .WSTRB(WSTRB),
                       .WLAST(WLAST),
                       .WUSER(WUSER),
                       .WREADY(WREADY),
                       .BVALID(BVALID),
                       .BRESP(BRESP),
                       .BID(BID),
                       .BUSER(BUSER),
                       .BREADY(BREADY));

  // QVIP AXI4 Monitor instance via instantiation of QVIP connectivity module "axi4_monitor"
  axi4_monitor #(  .ADDR_WIDTH      (TEST_AXI4_ADDRESS_WIDTH),
                   .RDATA_WIDTH     (TEST_AXI4_RDATA_WIDTH),
                   .WDATA_WIDTH     (TEST_AXI4_WDATA_WIDTH),
                   .ID_WIDTH        (TEST_AXI4_ID_WIDTH),
                   .USER_WIDTH      (TEST_AXI4_USER_WIDTH),
                   .REGION_MAP_SIZE (TEST_AXI4_REGION_MAP_SIZE),
                   .PATH_NAME       (UVMF_VIRTUAL_INTERFACES),
                   .IF_NAME         (MONITOR_INTERFACE_BFM)
                )
                monitor( .ACLK(ACLK),
                         .ARESETn(ARESETn),
                         .AWVALID(AWVALID),
                         .AWADDR(AWADDR),
                         .AWPROT(AWPROT),
                         .AWREGION(AWREGION),
                         .AWLEN(AWLEN),
                         .AWSIZE(AWSIZE),
                         .AWBURST(AWBURST),
                         .AWLOCK(AWLOCK),
                         .AWCACHE(AWCACHE),
                         .AWQOS(AWQOS),
                         .AWID(AWID),
                         .AWUSER(AWUSER),
                         .AWREADY(AWREADY),
                         .ARVALID(ARVALID),
                         .ARADDR(ARADDR),
                         .ARPROT(ARPROT),
                         .ARREGION(ARREGION),
                         .ARLEN(ARLEN),
                         .ARSIZE(ARSIZE),
                         .ARBURST(ARBURST),
                         .ARLOCK(ARLOCK),
                         .ARCACHE(ARCACHE),
                         .ARQOS(ARQOS),
                         .ARID(ARID),
                         .ARUSER(ARUSER),
                         .ARREADY(ARREADY),
                         .RVALID(RVALID),
                         .RDATA(RDATA),
                         .RRESP(RRESP),
                         .RLAST(RLAST),
                         .RID(RID),
                         .RUSER(RUSER),
                         .RREADY(RREADY),
                         .WVALID(WVALID),
                         .WDATA(WDATA),
                         .WSTRB(WSTRB),
                         .WLAST(WLAST),
                         .WUSER(WUSER),
                         .WREADY(WREADY),
                         .BVALID(BVALID),
                         .BRESP(BRESP),
                         .BID(BID),
                         .BUSER(BUSER),
                         .BREADY(BREADY));

  // clock generator
  initial forever clk = #(5) ~clk;

  // reset generator
  initial resetn <= #(5000) 1'b1;

  initial begin
     // Placing the associated mgc_axi4 interfaces within the uvm_config_db is provided for within the connectivity modules.
  end 

endmodule

