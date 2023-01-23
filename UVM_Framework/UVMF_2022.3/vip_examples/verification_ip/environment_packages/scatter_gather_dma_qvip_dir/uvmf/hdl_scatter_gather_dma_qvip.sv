//
// File: hdl_scatter_gather_dma_qvip.sv
//
// Generated from Mentor VIP Configurator (20201007)
// Generated using Mentor VIP Library ( 2020.4 : 10/16/2020:13:17 )
//
module hdl_scatter_gather_dma_qvip;
    parameter  UNIQUE_ID = "";
    parameter  MGC_AXI4_M0_ACTIVE = 1;
    parameter  MGC_AXI4_S0_ACTIVE = 1;
    parameter  EXT_CLK_RESET = 0;
    import uvm_pkg::*;
    import scatter_gather_dma_qvip_params_pkg::*;
    wire                                                        default_clk_gen_CLK;
    wire                                                        default_reset_gen_RESET;
    wire                                                        mgc_axi4_m0_AWVALID;
    wire [mgc_axi4_m0_params::AXI4_ADDRESS_WIDTH-1:0]           mgc_axi4_m0_AWADDR;
    wire [2:0]                                                  mgc_axi4_m0_AWPROT;
    wire                                                        mgc_axi4_m0_AWREADY;
    wire                                                        mgc_axi4_m0_ARVALID;
    wire [mgc_axi4_m0_params::AXI4_ADDRESS_WIDTH-1:0]           mgc_axi4_m0_ARADDR;
    wire [2:0]                                                  mgc_axi4_m0_ARPROT;
    wire                                                        mgc_axi4_m0_ARREADY;
    wire                                                        mgc_axi4_m0_RVALID;
    wire [mgc_axi4_m0_params::AXI4_RDATA_WIDTH-1:0]             mgc_axi4_m0_RDATA;
    wire [1:0]                                                  mgc_axi4_m0_RRESP;
    wire                                                        mgc_axi4_m0_RREADY;
    wire                                                        mgc_axi4_m0_WVALID;
    wire [mgc_axi4_m0_params::AXI4_WDATA_WIDTH-1:0]             mgc_axi4_m0_WDATA;
    wire [(mgc_axi4_m0_params::AXI4_WDATA_WIDTH/8)-1:0]         mgc_axi4_m0_WSTRB;
    wire                                                        mgc_axi4_m0_WREADY;
    wire                                                        mgc_axi4_m0_BVALID;
    wire [1:0]                                                  mgc_axi4_m0_BRESP;
    wire                                                        mgc_axi4_m0_BREADY;
    wire                                                        mgc_axi4_s0_AWVALID;
    wire [mgc_axi4_s0_params::AXI4_ADDRESS_WIDTH-1:0]           mgc_axi4_s0_AWADDR;
    wire [7:0]                                                  mgc_axi4_s0_AWLEN;
    wire [mgc_axi4_s0_params::AXI4_ID_WIDTH-1:0]                mgc_axi4_s0_AWID;
    wire                                                        mgc_axi4_s0_AWREADY;
    wire                                                        mgc_axi4_s0_ARVALID;
    wire [mgc_axi4_s0_params::AXI4_ADDRESS_WIDTH-1:0]           mgc_axi4_s0_ARADDR;
    wire [7:0]                                                  mgc_axi4_s0_ARLEN;
    wire [mgc_axi4_s0_params::AXI4_ID_WIDTH-1:0]                mgc_axi4_s0_ARID;
    wire                                                        mgc_axi4_s0_ARREADY;
    wire                                                        mgc_axi4_s0_RVALID;
    wire [mgc_axi4_s0_params::AXI4_RDATA_WIDTH-1:0]             mgc_axi4_s0_RDATA;
    wire [1:0]                                                  mgc_axi4_s0_RRESP;
    wire                                                        mgc_axi4_s0_RLAST;
    wire [mgc_axi4_s0_params::AXI4_ID_WIDTH-1:0]                mgc_axi4_s0_RID;
    wire [mgc_axi4_s0_params::AXI4_USER_WIDTH-1:0]              mgc_axi4_s0_RUSER;
    wire                                                        mgc_axi4_s0_RREADY;
    wire                                                        mgc_axi4_s0_WVALID;
    wire [mgc_axi4_s0_params::AXI4_WDATA_WIDTH-1:0]             mgc_axi4_s0_WDATA;
    wire [(mgc_axi4_s0_params::AXI4_WDATA_WIDTH/8)-1:0]         mgc_axi4_s0_WSTRB;
    wire                                                        mgc_axi4_s0_WLAST;
    wire                                                        mgc_axi4_s0_WREADY;
    wire                                                        mgc_axi4_s0_BVALID;
    wire [1:0]                                                  mgc_axi4_s0_BRESP;
    wire [mgc_axi4_s0_params::AXI4_ID_WIDTH-1:0]                mgc_axi4_s0_BID;
    wire [mgc_axi4_s0_params::AXI4_USER_WIDTH-1:0]              mgc_axi4_s0_BUSER;
    wire                                                        mgc_axi4_s0_BREADY;
    
    
    generate
        if ( EXT_CLK_RESET == 0 )
        begin: generate_internal_clk_rst
            default_clk_gen default_clk_gen
            (
                .CLK(default_clk_gen_CLK)
            );
            default_reset_gen default_reset_gen
            (
                .RESET(default_reset_gen_RESET),
                .CLK_IN(default_clk_gen_CLK)
            );
        end
    endgenerate
    generate
        if ( MGC_AXI4_M0_ACTIVE )
        begin: generate_active_mgc_axi4_m0
            axi4_master 
            #(
                .ADDR_WIDTH(mgc_axi4_m0_params::AXI4_ADDRESS_WIDTH),
                .RDATA_WIDTH(mgc_axi4_m0_params::AXI4_RDATA_WIDTH),
                .WDATA_WIDTH(mgc_axi4_m0_params::AXI4_WDATA_WIDTH),
                .ID_WIDTH(mgc_axi4_m0_params::AXI4_ID_WIDTH),
                .USER_WIDTH(mgc_axi4_m0_params::AXI4_USER_WIDTH),
                .REGION_MAP_SIZE(mgc_axi4_m0_params::AXI4_REGION_MAP_SIZE),
                .IF_NAME({UNIQUE_ID,"mgc_axi4_m0"}),
                .PATH_NAME("UVMF_VIRTUAL_INTERFACES")
            )
            mgc_axi4_m0
            (
                .ACLK(default_clk_gen_CLK),
                .ARESETn(default_reset_gen_RESET),
                .AWVALID(mgc_axi4_m0_AWVALID),
                .AWADDR(mgc_axi4_m0_AWADDR),
                .AWPROT(mgc_axi4_m0_AWPROT),
                .AWREGION(),
                .AWLEN(),
                .AWSIZE(),
                .AWBURST(),
                .AWLOCK(),
                .AWCACHE(),
                .AWQOS(),
                .AWID(),
                .AWUSER(),
                .AWREADY(mgc_axi4_m0_AWREADY),
                .ARVALID(mgc_axi4_m0_ARVALID),
                .ARADDR(mgc_axi4_m0_ARADDR),
                .ARPROT(mgc_axi4_m0_ARPROT),
                .ARREGION(),
                .ARLEN(),
                .ARSIZE(),
                .ARBURST(),
                .ARLOCK(),
                .ARCACHE(),
                .ARQOS(),
                .ARID(),
                .ARUSER(),
                .ARREADY(mgc_axi4_m0_ARREADY),
                .RVALID(mgc_axi4_m0_RVALID),
                .RDATA(mgc_axi4_m0_RDATA),
                .RRESP(mgc_axi4_m0_RRESP),
                .RLAST(),
                .RID(),
                .RUSER(),
                .RREADY(mgc_axi4_m0_RREADY),
                .WVALID(mgc_axi4_m0_WVALID),
                .WDATA(mgc_axi4_m0_WDATA),
                .WSTRB(mgc_axi4_m0_WSTRB),
                .WLAST(),
                .WUSER(),
                .WREADY(mgc_axi4_m0_WREADY),
                .BVALID(mgc_axi4_m0_BVALID),
                .BRESP(mgc_axi4_m0_BRESP),
                .BID(),
                .BUSER(),
                .BREADY(mgc_axi4_m0_BREADY)
            );
        end
        else
        begin: generate_passive_mgc_axi4_m0_monitor
            axi4_monitor 
            #(
                .ADDR_WIDTH(mgc_axi4_m0_params::AXI4_ADDRESS_WIDTH),
                .RDATA_WIDTH(mgc_axi4_m0_params::AXI4_RDATA_WIDTH),
                .WDATA_WIDTH(mgc_axi4_m0_params::AXI4_WDATA_WIDTH),
                .ID_WIDTH(mgc_axi4_m0_params::AXI4_ID_WIDTH),
                .USER_WIDTH(mgc_axi4_m0_params::AXI4_USER_WIDTH),
                .REGION_MAP_SIZE(mgc_axi4_m0_params::AXI4_REGION_MAP_SIZE),
                .IF_NAME({UNIQUE_ID,"mgc_axi4_m0"}),
                .PATH_NAME("UVMF_VIRTUAL_INTERFACES")
            )
            mgc_axi4_m0
            (
                .ACLK(default_clk_gen_CLK),
                .ARESETn(default_reset_gen_RESET),
                .AWVALID(mgc_axi4_m0_AWVALID),
                .AWADDR(mgc_axi4_m0_AWADDR),
                .AWPROT(mgc_axi4_m0_AWPROT),
                .AWREGION(),
                .AWLEN(),
                .AWSIZE(),
                .AWBURST(),
                .AWLOCK(),
                .AWCACHE(),
                .AWQOS(),
                .AWID(),
                .AWUSER(),
                .AWREADY(mgc_axi4_m0_AWREADY),
                .ARVALID(mgc_axi4_m0_ARVALID),
                .ARADDR(mgc_axi4_m0_ARADDR),
                .ARPROT(mgc_axi4_m0_ARPROT),
                .ARREGION(),
                .ARLEN(),
                .ARSIZE(),
                .ARBURST(),
                .ARLOCK(),
                .ARCACHE(),
                .ARQOS(),
                .ARID(),
                .ARUSER(),
                .ARREADY(mgc_axi4_m0_ARREADY),
                .RVALID(mgc_axi4_m0_RVALID),
                .RDATA(mgc_axi4_m0_RDATA),
                .RRESP(mgc_axi4_m0_RRESP),
                .RLAST(),
                .RID(),
                .RUSER(),
                .RREADY(mgc_axi4_m0_RREADY),
                .WVALID(mgc_axi4_m0_WVALID),
                .WDATA(mgc_axi4_m0_WDATA),
                .WSTRB(mgc_axi4_m0_WSTRB),
                .WLAST(),
                .WUSER(),
                .WREADY(mgc_axi4_m0_WREADY),
                .BVALID(mgc_axi4_m0_BVALID),
                .BRESP(mgc_axi4_m0_BRESP),
                .BID(),
                .BUSER(),
                .BREADY(mgc_axi4_m0_BREADY)
            );
        end
    endgenerate
    generate
        if ( MGC_AXI4_S0_ACTIVE )
        begin: generate_active_mgc_axi4_s0
            axi4_slave 
            #(
                .ADDR_WIDTH(mgc_axi4_s0_params::AXI4_ADDRESS_WIDTH),
                .RDATA_WIDTH(mgc_axi4_s0_params::AXI4_RDATA_WIDTH),
                .WDATA_WIDTH(mgc_axi4_s0_params::AXI4_WDATA_WIDTH),
                .ID_WIDTH(mgc_axi4_s0_params::AXI4_ID_WIDTH),
                .USER_WIDTH(mgc_axi4_s0_params::AXI4_USER_WIDTH),
                .REGION_MAP_SIZE(mgc_axi4_s0_params::AXI4_REGION_MAP_SIZE),
                .IF_NAME({UNIQUE_ID,"mgc_axi4_s0"}),
                .PATH_NAME("UVMF_VIRTUAL_INTERFACES")
            )
            mgc_axi4_s0
            (
                .ACLK(default_clk_gen_CLK),
                .ARESETn(default_reset_gen_RESET),
                .AWVALID(mgc_axi4_s0_AWVALID),
                .AWADDR(mgc_axi4_s0_AWADDR),
                .AWPROT(3'b0),
                .AWREGION(4'b0),
                .AWLEN(mgc_axi4_s0_AWLEN),
                .AWSIZE(3'b011),
                .AWBURST(2'b01),
                .AWLOCK(1'b0),
                .AWCACHE(4'b0),
                .AWQOS(4'b0),
                .AWID(mgc_axi4_s0_AWID),
                .AWUSER(4'b0),
                .AWREADY(mgc_axi4_s0_AWREADY),
                .ARVALID(mgc_axi4_s0_ARVALID),
                .ARADDR(mgc_axi4_s0_ARADDR),
                .ARPROT(3'b0),
                .ARREGION(4'b0),
                .ARLEN(mgc_axi4_s0_ARLEN),
                .ARSIZE(3'b011),
                .ARBURST(2'b01),
                .ARLOCK(1'b0),
                .ARCACHE(4'b0),
                .ARQOS(4'b0),
                .ARID(mgc_axi4_s0_ARID),
                .ARUSER(4'b0),
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
                .WUSER(4'b0),
                .WREADY(mgc_axi4_s0_WREADY),
                .BVALID(mgc_axi4_s0_BVALID),
                .BRESP(mgc_axi4_s0_BRESP),
                .BID(mgc_axi4_s0_BID),
                .BUSER(mgc_axi4_s0_BUSER),
                .BREADY(mgc_axi4_s0_BREADY)
            );
        end
        else
        begin: generate_passive_mgc_axi4_s0_monitor
            axi4_monitor 
            #(
                .ADDR_WIDTH(mgc_axi4_s0_params::AXI4_ADDRESS_WIDTH),
                .RDATA_WIDTH(mgc_axi4_s0_params::AXI4_RDATA_WIDTH),
                .WDATA_WIDTH(mgc_axi4_s0_params::AXI4_WDATA_WIDTH),
                .ID_WIDTH(mgc_axi4_s0_params::AXI4_ID_WIDTH),
                .USER_WIDTH(mgc_axi4_s0_params::AXI4_USER_WIDTH),
                .REGION_MAP_SIZE(mgc_axi4_s0_params::AXI4_REGION_MAP_SIZE),
                .IF_NAME({UNIQUE_ID,"mgc_axi4_s0"}),
                .PATH_NAME("UVMF_VIRTUAL_INTERFACES")
            )
            mgc_axi4_s0
            (
                .ACLK(default_clk_gen_CLK),
                .ARESETn(default_reset_gen_RESET),
                .AWVALID(mgc_axi4_s0_AWVALID),
                .AWADDR(mgc_axi4_s0_AWADDR),
                .AWPROT(3'b0),
                .AWREGION(4'b0),
                .AWLEN(mgc_axi4_s0_AWLEN),
                .AWSIZE(3'b011),
                .AWBURST(2'b01),
                .AWLOCK(1'b0),
                .AWCACHE(4'b0),
                .AWQOS(4'b0),
                .AWID(mgc_axi4_s0_AWID),
                .AWUSER(4'b0),
                .AWREADY(mgc_axi4_s0_AWREADY),
                .ARVALID(mgc_axi4_s0_ARVALID),
                .ARADDR(mgc_axi4_s0_ARADDR),
                .ARPROT(3'b0),
                .ARREGION(4'b0),
                .ARLEN(mgc_axi4_s0_ARLEN),
                .ARSIZE(3'b011),
                .ARBURST(2'b01),
                .ARLOCK(1'b0),
                .ARCACHE(4'b0),
                .ARQOS(4'b0),
                .ARID(mgc_axi4_s0_ARID),
                .ARUSER(4'b0),
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
                .WUSER(4'b0),
                .WREADY(mgc_axi4_s0_WREADY),
                .BVALID(mgc_axi4_s0_BVALID),
                .BRESP(mgc_axi4_s0_BRESP),
                .BID(mgc_axi4_s0_BID),
                .BUSER(mgc_axi4_s0_BUSER),
                .BREADY(mgc_axi4_s0_BREADY)
            );
        end
    endgenerate

endmodule: hdl_scatter_gather_dma_qvip
