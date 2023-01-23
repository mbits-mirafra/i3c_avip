//
// File: hdl_axi4_2x2_fabric_qvip.sv
//
// Generated from Mentor VIP Configurator (20160818)
// Generated using Mentor VIP Library ( 10_5b : 09/04/2016:09:24 )
//
module hdl_axi4_2x2_fabric_qvip;
    import uvm_pkg::*;
    import axi4_2x2_fabric_qvip_params_pkg::*;
    wire                                                ACLK;
    wire                                                ARESETn;
    wire                                                AWVALID_m0;
    wire [mgc_axi4_m0_params::AXI4_ADDRESS_WIDTH-1:0]   AWADDR_m0;
    wire [2:0]                                          AWPROT_m0;
    wire [3:0]                                          AWREGION_m0;
    wire [7:0]                                          AWLEN_m0;
    wire [2:0]                                          AWSIZE_m0;
    wire [1:0]                                          AWBURST_m0;
    wire                                                AWLOCK_m0;
    wire [3:0]                                          AWCACHE_m0;
    wire [3:0]                                          AWQOS_m0;
    wire [mgc_axi4_m0_params::AXI4_ID_WIDTH-1:0]        AWID_m0;
    wire [mgc_axi4_m0_params::AXI4_USER_WIDTH-1:0]      AWUSER_m0;
    wire                                                AWREADY_m0;
    wire                                                ARVALID_m0;
    wire [mgc_axi4_m0_params::AXI4_ADDRESS_WIDTH-1:0]   ARADDR_m0;
    wire [2:0]                                          ARPROT_m0;
    wire [3:0]                                          ARREGION_m0;
    wire [7:0]                                          ARLEN_m0;
    wire [2:0]                                          ARSIZE_m0;
    wire [1:0]                                          ARBURST_m0;
    wire                                                ARLOCK_m0;
    wire [3:0]                                          ARCACHE_m0;
    wire [3:0]                                          ARQOS_m0;
    wire [mgc_axi4_m0_params::AXI4_ID_WIDTH-1:0]        ARID_m0;
    wire [mgc_axi4_m0_params::AXI4_USER_WIDTH-1:0]      ARUSER_m0;
    wire                                                ARREADY_m0;
    wire                                                RVALID_m0;
    wire [mgc_axi4_m0_params::AXI4_RDATA_WIDTH-1:0]     RDATA_m0;
    wire [1:0]                                          RRESP_m0;
    wire                                                RLAST_m0;
    wire [mgc_axi4_m0_params::AXI4_ID_WIDTH-1:0]        RID_m0;
    wire [mgc_axi4_m0_params::AXI4_USER_WIDTH-1:0]      RUSER_m0;
    wire                                                RREADY_m0;
    wire                                                WVALID_m0;
    wire [mgc_axi4_m0_params::AXI4_WDATA_WIDTH-1:0]     WDATA_m0;
    wire [(mgc_axi4_m0_params::AXI4_WDATA_WIDTH/8)-1:0] WSTRB_m0;
    wire                                                WLAST_m0;
    wire [mgc_axi4_m0_params::AXI4_USER_WIDTH-1:0]      WUSER_m0;
    wire                                                WREADY_m0;
    wire                                                BVALID_m0;
    wire [1:0]                                          BRESP_m0;
    wire [mgc_axi4_m0_params::AXI4_ID_WIDTH-1:0]        BID_m0;
    wire [mgc_axi4_m0_params::AXI4_USER_WIDTH-1:0]      BUSER_m0;
    wire                                                BREADY_m0;
    wire                                                AWVALID_m1;
    wire [mgc_axi4_m1_params::AXI4_ADDRESS_WIDTH-1:0]   AWADDR_m1;
    wire [2:0]                                          AWPROT_m1;
    wire [3:0]                                          AWREGION_m1;
    wire [7:0]                                          AWLEN_m1;
    wire [2:0]                                          AWSIZE_m1;
    wire [1:0]                                          AWBURST_m1;
    wire                                                AWLOCK_m1;
    wire [3:0]                                          AWCACHE_m1;
    wire [3:0]                                          AWQOS_m1;
    wire [mgc_axi4_m1_params::AXI4_ID_WIDTH-1:0]        AWID_m1;
    wire [mgc_axi4_m1_params::AXI4_USER_WIDTH-1:0]      AWUSER_m1;
    wire                                                AWREADY_m1;
    wire                                                ARVALID_m1;
    wire [mgc_axi4_m1_params::AXI4_ADDRESS_WIDTH-1:0]   ARADDR_m1;
    wire [2:0]                                          ARPROT_m1;
    wire [3:0]                                          ARREGION_m1;
    wire [7:0]                                          ARLEN_m1;
    wire [2:0]                                          ARSIZE_m1;
    wire [1:0]                                          ARBURST_m1;
    wire                                                ARLOCK_m1;
    wire [3:0]                                          ARCACHE_m1;
    wire [3:0]                                          ARQOS_m1;
    wire [mgc_axi4_m1_params::AXI4_ID_WIDTH-1:0]        ARID_m1;
    wire [mgc_axi4_m1_params::AXI4_USER_WIDTH-1:0]      ARUSER_m1;
    wire                                                ARREADY_m1;
    wire                                                RVALID_m1;
    wire [mgc_axi4_m1_params::AXI4_RDATA_WIDTH-1:0]     RDATA_m1;
    wire [1:0]                                          RRESP_m1;
    wire                                                RLAST_m1;
    wire [mgc_axi4_m1_params::AXI4_ID_WIDTH-1:0]        RID_m1;
    wire [mgc_axi4_m1_params::AXI4_USER_WIDTH-1:0]      RUSER_m1;
    wire                                                RREADY_m1;
    wire                                                WVALID_m1;
    wire [mgc_axi4_m1_params::AXI4_WDATA_WIDTH-1:0]     WDATA_m1;
    wire [(mgc_axi4_m1_params::AXI4_WDATA_WIDTH/8)-1:0] WSTRB_m1;
    wire                                                WLAST_m1;
    wire [mgc_axi4_m1_params::AXI4_USER_WIDTH-1:0]      WUSER_m1;
    wire                                                WREADY_m1;
    wire                                                BVALID_m1;
    wire [1:0]                                          BRESP_m1;
    wire [mgc_axi4_m1_params::AXI4_ID_WIDTH-1:0]        BID_m1;
    wire [mgc_axi4_m1_params::AXI4_USER_WIDTH-1:0]      BUSER_m1;
    wire                                                BREADY_m1;
    wire                                                AWVALID_s0;
    wire [mgc_axi4_s0_params::AXI4_ADDRESS_WIDTH-1:0]   AWADDR_s0;
    wire [2:0]                                          AWPROT_s0;
    wire [3:0]                                          AWREGION_s0;
    wire [7:0]                                          AWLEN_s0;
    wire [2:0]                                          AWSIZE_s0;
    wire [1:0]                                          AWBURST_s0;
    wire                                                AWLOCK_s0;
    wire [3:0]                                          AWCACHE_s0;
    wire [3:0]                                          AWQOS_s0;
    wire [mgc_axi4_s0_params::AXI4_ID_WIDTH-1:0]        AWID_s0;
    wire [mgc_axi4_s0_params::AXI4_USER_WIDTH-1:0]      AWUSER_s0;
    wire                                                AWREADY_s0;
    wire                                                ARVALID_s0;
    wire [mgc_axi4_s0_params::AXI4_ADDRESS_WIDTH-1:0]   ARADDR_s0;
    wire [2:0]                                          ARPROT_s0;
    wire [3:0]                                          ARREGION_s0;
    wire [7:0]                                          ARLEN_s0;
    wire [2:0]                                          ARSIZE_s0;
    wire [1:0]                                          ARBURST_s0;
    wire                                                ARLOCK_s0;
    wire [3:0]                                          ARCACHE_s0;
    wire [3:0]                                          ARQOS_s0;
    wire [mgc_axi4_s0_params::AXI4_ID_WIDTH-1:0]        ARID_s0;
    wire [mgc_axi4_s0_params::AXI4_USER_WIDTH-1:0]      ARUSER_s0;
    wire                                                ARREADY_s0;
    wire                                                RVALID_s0;
    wire [mgc_axi4_s0_params::AXI4_RDATA_WIDTH-1:0]     RDATA_s0;
    wire [1:0]                                          RRESP_s0;
    wire                                                RLAST_s0;
    wire [mgc_axi4_s0_params::AXI4_ID_WIDTH-1:0]        RID_s0;
    wire [mgc_axi4_s0_params::AXI4_USER_WIDTH-1:0]      RUSER_s0;
    wire                                                RREADY_s0;
    wire                                                WVALID_s0;
    wire [mgc_axi4_s0_params::AXI4_WDATA_WIDTH-1:0]     WDATA_s0;
    wire [(mgc_axi4_s0_params::AXI4_WDATA_WIDTH/8)-1:0] WSTRB_s0;
    wire                                                WLAST_s0;
    wire [mgc_axi4_s0_params::AXI4_USER_WIDTH-1:0]      WUSER_s0;
    wire                                                WREADY_s0;
    wire                                                BVALID_s0;
    wire [1:0]                                          BRESP_s0;
    wire [mgc_axi4_s0_params::AXI4_ID_WIDTH-1:0]        BID_s0;
    wire [mgc_axi4_s0_params::AXI4_USER_WIDTH-1:0]      BUSER_s0;
    wire                                                BREADY_s0;
    wire                                                AWVALID_s1;
    wire [mgc_axi4_s1_params::AXI4_ADDRESS_WIDTH-1:0]   AWADDR_s1;
    wire [2:0]                                          AWPROT_s1;
    wire [3:0]                                          AWREGION_s1;
    wire [7:0]                                          AWLEN_s1;
    wire [2:0]                                          AWSIZE_s1;
    wire [1:0]                                          AWBURST_s1;
    wire                                                AWLOCK_s1;
    wire [3:0]                                          AWCACHE_s1;
    wire [3:0]                                          AWQOS_s1;
    wire [mgc_axi4_s1_params::AXI4_ID_WIDTH-1:0]        AWID_s1;
    wire [mgc_axi4_s1_params::AXI4_USER_WIDTH-1:0]      AWUSER_s1;
    wire                                                AWREADY_s1;
    wire                                                ARVALID_s1;
    wire [mgc_axi4_s1_params::AXI4_ADDRESS_WIDTH-1:0]   ARADDR_s1;
    wire [2:0]                                          ARPROT_s1;
    wire [3:0]                                          ARREGION_s1;
    wire [7:0]                                          ARLEN_s1;
    wire [2:0]                                          ARSIZE_s1;
    wire [1:0]                                          ARBURST_s1;
    wire                                                ARLOCK_s1;
    wire [3:0]                                          ARCACHE_s1;
    wire [3:0]                                          ARQOS_s1;
    wire [mgc_axi4_s1_params::AXI4_ID_WIDTH-1:0]        ARID_s1;
    wire [mgc_axi4_s1_params::AXI4_USER_WIDTH-1:0]      ARUSER_s1;
    wire                                                ARREADY_s1;
    wire                                                RVALID_s1;
    wire [mgc_axi4_s1_params::AXI4_RDATA_WIDTH-1:0]     RDATA_s1;
    wire [1:0]                                          RRESP_s1;
    wire                                                RLAST_s1;
    wire [mgc_axi4_s1_params::AXI4_ID_WIDTH-1:0]        RID_s1;
    wire [mgc_axi4_s1_params::AXI4_USER_WIDTH-1:0]      RUSER_s1;
    wire                                                RREADY_s1;
    wire                                                WVALID_s1;
    wire [mgc_axi4_s1_params::AXI4_WDATA_WIDTH-1:0]     WDATA_s1;
    wire [(mgc_axi4_s1_params::AXI4_WDATA_WIDTH/8)-1:0] WSTRB_s1;
    wire                                                WLAST_s1;
    wire [mgc_axi4_s1_params::AXI4_USER_WIDTH-1:0]      WUSER_s1;
    wire                                                WREADY_s1;
    wire                                                BVALID_s1;
    wire [1:0]                                          BRESP_s1;
    wire [mgc_axi4_s1_params::AXI4_ID_WIDTH-1:0]        BID_s1;
    wire [mgc_axi4_s1_params::AXI4_USER_WIDTH-1:0]      BUSER_s1;
    wire                                                BREADY_s1;
    
    // tying off annoying (unused) AXI4 USER signals
    assign ARUSER_s0 = 'b0;
    assign ARUSER_s1 = 'b0;
    assign AWUSER_s0 = 'b0;
    assign AWUSER_s1 = 'b0;
    assign BUSER_m0  = 'b0;
    assign BUSER_m1  = 'b0;
    assign RUSER_m0  = 'b0;
    assign RUSER_m1  = 'b0;
    assign WUSER_s0  = 'b0;
    assign WUSER_s1  = 'b0;

    // DUT connections parameters and wiring
    parameter int N_MASTERS           = 2;
    parameter int N_SLAVES            = 2;
    parameter int N_MASTERID_BITS     = 1;
    parameter int AXI4_ADDRESS_WIDTH  = mgc_axi4_m0_params::AXI4_ADDRESS_WIDTH;
    parameter int AXI4_DATA_WIDTH     = mgc_axi4_m0_params::AXI4_RDATA_WIDTH;
    parameter int AXI4_INIT_ID_WIDTH  = mgc_axi4_m0_params::AXI4_ID_WIDTH;
    parameter int AXI4_TARG_ID_WIDTH  = mgc_axi4_s0_params::AXI4_ID_WIDTH;
    parameter bit[AXI4_ADDRESS_WIDTH-1:0]     SLAVE0_ADDR_BASE  = 'h0000_0000;
    parameter bit[AXI4_ADDRESS_WIDTH-1:0]     SLAVE0_ADDR_LIMIT = 'h7FFF_FFFF;
    parameter bit[AXI4_ADDRESS_WIDTH-1:0]     SLAVE1_ADDR_BASE  = 'h8000_0000;
    parameter bit[AXI4_ADDRESS_WIDTH-1:0]     SLAVE1_ADDR_LIMIT = 'hFFFF_FFFF;

    // DUT wiring for Master interfaces
    wire[AXI4_ADDRESS_WIDTH-1:0]    AWADDR[N_MASTERS-1:0] = {AWADDR_m1, AWADDR_m0};
    wire[AXI4_INIT_ID_WIDTH-1:0]    AWID[N_MASTERS-1:0] = {AWID_m1, AWID_m0};
    wire[7:0]                       AWLEN[N_MASTERS-1:0] = {AWLEN_m1, AWLEN_m0};
    wire[2:0]                       AWSIZE[N_MASTERS-1:0] = {AWSIZE_m1, AWSIZE_m0};
    wire[1:0]                       AWBURST[N_MASTERS-1:0] = {AWBURST_m1, AWBURST_m0};
    wire                            AWLOCK[N_MASTERS-1:0] = {AWLOCK_m1, AWLOCK_m0};
    wire[3:0]                       AWCACHE[N_MASTERS-1:0] = {AWCACHE_m1, AWCACHE_m0};
    wire[2:0]                       AWPROT[N_MASTERS-1:0] = {AWPROT_m1, AWPROT_m0};
    wire[3:0]                       AWQOS[N_MASTERS-1:0] = {AWQOS_m1, AWQOS_m0};
    wire[3:0]                       AWREGION[N_MASTERS-1:0] = {AWREGION_m1, AWREGION_m0};
    wire                            AWREADY[N_MASTERS-1:0];
    wire                            AWVALID[N_MASTERS-1:0] = {AWVALID_m1, AWVALID_m0};
    wire[AXI4_ADDRESS_WIDTH-1:0]    ARADDR[N_MASTERS-1:0] = {ARADDR_m1, ARADDR_m0};
    wire[AXI4_INIT_ID_WIDTH-1:0]    ARID[N_MASTERS-1:0] = {ARID_m1, ARID_m0};
    wire[7:0]                       ARLEN[N_MASTERS-1:0] = {ARLEN_m1, ARLEN_m0};
    wire[2:0]                       ARSIZE[N_MASTERS-1:0] = {ARSIZE_m1, ARSIZE_m0};
    wire[1:0]                       ARBURST[N_MASTERS-1:0] = {ARBURST_m1, ARBURST_m0};
    wire                            ARLOCK[N_MASTERS-1:0] = {ARLOCK_m1, ARLOCK_m0};
    wire[3:0]                       ARCACHE[N_MASTERS-1:0] = {ARCACHE_m1, ARCACHE_m0};
    wire[2:0]                       ARPROT[N_MASTERS-1:0] = {ARPROT_m1, ARPROT_m0};
    wire[3:0]                       ARQOS[N_MASTERS-1:0] = {ARQOS_m1, ARQOS_m0};
    wire[3:0]                       ARREGION[N_MASTERS-1:0] = {ARREGION_m1, ARREGION_m0};
    wire                            ARREADY[N_MASTERS-1:0];
    wire                            ARVALID[N_MASTERS-1:0] = {ARVALID_m1, ARVALID_m0};
    wire[AXI4_INIT_ID_WIDTH-1:0]    BID[N_MASTERS-1:0];
    wire[1:0]                       BRESP[N_MASTERS-1:0];
    wire                            BVALID[N_MASTERS-1:0];
    wire                            BREADY[N_MASTERS-1:0] = {BREADY_m1, BREADY_m0};
    wire[AXI4_INIT_ID_WIDTH-1:0]    RID[N_MASTERS-1:0];
    wire[AXI4_DATA_WIDTH-1:0]       RDATA[N_MASTERS-1:0];
    wire[1:0]                       RRESP[N_MASTERS-1:0];
    wire                            RLAST[N_MASTERS-1:0];
    wire                            RVALID[N_MASTERS-1:0];
    wire                            RREADY[N_MASTERS-1:0] = {RREADY_m1, RREADY_m0};
    wire[(AXI4_DATA_WIDTH-1):0]     WDATA[N_MASTERS-1:0] = {WDATA_m1, WDATA_m0};
    wire[((AXI4_DATA_WIDTH/8)-1):0] WSTRB[N_MASTERS-1:0] = {WSTRB_m1, WSTRB_m0};
    wire                            WLAST[N_MASTERS-1:0] = {WLAST_m1, WLAST_m0};
    wire                            WVALID[N_MASTERS-1:0] = {WVALID_m1, WVALID_m0};
    wire                            WREADY[N_MASTERS-1:0];

    assign AWREADY_m0 = AWREADY[0];
    assign AWREADY_m1 = AWREADY[1];
    assign ARREADY_m0 = ARREADY[0];
    assign ARREADY_m1 = ARREADY[1];
    assign BID_m0 = BID[0];
    assign BID_m1 = BID[1];
    assign BRESP_m0 = BRESP[0];
    assign BRESP_m1 = BRESP[1];
    assign BVALID_m0 = BVALID[0];
    assign BVALID_m1 = BVALID[1];
    assign RID_m0 = RID[0];
    assign RID_m1 = RID[1];
    assign RDATA_m0 = RDATA[0];
    assign RDATA_m1 = RDATA[1];
    assign RRESP_m0 = RRESP[0];
    assign RRESP_m1 = RRESP[1];
    assign RLAST_m0 = RLAST[0];
    assign RLAST_m1 = RLAST[1];
    assign RVALID_m0 = RVALID[0];
    assign RVALID_m1 = RVALID[1];
    assign WREADY_m0 = WREADY[0];
    assign WREADY_m1 = WREADY[1];

    // DUT wiring for Slave interface
    wire[AXI4_ADDRESS_WIDTH-1:0]    SAWADDR[N_SLAVES:0];
    wire[AXI4_TARG_ID_WIDTH-1:0]    SAWID[N_SLAVES:0];
    wire[7:0]                       SAWLEN[N_SLAVES:0];
    wire[2:0]                       SAWSIZE[N_SLAVES:0];
    wire[1:0]                       SAWBURST[N_SLAVES:0];
    wire                            SAWLOCK[N_SLAVES:0];
    wire[3:0]                       SAWCACHE[N_SLAVES:0];
    wire[2:0]                       SAWPROT[N_SLAVES:0];
    wire[3:0]                       SAWQOS[N_SLAVES:0];
    wire[3:0]                       SAWREGION[N_SLAVES:0];
    wire                            SAWREADY[N_SLAVES:0] = {1'b0, AWREADY_s1, AWREADY_s0};
    wire                            SAWVALID[N_SLAVES:0];
    wire[AXI4_TARG_ID_WIDTH-1:0]    SWID[N_SLAVES:0];
    wire[(AXI4_DATA_WIDTH-1):0]     SWDATA[N_SLAVES:0];
    wire[((AXI4_DATA_WIDTH/8)-1):0] SWSTRB[N_SLAVES:0];
    wire                            SWLAST[N_SLAVES:0];
    wire                            SWVALID[N_SLAVES:0];
    wire                            SWREADY[N_SLAVES:0] = {1'b0, WREADY_s1, WREADY_s0};
    wire[AXI4_TARG_ID_WIDTH-1:0]    SBID[N_SLAVES:0] = {0, BID_s1, BID_s0};
    wire[1:0]                       SBRESP[N_SLAVES:0] = {0, BRESP_s1, BRESP_s0};
    wire                            SBVALID[N_SLAVES:0] = {0, BVALID_s1, BVALID_s0};
    wire                            SBREADY[N_SLAVES:0];
    wire[AXI4_ADDRESS_WIDTH-1:0]    SARADDR[N_SLAVES:0];
    wire[AXI4_TARG_ID_WIDTH-1:0]    SARID[N_SLAVES:0];
    wire[7:0]                       SARLEN[N_SLAVES:0];
    wire[2:0]                       SARSIZE[N_SLAVES:0];
    wire[1:0]                       SARBURST[N_SLAVES:0];
    wire                            SARLOCK[N_SLAVES:0];
    wire[3:0]                       SARCACHE[N_SLAVES:0];
    wire[2:0]                       SARPROT[N_SLAVES:0];
    wire[3:0]                       SARQOS[N_SLAVES:0];
    wire[3:0]                       SARREGION[N_SLAVES:0];
    wire                            SARREADY[N_SLAVES:0] = {0, ARREADY_s1, ARREADY_s0};
    wire                            SARVALID[N_SLAVES:0];
    wire[AXI4_TARG_ID_WIDTH-1:0]    SRID[N_SLAVES:0] = {0, RID_s1, RID_s0};
    wire[AXI4_DATA_WIDTH-1:0]       SRDATA[N_SLAVES:0] = {0, RDATA_s1, RDATA_s0};
    wire[1:0]                       SRRESP[N_SLAVES:0] = {0, RRESP_s1, RRESP_s0};
    wire                            SRLAST[N_SLAVES:0] = {0, RLAST_s1, RLAST_s0};
    wire                            SRVALID[N_SLAVES:0] = {0, RVALID_s1, RVALID_s0};
    wire                            SRREADY[N_SLAVES:0];

    assign AWADDR_s0 = SAWADDR[0];
    assign AWADDR_s1 = SAWADDR[1];
    assign AWID_s0 = SAWID[0];
    assign AWID_s1 = SAWID[1];
    assign AWLEN_s0 = SAWLEN[0];
    assign AWLEN_s1 = SAWLEN[1];
    assign AWSIZE_s0 = SAWSIZE[0];
    assign AWSIZE_s1 = SAWSIZE[1];
    assign AWBURST_s0 = SAWBURST[0];
    assign AWBURST_s1 = SAWBURST[1];
    assign AWLOCK_s0 = SAWLOCK[0];
    assign AWLOCK_s1 = SAWLOCK[1];
    assign AWCACHE_s0 = SAWCACHE[0];
    assign AWCACHE_s1 = SAWCACHE[1];
    assign AWPROT_s0 = SAWPROT[0];
    assign AWPROT_s1 = SAWPROT[1];
    assign AWQOS_s0 = SAWQOS[0];
    assign AWQOS_s1 = SAWQOS[1];
    assign AWREGION_s0 = SAWREGION[0];
    assign AWREGION_s1 = SAWREGION[1];
    assign AWVALID_s0 = SAWVALID[0];
    assign AWVALID_s1 = SAWVALID[1];
    assign WDATA_s0 = SWDATA[0];
    assign WDATA_s1 = SWDATA[1];
    assign WSTRB_s0 = SWSTRB[0];
    assign WSTRB_s1 = SWSTRB[1];
    assign WLAST_s0 = SWLAST[0];
    assign WLAST_s1 = SWLAST[1];
    assign WVALID_s0 = SWVALID[0];
    assign WVALID_s1 = SWVALID[1];
    assign BREADY_s0 = SBREADY[0];
    assign BREADY_s1 = SBREADY[1];
    assign ARADDR_s0 = SARADDR[0];
    assign ARADDR_s1 = SARADDR[1];
    assign ARID_s0 = SARID[0];
    assign ARID_s1 = SARID[1];
    assign ARLEN_s0 = SARLEN[0];
    assign ARLEN_s1 = SARLEN[1];
    assign ARSIZE_s0 = SARSIZE[0];
    assign ARSIZE_s1 = SARSIZE[1];
    assign ARBURST_s0 = SARBURST[0];
    assign ARBURST_s1 = SARBURST[1];
    assign ARLOCK_s0 = SARLOCK[0];
    assign ARLOCK_s1 = SARLOCK[1];
    assign ARCACHE_s0 = SARCACHE[0];
    assign ARCACHE_s1 = SARCACHE[1];
    assign ARPROT_s0 = SARPROT[0];
    assign ARPROT_s1 = SARPROT[1];
    assign ARQOS_s0 = SARQOS[0];
    assign ARQOS_s1 = SARQOS[1];
    assign ARREGION_s0 = SARREGION[0];
    assign ARREGION_s1 = SARREGION[1];
    assign ARVALID_s0 = SARVALID[0];
    assign ARVALID_s1 = SARVALID[1];
    assign RREADY_s0 = SRREADY[0];
    assign RREADY_s1 = SRREADY[1];

    axi4_interconnect_NxN #(
      .AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ),
      .AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH    ),
      .AXI4_ID_WIDTH       (AXI4_INIT_ID_WIDTH ),
      .N_MASTERS           (N_MASTERS          ),
      .N_SLAVES            (N_SLAVES           ),
      .ADDR_RANGES         ({SLAVE0_ADDR_BASE, SLAVE0_ADDR_LIMIT,
                            SLAVE1_ADDR_BASE, SLAVE1_ADDR_LIMIT})
      ) axi4_2x2_fabric_qvip (
      .clk                 (ACLK               ),
      .rstn                (ARESETn            ),
      .AWADDR              (AWADDR             ),
      .AWID                (AWID               ),
      .AWLEN               (AWLEN              ),
      .AWSIZE              (AWSIZE             ),
      .AWBURST             (AWBURST            ),
      .AWLOCK              (AWLOCK             ),
      .AWCACHE             (AWCACHE            ),
      .AWPROT              (AWPROT             ),
      .AWQOS               (AWQOS              ),
      .AWREGION            (AWREGION           ),
      .AWREADY             (AWREADY            ),
      .AWVALID             (AWVALID            ),
      .ARADDR              (ARADDR             ),
      .ARID                (ARID               ),
      .ARLEN               (ARLEN              ),
      .ARSIZE              (ARSIZE             ),
      .ARBURST             (ARBURST            ),
      .ARLOCK              (ARLOCK             ),
      .ARCACHE             (ARCACHE            ),
      .ARPROT              (ARPROT             ),
      .ARQOS               (ARQOS              ),
      .ARREGION            (ARREGION           ),
      .ARREADY             (ARREADY            ),
      .ARVALID             (ARVALID            ),
      .BID                 (BID                ),
      .BRESP               (BRESP              ),
      .BVALID              (BVALID             ),
      .BREADY              (BREADY             ),
      .RID                 (RID                ),
      .RDATA               (RDATA              ),
      .RRESP               (RRESP              ),
      .RLAST               (RLAST              ),
      .RVALID              (RVALID             ),
      .RREADY              (RREADY             ),
      .WDATA               (WDATA              ),
      .WSTRB               (WSTRB              ),
      .WLAST               (WLAST              ),
      .WVALID              (WVALID             ),
      .WREADY              (WREADY             ),
      .SAWADDR             (SAWADDR            ),
      .SAWID               (SAWID              ),
      .SAWLEN              (SAWLEN             ),
      .SAWSIZE             (SAWSIZE            ),
      .SAWBURST            (SAWBURST           ),
      .SAWLOCK             (SAWLOCK            ),
      .SAWCACHE            (SAWCACHE           ),
      .SAWPROT             (SAWPROT            ),
      .SAWQOS              (SAWQOS             ),
      .SAWREGION           (SAWREGION          ),
      .SAWREADY            (SAWREADY           ),
      .SAWVALID            (SAWVALID           ),
      .SWDATA              (SWDATA             ),
      .SWSTRB              (SWSTRB             ),
      .SWLAST              (SWLAST             ),
      .SWVALID             (SWVALID            ),
      .SWREADY             (SWREADY            ),
      .SBID                (SBID               ),
      .SBRESP              (SBRESP             ),
      .SBVALID             (SBVALID            ),
      .SBREADY             (SBREADY            ),
      .SARADDR             (SARADDR            ),
      .SARID               (SARID              ),
      .SARLEN              (SARLEN             ),
      .SARSIZE             (SARSIZE            ),
      .SARBURST            (SARBURST           ),
      .SARLOCK             (SARLOCK            ),
      .SARCACHE            (SARCACHE           ),
      .SARPROT             (SARPROT            ),
      .SARQOS              (SARQOS             ),
      .SARREGION           (SARREGION          ),
      .SARREADY            (SARREADY           ),
      .SARVALID            (SARVALID           ),
      .SRID                (SRID               ),
      .SRDATA              (SRDATA             ),
      .SRRESP              (SRRESP             ),
      .SRLAST              (SRLAST             ),
      .SRVALID             (SRVALID            ),
      .SRREADY             (SRREADY            ));

    axi4_master 
    #(
        .ADDR_WIDTH(mgc_axi4_m0_params::AXI4_ADDRESS_WIDTH),
        .RDATA_WIDTH(mgc_axi4_m0_params::AXI4_RDATA_WIDTH),
        .WDATA_WIDTH(mgc_axi4_m0_params::AXI4_WDATA_WIDTH),
        .ID_WIDTH(mgc_axi4_m0_params::AXI4_ID_WIDTH),
        .USER_WIDTH(mgc_axi4_m0_params::AXI4_USER_WIDTH),
        .REGION_MAP_SIZE(mgc_axi4_m0_params::AXI4_REGION_MAP_SIZE),
        .IF_NAME("mgc_axi4_m0"),
        .PATH_NAME("UVMF_VIRTUAL_INTERFACES")
    )
    mgc_axi4_m0
    (
        .ACLK(ACLK),
        .ARESETn(ARESETn),
        .AWVALID(AWVALID_m0),
        .AWADDR(AWADDR_m0),
        .AWPROT(AWPROT_m0),
        .AWREGION(AWREGION_m0),
        .AWLEN(AWLEN_m0),
        .AWSIZE(AWSIZE_m0),
        .AWBURST(AWBURST_m0),
        .AWLOCK(AWLOCK_m0),
        .AWCACHE(AWCACHE_m0),
        .AWQOS(AWQOS_m0),
        .AWID(AWID_m0),
        .AWUSER(AWUSER_m0),
        .AWREADY(AWREADY_m0),
        .ARVALID(ARVALID_m0),
        .ARADDR(ARADDR_m0),
        .ARPROT(ARPROT_m0),
        .ARREGION(ARREGION_m0),
        .ARLEN(ARLEN_m0),
        .ARSIZE(ARSIZE_m0),
        .ARBURST(ARBURST_m0),
        .ARLOCK(ARLOCK_m0),
        .ARCACHE(ARCACHE_m0),
        .ARQOS(ARQOS_m0),
        .ARID(ARID_m0),
        .ARUSER(ARUSER_m0),
        .ARREADY(ARREADY_m0),
        .RVALID(RVALID_m0),
        .RDATA(RDATA_m0),
        .RRESP(RRESP_m0),
        .RLAST(RLAST_m0),
        .RID(RID_m0),
        .RUSER(RUSER_m0),
        .RREADY(RREADY_m0),
        .WVALID(WVALID_m0),
        .WDATA(WDATA_m0),
        .WSTRB(WSTRB_m0),
        .WLAST(WLAST_m0),
        .WUSER(WUSER_m0),
        .WREADY(WREADY_m0),
        .BVALID(BVALID_m0),
        .BRESP(BRESP_m0),
        .BID(BID_m0),
        .BUSER(BUSER_m0),
        .BREADY(BREADY_m0)
    );
    
    axi4_master 
    #(
        .ADDR_WIDTH(mgc_axi4_m1_params::AXI4_ADDRESS_WIDTH),
        .RDATA_WIDTH(mgc_axi4_m1_params::AXI4_RDATA_WIDTH),
        .WDATA_WIDTH(mgc_axi4_m1_params::AXI4_WDATA_WIDTH),
        .ID_WIDTH(mgc_axi4_m1_params::AXI4_ID_WIDTH),
        .USER_WIDTH(mgc_axi4_m1_params::AXI4_USER_WIDTH),
        .REGION_MAP_SIZE(mgc_axi4_m1_params::AXI4_REGION_MAP_SIZE),
        .IF_NAME("mgc_axi4_m1"),
        .PATH_NAME("UVMF_VIRTUAL_INTERFACES")
    )
    mgc_axi4_m1
    (
        .ACLK(ACLK),
        .ARESETn(ARESETn),
        .AWVALID(AWVALID_m1),
        .AWADDR(AWADDR_m1),
        .AWPROT(AWPROT_m1),
        .AWREGION(AWREGION_m1),
        .AWLEN(AWLEN_m1),
        .AWSIZE(AWSIZE_m1),
        .AWBURST(AWBURST_m1),
        .AWLOCK(AWLOCK_m1),
        .AWCACHE(AWCACHE_m1),
        .AWQOS(AWQOS_m1),
        .AWID(AWID_m1),
        .AWUSER(AWUSER_m1),
        .AWREADY(AWREADY_m1),
        .ARVALID(ARVALID_m1),
        .ARADDR(ARADDR_m1),
        .ARPROT(ARPROT_m1),
        .ARREGION(ARREGION_m1),
        .ARLEN(ARLEN_m1),
        .ARSIZE(ARSIZE_m1),
        .ARBURST(ARBURST_m1),
        .ARLOCK(ARLOCK_m1),
        .ARCACHE(ARCACHE_m1),
        .ARQOS(ARQOS_m1),
        .ARID(ARID_m1),
        .ARUSER(ARUSER_m1),
        .ARREADY(ARREADY_m1),
        .RVALID(RVALID_m1),
        .RDATA(RDATA_m1),
        .RRESP(RRESP_m1),
        .RLAST(RLAST_m1),
        .RID(RID_m1),
        .RUSER(RUSER_m1),
        .RREADY(RREADY_m1),
        .WVALID(WVALID_m1),
        .WDATA(WDATA_m1),
        .WSTRB(WSTRB_m1),
        .WLAST(WLAST_m1),
        .WUSER(WUSER_m1),
        .WREADY(WREADY_m1),
        .BVALID(BVALID_m1),
        .BRESP(BRESP_m1),
        .BID(BID_m1),
        .BUSER(BUSER_m1),
        .BREADY(BREADY_m1)
    );
    
    axi4_slave 
    #(
        .ADDR_WIDTH(mgc_axi4_s0_params::AXI4_ADDRESS_WIDTH),
        .RDATA_WIDTH(mgc_axi4_s0_params::AXI4_RDATA_WIDTH),
        .WDATA_WIDTH(mgc_axi4_s0_params::AXI4_WDATA_WIDTH),
        .ID_WIDTH(mgc_axi4_s0_params::AXI4_ID_WIDTH),
        .USER_WIDTH(mgc_axi4_s0_params::AXI4_USER_WIDTH),
        .REGION_MAP_SIZE(mgc_axi4_s0_params::AXI4_REGION_MAP_SIZE),
        .IF_NAME("mgc_axi4_s0"),
        .PATH_NAME("UVMF_VIRTUAL_INTERFACES")
    )
    mgc_axi4_s0
    (
        .ACLK(ACLK),
        .ARESETn(ARESETn),
        .AWVALID(AWVALID_s0),
        .AWADDR(AWADDR_s0),
        .AWPROT(AWPROT_s0),
        .AWREGION(AWREGION_s0),
        .AWLEN(AWLEN_s0),
        .AWSIZE(AWSIZE_s0),
        .AWBURST(AWBURST_s0),
        .AWLOCK(AWLOCK_s0),
        .AWCACHE(AWCACHE_s0),
        .AWQOS(AWQOS_s0),
        .AWID(AWID_s0),
        .AWUSER(AWUSER_s0),
        .AWREADY(AWREADY_s0),
        .ARVALID(ARVALID_s0),
        .ARADDR(ARADDR_s0),
        .ARPROT(ARPROT_s0),
        .ARREGION(ARREGION_s0),
        .ARLEN(ARLEN_s0),
        .ARSIZE(ARSIZE_s0),
        .ARBURST(ARBURST_s0),
        .ARLOCK(ARLOCK_s0),
        .ARCACHE(ARCACHE_s0),
        .ARQOS(ARQOS_s0),
        .ARID(ARID_s0),
        .ARUSER(ARUSER_s0),
        .ARREADY(ARREADY_s0),
        .RVALID(RVALID_s0),
        .RDATA(RDATA_s0),
        .RRESP(RRESP_s0),
        .RLAST(RLAST_s0),
        .RID(RID_s0),
        .RUSER(RUSER_s0),
        .RREADY(RREADY_s0),
        .WVALID(WVALID_s0),
        .WDATA(WDATA_s0),
        .WSTRB(WSTRB_s0),
        .WLAST(WLAST_s0),
        .WUSER(WUSER_s0),
        .WREADY(WREADY_s0),
        .BVALID(BVALID_s0),
        .BRESP(BRESP_s0),
        .BID(BID_s0),
        .BUSER(BUSER_s0),
        .BREADY(BREADY_s0)
    );
    
    axi4_slave 
    #(
        .ADDR_WIDTH(mgc_axi4_s1_params::AXI4_ADDRESS_WIDTH),
        .RDATA_WIDTH(mgc_axi4_s1_params::AXI4_RDATA_WIDTH),
        .WDATA_WIDTH(mgc_axi4_s1_params::AXI4_WDATA_WIDTH),
        .ID_WIDTH(mgc_axi4_s1_params::AXI4_ID_WIDTH),
        .USER_WIDTH(mgc_axi4_s1_params::AXI4_USER_WIDTH),
        .REGION_MAP_SIZE(mgc_axi4_s1_params::AXI4_REGION_MAP_SIZE),
        .IF_NAME("mgc_axi4_s1"),
        .PATH_NAME("UVMF_VIRTUAL_INTERFACES")
    )
    mgc_axi4_s1
    (
        .ACLK(ACLK),
        .ARESETn(ARESETn),
        .AWVALID(AWVALID_s1),
        .AWADDR(AWADDR_s1),
        .AWPROT(AWPROT_s1),
        .AWREGION(AWREGION_s1),
        .AWLEN(AWLEN_s1),
        .AWSIZE(AWSIZE_s1),
        .AWBURST(AWBURST_s1),
        .AWLOCK(AWLOCK_s1),
        .AWCACHE(AWCACHE_s1),
        .AWQOS(AWQOS_s1),
        .AWID(AWID_s1),
        .AWUSER(AWUSER_s1),
        .AWREADY(AWREADY_s1),
        .ARVALID(ARVALID_s1),
        .ARADDR(ARADDR_s1),
        .ARPROT(ARPROT_s1),
        .ARREGION(ARREGION_s1),
        .ARLEN(ARLEN_s1),
        .ARSIZE(ARSIZE_s1),
        .ARBURST(ARBURST_s1),
        .ARLOCK(ARLOCK_s1),
        .ARCACHE(ARCACHE_s1),
        .ARQOS(ARQOS_s1),
        .ARID(ARID_s1),
        .ARUSER(ARUSER_s1),
        .ARREADY(ARREADY_s1),
        .RVALID(RVALID_s1),
        .RDATA(RDATA_s1),
        .RRESP(RRESP_s1),
        .RLAST(RLAST_s1),
        .RID(RID_s1),
        .RUSER(RUSER_s1),
        .RREADY(RREADY_s1),
        .WVALID(WVALID_s1),
        .WDATA(WDATA_s1),
        .WSTRB(WSTRB_s1),
        .WLAST(WLAST_s1),
        .WUSER(WUSER_s1),
        .WREADY(WREADY_s1),
        .BVALID(BVALID_s1),
        .BRESP(BRESP_s1),
        .BID(BID_s1),
        .BUSER(BUSER_s1),
        .BREADY(BREADY_s1)
    );

    default_clk_gen default_clk_gen_inst(ACLK);
    default_reset_gen default_reset_gen_inst(ARESETn,ACLK);

endmodule: hdl_axi4_2x2_fabric_qvip
