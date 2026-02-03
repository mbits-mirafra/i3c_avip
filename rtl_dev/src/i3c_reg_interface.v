`include "param.v"

module i3c_reg_interface (
  input  wire        clk,
  input  wire        rst_n,

  input  wire        wr_en,
  input  wire        rd_en,
  input  wire [6:0]  addrs,
  input  wire [31:0] w_reg_data,
  input  wire [7:0]  w_data,

  output reg  [31:0] rd_data,
  output reg  [7:0]  r_data,

  output reg         Tx_wr_en,
  output reg  [7:0]  Tx_wdata,

  output reg         Rx_rd_en,
  input  wire [7:0]  Rx_rdata,

  input  wire        SDR_DONE,
  input  wire        DAA_DONE,
  input  wire        SDR_BUSY,
  input  wire        DAA_BUSY,
  input  wire        DAA_ERROR,
  input  wire        SDR_ERROR,
  input  wire        nak,

  input  wire [6:0]  daa_dyn_addr,

  output reg         cmd_start,
  output reg  [1:0]  cmd_type,
  output reg  [6:0]  cmd_addr,
  output reg  [7:0]  cmd_ccc,
  output reg  [7:0]  cmd_len,
  output reg         cmd_dir
);

reg [31:0] CONFIG;
reg [31:0] CTRL;
reg [6:0]  DYNADDR;
reg [7:0]  STATUS;

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    CONFIG     <= 0;
    CTRL       <= 0;
    STATUS     <= 0;
    DYNADDR    <= 0;
    Tx_wr_en   <= 0;
    Rx_rd_en   <= 0;
    cmd_start  <= 0;
    cmd_type   <= 0;
    cmd_addr   <= 0;
    cmd_len    <= 0;
    cmd_dir    <= 0;
    cmd_ccc    <= 0;
    rd_data    <= 0;
    r_data     <= 0;
  end else begin
    Tx_wr_en  <= 0;
    Rx_rd_en  <= 0;
    cmd_start <= 0;
    if (wr_en) begin
      case (addrs)
        `REG_CONFIG:
          CONFIG <= w_reg_data;
        `REG_CTRL: begin
          CTRL       <= w_reg_data;
          cmd_start <= w_reg_data[31];
          cmd_type  <= w_reg_data[25:24];
          cmd_ccc   <= w_reg_data[23:16];
          cmd_dir   <= w_reg_data[15];
          cmd_len   <= w_reg_data[14:7];
          cmd_addr  <= w_reg_data[6:0];
        end
        `REG_WDATAB: begin
          Tx_wr_en  <= 1'b1;
          Tx_wdata <= w_data;
        end
      endcase
    end
    if (rd_en) begin
      case (addrs)
        `REG_CONFIG:   rd_data <= CONFIG;
        `REG_STATUS:   rd_data <= {27'd0, STATUS};
        `REG_CTRL:     rd_data <= CTRL;
        `REG_DYNADDR:  rd_data <= {25'd0, DYNADDR};
        `REG_RDATAB: begin
          Rx_rd_en <= 1'b1;
          r_data   <= Rx_rdata;
        end
      endcase
    end
    STATUS[0] <= SDR_DONE;
    STATUS[1] <= DAA_DONE;
    STATUS[2] <= SDR_BUSY;
    STATUS[3] <= DAA_BUSY;
    STATUS[4] <= SDR_ERROR;
    STATUS[5] <= DAA_ERROR;
    STATUS[6] <= nak;
    if (DAA_DONE)
      DYNADDR <= daa_dyn_addr;
  end
end

endmodule