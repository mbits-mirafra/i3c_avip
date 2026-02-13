`include "param.v"
module i3c_cmd_ctrl (
  input  wire        clk,
  input  wire        rst_n,

  input  wire        cmd_start,
  input  wire [1:0]  cmd_type,
  input  wire [6:0]  cmd_addr,
  input  wire [7:0]  cmd_ccc,
  input  wire [7:0]  cmd_len,
  input  wire        cmd_dir,

  output reg         start_sdr,
  output reg  [6:0]  sdr_addr,
  output reg  [7:0]  sdr_len,
  output reg         sdr_dir,

  output reg         sdr_is_ccc,
  output reg  [7:0]  sdr_ccc_code,
  output reg         sdr_ccc_is_read,

  output reg         start_daa,

  input  wire        sdr_done,
  input  wire        daa_done,

  output reg         cmd_busy
);

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    start_sdr        <= 0;
    start_daa        <= 0;
    cmd_busy         <= 0;
    sdr_addr         <= 0;
    sdr_len          <= 0;
    sdr_dir          <= 0;
    sdr_is_ccc       <= 0;
    sdr_ccc_code     <= 0;
    sdr_ccc_is_read  <= 0;
  end else begin
    start_sdr <= 0;
    start_daa <= 0;
    if (cmd_start && !cmd_busy) begin
      cmd_busy <= 1'b0;
      case (cmd_type)
        2'd0,
        2'd1: begin
          cmd_busy   <= 1'b1;
          start_sdr  <= 1'b1;
          sdr_addr   <= cmd_addr;
          sdr_len    <= cmd_len;
          sdr_dir    <= cmd_dir;
          sdr_is_ccc <= 1'b0;
        end
        2'd2: begin
          start_sdr     <= (cmd_ccc != `CCC_ENTDAA);
          start_daa     <= (cmd_ccc == `CCC_ENTDAA);
          sdr_is_ccc    <= 1'b1;
          sdr_ccc_code  <= cmd_ccc;
          sdr_len       <= cmd_len;
          sdr_addr      <= cmd_ccc[7] ? cmd_addr : 7'h7E;
          sdr_dir       <= 1'b0;
        end
        2'd3: begin
          start_daa <= 1'b1;
        end
      endcase
    end
    if (sdr_done || daa_done)
      cmd_busy <= 1'b0;
  end
end

endmodule