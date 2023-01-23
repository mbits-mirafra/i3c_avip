
module mgc_ahb_slave_hdl #(
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
   bit[31:0] RTL_MASTER             = 'hFFFF
) (mgc_ahb_signal_if pin_if); //pragma attribute mgc_ahb_slave_hdl partition_module_xrtl


`ifdef XRTL

   //
   // Adjust for signal width differences between VTL XRTL BFM and (QVIP) pin i/f
   // (due to QVIP support for ARM11 AHB)
   //
   wire [3:0] master_HPROT [NUM_MASTERS];
   for (genvar i = 0; i < NUM_MASTERS; i++) begin
      assign master_HPROT[i] = pin_if.master_HPROT[i][3:0];
   end
   wire [1:0] slave_HRESP [NUM_SLAVES];
   for (genvar i = 0; i < NUM_SLAVES; i++) begin
      assign pin_if.slave_HRESP[i] = {1'b0, slave_HRESP[i]};
   end

   //
   // Instantiate VTL XRTL BFM:
   //
   mgc_ahb_slave_module #(
      .AHB_NUM_MASTERS(NUM_MASTERS),
      .AHB_NUM_MASTER_BITS(NUM_MASTER_BITS),
      .AHB_NUM_SLAVES(NUM_SLAVES),
      .AHB_ADDRESS_WIDTH(ADDRESS_WIDTH),
      .AHB_WDATA_WIDTH(WDATA_WIDTH),
      .AHB_RDATA_WIDTH(RDATA_WIDTH)//,
      //.AHB_USER_DATA_WIDTH(USER_DATA_WIDTH),
      //.AHB_DEFAULT_BURST_TIMEOUT_FACTOR(DEFAULT_BURST_TIMEOUT_FACTOR),
      //.RTL_SLAVE(RTL_SLAVE)
   ) vip_bfm ( 
      .HCLK(pin_if.HCLK),
      .HRESETn(pin_if.HRESETn),
      .rtl_master_HBUSREQ(pin_if.master_HBUSREQ),
      .rtl_master_HLOCK(pin_if.master_HLOCK),
      .rtl_master_HADDR(pin_if.master_HADDR),
      .rtl_master_HTRANS(pin_if.master_HTRANS),
      .rtl_master_HWRITE(pin_if.master_HWRITE),
      .rtl_master_HSIZE(pin_if.master_HSIZE),
      .rtl_master_HBURST(pin_if.master_HBURST),
      .rtl_master_HPROT(/*pin_if.*/master_HPROT),
      .rtl_master_HWDATA(pin_if.master_HWDATA),
      .rtl_master_user_HDATA(pin_if.user_HDATA),
      .rtl_master_HRDATA(pin_if.slave_HRDATA),
      .rtl_master_HRESP(/*pin_if.*/slave_HRESP),
      .rtl_master_HREADY(pin_if.slave_HREADY),
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
  assign vip_if.master_HBUSREQ[i]    = pin_if.master_HBUSREQ[i];
  assign vip_if.master_HLOCK[i]      = pin_if.master_HLOCK[i];
  //assign vip_if.HGRANT            = pin_if.HGRANT; //// Driven internally by QVIP
  assign vip_if.master_HADDR[i]      = pin_if.master_HADDR[i];
  assign vip_if.master_HTRANS[i]     = pin_if.master_HTRANS[i];
  assign vip_if.master_HWRITE[i]     = pin_if.master_HWRITE[i];
  assign vip_if.master_HSIZE[i]      = pin_if.master_HSIZE[i];
  assign vip_if.master_HBURST[i]     = pin_if.master_HBURST[i];
  assign vip_if.master_HPROT[i]      = pin_if.master_HPROT[i];
  assign vip_if.master_HWDATA[i]     = pin_if.master_HWDATA[i];
  assign vip_if.user_HDATA[i]        = pin_if.user_HDATA[i];
  assign vip_if.user_HADDR[i]        = pin_if.user_HADDR[i];
end

  // Slave driven master inputs
for (genvar i = 0; i < NUM_SLAVES; i++) begin
  assign pin_if.slave_HRDATA[i]      = vip_if.slave_HRDATA[i];
  assign pin_if.slave_HREADY[i]      = vip_if.slave_HREADY[i];
  assign pin_if.slave_HRESP[i]       = vip_if.slave_HRESP[i];
  assign pin_if.slave_HSPLIT[i]      = vip_if.slave_HSPLIT[i];
  assign vip_if.slave_HMASTER[i]     = pin_if.slave_HMASTER[i];
  assign vip_if.decoder_HSEL[i]      = pin_if.decoder_HSEL[i];
end


  // Arbiter driven slave inputs
  assign vip_if.arbiter_HGRANT    = pin_if.arbiter_HGRANT;
  assign vip_if.HMASTER           = pin_if.HMASTER;
//  assign vip_if.slave_HMASTER     = pin_if.slave_HMASTER;
  assign vip_if.arbiter_HMASTLOCK = pin_if.arbiter_HMASTLOCK;

  // Master driven arbiter inputs
  assign pin_if.arbiter_HBURST    = vip_if.arbiter_HBURST;
  assign pin_if.arbiter_HBUSREQ   = vip_if.arbiter_HBUSREQ;
  //assign pin_if.arbiter_HLOCK     = vip_if.arbiter_HLOCK;
  assign pin_if.arbiter_HRESP     = vip_if.arbiter_HRESP;
  assign pin_if.HREADY            = vip_if.HREADY;
  assign pin_if.HSPLIT            = vip_if.HSPLIT;

  // Mscellaneous rationale unclear
  assign vip_if.HREADYin          = pin_if.HREADYin;
  //assign pin_if.HMASTLOCK         = vip_if.HMASTLOCK; // Driven internally by QVIP

  // Master driven decoder inputs
//  assign vip_if.decoder_HSEL      = pin_if.decoder_HSEL;
  //assign vip_if.decoder_HADDR     = pin_if.decoder_HADDR; // Driven internally by QVIP


  // These signals are used only in ARM11 AHB and ignored here (for now):
  //master_HBSTROBE
  //master_HUNALIGN
  //slave_HBSTROBE
  //slave_HUNALIGN
  //slave_HDOMAIN
  //HDOMAIN

`endif

endmodule: mgc_ahb_slave_hdl
