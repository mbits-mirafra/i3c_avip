module ahb2spi(

    //AHB port
    ahb_if ahb,
    // SPI port
    spi_if spi
);

  // Wishbone connections
parameter DATA_WIDTH = 16;
parameter ADDR_WIDTH = 32;

wire                 clk;
wire                 rst;
wire                 inta;
wire                 cyc;
wire                 stb;
wire [ADDR_WIDTH   -1:0] adr;
wire                 we;
wire [DATA_WIDTH   -1:0] din;
wire [DATA_WIDTH   -1:0] dout;
wire                 ack;

wire                 err;
wire                 rty;
wire [DATA_WIDTH/8 -1:0] sel;
wire [DATA_WIDTH   -1:0] q;


  ahb2wb #(.ADDR_WIDTH(ADDR_WIDTH),.DATA_WIDTH(DATA_WIDTH))   ahb2wb  (
       // AHB connections
      .hclk    (ahb.hclk ) ,
      .hresetn (ahb.hresetn ) ,
      .haddr   (ahb.haddr ) ,
      .hwdata  (ahb.hwdata ) ,
      .htrans  (ahb.htrans ) ,
      .hburst  (ahb.hburst ) ,
      .hsize   (ahb.hsize ) ,
      .hwrite  (ahb.hwrite ) ,
      .hsel    (ahb.hsel ) ,
      .hready  (ahb.hready ) ,
      .hrdata  (ahb.hrdata ) ,
      .hresp   (ahb.hresp ) ,

      // Wishbone connections
      .wb_clk      (clk),
      .wb_rst      (rst) ,
      .wb_cyc      (cyc ) ,
      .wb_stb      (stb ),
      .wb_addr     (adr ) ,
      .wb_we       (we ) ,
      .wb_data_in  (din ) ,
      .wb_data_out (dout ) ,
      .wb_ack      (ack ) );

wb2spi wb2spi(
  // Wishbone port
  .wb_clk(clk),
  .wb_rst(rst),
  .wb_cyc(cyc),
  .wb_stb(stb),
  .wb_addr(adr[1:0]),
  .wb_we(we),
  .wb_data_in(dout[7:0]),
  .wb_data_out(din[7:0]),
  .wb_ack(ack),

  // SPI port
  .sck(spi.sck),
  .mosi(spi.mosi),
  .miso(spi.miso)
);

endmodule


