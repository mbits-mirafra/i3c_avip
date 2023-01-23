
module mgc_ahb_master_hdl #(
   int NUM_MASTERS                  = 16, 
   int NUM_MASTER_BITS              = 4, 
   int NUM_SLAVES                   = 32, 
   int ADDRESS_WIDTH                = 32, 
   int WDATA_WIDTH                  = 1024, 
   int RDATA_WIDTH                  = 1024,
   string VIP_IF_UVM_NAME,
   string VIP_IF_UVM_CONTEXT,
   int USER_DATA_WIDTH              = 64,
   int DEFAULT_BURST_TIMEOUT_FACTOR = 100000,
   bit[31:0] RTL_SLAVE              = 'hffff_ffff
) (mgc_ahb_signal_if pin_if); //pragma attribute mgc_ahb_master_hdl partition_module_xrtl


`ifdef XRTL

   //
   // Adjust for signal width differences between VTL XRTL BFM and (QVIP) pin i/f
   // (due to QVIP support for ARM11 AHB)
   //
   wire [3:0] slave_HPROT [NUM_SLAVES];
   wire [1:0] slave_HRESP [NUM_SLAVES];
   for (genvar i = 0; i < NUM_SLAVES; i++) begin
      assign pin_if.slave_HPROT[i] = {2'b00, slave_HPROT[i]};
      assign slave_HRESP[i] = pin_if.slave_HRESP[i][1:0];
   end
   wire [3:0] master_HPROT [NUM_MASTERS];
   for (genvar i = 0; i < NUM_MASTERS; i++) begin
      assign pin_if.master_HPROT[i] = {2'b00, master_HPROT[i]};
   end

   //
   // Instantiate VTL XRTL BFM:
   //
   mgc_ahb_master_module #(
      .AHB_NUM_MASTERS(NUM_MASTERS),
      .AHB_NUM_MASTER_BITS(NUM_MASTER_BITS),
      .AHB_NUM_SLAVES(NUM_SLAVES),
      .AHB_ADDRESS_WIDTH(ADDRESS_WIDTH),
      .AHB_WDATA_WIDTH(WDATA_WIDTH),
      .AHB_RDATA_WIDTH(RDATA_WIDTH),
      .AHB_USER_DATA_WIDTH(USER_DATA_WIDTH),
      .AHB_DEFAULT_BURST_TIMEOUT_FACTOR(DEFAULT_BURST_TIMEOUT_FACTOR),
      .RTL_SLAVE(RTL_SLAVE)
   ) vip_bfm ( 
      .HCLK(pin_if.HCLK),
      .HRESETn(pin_if.HRESETn),
      .rtl_slave_HSEL(pin_if.slave_HSEL),
      .rtl_slave_HADDR(pin_if.master_HADDR),
      .rtl_slave_HTRANS(pin_if.master_HTRANS),
      .rtl_slave_HWRITE(pin_if.master_HWRITE),
      .rtl_slave_HSIZE(pin_if.master_HSIZE),
      .rtl_slave_HBURST(pin_if.master_HBURST),
      .rtl_slave_HPROT(/*pin_if.*/master_HPROT),
      .rtl_slave_HWDATA(pin_if.master_HWDATA),
      .rtl_slave_HMASTER(pin_if.slave_HMASTER),
      .rtl_slave_user_HDATA(pin_if./*slave_*/user_HDATA),
      .rtl_slave_HRDATA(pin_if.slave_HRDATA),
      .rtl_slave_HREADY(pin_if.slave_HREADY),
      .rtl_slave_HRESP(/*pin_if.*/slave_HRESP),
      .rtl_slave_HSPLIT(pin_if.slave_HSPLIT),
      .arbiter_HGRANT(pin_if.arbiter_HGRANT),
      .arbiter_HMASTER(pin_if.HMASTER),
      .arbiter_HMASTLOCK(pin_if.arbiter_HMASTLOCK),
      .arbiter_HBURST(pin_if.arbiter_HBURST),
      .arbiter_HBUSREQ(pin_if.arbiter_HBUSREQ),
      .arbiter_HLOCK(pin_if.arbiter_HLOCK),
      .arbiter_HRESP(pin_if.arbiter_HRESP[1:0]),
      .arbiter_HTRANS(pin_if.arbiter_HTRANS),
      .arbiter_HREADY(pin_if.HREADY),
      .arbiter_HSPLIT(pin_if.HSPLIT),
      .external_core_HSEL(pin_if.external_core_HSEL),
      .core_HADDR_to_ex_decoder(pin_if.core_HADDR_to_ex_decoder),
      .default_Master(pin_if.default_Master)
   );

`else

  //
  // Instantiate QVIP interface:
  //
  mgc_ahb #(NUM_MASTERS, NUM_MASTER_BITS, NUM_SLAVES, ADDRESS_WIDTH, WDATA_WIDTH, RDATA_WIDTH) vip_if (pin_if.HCLK, pin_if.HRESETn);

  //
  // Register QVIP interface with UVM config DB using given UVM context and name:
  //
  initial begin

	$display("NUM_MASTERS = %0d", NUM_MASTERS);
	$display("NUM_MASTER_BITS = %0d", NUM_MASTER_BITS);
	$display("NUM_SLAVES = %0d", NUM_SLAVES);
	$display("ADDRESS_WIDTH = %0d", ADDRESS_WIDTH);
	$display("WDATA_WIDTH = %0d", WDATA_WIDTH);
	$display("RDATA_WIDTH = %0d", RDATA_WIDTH);

    uvm_pkg::uvm_config_db #(virtual mgc_ahb #(NUM_MASTERS, NUM_MASTER_BITS, NUM_SLAVES, ADDRESS_WIDTH, WDATA_WIDTH, RDATA_WIDTH))::
       set(null, VIP_IF_UVM_CONTEXT, VIP_IF_UVM_NAME, vip_if);
  end

  //
  // Cross-wire QVIP interface signals and protocol interface port signals:
  // Inputs:  pin_if -> vip_if
  // Outputs: vip_if -> pin_if
  //

  // Master driven slave inputs
   for (genvar i = 0; i < NUM_MASTERS; i++) begin
  	assign pin_if.master_HBUSREQ[i]    = vip_if.master_HBUSREQ[i];
  	assign pin_if.master_HLOCK[i]      = vip_if.master_HLOCK[i];
  	//assign pin_if.HGRANT            = vip_if.HGRANT; // Driven internally by QVIP
  	assign pin_if.master_HADDR[i]      = vip_if.master_HADDR[i];
 	  assign pin_if.master_HTRANS[i]     = vip_if.master_HTRANS[i];
  	assign pin_if.master_HWRITE[i]     = vip_if.master_HWRITE[i];
  	assign pin_if.master_HSIZE[i]      = vip_if.master_HSIZE[i];
  	assign pin_if.master_HBURST[i]     = vip_if.master_HBURST[i];
  	assign pin_if.master_HPROT[i]      = vip_if.master_HPROT[i];
  	assign pin_if.master_HWDATA[i]     = vip_if.master_HWDATA[i];
  	assign pin_if.user_HDATA[i]        = vip_if.user_HDATA[i];
  	assign pin_if.user_HADDR[i]        = vip_if.user_HADDR[i];

   end



  // Slave driven master inputs
  for (genvar i = 0; i < NUM_SLAVES; i++) begin
  	assign vip_if.slave_HRDATA[i]      = pin_if.slave_HRDATA[i];
  	assign vip_if.slave_HREADY[i]      = pin_if.slave_HREADY[i];
  	assign vip_if.slave_HRESP[i]       = pin_if.slave_HRESP[i];
  	assign vip_if.slave_HSPLIT[i]      = pin_if.slave_HSPLIT[i];
  	assign vip_if.slave_HMASTER[i]     = pin_if.slave_HMASTER[i];
//  	assign vip_if.decoder_HSEL[i]      = pin_if.decoder_HSEL[i];
  	assign pin_if.decoder_HSEL[i]      = vip_if.slave_HSEL[i];
  end

  // Arbiter driven master inputs
  assign vip_if.arbiter_HGRANT    = pin_if.arbiter_HGRANT;
  assign vip_if.HMASTER           = pin_if.HMASTER;
  //////assign vip_if.slave_HMASTER     = pin_if.slave_HMASTER;
  assign vip_if.arbiter_HMASTLOCK = pin_if.arbiter_HMASTLOCK;

  // Master driven arbiter inputs
  assign pin_if.arbiter_HBURST    = vip_if.arbiter_HBURST;
  assign pin_if.arbiter_HBUSREQ   = vip_if.arbiter_HBUSREQ;
  assign pin_if.arbiter_HLOCK     = vip_if.arbiter_HLOCK;
  assign pin_if.arbiter_HRESP     = vip_if.arbiter_HRESP;
  assign pin_if.HREADY            = vip_if.HREADY;
  assign pin_if.HSPLIT            = vip_if.HSPLIT;

  // Miscellaneous rationale unclear
  assign pin_if.HREADYin          = vip_if.HREADYin;
  //assign pin_if.HMASTLOCK         = vip_if.HMASTLOCK; // Driven internally by QVIP

  // Master driven decoder inputs
  //////assign vip_if.decoder_HSEL      = pin_if.decoder_HSEL;
  //assign vip_if.decoder_HADDR     = pin_if.decoder_HADDR; // Driven internally by QVIP

  // These signals are used only in ARM11 AHB and ignored here (for now):
  //master_HBSTROBE
  //master_HUNALIGN
  //slave_HBSTROBE
  //slave_HUNALIGN
  //slave_HDOMAIN
  //HDOMAIN*/

`endif

endmodule: mgc_ahb_master_hdl
