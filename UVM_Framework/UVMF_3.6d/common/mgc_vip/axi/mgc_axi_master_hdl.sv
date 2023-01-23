module mgc_axi_master_hdl #(
   int ADDR_WIDTH  = 32,
   int RDATA_WIDTH = 32,
   int WDATA_WIDTH = 32,
   int ID_WIDTH    = 4,
   string VIP_IF_UVM_NAME,
   string VIP_IF_UVM_CONTEXT,
   int write_addr_channel_phase_emul_BUFFER_MAX_ELEMENTS = 17, 
   int write_channel_phase_BUFFER_MAX_ELEMENTS = 49, 
   int BURST_BUFFER = 16
)(mgc_axi_signal_if pin_if); //pragma attribute mgc_axi_master_hdl partition_module_xrtl

`ifdef XRTL

   //
   // Instantiate VTL XRTL BFM:
   //
   mgc_xrtl_axi_master #(
      .AXI_ADDRESS_WIDTH(ADDR_WIDTH),
      .AXI_RDATA_WIDTH(RDATA_WIDTH),
      .AXI_WDATA_WIDTH(WDATA_WIDTH),
      .AXI_ID_WIDTH(ID_WIDTH),
      .write_addr_channel_phase_emul_BUFFER_MAX_ELEMENTS(write_addr_channel_phase_emul_BUFFER_MAX_ELEMENTS),
      .write_channel_phase_BUFFER_MAX_ELEMENTS(write_channel_phase_BUFFER_MAX_ELEMENTS),
      .BURST_BUFFER(BURST_BUFFER)
   ) vip_module (
      .ACLK(pin_if.ACLK),
      .ARESETn(pin_if.ARESETn),
      .AWVALID(pin_if.AWVALID),
      .AWADDR(pin_if.AWADDR),
      .AWLEN(pin_if.AWLEN),
      .AWSIZE(pin_if.AWSIZE),
      .AWBURST(pin_if.AWBURST),
      .AWLOCK(pin_if.AWLOCK),
      .AWCACHE(pin_if.AWCACHE),
      .AWPROT(pin_if.AWPROT),
      .AWID(pin_if.AWID),
      .AWREADY(pin_if.AWREADY),
      .AWUSER(pin_if.AWUSER),
      .ARVALID(pin_if.ARVALID),
      .ARADDR(pin_if.ARADDR),
      .ARLEN(pin_if.ARLEN),
      .ARSIZE(pin_if.ARSIZE),
      .ARBURST(pin_if.ARBURST),
      .ARLOCK(pin_if.ARLOCK),
      .ARCACHE(pin_if.ARCACHE),
      .ARPROT(pin_if.ARPROT),
      .ARID(pin_if.ARID),
      .ARREADY(pin_if.ARREADY),
      .ARUSER(pin_if.ARUSER),
      .RVALID(pin_if.RVALID),
      .RLAST(pin_if.RLAST),
      .RDATA(pin_if.RDATA),
      .RRESP(pin_if.RRESP),
      .RID(pin_if.RID),
      .RREADY(pin_if.RREADY),
      .RUSER(pin_if.RUSER),
      .WVALID(pin_if.WVALID),
      .WLAST(pin_if.WLAST),
      .WDATA(pin_if.WDATA),
      .WSTRB(pin_if.WSTRB),
      .WID(pin_if.WID),
      .WREADY(pin_if.WREADY),
      .WUSER(pin_if.WUSER),
      .BVALID(pin_if.BVALID),
      .BRESP(pin_if.BRESP),
      .BID(pin_if.BID),
      .BREADY(pin_if.BREADY),
      .BUSER(pin_if.BUSER)
   );

`else

   //
   // Instantiate QVIP connectivity module:
   //
   axi_master #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .RDATA_WIDTH(RDATA_WIDTH),
      .WDATA_WIDTH(WDATA_WIDTH),
      .ID_WIDTH(ID_WIDTH),
      .IF_NAME(VIP_IF_UVM_NAME),
      .PATH_NAME(VIP_IF_UVM_CONTEXT)
   ) vip_module (
      .ACLK(pin_if.ACLK),
      .ARESETn(pin_if.ARESETn),
      .AWVALID(pin_if.AWVALID),
      .AWADDR(pin_if.AWADDR),
      .AWLEN(pin_if.AWLEN[3:0]), // !!!
      .AWSIZE(pin_if.AWSIZE),
      .AWBURST(pin_if.AWBURST),
      .AWLOCK(pin_if.AWLOCK),
      .AWCACHE(pin_if.AWCACHE),
      .AWPROT(pin_if.AWPROT),
      .AWID(pin_if.AWID),
      .AWREADY(pin_if.AWREADY),
      .ARVALID(pin_if.ARVALID),
      .ARADDR(pin_if.ARADDR),
      .ARLEN(pin_if.ARLEN[3:0]), // !!!
      .ARSIZE(pin_if.ARSIZE),
      .ARBURST(pin_if.ARBURST),
      .ARLOCK(pin_if.ARLOCK),
      .ARCACHE(pin_if.ARCACHE),
      .ARPROT(pin_if.ARPROT),
      .ARID(pin_if.ARID),
      .ARREADY(pin_if.ARREADY),
      .RVALID(pin_if.RVALID),
      .RLAST(pin_if.RLAST),
      .RDATA(pin_if.RDATA),
      .RRESP(pin_if.RRESP),
      .RID(pin_if.RID),
      .RREADY(pin_if.RREADY),
      .WVALID(pin_if.WVALID),
      .WLAST(pin_if.WLAST),
      .WDATA(pin_if.WDATA),
      .WSTRB(pin_if.WSTRB),
      .WID(pin_if.WID),
      .WREADY(pin_if.WREADY),
      .BVALID(pin_if.BVALID),
      .BRESP(pin_if.BRESP),
      .BID(pin_if.BID),
      .BREADY(pin_if.BREADY),
      .RUSER(pin_if.RUSER),
      .BUSER(pin_if.BUSER),
      .WUSER(pin_if.WUSER),
      .AWUSER(pin_if.AWUSER),
      .ARUSER(pin_if.ARUSER)
	 );

`endif

endmodule: mgc_axi_master_hdl
