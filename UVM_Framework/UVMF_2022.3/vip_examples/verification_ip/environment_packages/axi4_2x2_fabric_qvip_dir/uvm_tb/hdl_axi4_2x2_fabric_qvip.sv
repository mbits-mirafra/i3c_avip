//
// File: hdl_axi4_2x2_fabric_qvip.sv
//
// Generated from Mentor VIP Configurator (20191003)
// Generated using Mentor VIP Library ( 2019.4 : 10/16/2019:13:47 )
//
module hdl_axi4_2x2_fabric_qvip;
    import uvm_pkg::*;
    import axi4_2x2_fabric_qvip_params_pkg::*;
    wire                                                  default_clk_gen_CLK;
    wire                                                  default_reset_gen_RESET;
    wire                                                  mgc_axi4_m0_AWVALID;
    wire [mgc_axi4_m0_params::AXI4_ADDRESS_WIDTH-1:0]     mgc_axi4_m0_AWADDR;
    wire [2:0]                                            mgc_axi4_m0_AWPROT;
    wire [3:0]                                            mgc_axi4_m0_AWREGION;
    wire [7:0]                                            mgc_axi4_m0_AWLEN;
    wire [2:0]                                            mgc_axi4_m0_AWSIZE;
    wire [1:0]                                            mgc_axi4_m0_AWBURST;
    wire                                                  mgc_axi4_m0_AWLOCK;
    wire [3:0]                                            mgc_axi4_m0_AWCACHE;
    wire [3:0]                                            mgc_axi4_m0_AWQOS;
    wire [mgc_axi4_m0_params::AXI4_ID_WIDTH-1:0]          mgc_axi4_m0_AWID;
    wire [mgc_axi4_m0_params::AXI4_USER_WIDTH-1:0]        mgc_axi4_m0_AWUSER;
    wire                                                  mgc_axi4_m0_AWREADY;
    wire                                                  mgc_axi4_m0_ARVALID;
    wire [mgc_axi4_m0_params::AXI4_ADDRESS_WIDTH-1:0]     mgc_axi4_m0_ARADDR;
    wire [2:0]                                            mgc_axi4_m0_ARPROT;
    wire [3:0]                                            mgc_axi4_m0_ARREGION;
    wire [7:0]                                            mgc_axi4_m0_ARLEN;
    wire [2:0]                                            mgc_axi4_m0_ARSIZE;
    wire [1:0]                                            mgc_axi4_m0_ARBURST;
    wire                                                  mgc_axi4_m0_ARLOCK;
    wire [3:0]                                            mgc_axi4_m0_ARCACHE;
    wire [3:0]                                            mgc_axi4_m0_ARQOS;
    wire [mgc_axi4_m0_params::AXI4_ID_WIDTH-1:0]          mgc_axi4_m0_ARID;
    wire [mgc_axi4_m0_params::AXI4_USER_WIDTH-1:0]        mgc_axi4_m0_ARUSER;
    wire                                                  mgc_axi4_m0_ARREADY;
    wire                                                  mgc_axi4_m0_RVALID;
    wire [mgc_axi4_m0_params::AXI4_RDATA_WIDTH-1:0]       mgc_axi4_m0_RDATA;
    wire [1:0]                                            mgc_axi4_m0_RRESP;
    wire                                                  mgc_axi4_m0_RLAST;
    wire [mgc_axi4_m0_params::AXI4_ID_WIDTH-1:0]          mgc_axi4_m0_RID;
    wire [mgc_axi4_m0_params::AXI4_USER_WIDTH-1:0]        mgc_axi4_m0_RUSER;
    wire                                                  mgc_axi4_m0_RREADY;
    wire                                                  mgc_axi4_m0_WVALID;
    wire [mgc_axi4_m0_params::AXI4_WDATA_WIDTH-1:0]       mgc_axi4_m0_WDATA;
    wire [(mgc_axi4_m0_params::AXI4_WDATA_WIDTH/8)-1:0]   mgc_axi4_m0_WSTRB;
    wire                                                  mgc_axi4_m0_WLAST;
    wire [mgc_axi4_m0_params::AXI4_USER_WIDTH-1:0]        mgc_axi4_m0_WUSER;
    wire                                                  mgc_axi4_m0_WREADY;
    wire                                                  mgc_axi4_m0_BVALID;
    wire [1:0]                                            mgc_axi4_m0_BRESP;
    wire [mgc_axi4_m0_params::AXI4_ID_WIDTH-1:0]          mgc_axi4_m0_BID;
    wire [mgc_axi4_m0_params::AXI4_USER_WIDTH-1:0]        mgc_axi4_m0_BUSER;
    wire                                                  mgc_axi4_m0_BREADY;
    wire                                                  mgc_axi4_m1_AWVALID;
    wire [mgc_axi4_m1_params::AXI4_ADDRESS_WIDTH-1:0]     mgc_axi4_m1_AWADDR;
    wire [2:0]                                            mgc_axi4_m1_AWPROT;
    wire [3:0]                                            mgc_axi4_m1_AWREGION;
    wire [7:0]                                            mgc_axi4_m1_AWLEN;
    wire [2:0]                                            mgc_axi4_m1_AWSIZE;
    wire [1:0]                                            mgc_axi4_m1_AWBURST;
    wire                                                  mgc_axi4_m1_AWLOCK;
    wire [3:0]                                            mgc_axi4_m1_AWCACHE;
    wire [3:0]                                            mgc_axi4_m1_AWQOS;
    wire [mgc_axi4_m1_params::AXI4_ID_WIDTH-1:0]          mgc_axi4_m1_AWID;
    wire [mgc_axi4_m1_params::AXI4_USER_WIDTH-1:0]        mgc_axi4_m1_AWUSER;
    wire                                                  mgc_axi4_m1_AWREADY;
    wire                                                  mgc_axi4_m1_ARVALID;
    wire [mgc_axi4_m1_params::AXI4_ADDRESS_WIDTH-1:0]     mgc_axi4_m1_ARADDR;
    wire [2:0]                                            mgc_axi4_m1_ARPROT;
    wire [3:0]                                            mgc_axi4_m1_ARREGION;
    wire [7:0]                                            mgc_axi4_m1_ARLEN;
    wire [2:0]                                            mgc_axi4_m1_ARSIZE;
    wire [1:0]                                            mgc_axi4_m1_ARBURST;
    wire                                                  mgc_axi4_m1_ARLOCK;
    wire [3:0]                                            mgc_axi4_m1_ARCACHE;
    wire [3:0]                                            mgc_axi4_m1_ARQOS;
    wire [mgc_axi4_m1_params::AXI4_ID_WIDTH-1:0]          mgc_axi4_m1_ARID;
    wire [mgc_axi4_m1_params::AXI4_USER_WIDTH-1:0]        mgc_axi4_m1_ARUSER;
    wire                                                  mgc_axi4_m1_ARREADY;
    wire                                                  mgc_axi4_m1_RVALID;
    wire [mgc_axi4_m1_params::AXI4_RDATA_WIDTH-1:0]       mgc_axi4_m1_RDATA;
    wire [1:0]                                            mgc_axi4_m1_RRESP;
    wire                                                  mgc_axi4_m1_RLAST;
    wire [mgc_axi4_m1_params::AXI4_ID_WIDTH-1:0]          mgc_axi4_m1_RID;
    wire [mgc_axi4_m1_params::AXI4_USER_WIDTH-1:0]        mgc_axi4_m1_RUSER;
    wire                                                  mgc_axi4_m1_RREADY;
    wire                                                  mgc_axi4_m1_WVALID;
    wire [mgc_axi4_m1_params::AXI4_WDATA_WIDTH-1:0]       mgc_axi4_m1_WDATA;
    wire [(mgc_axi4_m1_params::AXI4_WDATA_WIDTH/8)-1:0]   mgc_axi4_m1_WSTRB;
    wire                                                  mgc_axi4_m1_WLAST;
    wire [mgc_axi4_m1_params::AXI4_USER_WIDTH-1:0]        mgc_axi4_m1_WUSER;
    wire                                                  mgc_axi4_m1_WREADY;
    wire                                                  mgc_axi4_m1_BVALID;
    wire [1:0]                                            mgc_axi4_m1_BRESP;
    wire [mgc_axi4_m1_params::AXI4_ID_WIDTH-1:0]          mgc_axi4_m1_BID;
    wire [mgc_axi4_m1_params::AXI4_USER_WIDTH-1:0]        mgc_axi4_m1_BUSER;
    wire                                                  mgc_axi4_m1_BREADY;
    wire                                                  mgc_axi4_s0_AWVALID;
    wire [mgc_axi4_s0_params::AXI4_ADDRESS_WIDTH-1:0]     mgc_axi4_s0_AWADDR;
    wire [2:0]                                            mgc_axi4_s0_AWPROT;
    wire [3:0]                                            mgc_axi4_s0_AWREGION;
    wire [7:0]                                            mgc_axi4_s0_AWLEN;
    wire [2:0]                                            mgc_axi4_s0_AWSIZE;
    wire [1:0]                                            mgc_axi4_s0_AWBURST;
    wire                                                  mgc_axi4_s0_AWLOCK;
    wire [3:0]                                            mgc_axi4_s0_AWCACHE;
    wire [3:0]                                            mgc_axi4_s0_AWQOS;
    wire [mgc_axi4_s0_params::AXI4_ID_WIDTH-1:0]          mgc_axi4_s0_AWID;
    wire [mgc_axi4_s0_params::AXI4_USER_WIDTH-1:0]        mgc_axi4_s0_AWUSER;
    wire                                                  mgc_axi4_s0_AWREADY;
    wire                                                  mgc_axi4_s0_ARVALID;
    wire [mgc_axi4_s0_params::AXI4_ADDRESS_WIDTH-1:0]     mgc_axi4_s0_ARADDR;
    wire [2:0]                                            mgc_axi4_s0_ARPROT;
    wire [3:0]                                            mgc_axi4_s0_ARREGION;
    wire [7:0]                                            mgc_axi4_s0_ARLEN;
    wire [2:0]                                            mgc_axi4_s0_ARSIZE;
    wire [1:0]                                            mgc_axi4_s0_ARBURST;
    wire                                                  mgc_axi4_s0_ARLOCK;
    wire [3:0]                                            mgc_axi4_s0_ARCACHE;
    wire [3:0]                                            mgc_axi4_s0_ARQOS;
    wire [mgc_axi4_s0_params::AXI4_ID_WIDTH-1:0]          mgc_axi4_s0_ARID;
    wire [mgc_axi4_s0_params::AXI4_USER_WIDTH-1:0]        mgc_axi4_s0_ARUSER;
    wire                                                  mgc_axi4_s0_ARREADY;
    wire                                                  mgc_axi4_s0_RVALID;
    wire [mgc_axi4_s0_params::AXI4_RDATA_WIDTH-1:0]       mgc_axi4_s0_RDATA;
    wire [1:0]                                            mgc_axi4_s0_RRESP;
    wire                                                  mgc_axi4_s0_RLAST;
    wire [mgc_axi4_s0_params::AXI4_ID_WIDTH-1:0]          mgc_axi4_s0_RID;
    wire [mgc_axi4_s0_params::AXI4_USER_WIDTH-1:0]        mgc_axi4_s0_RUSER;
    wire                                                  mgc_axi4_s0_RREADY;
    wire                                                  mgc_axi4_s0_WVALID;
    wire [mgc_axi4_s0_params::AXI4_WDATA_WIDTH-1:0]       mgc_axi4_s0_WDATA;
    wire [(mgc_axi4_s0_params::AXI4_WDATA_WIDTH/8)-1:0]   mgc_axi4_s0_WSTRB;
    wire                                                  mgc_axi4_s0_WLAST;
    wire [mgc_axi4_s0_params::AXI4_USER_WIDTH-1:0]        mgc_axi4_s0_WUSER;
    wire                                                  mgc_axi4_s0_WREADY;
    wire                                                  mgc_axi4_s0_BVALID;
    wire [1:0]                                            mgc_axi4_s0_BRESP;
    wire [mgc_axi4_s0_params::AXI4_ID_WIDTH-1:0]          mgc_axi4_s0_BID;
    wire [mgc_axi4_s0_params::AXI4_USER_WIDTH-1:0]        mgc_axi4_s0_BUSER;
    wire                                                  mgc_axi4_s0_BREADY;
    wire                                                  mgc_axi4_s1_AWVALID;
    wire [mgc_axi4_s1_params::AXI4_ADDRESS_WIDTH-1:0]     mgc_axi4_s1_AWADDR;
    wire [2:0]                                            mgc_axi4_s1_AWPROT;
    wire [3:0]                                            mgc_axi4_s1_AWREGION;
    wire [7:0]                                            mgc_axi4_s1_AWLEN;
    wire [2:0]                                            mgc_axi4_s1_AWSIZE;
    wire [1:0]                                            mgc_axi4_s1_AWBURST;
    wire                                                  mgc_axi4_s1_AWLOCK;
    wire [3:0]                                            mgc_axi4_s1_AWCACHE;
    wire [3:0]                                            mgc_axi4_s1_AWQOS;
    wire [mgc_axi4_s1_params::AXI4_ID_WIDTH-1:0]          mgc_axi4_s1_AWID;
    wire [mgc_axi4_s1_params::AXI4_USER_WIDTH-1:0]        mgc_axi4_s1_AWUSER;
    wire                                                  mgc_axi4_s1_AWREADY;
    wire                                                  mgc_axi4_s1_ARVALID;
    wire [mgc_axi4_s1_params::AXI4_ADDRESS_WIDTH-1:0]     mgc_axi4_s1_ARADDR;
    wire [2:0]                                            mgc_axi4_s1_ARPROT;
    wire [3:0]                                            mgc_axi4_s1_ARREGION;
    wire [7:0]                                            mgc_axi4_s1_ARLEN;
    wire [2:0]                                            mgc_axi4_s1_ARSIZE;
    wire [1:0]                                            mgc_axi4_s1_ARBURST;
    wire                                                  mgc_axi4_s1_ARLOCK;
    wire [3:0]                                            mgc_axi4_s1_ARCACHE;
    wire [3:0]                                            mgc_axi4_s1_ARQOS;
    wire [mgc_axi4_s1_params::AXI4_ID_WIDTH-1:0]          mgc_axi4_s1_ARID;
    wire [mgc_axi4_s1_params::AXI4_USER_WIDTH-1:0]        mgc_axi4_s1_ARUSER;
    wire                                                  mgc_axi4_s1_ARREADY;
    wire                                                  mgc_axi4_s1_RVALID;
    wire [mgc_axi4_s1_params::AXI4_RDATA_WIDTH-1:0]       mgc_axi4_s1_RDATA;
    wire [1:0]                                            mgc_axi4_s1_RRESP;
    wire                                                  mgc_axi4_s1_RLAST;
    wire [mgc_axi4_s1_params::AXI4_ID_WIDTH-1:0]          mgc_axi4_s1_RID;
    wire [mgc_axi4_s1_params::AXI4_USER_WIDTH-1:0]        mgc_axi4_s1_RUSER;
    wire                                                  mgc_axi4_s1_RREADY;
    wire                                                  mgc_axi4_s1_WVALID;
    wire [mgc_axi4_s1_params::AXI4_WDATA_WIDTH-1:0]       mgc_axi4_s1_WDATA;
    wire [(mgc_axi4_s1_params::AXI4_WDATA_WIDTH/8)-1:0]   mgc_axi4_s1_WSTRB;
    wire                                                  mgc_axi4_s1_WLAST;
    wire [mgc_axi4_s1_params::AXI4_USER_WIDTH-1:0]        mgc_axi4_s1_WUSER;
    wire                                                  mgc_axi4_s1_WREADY;
    wire                                                  mgc_axi4_s1_BVALID;
    wire [1:0]                                            mgc_axi4_s1_BRESP;
    wire [mgc_axi4_s1_params::AXI4_ID_WIDTH-1:0]          mgc_axi4_s1_BID;
    wire [mgc_axi4_s1_params::AXI4_USER_WIDTH-1:0]        mgc_axi4_s1_BUSER;
    wire                                                  mgc_axi4_s1_BREADY;
    
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
        .ACLK(default_clk_gen_CLK),
        .ARESETn(default_reset_gen_RESET),
        .AWVALID(mgc_axi4_m0_AWVALID),
        .AWADDR(mgc_axi4_m0_AWADDR),
        .AWPROT(mgc_axi4_m0_AWPROT),
        .AWREGION(mgc_axi4_m0_AWREGION),
        .AWLEN(mgc_axi4_m0_AWLEN),
        .AWSIZE(mgc_axi4_m0_AWSIZE),
        .AWBURST(mgc_axi4_m0_AWBURST),
        .AWLOCK(mgc_axi4_m0_AWLOCK),
        .AWCACHE(mgc_axi4_m0_AWCACHE),
        .AWQOS(mgc_axi4_m0_AWQOS),
        .AWID(mgc_axi4_m0_AWID),
        .AWUSER(mgc_axi4_m0_AWUSER),
        .AWREADY(mgc_axi4_m0_AWREADY),
        .ARVALID(mgc_axi4_m0_ARVALID),
        .ARADDR(mgc_axi4_m0_ARADDR),
        .ARPROT(mgc_axi4_m0_ARPROT),
        .ARREGION(mgc_axi4_m0_ARREGION),
        .ARLEN(mgc_axi4_m0_ARLEN),
        .ARSIZE(mgc_axi4_m0_ARSIZE),
        .ARBURST(mgc_axi4_m0_ARBURST),
        .ARLOCK(mgc_axi4_m0_ARLOCK),
        .ARCACHE(mgc_axi4_m0_ARCACHE),
        .ARQOS(mgc_axi4_m0_ARQOS),
        .ARID(mgc_axi4_m0_ARID),
        .ARUSER(mgc_axi4_m0_ARUSER),
        .ARREADY(mgc_axi4_m0_ARREADY),
        .RVALID(mgc_axi4_m0_RVALID),
        .RDATA(mgc_axi4_m0_RDATA),
        .RRESP(mgc_axi4_m0_RRESP),
        .RLAST(mgc_axi4_m0_RLAST),
        .RID(mgc_axi4_m0_RID),
        .RUSER(mgc_axi4_m0_RUSER),
        .RREADY(mgc_axi4_m0_RREADY),
        .WVALID(mgc_axi4_m0_WVALID),
        .WDATA(mgc_axi4_m0_WDATA),
        .WSTRB(mgc_axi4_m0_WSTRB),
        .WLAST(mgc_axi4_m0_WLAST),
        .WUSER(mgc_axi4_m0_WUSER),
        .WREADY(mgc_axi4_m0_WREADY),
        .BVALID(mgc_axi4_m0_BVALID),
        .BRESP(mgc_axi4_m0_BRESP),
        .BID(mgc_axi4_m0_BID),
        .BUSER(mgc_axi4_m0_BUSER),
        .BREADY(mgc_axi4_m0_BREADY)
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
        .ACLK(default_clk_gen_CLK),
        .ARESETn(default_reset_gen_RESET),
        .AWVALID(mgc_axi4_m1_AWVALID),
        .AWADDR(mgc_axi4_m1_AWADDR),
        .AWPROT(mgc_axi4_m1_AWPROT),
        .AWREGION(mgc_axi4_m1_AWREGION),
        .AWLEN(mgc_axi4_m1_AWLEN),
        .AWSIZE(mgc_axi4_m1_AWSIZE),
        .AWBURST(mgc_axi4_m1_AWBURST),
        .AWLOCK(mgc_axi4_m1_AWLOCK),
        .AWCACHE(mgc_axi4_m1_AWCACHE),
        .AWQOS(mgc_axi4_m1_AWQOS),
        .AWID(mgc_axi4_m1_AWID),
        .AWUSER(mgc_axi4_m1_AWUSER),
        .AWREADY(mgc_axi4_m1_AWREADY),
        .ARVALID(mgc_axi4_m1_ARVALID),
        .ARADDR(mgc_axi4_m1_ARADDR),
        .ARPROT(mgc_axi4_m1_ARPROT),
        .ARREGION(mgc_axi4_m1_ARREGION),
        .ARLEN(mgc_axi4_m1_ARLEN),
        .ARSIZE(mgc_axi4_m1_ARSIZE),
        .ARBURST(mgc_axi4_m1_ARBURST),
        .ARLOCK(mgc_axi4_m1_ARLOCK),
        .ARCACHE(mgc_axi4_m1_ARCACHE),
        .ARQOS(mgc_axi4_m1_ARQOS),
        .ARID(mgc_axi4_m1_ARID),
        .ARUSER(mgc_axi4_m1_ARUSER),
        .ARREADY(mgc_axi4_m1_ARREADY),
        .RVALID(mgc_axi4_m1_RVALID),
        .RDATA(mgc_axi4_m1_RDATA),
        .RRESP(mgc_axi4_m1_RRESP),
        .RLAST(mgc_axi4_m1_RLAST),
        .RID(mgc_axi4_m1_RID),
        .RUSER(mgc_axi4_m1_RUSER),
        .RREADY(mgc_axi4_m1_RREADY),
        .WVALID(mgc_axi4_m1_WVALID),
        .WDATA(mgc_axi4_m1_WDATA),
        .WSTRB(mgc_axi4_m1_WSTRB),
        .WLAST(mgc_axi4_m1_WLAST),
        .WUSER(mgc_axi4_m1_WUSER),
        .WREADY(mgc_axi4_m1_WREADY),
        .BVALID(mgc_axi4_m1_BVALID),
        .BRESP(mgc_axi4_m1_BRESP),
        .BID(mgc_axi4_m1_BID),
        .BUSER(mgc_axi4_m1_BUSER),
        .BREADY(mgc_axi4_m1_BREADY)
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
        .ACLK(default_clk_gen_CLK),
        .ARESETn(default_reset_gen_RESET),
        .AWVALID(mgc_axi4_s0_AWVALID),
        .AWADDR(mgc_axi4_s0_AWADDR),
        .AWPROT(mgc_axi4_s0_AWPROT),
        .AWREGION(mgc_axi4_s0_AWREGION),
        .AWLEN(mgc_axi4_s0_AWLEN),
        .AWSIZE(mgc_axi4_s0_AWSIZE),
        .AWBURST(mgc_axi4_s0_AWBURST),
        .AWLOCK(mgc_axi4_s0_AWLOCK),
        .AWCACHE(mgc_axi4_s0_AWCACHE),
        .AWQOS(mgc_axi4_s0_AWQOS),
        .AWID(mgc_axi4_s0_AWID),
        .AWUSER(mgc_axi4_s0_AWUSER),
        .AWREADY(mgc_axi4_s0_AWREADY),
        .ARVALID(mgc_axi4_s0_ARVALID),
        .ARADDR(mgc_axi4_s0_ARADDR),
        .ARPROT(mgc_axi4_s0_ARPROT),
        .ARREGION(mgc_axi4_s0_ARREGION),
        .ARLEN(mgc_axi4_s0_ARLEN),
        .ARSIZE(mgc_axi4_s0_ARSIZE),
        .ARBURST(mgc_axi4_s0_ARBURST),
        .ARLOCK(mgc_axi4_s0_ARLOCK),
        .ARCACHE(mgc_axi4_s0_ARCACHE),
        .ARQOS(mgc_axi4_s0_ARQOS),
        .ARID(mgc_axi4_s0_ARID),
        .ARUSER(mgc_axi4_s0_ARUSER),
        .ARREADY(mgc_axi4_s0_ARREADY),
        .RVALID(mgc_axi4_s0_RVALID),
        .RDATA(mgc_axi4_s0_RDATA),
        .RRESP(mgc_axi4_s0_RRESP),
        .RLAST(mgc_axi4_s0_RLAST),
        .RID(mgc_axi4_s0_RID),
        .RUSER(mgc_axi4_s0_RUSER),
        .RREADY(mgc_axi4_s0_RREADY),
        .WVALID(mgc_axi4_s0_WVALID),
        .WDATA(mgc_axi4_s0_WDATA),
        .WSTRB(mgc_axi4_s0_WSTRB),
        .WLAST(mgc_axi4_s0_WLAST),
        .WUSER(mgc_axi4_s0_WUSER),
        .WREADY(mgc_axi4_s0_WREADY),
        .BVALID(mgc_axi4_s0_BVALID),
        .BRESP(mgc_axi4_s0_BRESP),
        .BID(mgc_axi4_s0_BID),
        .BUSER(mgc_axi4_s0_BUSER),
        .BREADY(mgc_axi4_s0_BREADY)
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
        .ACLK(default_clk_gen_CLK),
        .ARESETn(default_reset_gen_RESET),
        .AWVALID(mgc_axi4_s1_AWVALID),
        .AWADDR(mgc_axi4_s1_AWADDR),
        .AWPROT(mgc_axi4_s1_AWPROT),
        .AWREGION(mgc_axi4_s1_AWREGION),
        .AWLEN(mgc_axi4_s1_AWLEN),
        .AWSIZE(mgc_axi4_s1_AWSIZE),
        .AWBURST(mgc_axi4_s1_AWBURST),
        .AWLOCK(mgc_axi4_s1_AWLOCK),
        .AWCACHE(mgc_axi4_s1_AWCACHE),
        .AWQOS(mgc_axi4_s1_AWQOS),
        .AWID(mgc_axi4_s1_AWID),
        .AWUSER(mgc_axi4_s1_AWUSER),
        .AWREADY(mgc_axi4_s1_AWREADY),
        .ARVALID(mgc_axi4_s1_ARVALID),
        .ARADDR(mgc_axi4_s1_ARADDR),
        .ARPROT(mgc_axi4_s1_ARPROT),
        .ARREGION(mgc_axi4_s1_ARREGION),
        .ARLEN(mgc_axi4_s1_ARLEN),
        .ARSIZE(mgc_axi4_s1_ARSIZE),
        .ARBURST(mgc_axi4_s1_ARBURST),
        .ARLOCK(mgc_axi4_s1_ARLOCK),
        .ARCACHE(mgc_axi4_s1_ARCACHE),
        .ARQOS(mgc_axi4_s1_ARQOS),
        .ARID(mgc_axi4_s1_ARID),
        .ARUSER(mgc_axi4_s1_ARUSER),
        .ARREADY(mgc_axi4_s1_ARREADY),
        .RVALID(mgc_axi4_s1_RVALID),
        .RDATA(mgc_axi4_s1_RDATA),
        .RRESP(mgc_axi4_s1_RRESP),
        .RLAST(mgc_axi4_s1_RLAST),
        .RID(mgc_axi4_s1_RID),
        .RUSER(mgc_axi4_s1_RUSER),
        .RREADY(mgc_axi4_s1_RREADY),
        .WVALID(mgc_axi4_s1_WVALID),
        .WDATA(mgc_axi4_s1_WDATA),
        .WSTRB(mgc_axi4_s1_WSTRB),
        .WLAST(mgc_axi4_s1_WLAST),
        .WUSER(mgc_axi4_s1_WUSER),
        .WREADY(mgc_axi4_s1_WREADY),
        .BVALID(mgc_axi4_s1_BVALID),
        .BRESP(mgc_axi4_s1_BRESP),
        .BID(mgc_axi4_s1_BID),
        .BUSER(mgc_axi4_s1_BUSER),
        .BREADY(mgc_axi4_s1_BREADY)
    );
    default_clk_gen default_clk_gen
    (
        .CLK(default_clk_gen_CLK)
    );
    default_reset_gen default_reset_gen
    (
        .RESET(default_reset_gen_RESET),
        .CLK_IN(default_clk_gen_CLK)
    );

endmodule: hdl_axi4_2x2_fabric_qvip
