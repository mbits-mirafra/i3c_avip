module mgc_ethernet_mac_hdl #(
   string VIP_IF_UVM_NAME = " ",
   string VIP_IF_UVM_CONTEXT = "",
   int    NUM_LANES = 4,
   bit    TX_IDX = 0
)(
   mgc_ethernet_signal_if pin_if/*,
	 input	resetn,
   input  logic TX_CLK_2X,                     //The transactor's MAC Transmit (TXC, TXD) interface is running at this clock...  
   output logic [NUM_LANES-1:0]TXC,
   output logic [NUM_LANES-1:0][7:0]TXD,
   input  logic RX_CLK_2X,                     //The transactor's MAC Receive (RXC, RXD) interface is running at this clock...
   input	logic [NUM_LANES-1:0]RXC,
   input	logic [NUM_LANES-1:0][7:0]RXD
*/); //pragma attribute mgc_ethernet_mac_hdl partition_module_xrtl

  localparam bit RX_IDX = ~TX_IDX;

`ifdef XRTL

   //
   // Some glue logic:
   //
   wire resetn = pin_if.reset;
   wire TX_CLK_2X = pin_if.clk_0;
   wire RX_CLK_2X = pin_if.clk_1;

   wire [NUM_LANES-1:0]      TXC;
   wire [NUM_LANES-1:0][7:0] TXD;
   wire [NUM_LANES-1:0]      RXC;
   wire [NUM_LANES-1:0][7:0] RXD;

   for (genvar i = 0; i < NUM_LANES; i++) begin
      assign pin_if.XC[TX_IDX][i] = TXC[i];
      assign pin_if.XD[TX_IDX][i] = TXD[i];
      assign RXC[i] = pin_if.XC[RX_IDX][i];
      assign RXD[i] = pin_if.XD[RX_IDX][i];
   end

   //
   // Instantiate VTL XRTL BFM:
   //
   eth_mac #(
      .NUM_OF_LANES(NUM_LANES)
   ) vip_mod (
      .resetn(resetn),
      .TX_CLK_2X(TX_CLK_2X),
      .TXC(TXC),
      .TXD(TXD),
      .RX_CLK_2X(RX_CLK_2X),
      .RXC(RXC),
      .RXD(RXD)
   );

`else

   //
   // Instantiate QVIP interface:
   //
   mgc_ethernet vip_if (
      .iclk_0(pin_if.clk_0), 
      .iclk_1(pin_if.clk_1), 
      .ian_clk_0(pin_if.an_clk_0), 
      .ian_clk_1(pin_if.an_clk_1), 
      .iMDC(pin_if.MDC), 
      .ireset(pin_if.reset)
   );

   //
   // Register QVIP interface with UVM config DB using given UVM context and name:
   //
   initial begin
     uvm_pkg::uvm_config_db #(virtual mgc_ethernet)::set(null, VIP_IF_UVM_CONTEXT, VIP_IF_UVM_NAME, vip_if);
   end

   //
   // Cross-wire QVIP interface signals and protocol interface port signals:
   // Inputs:  pin_if -> vip_if
   // Outputs: vip_if -> pin_if
   //
 
   // Transmit wires
   assign pin_if.XD[TX_IDX]                 = vip_if.XD[TX_IDX];
   assign pin_if.XC[TX_IDX]                 = vip_if.XC[TX_IDX];
   assign pin_if.lane_bit[TX_IDX]           = vip_if.lane_bit[TX_IDX];
   assign pin_if.lane_bit_n[TX_IDX]         = vip_if.lane_bit_n[TX_IDX];
   assign pin_if.L_10b[TX_IDX]              = vip_if.L_10b[TX_IDX];
   assign pin_if.XSBI_DATA_PARALLEL[TX_IDX] = vip_if.XSBI_DATA_PARALLEL[TX_IDX];
   assign pin_if.pcs_baser_66b[TX_IDX]      = vip_if.pcs_baser_66b[TX_IDX];
   assign pin_if.MDIO_OUT                   = vip_if.MDIO_OUT;
 
   // Receive wires
   assign vip_if.XD[RX_IDX]                 = pin_if.XD[RX_IDX];
   assign vip_if.XC[RX_IDX]                 = pin_if.XC[RX_IDX];
   assign vip_if.lane_bit[RX_IDX]           = pin_if.lane_bit[RX_IDX];
   assign vip_if.lane_bit_n[RX_IDX]         = pin_if.lane_bit_n[RX_IDX];
   assign vip_if.L_10b[RX_IDX]              = pin_if.L_10b[RX_IDX];
   assign vip_if.XSBI_DATA_PARALLEL[RX_IDX] = pin_if.XSBI_DATA_PARALLEL[RX_IDX];
   assign vip_if.pcs_baser_66b[RX_IDX]      = pin_if.pcs_baser_66b[RX_IDX];
   assign vip_if.MDIO_IN                    = pin_if.MDIO_IN;

`endif

endmodule: mgc_ethernet_mac_hdl
