module mgc_ethernet_device_hdl #(
   string VIP_IF_UVM_NAME = " ",
   string VIP_IF_UVM_CONTEXT = "",
   bit    TX_IDX = 0
)(
   mgc_ethernet_signal_if pin_if,
	 //input	resetn,
   input  REF_CLK_2X,                       //The transactor's internal MAC layer is running at this clock...
   input  REF_CLK_X,                        //The transactor's PHY (PCS+PMA) layer is running at this clock...
   input  logic [19:0] pcs_pma_tx_data,     //This is the input to the PHY layer of the transactor @ REF_CLK_X
   output logic [19:0] pcs_pma_rx_data      //This is the output from the PHY layer of the transactor @ REF_CLK_X
); //pragma attribute mgc_ethernet_device_hdl partition_module_xrtl

  localparam bit RX_IDX = ~TX_IDX;

`ifdef XRTL

/*
   //
   // Some glue logic:
   //
   wire resetn = pin_if.reset;
   wire REF_CLK_X  = pin_if.clk_0;
   wire REF_CLK_2X = pin_if.clk_1;

   wire [19:0] pcs_pma_tx_data;
   wire [19:0] pcs_pma_rx_data;

   for (genvar i = 0; i < 20; i++) begin
      pin_if.pcs_baser_66b?  //wire [65:0] pcs_baser_66b[2][20];
      assign pcs_pma_tx_data[i] = pin_if.lane_bit[TX_IDX][i];
      assign pin_if.lane_bit[RX_IDX][i] = pcs_pma_rx_data[i];
   end
*/

   //
   // Instantiate VTL XRTL BFM:
   //
   eth_device_top vip_mod (
      .resetn(pin_if.reset),
      .REF_CLK_2X(REF_CLK_2X),
      .REF_CLK_X(REF_CLK_X),
      .pcs_pma_tx_data(pcs_pma_tx_data),
      .pcs_pma_rx_data(pcs_pma_rx_data)
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

endmodule: mgc_ethernet_device_hdl
