module mgc_axi4_slave_hdl #(
   int ADDR_WIDTH  = 32,
   int RDATA_WIDTH = 32,
   int WDATA_WIDTH = 32,
   int ID_WIDTH    = 4,
   int USER_WIDTH  = 4,
   int REGION_MAP_SIZE = 16,
   string VIP_IF_UVM_NAME,
   string VIP_IF_UVM_CONTEXT
)(mgc_axi4_signal_if pin_if); //pragma attribute mgc_axi4_slave_hdl partition_module_xrtl


`ifdef XRTL

   //
   // Instantiate VTL XRTL BFM:
   //
   mgc_xrtl_axi4_slave #(
      .AXI4_ADDRESS_WIDTH(ADDR_WIDTH),
      .AXI4_RDATA_WIDTH(RDATA_WIDTH),
      .AXI4_WDATA_WIDTH(WDATA_WIDTH),
      .AXI4_ID_WIDTH(ID_WIDTH),
      .AXI4_USER_WIDTH(USER_WIDTH)
   ) vip_module (
      .ACLK(pin_if.ACLK),
      .ARESETn(pin_if.ARESETn),
      .AWVALID(pin_if.AWVALID),
      .AWADDR(pin_if.AWADDR),
      .AWPROT(pin_if.AWPROT),
      .AWREGION(pin_if.AWREGION),
      .AWLEN(pin_if.AWLEN),
      .AWSIZE(pin_if.AWSIZE),
      .AWBURST(pin_if.AWBURST),
      .AWLOCK(pin_if.AWLOCK),
      .AWCACHE(pin_if.AWCACHE),
      .AWQOS(pin_if.AWQOS),
      .AWID(pin_if.AWID),
      .AWUSER(pin_if.AWUSER),
      .AWREADY(pin_if.AWREADY),
      .ARVALID(pin_if.ARVALID),
      .ARADDR(pin_if.ARADDR),
      .ARPROT(pin_if.ARPROT),
      .ARREGION(pin_if.ARREGION),
      .ARLEN(pin_if.ARLEN),
      .ARSIZE(pin_if.ARSIZE),
      .ARBURST(pin_if.ARBURST),
      .ARLOCK(pin_if.ARLOCK),
      .ARCACHE(pin_if.ARCACHE),
      .ARQOS(pin_if.ARQOS),
      .ARID(pin_if.ARID),
      .ARUSER(pin_if.ARUSER),
      .ARREADY(pin_if.ARREADY),
      .RVALID(pin_if.RVALID),
      .RDATA(pin_if.RDATA),
      .RRESP(pin_if.RRESP),
      .RLAST(pin_if.RLAST),
      .RID(pin_if.RID),
      .RUSER(pin_if.RUSER),
      .RREADY(pin_if.RREADY),
      .WVALID(pin_if.WVALID),
      .WDATA(pin_if.WDATA),
      .WSTRB(pin_if.WSTRB),
      .WLAST(pin_if.WLAST),
      .WUSER(pin_if.WUSER),
      .WREADY(pin_if.WREADY),
      .BVALID(pin_if.BVALID),
      .BRESP(pin_if.BRESP),
      .BID(pin_if.BID),
      .BUSER(pin_if.BUSER),
      .BREADY(pin_if.BREADY)
   );

`else

   //
   // Instantiate QVIP connectivity module:
   //
   axi4_slave #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .RDATA_WIDTH(RDATA_WIDTH),
      .WDATA_WIDTH(WDATA_WIDTH),
      .ID_WIDTH(ID_WIDTH),
      .USER_WIDTH(USER_WIDTH),
      .REGION_MAP_SIZE(REGION_MAP_SIZE),
      .IF_NAME(VIP_IF_UVM_NAME),
      .PATH_NAME(VIP_IF_UVM_CONTEXT)
   ) vip_module (
      .ACLK(pin_if.ACLK),
      .ARESETn(pin_if.ARESETn),
      .AWVALID(pin_if.AWVALID),
      .AWADDR(pin_if.AWADDR),
      .AWPROT(pin_if.AWPROT),
      .AWREGION(pin_if.AWREGION),
      .AWLEN(pin_if.AWLEN),
      .AWSIZE(pin_if.AWSIZE),
      .AWBURST(pin_if.AWBURST),
      .AWLOCK(pin_if.AWLOCK),
      .AWCACHE(pin_if.AWCACHE),
      .AWQOS(pin_if.AWQOS),
      .AWID(pin_if.AWID),
      .AWUSER(pin_if.AWUSER),
      .AWREADY(pin_if.AWREADY),
      .ARVALID(pin_if.ARVALID),
      .ARADDR(pin_if.ARADDR),
      .ARPROT(pin_if.ARPROT),
      .ARREGION(pin_if.ARREGION),
      .ARLEN(pin_if.ARLEN),
      .ARSIZE(pin_if.ARSIZE),
      .ARBURST(pin_if.ARBURST),
      .ARLOCK(pin_if.ARLOCK),
      .ARCACHE(pin_if.ARCACHE),
      .ARQOS(pin_if.ARQOS),
      .ARID(pin_if.ARID),
      .ARUSER(pin_if.ARUSER),
      .ARREADY(pin_if.ARREADY),
      .RVALID(pin_if.RVALID),
      .RDATA(pin_if.RDATA),
      .RRESP(pin_if.RRESP),
      .RLAST(pin_if.RLAST),
      .RID(pin_if.RID),
      .RUSER(pin_if.RUSER),
      .RREADY(pin_if.RREADY),
      .WVALID(pin_if.WVALID),
      .WDATA(pin_if.WDATA),
      .WSTRB(pin_if.WSTRB),
      .WLAST(pin_if.WLAST),
      .WUSER(pin_if.WUSER),
      .WREADY(pin_if.WREADY),
      .BVALID(pin_if.BVALID),
      .BRESP(pin_if.BRESP),
      .BID(pin_if.BID),
      .BUSER(pin_if.BUSER),
      .BREADY(pin_if.BREADY)
	 );

`endif

endmodule: mgc_axi4_slave_hdl
