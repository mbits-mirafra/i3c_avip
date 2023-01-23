//
// File: DUT.sv
//
// Generated from Mentor VIP Configurator (20160818)
// Generated using Mentor VIP Library ( 10_5b : 09/04/2016:09:24 )
//
import axi4_2x2_fabric_qvip_params_pkg::*;
module DUT
(
    // clock and reset signals
    //
    output                                                ACLK,
    output                                                ARESETn,
    // write address channel signals
    //
    input                                                 AWVALID,
    input  [mgc_axi4_m0_params::AXI4_ADDRESS_WIDTH-1:0]   AWADDR,
    input  [2:0]                                          AWPROT,
    input  [3:0]                                          AWREGION,
    input  [7:0]                                          AWLEN,
    input  [2:0]                                          AWSIZE,
    input  [1:0]                                          AWBURST,
    input                                                 AWLOCK,
    input  [3:0]                                          AWCACHE,
    input  [3:0]                                          AWQOS,
    input  [mgc_axi4_m0_params::AXI4_ID_WIDTH-1:0]        AWID,
    input  [mgc_axi4_m0_params::AXI4_USER_WIDTH-1:0]      AWUSER,
    output                                                AWREADY,
    // read address channel signals
    //
    input                                                 ARVALID,
    input  [mgc_axi4_m0_params::AXI4_ADDRESS_WIDTH-1:0]   ARADDR,
    input  [2:0]                                          ARPROT,
    input  [3:0]                                          ARREGION,
    input  [7:0]                                          ARLEN,
    input  [2:0]                                          ARSIZE,
    input  [1:0]                                          ARBURST,
    input                                                 ARLOCK,
    input  [3:0]                                          ARCACHE,
    input  [3:0]                                          ARQOS,
    input  [mgc_axi4_m0_params::AXI4_ID_WIDTH-1:0]        ARID,
    input  [mgc_axi4_m0_params::AXI4_USER_WIDTH-1:0]      ARUSER,
    output                                                ARREADY,
    // read channel (data) signals
    //
    output                                                RVALID,
    output [mgc_axi4_m0_params::AXI4_RDATA_WIDTH-1:0]     RDATA,
    output [1:0]                                          RRESP,
    output                                                RLAST,
    output [mgc_axi4_m0_params::AXI4_ID_WIDTH-1:0]        RID,
    output [mgc_axi4_m0_params::AXI4_USER_WIDTH-1:0]      RUSER,
    input                                                 RREADY,
    // write channel signals
    //
    input                                                 WVALID,
    input  [mgc_axi4_m0_params::AXI4_WDATA_WIDTH-1:0]     WDATA,
    input  [(mgc_axi4_m0_params::AXI4_WDATA_WIDTH/8)-1:0] WSTRB,
    input                                                 WLAST,
    input  [mgc_axi4_m0_params::AXI4_USER_WIDTH-1:0]      WUSER,
    output                                                WREADY,
    // write response channel signals
    //
    output                                                BVALID,
    output [1:0]                                          BRESP,
    output [mgc_axi4_m0_params::AXI4_ID_WIDTH-1:0]        BID,
    output [mgc_axi4_m0_params::AXI4_USER_WIDTH-1:0]      BUSER,
    input                                                 BREADY,
    // clock and reset signals
    //
    output                                                ACLK_0,
    output                                                ARESETn_0,
    // write address channel signals
    //
    input                                                 AWVALID_0,
    input  [mgc_axi4_m1_params::AXI4_ADDRESS_WIDTH-1:0]   AWADDR_0,
    input  [2:0]                                          AWPROT_0,
    input  [3:0]                                          AWREGION_0,
    input  [7:0]                                          AWLEN_0,
    input  [2:0]                                          AWSIZE_0,
    input  [1:0]                                          AWBURST_0,
    input                                                 AWLOCK_0,
    input  [3:0]                                          AWCACHE_0,
    input  [3:0]                                          AWQOS_0,
    input  [mgc_axi4_m1_params::AXI4_ID_WIDTH-1:0]        AWID_0,
    input  [mgc_axi4_m1_params::AXI4_USER_WIDTH-1:0]      AWUSER_0,
    output                                                AWREADY_0,
    // read address channel signals
    //
    input                                                 ARVALID_0,
    input  [mgc_axi4_m1_params::AXI4_ADDRESS_WIDTH-1:0]   ARADDR_0,
    input  [2:0]                                          ARPROT_0,
    input  [3:0]                                          ARREGION_0,
    input  [7:0]                                          ARLEN_0,
    input  [2:0]                                          ARSIZE_0,
    input  [1:0]                                          ARBURST_0,
    input                                                 ARLOCK_0,
    input  [3:0]                                          ARCACHE_0,
    input  [3:0]                                          ARQOS_0,
    input  [mgc_axi4_m1_params::AXI4_ID_WIDTH-1:0]        ARID_0,
    input  [mgc_axi4_m1_params::AXI4_USER_WIDTH-1:0]      ARUSER_0,
    output                                                ARREADY_0,
    // read channel (data) signals
    //
    output                                                RVALID_0,
    output [mgc_axi4_m1_params::AXI4_RDATA_WIDTH-1:0]     RDATA_0,
    output [1:0]                                          RRESP_0,
    output                                                RLAST_0,
    output [mgc_axi4_m1_params::AXI4_ID_WIDTH-1:0]        RID_0,
    output [mgc_axi4_m1_params::AXI4_USER_WIDTH-1:0]      RUSER_0,
    input                                                 RREADY_0,
    // write channel signals
    //
    input                                                 WVALID_0,
    input  [mgc_axi4_m1_params::AXI4_WDATA_WIDTH-1:0]     WDATA_0,
    input  [(mgc_axi4_m1_params::AXI4_WDATA_WIDTH/8)-1:0] WSTRB_0,
    input                                                 WLAST_0,
    input  [mgc_axi4_m1_params::AXI4_USER_WIDTH-1:0]      WUSER_0,
    output                                                WREADY_0,
    // write response channel signals
    //
    output                                                BVALID_0,
    output [1:0]                                          BRESP_0,
    output [mgc_axi4_m1_params::AXI4_ID_WIDTH-1:0]        BID_0,
    output [mgc_axi4_m1_params::AXI4_USER_WIDTH-1:0]      BUSER_0,
    input                                                 BREADY_0,
    // clock and reset signals
    //
    output                                                ACLK_1,
    output                                                ARESETn_1,
    // write address channel signals
    //
    output                                                AWVALID_1,
    output [mgc_axi4_s0_params::AXI4_ADDRESS_WIDTH-1:0]   AWADDR_1,
    output [2:0]                                          AWPROT_1,
    output [3:0]                                          AWREGION_1,
    output [7:0]                                          AWLEN_1,
    output [2:0]                                          AWSIZE_1,
    output [1:0]                                          AWBURST_1,
    output                                                AWLOCK_1,
    output [3:0]                                          AWCACHE_1,
    output [3:0]                                          AWQOS_1,
    output [mgc_axi4_s0_params::AXI4_ID_WIDTH-1:0]        AWID_1,
    output [mgc_axi4_s0_params::AXI4_USER_WIDTH-1:0]      AWUSER_1,
    input                                                 AWREADY_1,
    // read address channel signals 
    //
    output                                                ARVALID_1,
    output [mgc_axi4_s0_params::AXI4_ADDRESS_WIDTH-1:0]   ARADDR_1,
    output [2:0]                                          ARPROT_1,
    output [3:0]                                          ARREGION_1,
    output [7:0]                                          ARLEN_1,
    output [2:0]                                          ARSIZE_1,
    output [1:0]                                          ARBURST_1,
    output                                                ARLOCK_1,
    output [3:0]                                          ARCACHE_1,
    output [3:0]                                          ARQOS_1,
    output [mgc_axi4_s0_params::AXI4_ID_WIDTH-1:0]        ARID_1,
    output [mgc_axi4_s0_params::AXI4_USER_WIDTH-1:0]      ARUSER_1,
    input                                                 ARREADY_1,
    // read channel (data) signals
    //
    input                                                 RVALID_1,
    input  [mgc_axi4_s0_params::AXI4_RDATA_WIDTH-1:0]     RDATA_1,
    input  [1:0]                                          RRESP_1,
    input                                                 RLAST_1,
    input  [mgc_axi4_s0_params::AXI4_ID_WIDTH-1:0]        RID_1,
    input  [mgc_axi4_s0_params::AXI4_USER_WIDTH-1:0]      RUSER_1,
    output                                                RREADY_1,
    // write channel signals
    //
    output                                                WVALID_1,
    output [mgc_axi4_s0_params::AXI4_WDATA_WIDTH-1:0]     WDATA_1,
    output [(mgc_axi4_s0_params::AXI4_WDATA_WIDTH/8)-1:0] WSTRB_1,
    output                                                WLAST_1,
    output [mgc_axi4_s0_params::AXI4_USER_WIDTH-1:0]      WUSER_1,
    input                                                 WREADY_1,
    // write response channel signals
    //
    input                                                 BVALID_1,
    input  [1:0]                                          BRESP_1,
    input  [mgc_axi4_s0_params::AXI4_ID_WIDTH-1:0]        BID_1,
    input  [mgc_axi4_s0_params::AXI4_USER_WIDTH-1:0]      BUSER_1,
    output                                                BREADY_1,
    // clock and reset signals
    //
    output                                                ACLK_2,
    output                                                ARESETn_2,
    // write address channel signals
    //
    output                                                AWVALID_2,
    output [mgc_axi4_s1_params::AXI4_ADDRESS_WIDTH-1:0]   AWADDR_2,
    output [2:0]                                          AWPROT_2,
    output [3:0]                                          AWREGION_2,
    output [7:0]                                          AWLEN_2,
    output [2:0]                                          AWSIZE_2,
    output [1:0]                                          AWBURST_2,
    output                                                AWLOCK_2,
    output [3:0]                                          AWCACHE_2,
    output [3:0]                                          AWQOS_2,
    output [mgc_axi4_s1_params::AXI4_ID_WIDTH-1:0]        AWID_2,
    output [mgc_axi4_s1_params::AXI4_USER_WIDTH-1:0]      AWUSER_2,
    input                                                 AWREADY_2,
    // read address channel signals 
    //
    output                                                ARVALID_2,
    output [mgc_axi4_s1_params::AXI4_ADDRESS_WIDTH-1:0]   ARADDR_2,
    output [2:0]                                          ARPROT_2,
    output [3:0]                                          ARREGION_2,
    output [7:0]                                          ARLEN_2,
    output [2:0]                                          ARSIZE_2,
    output [1:0]                                          ARBURST_2,
    output                                                ARLOCK_2,
    output [3:0]                                          ARCACHE_2,
    output [3:0]                                          ARQOS_2,
    output [mgc_axi4_s1_params::AXI4_ID_WIDTH-1:0]        ARID_2,
    output [mgc_axi4_s1_params::AXI4_USER_WIDTH-1:0]      ARUSER_2,
    input                                                 ARREADY_2,
    // read channel (data) signals
    //
    input                                                 RVALID_2,
    input  [mgc_axi4_s1_params::AXI4_RDATA_WIDTH-1:0]     RDATA_2,
    input  [1:0]                                          RRESP_2,
    input                                                 RLAST_2,
    input  [mgc_axi4_s1_params::AXI4_ID_WIDTH-1:0]        RID_2,
    input  [mgc_axi4_s1_params::AXI4_USER_WIDTH-1:0]      RUSER_2,
    output                                                RREADY_2,
    // write channel signals
    //
    output                                                WVALID_2,
    output [mgc_axi4_s1_params::AXI4_WDATA_WIDTH-1:0]     WDATA_2,
    output [(mgc_axi4_s1_params::AXI4_WDATA_WIDTH/8)-1:0] WSTRB_2,
    output                                                WLAST_2,
    output [mgc_axi4_s1_params::AXI4_USER_WIDTH-1:0]      WUSER_2,
    input                                                 WREADY_2,
    // write response channel signals
    //
    input                                                 BVALID_2,
    input  [1:0]                                          BRESP_2,
    input  [mgc_axi4_s1_params::AXI4_ID_WIDTH-1:0]        BID_2,
    input  [mgc_axi4_s1_params::AXI4_USER_WIDTH-1:0]      BUSER_2,
    output                                                BREADY_2
);

endmodule: DUT
