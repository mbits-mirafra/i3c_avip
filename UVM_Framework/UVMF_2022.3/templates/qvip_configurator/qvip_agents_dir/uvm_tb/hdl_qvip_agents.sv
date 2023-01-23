//
// File: hdl_qvip_agents.sv
//
// Generated from Mentor VIP Configurator (20200402)
// Generated using Mentor VIP Library ( 2020.2 : 04/19/2020:18:58 )
//
module hdl_qvip_agents;
    import uvm_pkg::*;
    import qvip_agents_params_pkg::*;
    wire                                                            default_clk_gen_CLK;
    wire                                                            default_reset_gen_RESET;
    wire                                                            pcie_ep_clk;
    wire                                                            pcie_ep_rst_n;
    wire [pcie_ep_params::LANES-1:0]                                pcie_ep_rx_data_plus;
    wire [pcie_ep_params::LANES-1:0]                                pcie_ep_rx_data_minus;
    wire [pcie_ep_params::LANES-1:0]                                pcie_ep_tx_data_plus;
    wire [pcie_ep_params::LANES-1:0]                                pcie_ep_tx_data_minus;
    tri1                                                            pcie_ep_clkreq;
    tri1                                                            pcie_ep_wake_up_n;
    wire                                                            pcie_ep_clk_jitter;
    wire                                                            axi4_master_0_AWVALID;
    wire [axi4_master_0_params::AXI4_ADDRESS_WIDTH-1:0]             axi4_master_0_AWADDR;
    wire [2:0]                                                      axi4_master_0_AWPROT;
    wire [3:0]                                                      axi4_master_0_AWREGION;
    wire [7:0]                                                      axi4_master_0_AWLEN;
    wire [((axi4_master_0_params::AXI4_WDATA_WIDTH==2048)?3:2):0]   axi4_master_0_AWSIZE;
    wire [1:0]                                                      axi4_master_0_AWBURST;
    wire                                                            axi4_master_0_AWLOCK;
    wire [3:0]                                                      axi4_master_0_AWCACHE;
    wire [3:0]                                                      axi4_master_0_AWQOS;
    wire [axi4_master_0_params::AXI4_ID_WIDTH-1:0]                  axi4_master_0_AWID;
    wire [axi4_master_0_params::AXI4_USER_WIDTH-1:0]                axi4_master_0_AWUSER;
    wire                                                            axi4_master_0_AWREADY;
    wire                                                            axi4_master_0_ARVALID;
    wire [axi4_master_0_params::AXI4_ADDRESS_WIDTH-1:0]             axi4_master_0_ARADDR;
    wire [2:0]                                                      axi4_master_0_ARPROT;
    wire [3:0]                                                      axi4_master_0_ARREGION;
    wire [7:0]                                                      axi4_master_0_ARLEN;
    wire [((axi4_master_0_params::AXI4_RDATA_WIDTH==2048)?3:2):0]   axi4_master_0_ARSIZE;
    wire [1:0]                                                      axi4_master_0_ARBURST;
    wire                                                            axi4_master_0_ARLOCK;
    wire [3:0]                                                      axi4_master_0_ARCACHE;
    wire [3:0]                                                      axi4_master_0_ARQOS;
    wire [axi4_master_0_params::AXI4_ID_WIDTH-1:0]                  axi4_master_0_ARID;
    wire [axi4_master_0_params::AXI4_USER_WIDTH-1:0]                axi4_master_0_ARUSER;
    wire                                                            axi4_master_0_ARREADY;
    wire                                                            axi4_master_0_RVALID;
    wire [axi4_master_0_params::AXI4_RDATA_WIDTH-1:0]               axi4_master_0_RDATA;
    wire [1:0]                                                      axi4_master_0_RRESP;
    wire                                                            axi4_master_0_RLAST;
    wire [axi4_master_0_params::AXI4_ID_WIDTH-1:0]                  axi4_master_0_RID;
    wire [axi4_master_0_params::AXI4_USER_WIDTH-1:0]                axi4_master_0_RUSER;
    wire                                                            axi4_master_0_RREADY;
    wire                                                            axi4_master_0_WVALID;
    wire [axi4_master_0_params::AXI4_WDATA_WIDTH-1:0]               axi4_master_0_WDATA;
    wire [(axi4_master_0_params::AXI4_WDATA_WIDTH/8)-1:0]           axi4_master_0_WSTRB;
    wire                                                            axi4_master_0_WLAST;
    wire [axi4_master_0_params::AXI4_USER_WIDTH-1:0]                axi4_master_0_WUSER;
    wire                                                            axi4_master_0_WREADY;
    wire                                                            axi4_master_0_BVALID;
    wire [1:0]                                                      axi4_master_0_BRESP;
    wire [axi4_master_0_params::AXI4_ID_WIDTH-1:0]                  axi4_master_0_BID;
    wire [axi4_master_0_params::AXI4_USER_WIDTH-1:0]                axi4_master_0_BUSER;
    wire                                                            axi4_master_0_BREADY;
    wire                                                            axi4_master_1_AWVALID;
    wire [axi4_master_1_params::AXI4_ADDRESS_WIDTH-1:0]             axi4_master_1_AWADDR;
    wire [2:0]                                                      axi4_master_1_AWPROT;
    wire [3:0]                                                      axi4_master_1_AWREGION;
    wire [7:0]                                                      axi4_master_1_AWLEN;
    wire [((axi4_master_1_params::AXI4_WDATA_WIDTH==2048)?3:2):0]   axi4_master_1_AWSIZE;
    wire [1:0]                                                      axi4_master_1_AWBURST;
    wire                                                            axi4_master_1_AWLOCK;
    wire [3:0]                                                      axi4_master_1_AWCACHE;
    wire [3:0]                                                      axi4_master_1_AWQOS;
    wire [axi4_master_1_params::AXI4_ID_WIDTH-1:0]                  axi4_master_1_AWID;
    wire [axi4_master_1_params::AXI4_USER_WIDTH-1:0]                axi4_master_1_AWUSER;
    wire                                                            axi4_master_1_AWREADY;
    wire                                                            axi4_master_1_ARVALID;
    wire [axi4_master_1_params::AXI4_ADDRESS_WIDTH-1:0]             axi4_master_1_ARADDR;
    wire [2:0]                                                      axi4_master_1_ARPROT;
    wire [3:0]                                                      axi4_master_1_ARREGION;
    wire [7:0]                                                      axi4_master_1_ARLEN;
    wire [((axi4_master_1_params::AXI4_RDATA_WIDTH==2048)?3:2):0]   axi4_master_1_ARSIZE;
    wire [1:0]                                                      axi4_master_1_ARBURST;
    wire                                                            axi4_master_1_ARLOCK;
    wire [3:0]                                                      axi4_master_1_ARCACHE;
    wire [3:0]                                                      axi4_master_1_ARQOS;
    wire [axi4_master_1_params::AXI4_ID_WIDTH-1:0]                  axi4_master_1_ARID;
    wire [axi4_master_1_params::AXI4_USER_WIDTH-1:0]                axi4_master_1_ARUSER;
    wire                                                            axi4_master_1_ARREADY;
    wire                                                            axi4_master_1_RVALID;
    wire [axi4_master_1_params::AXI4_RDATA_WIDTH-1:0]               axi4_master_1_RDATA;
    wire [1:0]                                                      axi4_master_1_RRESP;
    wire                                                            axi4_master_1_RLAST;
    wire [axi4_master_1_params::AXI4_ID_WIDTH-1:0]                  axi4_master_1_RID;
    wire [axi4_master_1_params::AXI4_USER_WIDTH-1:0]                axi4_master_1_RUSER;
    wire                                                            axi4_master_1_RREADY;
    wire                                                            axi4_master_1_WVALID;
    wire [axi4_master_1_params::AXI4_WDATA_WIDTH-1:0]               axi4_master_1_WDATA;
    wire [(axi4_master_1_params::AXI4_WDATA_WIDTH/8)-1:0]           axi4_master_1_WSTRB;
    wire                                                            axi4_master_1_WLAST;
    wire [axi4_master_1_params::AXI4_USER_WIDTH-1:0]                axi4_master_1_WUSER;
    wire                                                            axi4_master_1_WREADY;
    wire                                                            axi4_master_1_BVALID;
    wire [1:0]                                                      axi4_master_1_BRESP;
    wire [axi4_master_1_params::AXI4_ID_WIDTH-1:0]                  axi4_master_1_BID;
    wire [axi4_master_1_params::AXI4_USER_WIDTH-1:0]                axi4_master_1_BUSER;
    wire                                                            axi4_master_1_BREADY;
    wire                                                            axi4_slave_AWVALID;
    wire [axi4_slave_params::AXI4_ADDRESS_WIDTH-1:0]                axi4_slave_AWADDR;
    wire [2:0]                                                      axi4_slave_AWPROT;
    wire [3:0]                                                      axi4_slave_AWREGION;
    wire [7:0]                                                      axi4_slave_AWLEN;
    wire [((axi4_slave_params::AXI4_WDATA_WIDTH==2048)?3:2):0]      axi4_slave_AWSIZE;
    wire [1:0]                                                      axi4_slave_AWBURST;
    wire                                                            axi4_slave_AWLOCK;
    wire [3:0]                                                      axi4_slave_AWCACHE;
    wire [3:0]                                                      axi4_slave_AWQOS;
    wire [axi4_slave_params::AXI4_ID_WIDTH-1:0]                     axi4_slave_AWID;
    wire [axi4_slave_params::AXI4_USER_WIDTH-1:0]                   axi4_slave_AWUSER;
    wire                                                            axi4_slave_AWREADY;
    wire                                                            axi4_slave_ARVALID;
    wire [axi4_slave_params::AXI4_ADDRESS_WIDTH-1:0]                axi4_slave_ARADDR;
    wire [2:0]                                                      axi4_slave_ARPROT;
    wire [3:0]                                                      axi4_slave_ARREGION;
    wire [7:0]                                                      axi4_slave_ARLEN;
    wire [((axi4_slave_params::AXI4_RDATA_WIDTH==2048)?3:2):0]      axi4_slave_ARSIZE;
    wire [1:0]                                                      axi4_slave_ARBURST;
    wire                                                            axi4_slave_ARLOCK;
    wire [3:0]                                                      axi4_slave_ARCACHE;
    wire [3:0]                                                      axi4_slave_ARQOS;
    wire [axi4_slave_params::AXI4_ID_WIDTH-1:0]                     axi4_slave_ARID;
    wire [axi4_slave_params::AXI4_USER_WIDTH-1:0]                   axi4_slave_ARUSER;
    wire                                                            axi4_slave_ARREADY;
    wire                                                            axi4_slave_RVALID;
    wire [axi4_slave_params::AXI4_RDATA_WIDTH-1:0]                  axi4_slave_RDATA;
    wire [1:0]                                                      axi4_slave_RRESP;
    wire                                                            axi4_slave_RLAST;
    wire [axi4_slave_params::AXI4_ID_WIDTH-1:0]                     axi4_slave_RID;
    wire [axi4_slave_params::AXI4_USER_WIDTH-1:0]                   axi4_slave_RUSER;
    wire                                                            axi4_slave_RREADY;
    wire                                                            axi4_slave_WVALID;
    wire [axi4_slave_params::AXI4_WDATA_WIDTH-1:0]                  axi4_slave_WDATA;
    wire [(axi4_slave_params::AXI4_WDATA_WIDTH/8)-1:0]              axi4_slave_WSTRB;
    wire                                                            axi4_slave_WLAST;
    wire [axi4_slave_params::AXI4_USER_WIDTH-1:0]                   axi4_slave_WUSER;
    wire                                                            axi4_slave_WREADY;
    wire                                                            axi4_slave_BVALID;
    wire [1:0]                                                      axi4_slave_BRESP;
    wire [axi4_slave_params::AXI4_ID_WIDTH-1:0]                     axi4_slave_BID;
    wire [axi4_slave_params::AXI4_USER_WIDTH-1:0]                   axi4_slave_BUSER;
    wire                                                            axi4_slave_BREADY;
    wire [apb3_config_master_params::APB3_PADDR_BIT_WIDTH-1:0]      apb3_config_master_PADDR;
    wire [apb3_config_master_params::APB3_SLAVE_COUNT-1:0]          apb3_config_master_PSEL;
    wire                                                            apb3_config_master_PENABLE;
    wire                                                            apb3_config_master_PWRITE;
    wire [apb3_config_master_params::APB3_PWDATA_BIT_WIDTH-1:0]     apb3_config_master_PWDATA;
    wire [apb3_config_master_params::APB3_PRDATA_BIT_WIDTH-1:0]     apb3_config_master_PRDATA;
    wire                                                            apb3_config_master_PREADY;
    wire                                                            apb3_config_master_PSLVERR;
    
    pcie_ep_serial 
    #(
        .LANES(pcie_ep_params::LANES),
        .PIPE_BYTES_MAX(pcie_ep_params::PIPE_BYTES_MAX),
        .CONFIG_NUM_OF_FUNCTIONS(pcie_ep_params::CONFIG_NUM_OF_FUNCTIONS),
        .INTERFACE_NAME("pcie_ep"),
        .PATH_NAME("uvm_test_top"),
        .NON_DIFF_MODE(0),
        .JITTERED_CLK(0)
    )
    pcie_ep
    (
        .clk(pcie_ep_clk),
        .rst_n(pcie_ep_rst_n),
        .rx_data_plus(pcie_ep_rx_data_plus),
        .rx_data_minus(pcie_ep_rx_data_minus),
        .tx_data_plus(pcie_ep_tx_data_plus),
        .tx_data_minus(pcie_ep_tx_data_minus),
        .clkreq(pcie_ep_clkreq),
        .wake_up_n(pcie_ep_wake_up_n),
        .clk_jitter(pcie_ep_clk_jitter)
    );
    
    axi4_master 
    #(
        .ADDR_WIDTH(axi4_master_0_params::AXI4_ADDRESS_WIDTH),
        .RDATA_WIDTH(axi4_master_0_params::AXI4_RDATA_WIDTH),
        .WDATA_WIDTH(axi4_master_0_params::AXI4_WDATA_WIDTH),
        .ID_WIDTH(axi4_master_0_params::AXI4_ID_WIDTH),
        .USER_WIDTH(axi4_master_0_params::AXI4_USER_WIDTH),
        .REGION_MAP_SIZE(axi4_master_0_params::AXI4_REGION_MAP_SIZE),
        .IF_NAME("axi4_master_0"),
        .PATH_NAME("uvm_test_top")
    )
    axi4_master_0
    (
        .ACLK(default_clk_gen_CLK),
        .ARESETn(default_reset_gen_RESET),
        .AWVALID(axi4_master_0_AWVALID),
        .AWADDR(axi4_master_0_AWADDR),
        .AWPROT(axi4_master_0_AWPROT),
        .AWREGION(axi4_master_0_AWREGION),
        .AWLEN(axi4_master_0_AWLEN),
        .AWSIZE(axi4_master_0_AWSIZE),
        .AWBURST(axi4_master_0_AWBURST),
        .AWLOCK(axi4_master_0_AWLOCK),
        .AWCACHE(axi4_master_0_AWCACHE),
        .AWQOS(axi4_master_0_AWQOS),
        .AWID(axi4_master_0_AWID),
        .AWUSER(axi4_master_0_AWUSER),
        .AWREADY(axi4_master_0_AWREADY),
        .ARVALID(axi4_master_0_ARVALID),
        .ARADDR(axi4_master_0_ARADDR),
        .ARPROT(axi4_master_0_ARPROT),
        .ARREGION(axi4_master_0_ARREGION),
        .ARLEN(axi4_master_0_ARLEN),
        .ARSIZE(axi4_master_0_ARSIZE),
        .ARBURST(axi4_master_0_ARBURST),
        .ARLOCK(axi4_master_0_ARLOCK),
        .ARCACHE(axi4_master_0_ARCACHE),
        .ARQOS(axi4_master_0_ARQOS),
        .ARID(axi4_master_0_ARID),
        .ARUSER(axi4_master_0_ARUSER),
        .ARREADY(axi4_master_0_ARREADY),
        .RVALID(axi4_master_0_RVALID),
        .RDATA(axi4_master_0_RDATA),
        .RRESP(axi4_master_0_RRESP),
        .RLAST(axi4_master_0_RLAST),
        .RID(axi4_master_0_RID),
        .RUSER(axi4_master_0_RUSER),
        .RREADY(axi4_master_0_RREADY),
        .WVALID(axi4_master_0_WVALID),
        .WDATA(axi4_master_0_WDATA),
        .WSTRB(axi4_master_0_WSTRB),
        .WLAST(axi4_master_0_WLAST),
        .WUSER(axi4_master_0_WUSER),
        .WREADY(axi4_master_0_WREADY),
        .BVALID(axi4_master_0_BVALID),
        .BRESP(axi4_master_0_BRESP),
        .BID(axi4_master_0_BID),
        .BUSER(axi4_master_0_BUSER),
        .BREADY(axi4_master_0_BREADY)
    );
    
    axi4_master 
    #(
        .ADDR_WIDTH(axi4_master_1_params::AXI4_ADDRESS_WIDTH),
        .RDATA_WIDTH(axi4_master_1_params::AXI4_RDATA_WIDTH),
        .WDATA_WIDTH(axi4_master_1_params::AXI4_WDATA_WIDTH),
        .ID_WIDTH(axi4_master_1_params::AXI4_ID_WIDTH),
        .USER_WIDTH(axi4_master_1_params::AXI4_USER_WIDTH),
        .REGION_MAP_SIZE(axi4_master_1_params::AXI4_REGION_MAP_SIZE),
        .IF_NAME("axi4_master_1"),
        .PATH_NAME("uvm_test_top")
    )
    axi4_master_1
    (
        .ACLK(default_clk_gen_CLK),
        .ARESETn(default_reset_gen_RESET),
        .AWVALID(axi4_master_1_AWVALID),
        .AWADDR(axi4_master_1_AWADDR),
        .AWPROT(axi4_master_1_AWPROT),
        .AWREGION(axi4_master_1_AWREGION),
        .AWLEN(axi4_master_1_AWLEN),
        .AWSIZE(axi4_master_1_AWSIZE),
        .AWBURST(axi4_master_1_AWBURST),
        .AWLOCK(axi4_master_1_AWLOCK),
        .AWCACHE(axi4_master_1_AWCACHE),
        .AWQOS(axi4_master_1_AWQOS),
        .AWID(axi4_master_1_AWID),
        .AWUSER(axi4_master_1_AWUSER),
        .AWREADY(axi4_master_1_AWREADY),
        .ARVALID(axi4_master_1_ARVALID),
        .ARADDR(axi4_master_1_ARADDR),
        .ARPROT(axi4_master_1_ARPROT),
        .ARREGION(axi4_master_1_ARREGION),
        .ARLEN(axi4_master_1_ARLEN),
        .ARSIZE(axi4_master_1_ARSIZE),
        .ARBURST(axi4_master_1_ARBURST),
        .ARLOCK(axi4_master_1_ARLOCK),
        .ARCACHE(axi4_master_1_ARCACHE),
        .ARQOS(axi4_master_1_ARQOS),
        .ARID(axi4_master_1_ARID),
        .ARUSER(axi4_master_1_ARUSER),
        .ARREADY(axi4_master_1_ARREADY),
        .RVALID(axi4_master_1_RVALID),
        .RDATA(axi4_master_1_RDATA),
        .RRESP(axi4_master_1_RRESP),
        .RLAST(axi4_master_1_RLAST),
        .RID(axi4_master_1_RID),
        .RUSER(axi4_master_1_RUSER),
        .RREADY(axi4_master_1_RREADY),
        .WVALID(axi4_master_1_WVALID),
        .WDATA(axi4_master_1_WDATA),
        .WSTRB(axi4_master_1_WSTRB),
        .WLAST(axi4_master_1_WLAST),
        .WUSER(axi4_master_1_WUSER),
        .WREADY(axi4_master_1_WREADY),
        .BVALID(axi4_master_1_BVALID),
        .BRESP(axi4_master_1_BRESP),
        .BID(axi4_master_1_BID),
        .BUSER(axi4_master_1_BUSER),
        .BREADY(axi4_master_1_BREADY)
    );
    
    axi4_slave 
    #(
        .ADDR_WIDTH(axi4_slave_params::AXI4_ADDRESS_WIDTH),
        .RDATA_WIDTH(axi4_slave_params::AXI4_RDATA_WIDTH),
        .WDATA_WIDTH(axi4_slave_params::AXI4_WDATA_WIDTH),
        .ID_WIDTH(axi4_slave_params::AXI4_ID_WIDTH),
        .USER_WIDTH(axi4_slave_params::AXI4_USER_WIDTH),
        .REGION_MAP_SIZE(axi4_slave_params::AXI4_REGION_MAP_SIZE),
        .IF_NAME("axi4_slave"),
        .PATH_NAME("uvm_test_top")
    )
    axi4_slave
    (
        .ACLK(default_clk_gen_CLK),
        .ARESETn(default_reset_gen_RESET),
        .AWVALID(axi4_slave_AWVALID),
        .AWADDR(axi4_slave_AWADDR),
        .AWPROT(axi4_slave_AWPROT),
        .AWREGION(axi4_slave_AWREGION),
        .AWLEN(axi4_slave_AWLEN),
        .AWSIZE(axi4_slave_AWSIZE),
        .AWBURST(axi4_slave_AWBURST),
        .AWLOCK(axi4_slave_AWLOCK),
        .AWCACHE(axi4_slave_AWCACHE),
        .AWQOS(axi4_slave_AWQOS),
        .AWID(axi4_slave_AWID),
        .AWUSER(axi4_slave_AWUSER),
        .AWREADY(axi4_slave_AWREADY),
        .ARVALID(axi4_slave_ARVALID),
        .ARADDR(axi4_slave_ARADDR),
        .ARPROT(axi4_slave_ARPROT),
        .ARREGION(axi4_slave_ARREGION),
        .ARLEN(axi4_slave_ARLEN),
        .ARSIZE(axi4_slave_ARSIZE),
        .ARBURST(axi4_slave_ARBURST),
        .ARLOCK(axi4_slave_ARLOCK),
        .ARCACHE(axi4_slave_ARCACHE),
        .ARQOS(axi4_slave_ARQOS),
        .ARID(axi4_slave_ARID),
        .ARUSER(axi4_slave_ARUSER),
        .ARREADY(axi4_slave_ARREADY),
        .RVALID(axi4_slave_RVALID),
        .RDATA(axi4_slave_RDATA),
        .RRESP(axi4_slave_RRESP),
        .RLAST(axi4_slave_RLAST),
        .RID(axi4_slave_RID),
        .RUSER(axi4_slave_RUSER),
        .RREADY(axi4_slave_RREADY),
        .WVALID(axi4_slave_WVALID),
        .WDATA(axi4_slave_WDATA),
        .WSTRB(axi4_slave_WSTRB),
        .WLAST(axi4_slave_WLAST),
        .WUSER(axi4_slave_WUSER),
        .WREADY(axi4_slave_WREADY),
        .BVALID(axi4_slave_BVALID),
        .BRESP(axi4_slave_BRESP),
        .BID(axi4_slave_BID),
        .BUSER(axi4_slave_BUSER),
        .BREADY(axi4_slave_BREADY)
    );
    
    apb_master 
    #(
        .SLAVE_COUNT(apb3_config_master_params::APB3_SLAVE_COUNT),
        .ADDR_WIDTH(apb3_config_master_params::APB3_PADDR_BIT_WIDTH),
        .WDATA_WIDTH(apb3_config_master_params::APB3_PWDATA_BIT_WIDTH),
        .RDATA_WIDTH(apb3_config_master_params::APB3_PRDATA_BIT_WIDTH),
        .IF_NAME("apb3_config_master"),
        .PATH_NAME("uvm_test_top")
    )
    apb3_config_master
    (
        .PCLK(default_clk_gen_CLK),
        .PRESETn(default_reset_gen_RESET),
        .PADDR(apb3_config_master_PADDR),
        .PSEL(apb3_config_master_PSEL),
        .PENABLE(apb3_config_master_PENABLE),
        .PWRITE(apb3_config_master_PWRITE),
        .PWDATA(apb3_config_master_PWDATA),
        .PRDATA(apb3_config_master_PRDATA),
        .PREADY(apb3_config_master_PREADY),
        .PSLVERR(apb3_config_master_PSLVERR),
        .PPROT(),
        .PSTRB()
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

endmodule: hdl_qvip_agents
