module i3c_Tx_FIFO #(
  parameter WIDTH      = 8,
  parameter DEPTH      = 16,
  parameter ADDR_BITS  = 4
)(
  input  wire               clk,
  input  wire               rst_n,

  input  wire               wr_en,
  input  wire [WIDTH-1:0]   din,

  input  wire               rd_en,
  output reg  [WIDTH-1:0]   dout,

  output wire               valid,
  output wire               full,
  output wire               empty
);

reg [WIDTH-1:0] mem [0:DEPTH-1];
reg [ADDR_BITS:0] wr_ptr, rd_ptr;

assign empty = (wr_ptr == rd_ptr);
assign full  = (wr_ptr[ADDR_BITS]     != rd_ptr[ADDR_BITS]) &&
               (wr_ptr[ADDR_BITS-1:0] == rd_ptr[ADDR_BITS-1:0]);
assign valid = !empty;

integer i;

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    for (i = 0; i < DEPTH; i = i + 1)
      mem[i] <= 0;
    wr_ptr <= 0;
    rd_ptr <= 0;
    dout   <= 0;
  end else begin
    if (wr_en && !full) begin
      mem[wr_ptr[ADDR_BITS-1:0]] <= din;
      wr_ptr <= wr_ptr + 1'b1;
    end
    if (rd_en && !empty) begin
      dout   <= mem[rd_ptr[ADDR_BITS-1:0]];
      rd_ptr <= rd_ptr + 1'b1;
    end
  end
end

endmodule