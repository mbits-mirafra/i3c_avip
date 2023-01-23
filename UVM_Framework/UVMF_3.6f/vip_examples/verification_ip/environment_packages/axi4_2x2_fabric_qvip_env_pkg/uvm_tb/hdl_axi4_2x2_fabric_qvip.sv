//
// File: hdl_axi4_2x2_fabric_qvip.sv
//
// Generated from Mentor VIP Configurator (20160818)
// Generated using Mentor VIP Library ( 10_5b : 09/04/2016:09:24 )
//
module hdl_axi4_2x2_fabric_qvip;
    import uvm_pkg::*;
    import axi4_2x2_fabric_qvip_params_pkg::*;
    wire                                                clock_gen_default_clk_gen;
    wire                                                reset_gen_default_reset_gen;
    wire                                                ACLK;
    wire                                                ARESETn;
    wire                                                AWVALID;
    wire [mgc_axi4_m0_params::AXI4_ADDRESS_WIDTH-1:0]   AWADDR;
    wire [2:0]                                          AWPROT;
    wire [3:0]                                          AWREGION;
    wire [7:0]                                          AWLEN;
    wire [2:0]                                          AWSIZE;
    wire [1:0]                                          AWBURST;
    wire                                                AWLOCK;
    wire [3:0]                                          AWCACHE;
    wire [3:0]                                          AWQOS;
    wire [mgc_axi4_m0_params::AXI4_ID_WIDTH-1:0]        AWID;
    wire [mgc_axi4_m0_params::AXI4_USER_WIDTH-1:0]      AWUSER;
    wire                                                AWREADY;
    wire                                                ARVALID;
    wire [mgc_axi4_m0_params::AXI4_ADDRESS_WIDTH-1:0]   ARADDR;
    wire [2:0]                                          ARPROT;
    wire [3:0]                                          ARREGION;
    wire [7:0]                                          ARLEN;
    wire [2:0]                                          ARSIZE;
    wire [1:0]                                          ARBURST;
    wire                                                ARLOCK;
    wire [3:0]                                          ARCACHE;
    wire [3:0]                                          ARQOS;
    wire [mgc_axi4_m0_params::AXI4_ID_WIDTH-1:0]        ARID;
    wire [mgc_axi4_m0_params::AXI4_USER_WIDTH-1:0]      ARUSER;
    wire                                                ARREADY;
    wire                                                RVALID;
    wire [mgc_axi4_m0_params::AXI4_RDATA_WIDTH-1:0]     RDATA;
    wire [1:0]                                          RRESP;
    wire                                                RLAST;
    wire [mgc_axi4_m0_params::AXI4_ID_WIDTH-1:0]        RID;
    wire [mgc_axi4_m0_params::AXI4_USER_WIDTH-1:0]      RUSER;
    wire                                                RREADY;
    wire                                                WVALID;
    wire [mgc_axi4_m0_params::AXI4_WDATA_WIDTH-1:0]     WDATA;
    wire [(mgc_axi4_m0_params::AXI4_WDATA_WIDTH/8)-1:0] WSTRB;
    wire                                                WLAST;
    wire [mgc_axi4_m0_params::AXI4_USER_WIDTH-1:0]      WUSER;
    wire                                                WREADY;
    wire                                                BVALID;
    wire [1:0]                                          BRESP;
    wire [mgc_axi4_m0_params::AXI4_ID_WIDTH-1:0]        BID;
    wire [mgc_axi4_m0_params::AXI4_USER_WIDTH-1:0]      BUSER;
    wire                                                BREADY;
    wire                                                ACLK_0;
    wire                                                ARESETn_0;
    wire                                                AWVALID_0;
    wire [mgc_axi4_m1_params::AXI4_ADDRESS_WIDTH-1:0]   AWADDR_0;
    wire [2:0]                                          AWPROT_0;
    wire [3:0]                                          AWREGION_0;
    wire [7:0]                                          AWLEN_0;
    wire [2:0]                                          AWSIZE_0;
    wire [1:0]                                          AWBURST_0;
    wire                                                AWLOCK_0;
    wire [3:0]                                          AWCACHE_0;
    wire [3:0]                                          AWQOS_0;
    wire [mgc_axi4_m1_params::AXI4_ID_WIDTH-1:0]        AWID_0;
    wire [mgc_axi4_m1_params::AXI4_USER_WIDTH-1:0]      AWUSER_0;
    wire                                                AWREADY_0;
    wire                                                ARVALID_0;
    wire [mgc_axi4_m1_params::AXI4_ADDRESS_WIDTH-1:0]   ARADDR_0;
    wire [2:0]                                          ARPROT_0;
    wire [3:0]                                          ARREGION_0;
    wire [7:0]                                          ARLEN_0;
    wire [2:0]                                          ARSIZE_0;
    wire [1:0]                                          ARBURST_0;
    wire                                                ARLOCK_0;
    wire [3:0]                                          ARCACHE_0;
    wire [3:0]                                          ARQOS_0;
    wire [mgc_axi4_m1_params::AXI4_ID_WIDTH-1:0]        ARID_0;
    wire [mgc_axi4_m1_params::AXI4_USER_WIDTH-1:0]      ARUSER_0;
    wire                                                ARREADY_0;
    wire                                                RVALID_0;
    wire [mgc_axi4_m1_params::AXI4_RDATA_WIDTH-1:0]     RDATA_0;
    wire [1:0]                                          RRESP_0;
    wire                                                RLAST_0;
    wire [mgc_axi4_m1_params::AXI4_ID_WIDTH-1:0]        RID_0;
    wire [mgc_axi4_m1_params::AXI4_USER_WIDTH-1:0]      RUSER_0;
    wire                                                RREADY_0;
    wire                                                WVALID_0;
    wire [mgc_axi4_m1_params::AXI4_WDATA_WIDTH-1:0]     WDATA_0;
    wire [(mgc_axi4_m1_params::AXI4_WDATA_WIDTH/8)-1:0] WSTRB_0;
    wire                                                WLAST_0;
    wire [mgc_axi4_m1_params::AXI4_USER_WIDTH-1:0]      WUSER_0;
    wire                                                WREADY_0;
    wire                                                BVALID_0;
    wire [1:0]                                          BRESP_0;
    wire [mgc_axi4_m1_params::AXI4_ID_WIDTH-1:0]        BID_0;
    wire [mgc_axi4_m1_params::AXI4_USER_WIDTH-1:0]      BUSER_0;
    wire                                                BREADY_0;
    wire                                                ACLK_1;
    wire                                                ARESETn_1;
    wire                                                AWVALID_1;
    wire [mgc_axi4_s0_params::AXI4_ADDRESS_WIDTH-1:0]   AWADDR_1;
    wire [2:0]                                          AWPROT_1;
    wire [3:0]                                          AWREGION_1;
    wire [7:0]                                          AWLEN_1;
    wire [2:0]                                          AWSIZE_1;
    wire [1:0]                                          AWBURST_1;
    wire                                                AWLOCK_1;
    wire [3:0]                                          AWCACHE_1;
    wire [3:0]                                          AWQOS_1;
    wire [mgc_axi4_s0_params::AXI4_ID_WIDTH-1:0]        AWID_1;
    wire [mgc_axi4_s0_params::AXI4_USER_WIDTH-1:0]      AWUSER_1;
    wire                                                AWREADY_1;
    wire                                                ARVALID_1;
    wire [mgc_axi4_s0_params::AXI4_ADDRESS_WIDTH-1:0]   ARADDR_1;
    wire [2:0]                                          ARPROT_1;
    wire [3:0]                                          ARREGION_1;
    wire [7:0]                                          ARLEN_1;
    wire [2:0]                                          ARSIZE_1;
    wire [1:0]                                          ARBURST_1;
    wire                                                ARLOCK_1;
    wire [3:0]                                          ARCACHE_1;
    wire [3:0]                                          ARQOS_1;
    wire [mgc_axi4_s0_params::AXI4_ID_WIDTH-1:0]        ARID_1;
    wire [mgc_axi4_s0_params::AXI4_USER_WIDTH-1:0]      ARUSER_1;
    wire                                                ARREADY_1;
    wire                                                RVALID_1;
    wire [mgc_axi4_s0_params::AXI4_RDATA_WIDTH-1:0]     RDATA_1;
    wire [1:0]                                          RRESP_1;
    wire                                                RLAST_1;
    wire [mgc_axi4_s0_params::AXI4_ID_WIDTH-1:0]        RID_1;
    wire [mgc_axi4_s0_params::AXI4_USER_WIDTH-1:0]      RUSER_1;
    wire                                                RREADY_1;
    wire                                                WVALID_1;
    wire [mgc_axi4_s0_params::AXI4_WDATA_WIDTH-1:0]     WDATA_1;
    wire [(mgc_axi4_s0_params::AXI4_WDATA_WIDTH/8)-1:0] WSTRB_1;
    wire                                                WLAST_1;
    wire [mgc_axi4_s0_params::AXI4_USER_WIDTH-1:0]      WUSER_1;
    wire                                                WREADY_1;
    wire                                                BVALID_1;
    wire [1:0]                                          BRESP_1;
    wire [mgc_axi4_s0_params::AXI4_ID_WIDTH-1:0]        BID_1;
    wire [mgc_axi4_s0_params::AXI4_USER_WIDTH-1:0]      BUSER_1;
    wire                                                BREADY_1;
    wire                                                ACLK_2;
    wire                                                ARESETn_2;
    wire                                                AWVALID_2;
    wire [mgc_axi4_s1_params::AXI4_ADDRESS_WIDTH-1:0]   AWADDR_2;
    wire [2:0]                                          AWPROT_2;
    wire [3:0]                                          AWREGION_2;
    wire [7:0]                                          AWLEN_2;
    wire [2:0]                                          AWSIZE_2;
    wire [1:0]                                          AWBURST_2;
    wire                                                AWLOCK_2;
    wire [3:0]                                          AWCACHE_2;
    wire [3:0]                                          AWQOS_2;
    wire [mgc_axi4_s1_params::AXI4_ID_WIDTH-1:0]        AWID_2;
    wire [mgc_axi4_s1_params::AXI4_USER_WIDTH-1:0]      AWUSER_2;
    wire                                                AWREADY_2;
    wire                                                ARVALID_2;
    wire [mgc_axi4_s1_params::AXI4_ADDRESS_WIDTH-1:0]   ARADDR_2;
    wire [2:0]                                          ARPROT_2;
    wire [3:0]                                          ARREGION_2;
    wire [7:0]                                          ARLEN_2;
    wire [2:0]                                          ARSIZE_2;
    wire [1:0]                                          ARBURST_2;
    wire                                                ARLOCK_2;
    wire [3:0]                                          ARCACHE_2;
    wire [3:0]                                          ARQOS_2;
    wire [mgc_axi4_s1_params::AXI4_ID_WIDTH-1:0]        ARID_2;
    wire [mgc_axi4_s1_params::AXI4_USER_WIDTH-1:0]      ARUSER_2;
    wire                                                ARREADY_2;
    wire                                                RVALID_2;
    wire [mgc_axi4_s1_params::AXI4_RDATA_WIDTH-1:0]     RDATA_2;
    wire [1:0]                                          RRESP_2;
    wire                                                RLAST_2;
    wire [mgc_axi4_s1_params::AXI4_ID_WIDTH-1:0]        RID_2;
    wire [mgc_axi4_s1_params::AXI4_USER_WIDTH-1:0]      RUSER_2;
    wire                                                RREADY_2;
    wire                                                WVALID_2;
    wire [mgc_axi4_s1_params::AXI4_WDATA_WIDTH-1:0]     WDATA_2;
    wire [(mgc_axi4_s1_params::AXI4_WDATA_WIDTH/8)-1:0] WSTRB_2;
    wire                                                WLAST_2;
    wire [mgc_axi4_s1_params::AXI4_USER_WIDTH-1:0]      WUSER_2;
    wire                                                WREADY_2;
    wire                                                BVALID_2;
    wire [1:0]                                          BRESP_2;
    wire [mgc_axi4_s1_params::AXI4_ID_WIDTH-1:0]        BID_2;
    wire [mgc_axi4_s1_params::AXI4_USER_WIDTH-1:0]      BUSER_2;
    wire                                                BREADY_2;
    
    DUT DUT
    (
        .ACLK(ACLK),
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
        .BREADY(BREADY),
        .ACLK_0(ACLK_0),
        .ARESETn_0(ARESETn_0),
        .AWVALID_0(AWVALID_0),
        .AWADDR_0(AWADDR_0),
        .AWPROT_0(AWPROT_0),
        .AWREGION_0(AWREGION_0),
        .AWLEN_0(AWLEN_0),
        .AWSIZE_0(AWSIZE_0),
        .AWBURST_0(AWBURST_0),
        .AWLOCK_0(AWLOCK_0),
        .AWCACHE_0(AWCACHE_0),
        .AWQOS_0(AWQOS_0),
        .AWID_0(AWID_0),
        .AWUSER_0(AWUSER_0),
        .AWREADY_0(AWREADY_0),
        .ARVALID_0(ARVALID_0),
        .ARADDR_0(ARADDR_0),
        .ARPROT_0(ARPROT_0),
        .ARREGION_0(ARREGION_0),
        .ARLEN_0(ARLEN_0),
        .ARSIZE_0(ARSIZE_0),
        .ARBURST_0(ARBURST_0),
        .ARLOCK_0(ARLOCK_0),
        .ARCACHE_0(ARCACHE_0),
        .ARQOS_0(ARQOS_0),
        .ARID_0(ARID_0),
        .ARUSER_0(ARUSER_0),
        .ARREADY_0(ARREADY_0),
        .RVALID_0(RVALID_0),
        .RDATA_0(RDATA_0),
        .RRESP_0(RRESP_0),
        .RLAST_0(RLAST_0),
        .RID_0(RID_0),
        .RUSER_0(RUSER_0),
        .RREADY_0(RREADY_0),
        .WVALID_0(WVALID_0),
        .WDATA_0(WDATA_0),
        .WSTRB_0(WSTRB_0),
        .WLAST_0(WLAST_0),
        .WUSER_0(WUSER_0),
        .WREADY_0(WREADY_0),
        .BVALID_0(BVALID_0),
        .BRESP_0(BRESP_0),
        .BID_0(BID_0),
        .BUSER_0(BUSER_0),
        .BREADY_0(BREADY_0),
        .ACLK_1(ACLK_1),
        .ARESETn_1(ARESETn_1),
        .AWVALID_1(AWVALID_1),
        .AWADDR_1(AWADDR_1),
        .AWPROT_1(AWPROT_1),
        .AWREGION_1(AWREGION_1),
        .AWLEN_1(AWLEN_1),
        .AWSIZE_1(AWSIZE_1),
        .AWBURST_1(AWBURST_1),
        .AWLOCK_1(AWLOCK_1),
        .AWCACHE_1(AWCACHE_1),
        .AWQOS_1(AWQOS_1),
        .AWID_1(AWID_1),
        .AWUSER_1(AWUSER_1),
        .AWREADY_1(AWREADY_1),
        .ARVALID_1(ARVALID_1),
        .ARADDR_1(ARADDR_1),
        .ARPROT_1(ARPROT_1),
        .ARREGION_1(ARREGION_1),
        .ARLEN_1(ARLEN_1),
        .ARSIZE_1(ARSIZE_1),
        .ARBURST_1(ARBURST_1),
        .ARLOCK_1(ARLOCK_1),
        .ARCACHE_1(ARCACHE_1),
        .ARQOS_1(ARQOS_1),
        .ARID_1(ARID_1),
        .ARUSER_1(ARUSER_1),
        .ARREADY_1(ARREADY_1),
        .RVALID_1(RVALID_1),
        .RDATA_1(RDATA_1),
        .RRESP_1(RRESP_1),
        .RLAST_1(RLAST_1),
        .RID_1(RID_1),
        .RUSER_1(RUSER_1),
        .RREADY_1(RREADY_1),
        .WVALID_1(WVALID_1),
        .WDATA_1(WDATA_1),
        .WSTRB_1(WSTRB_1),
        .WLAST_1(WLAST_1),
        .WUSER_1(WUSER_1),
        .WREADY_1(WREADY_1),
        .BVALID_1(BVALID_1),
        .BRESP_1(BRESP_1),
        .BID_1(BID_1),
        .BUSER_1(BUSER_1),
        .BREADY_1(BREADY_1),
        .ACLK_2(ACLK_2),
        .ARESETn_2(ARESETn_2),
        .AWVALID_2(AWVALID_2),
        .AWADDR_2(AWADDR_2),
        .AWPROT_2(AWPROT_2),
        .AWREGION_2(AWREGION_2),
        .AWLEN_2(AWLEN_2),
        .AWSIZE_2(AWSIZE_2),
        .AWBURST_2(AWBURST_2),
        .AWLOCK_2(AWLOCK_2),
        .AWCACHE_2(AWCACHE_2),
        .AWQOS_2(AWQOS_2),
        .AWID_2(AWID_2),
        .AWUSER_2(AWUSER_2),
        .AWREADY_2(AWREADY_2),
        .ARVALID_2(ARVALID_2),
        .ARADDR_2(ARADDR_2),
        .ARPROT_2(ARPROT_2),
        .ARREGION_2(ARREGION_2),
        .ARLEN_2(ARLEN_2),
        .ARSIZE_2(ARSIZE_2),
        .ARBURST_2(ARBURST_2),
        .ARLOCK_2(ARLOCK_2),
        .ARCACHE_2(ARCACHE_2),
        .ARQOS_2(ARQOS_2),
        .ARID_2(ARID_2),
        .ARUSER_2(ARUSER_2),
        .ARREADY_2(ARREADY_2),
        .RVALID_2(RVALID_2),
        .RDATA_2(RDATA_2),
        .RRESP_2(RRESP_2),
        .RLAST_2(RLAST_2),
        .RID_2(RID_2),
        .RUSER_2(RUSER_2),
        .RREADY_2(RREADY_2),
        .WVALID_2(WVALID_2),
        .WDATA_2(WDATA_2),
        .WSTRB_2(WSTRB_2),
        .WLAST_2(WLAST_2),
        .WUSER_2(WUSER_2),
        .WREADY_2(WREADY_2),
        .BVALID_2(BVALID_2),
        .BRESP_2(BRESP_2),
        .BID_2(BID_2),
        .BUSER_2(BUSER_2),
        .BREADY_2(BREADY_2)
    );
    
    axi4_master 
    #(
        .ADDR_WIDTH(mgc_axi4_m0_params::AXI4_ADDRESS_WIDTH),
        .RDATA_WIDTH(mgc_axi4_m0_params::AXI4_RDATA_WIDTH),
        .WDATA_WIDTH(mgc_axi4_m0_params::AXI4_WDATA_WIDTH),
        .ID_WIDTH(mgc_axi4_m0_params::AXI4_ID_WIDTH),
        .USER_WIDTH(mgc_axi4_m0_params::AXI4_USER_WIDTH),
        .REGION_MAP_SIZE(mgc_axi4_m0_params::AXI4_REGION_MAP_SIZE),
        .IF_NAME("mgc_axi4_m0"),
        .PATH_NAME("uvm_test_top")
    )
    mgc_axi4_m0
    (
        .ACLK(clock_gen_default_clk_gen),
        .ARESETn(reset_gen_default_reset_gen),
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
        .BREADY(BREADY)
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
        .PATH_NAME("uvm_test_top")
    )
    mgc_axi4_m1
    (
        .ACLK(clock_gen_default_clk_gen),
        .ARESETn(reset_gen_default_reset_gen),
        .AWVALID(AWVALID_0),
        .AWADDR(AWADDR_0),
        .AWPROT(AWPROT_0),
        .AWREGION(AWREGION_0),
        .AWLEN(AWLEN_0),
        .AWSIZE(AWSIZE_0),
        .AWBURST(AWBURST_0),
        .AWLOCK(AWLOCK_0),
        .AWCACHE(AWCACHE_0),
        .AWQOS(AWQOS_0),
        .AWID(AWID_0),
        .AWUSER(AWUSER_0),
        .AWREADY(AWREADY_0),
        .ARVALID(ARVALID_0),
        .ARADDR(ARADDR_0),
        .ARPROT(ARPROT_0),
        .ARREGION(ARREGION_0),
        .ARLEN(ARLEN_0),
        .ARSIZE(ARSIZE_0),
        .ARBURST(ARBURST_0),
        .ARLOCK(ARLOCK_0),
        .ARCACHE(ARCACHE_0),
        .ARQOS(ARQOS_0),
        .ARID(ARID_0),
        .ARUSER(ARUSER_0),
        .ARREADY(ARREADY_0),
        .RVALID(RVALID_0),
        .RDATA(RDATA_0),
        .RRESP(RRESP_0),
        .RLAST(RLAST_0),
        .RID(RID_0),
        .RUSER(RUSER_0),
        .RREADY(RREADY_0),
        .WVALID(WVALID_0),
        .WDATA(WDATA_0),
        .WSTRB(WSTRB_0),
        .WLAST(WLAST_0),
        .WUSER(WUSER_0),
        .WREADY(WREADY_0),
        .BVALID(BVALID_0),
        .BRESP(BRESP_0),
        .BID(BID_0),
        .BUSER(BUSER_0),
        .BREADY(BREADY_0)
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
        .PATH_NAME("uvm_test_top")
    )
    mgc_axi4_s0
    (
        .ACLK(clock_gen_default_clk_gen),
        .ARESETn(reset_gen_default_reset_gen),
        .AWVALID(AWVALID_1),
        .AWADDR(AWADDR_1),
        .AWPROT(AWPROT_1),
        .AWREGION(AWREGION_1),
        .AWLEN(AWLEN_1),
        .AWSIZE(AWSIZE_1),
        .AWBURST(AWBURST_1),
        .AWLOCK(AWLOCK_1),
        .AWCACHE(AWCACHE_1),
        .AWQOS(AWQOS_1),
        .AWID(AWID_1),
        .AWUSER(AWUSER_1),
        .AWREADY(AWREADY_1),
        .ARVALID(ARVALID_1),
        .ARADDR(ARADDR_1),
        .ARPROT(ARPROT_1),
        .ARREGION(ARREGION_1),
        .ARLEN(ARLEN_1),
        .ARSIZE(ARSIZE_1),
        .ARBURST(ARBURST_1),
        .ARLOCK(ARLOCK_1),
        .ARCACHE(ARCACHE_1),
        .ARQOS(ARQOS_1),
        .ARID(ARID_1),
        .ARUSER(ARUSER_1),
        .ARREADY(ARREADY_1),
        .RVALID(RVALID_1),
        .RDATA(RDATA_1),
        .RRESP(RRESP_1),
        .RLAST(RLAST_1),
        .RID(RID_1),
        .RUSER(RUSER_1),
        .RREADY(RREADY_1),
        .WVALID(WVALID_1),
        .WDATA(WDATA_1),
        .WSTRB(WSTRB_1),
        .WLAST(WLAST_1),
        .WUSER(WUSER_1),
        .WREADY(WREADY_1),
        .BVALID(BVALID_1),
        .BRESP(BRESP_1),
        .BID(BID_1),
        .BUSER(BUSER_1),
        .BREADY(BREADY_1)
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
        .PATH_NAME("uvm_test_top")
    )
    mgc_axi4_s1
    (
        .ACLK(clock_gen_default_clk_gen),
        .ARESETn(reset_gen_default_reset_gen),
        .AWVALID(AWVALID_2),
        .AWADDR(AWADDR_2),
        .AWPROT(AWPROT_2),
        .AWREGION(AWREGION_2),
        .AWLEN(AWLEN_2),
        .AWSIZE(AWSIZE_2),
        .AWBURST(AWBURST_2),
        .AWLOCK(AWLOCK_2),
        .AWCACHE(AWCACHE_2),
        .AWQOS(AWQOS_2),
        .AWID(AWID_2),
        .AWUSER(AWUSER_2),
        .AWREADY(AWREADY_2),
        .ARVALID(ARVALID_2),
        .ARADDR(ARADDR_2),
        .ARPROT(ARPROT_2),
        .ARREGION(ARREGION_2),
        .ARLEN(ARLEN_2),
        .ARSIZE(ARSIZE_2),
        .ARBURST(ARBURST_2),
        .ARLOCK(ARLOCK_2),
        .ARCACHE(ARCACHE_2),
        .ARQOS(ARQOS_2),
        .ARID(ARID_2),
        .ARUSER(ARUSER_2),
        .ARREADY(ARREADY_2),
        .RVALID(RVALID_2),
        .RDATA(RDATA_2),
        .RRESP(RRESP_2),
        .RLAST(RLAST_2),
        .RID(RID_2),
        .RUSER(RUSER_2),
        .RREADY(RREADY_2),
        .WVALID(WVALID_2),
        .WDATA(WDATA_2),
        .WSTRB(WSTRB_2),
        .WLAST(WLAST_2),
        .WUSER(WUSER_2),
        .WREADY(WREADY_2),
        .BVALID(BVALID_2),
        .BRESP(BRESP_2),
        .BID(BID_2),
        .BUSER(BUSER_2),
        .BREADY(BREADY_2)
    );
    default_clk_gen default_clk_gen_inst(clock_gen_default_clk_gen);
    default_reset_gen default_reset_gen_inst(reset_gen_default_reset_gen,clock_gen_default_clk_gen);

endmodule: hdl_axi4_2x2_fabric_qvip
