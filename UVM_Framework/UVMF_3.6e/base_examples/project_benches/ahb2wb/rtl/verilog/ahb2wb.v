//----------------------------------------------------------------------
//                   Mentor Graphics Inc
//----------------------------------------------------------------------
// Project         : AHB to WB DUT
// Unit            : DUT
// File            : ahb2wb.v
//----------------------------------------------------------------------
// Creation Date   : 12.18.2015
//----------------------------------------------------------------------
// Description: AHB to WB Bridge
//
//----------------------------------------------------------------------
module ahb2wb(
   // AHB Ports
   hclk, hresetn, haddr, htrans, hwrite, hsize, hburst,
   hsel, hwdata, hrdata, hresp, hready, 
   // WB Ports
   wb_clk, wb_rst, wb_addr, wb_data_out, wb_data_in, wb_ack, wb_cyc, wb_we, wb_stb
   );

//parameter declaration
   parameter ADDR_WIDTH = 2;
   parameter DATA_WIDTH = 8;

//*****************************************************************************
//wishbone ports   
//*****************************************************************************
   input [DATA_WIDTH-1:0]  wb_data_in;  // data input from wishbone slave
   input                   wb_ack;      // acknowledment from wishbone slave
   output                  wb_clk;      // Clock output to WB bus
   output                  wb_rst;      // Reset output to WB bus
   output [ADDR_WIDTH-1:0] wb_addr;     // address to wishbone slave 
   output [DATA_WIDTH-1:0] wb_data_out; // data output for wishbone slave
   output                  wb_cyc;      // signal to indicate valid bus cycle
   output                  wb_we;       // write enable
   output                  wb_stb;      // strobe to indicate valid data transfer cycle

//*****************************************************************************
// AHB ports
//*****************************************************************************
   input                   hclk;   // clock
   input                   hresetn;// active low reset
   input [DATA_WIDTH-1:0]  hwdata; // data bus      
   input                   hwrite; // write/read enable
   input [2:0]             hburst; // burst type
   input [2:0]             hsize;  // data size
   input [1:0]             htrans; // type of transfer
   input                   hsel;   // slave select 
   input [ADDR_WIDTH-1:0]  haddr;  // address bus   
   output [DATA_WIDTH-1:0] hrdata; // data output for wishbone slave
   output [1:0]            hresp;  // response signal from slave
   output                  hready; // slave ready

//*****************************************************************************
// Output signal storage
//
   reg [DATA_WIDTH-1:0]    hrdata;
   reg                     hready;
   reg [1:0]               hresp;

   wire                    wb_clk;
   wire                    wb_rst;
   reg                     wb_stb;
   reg                     wb_we;
   reg                     wb_cyc;
   reg [ADDR_WIDTH-1:0]    wb_addr;
   reg [DATA_WIDTH-1:0]    wb_data_out;
   reg                     wb_ack_d1;
   
//*****************************************************************************
// Bridge Logic

   // wb clock and reset pass through asynchronously
   assign wb_clk = hclk;
   assign wb_rst = hresetn;

   // Syncrhonous logic
   always @ (posedge hclk ) begin
      // Reset all outputs if reset asserted
      if (!hresetn) begin
         wb_addr <= 'b0;
         wb_data_out <= 'b0;
         wb_cyc <= 'b0;
         wb_we <= 'b0;
         wb_stb <= 'b0;
         hrdata <= 'b0;
         hresp <= 'b0;
         hready <= 'b0;
         wb_ack_d1 <= 'b0;
      end
      else begin
         // Address write enable and write data pass through from ahb to wb
         wb_addr <= haddr;
         wb_data_out <= hwdata;
         wb_we <= hwrite;
         // Read data, response and ready pass through from wb to ahb
         hrdata <= wb_data_in;
         hresp <= 'b0;
         hready <= wb_ack;
	 // Deassert WB stb and cyc once ack received
         if (wb_ack || wb_ack_d1) begin
            wb_cyc <= 'b0;
            wb_stb <= 'b0;
         end else begin
            wb_cyc <= hsel;
            wb_stb <= hsel;
         end
	 // Hold ack signal to prolong wb cyc and stb one clock cycle
         wb_ack_d1 <= wb_ack;
      end
   end
      
endmodule
