module wb2spi(
  wb_clk, wb_rst, wb_cyc, wb_stb, wb_addr, wb_we, wb_data_in, wb_data_out, wb_ack,
  sck, mosi, miso 
);

  // Wishbone signals
  input  wb_clk;      // clock
  input  wb_rst;      // reset (asynchronous active low)
  input  wb_cyc;      // cycle
  input  wb_stb;      // strobe
  input  [1:0] wb_addr;     // address
  input  wb_we;       // write enable
  input  [7:0] wb_data_in;  // data input
  output [7:0] wb_data_out; // data output
  output wb_ack;      // normal bus termination

  // SPI signals
  output sck;         // serial clock 
  output mosi;        // Master Out Slave In
  input  miso;        // Master In  Slave Out

// Output storage
  reg  [7:0] wb_data_out; // data output
  reg        wb_ack;      // normal bus termination
  reg        sck;         // serial clock output
  reg        mosi;        // Master Out SlaveIN

//
// Registers
//
  reg  [7:0] spcr;       // Serial Peripheral Control Register 
  reg  [7:0] spsr;       // Serial Peripheral Status register 
  reg  [7:0] spdr_mosi;  // Serial Peripheral Data register out to SPI slave
  reg  [7:0] spdr_miso;  // Serial Peripheral Extension register in from SPI slave
  reg  [7:0] sper;       // Serial Peripheral Extension register

  reg [4:0]  transfer_state;

  // wb_data_in
  always @(posedge wb_clk or negedge wb_rst)
    if (~wb_rst)
      begin
          spcr       <= #1 8'h00;
          spdr_mosi  <= #1 8'h00;
          sper       <= #1 8'h00;
      end
    else if (wb_cyc & wb_we)
      begin
        if (wb_addr == 2'b00)
          spcr <= #1 wb_data_in;

        if (wb_addr == 2'b10)
          spdr_mosi <= #1 wb_data_in;

        if (wb_addr == 2'b11)
          sper <= #1 wb_data_in;
      end

  // wb_data_out
  always @(posedge wb_clk)
    case(wb_addr) // synopsys full_case parallel_case
      2'b00: wb_data_out <= #1 spcr;
      2'b01: wb_data_out <= #1 spsr;
      2'b10: wb_data_out <= #1 spdr_miso;
      2'b11: wb_data_out <= #1 sper;
    endcase

  // wb_ack
  always @(posedge wb_clk or negedge wb_rst)
    if (~wb_rst)
      wb_ack <= #1 1'b0;
    else
      wb_ack <= #1 wb_cyc & !wb_ack;

  // Trigger to start spi transfer
  wire start_spi_xfer = (wb_addr == 2'b10) & wb_cyc & wb_we ;

  // transfer statemachine
  always @(posedge wb_clk)
    if (~wb_rst)
      begin
          transfer_state <= #1 5'h1f; // idle
          sck            <= #1 1'b0;
          mosi           <= #1 1'bx;
          spsr           <= #1 8'h01;
      end
    else
      begin
         case (transfer_state) 
           5'h1f: // idle state
              begin
		 if ( start_spi_xfer ) transfer_state <= #1 5'h00; 
		 else                  transfer_state <= #1 5'h1f; 
                 sck            <= #1 1'b0;
                 mosi           <= #1 1'bx;
                 spsr           <= #1 8'h00;
              end
           5'h00:  
              begin
                 transfer_state <= #1 5'h01; 
                 sck            <= #1 1'b0;
                 mosi           <= #1 spdr_mosi[7];
                 spsr           <= #1 8'h01;
              end
           5'h01: // posedge sck 7 
              begin
                 transfer_state <= #1 5'h02; 
                 sck            <= #1 1'b1;
                 spsr           <= #1 8'h01;
              end
           5'h02:  
              begin
                 transfer_state <= #1 5'h03; 
                 sck            <= #1 1'b0;
                 mosi           <= #1 spdr_mosi[6];
                 spsr           <= #1 8'h01;
              end
           5'h03:  // posedge sck 6
              begin
                 transfer_state <= #1 5'h04; 
                 sck            <= #1 1'b1;
		 spdr_miso[7]   <= #1 miso;
                 spsr           <= #1 8'h01;
              end
           5'h04:  
              begin
                 transfer_state <= #1 5'h05; 
                 sck            <= #1 1'b0;
                 mosi           <= #1 spdr_mosi[5];
                 spsr           <= #1 8'h01;
              end
           5'h05:  // posedge sck 5
              begin
                 transfer_state <= #1 5'h06; 
                 sck            <= #1 1'b1;
		 spdr_miso[6]   <= #1 miso;
                 spsr           <= #1 8'h01;
              end
           5'h06:  
              begin
                 transfer_state <= #1 5'h07; 
                 sck            <= #1 1'b0;
                 mosi           <= #1 spdr_mosi[4];
                 spsr           <= #1 8'h01;
              end
           5'h07:  // posedge sck 4
              begin
                 transfer_state <= #1 5'h08; 
                 sck            <= #1 1'b1;
		 spdr_miso[5]   <= #1 miso;
                 spsr           <= #1 8'h01;
              end
           5'h08:  
              begin
                 transfer_state <= #1 5'h09; 
                 sck            <= #1 1'b0;
                 mosi           <= #1 spdr_mosi[3];
                 spsr           <= #1 8'h01;
              end
           5'h09:  // posedge sck 3
              begin
                 transfer_state <= #1 5'h0a; 
                 sck            <= #1 1'b1;
		 spdr_miso[4]   <= #1 miso;
                 spsr           <= #1 8'h01;
              end
           5'h0a:  
              begin
                 transfer_state <= #1 5'h0b; 
                 sck            <= #1 1'b0;
                 mosi           <= #1 spdr_mosi[2];
                 spsr           <= #1 8'h01;
              end
           5'h0b:  // posedge sck 2
              begin
                 transfer_state <= #1 5'h0c; 
                 sck            <= #1 1'b1;
		 spdr_miso[3]   <= #1 miso;
                 spsr           <= #1 8'h01;
              end
           5'h0c:  
              begin
                 transfer_state <= #1 5'h0d; 
                 sck            <= #1 1'b0;
                 mosi           <= #1 spdr_mosi[1];
                 spsr           <= #1 8'h01;
              end
           5'h0d:  // posedge sck 1
              begin
                 transfer_state <= #1 5'h0e; 
                 sck            <= #1 1'b1;
		 spdr_miso[2]   <= #1 miso;
                 spsr           <= #1 8'h01;
              end
           5'h0e:  
              begin
                 transfer_state <= #1 5'h0f; 
                 sck            <= #1 1'b0;
                 mosi           <= #1 spdr_mosi[0];
                 spsr           <= #1 8'h01;
              end
           5'h0f:  // posedge sck 0
              begin
                 transfer_state <= #1 5'h10; 
                 sck            <= #1 1'b1;
		 spdr_miso[1]   <= #1 miso;
                 spsr           <= #1 8'h01;
              end
           5'h10:  
              begin
                 transfer_state <= #1 5'h11; 
                 sck            <= #1 1'b0;
                 spsr           <= #1 8'h01;
              end
           5'h11:  
              begin
                 transfer_state <= #1 5'h1f; 
                 sck            <= #1 1'b0;
		 spdr_miso[0]   <= #1 miso;
                 spsr           <= #1 8'h01;
              end
         endcase
      end

endmodule
