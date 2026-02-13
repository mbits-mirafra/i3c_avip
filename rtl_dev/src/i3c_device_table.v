module i3c_device_table #(
  parameter A_WIDTH = 7,    // 128 depth
  parameter D_WIDTH = 71
)(
  input   wire                clk,
  input   wire                rst_n,
  input   wire                rd_en,      // read enable
  input   wire                wr_en,      // write enable
  input   wire [A_WIDTH-1:0]  rd_idx,     // device index containing dynamic address 
  input   wire [D_WIDTH-1:0]  wr_data,
  output  reg  [6:0]          rd_data,      // dynamic address to be accessed
  output  reg                 rd_valid,   // pulses one cycle after rd_en

  input   wire [6:0]          sdr_addr,   // to check weather current device is i3c or i2c 
  output  reg                 is_i3c
);

reg [D_WIDTH-1:0] mem [0:(1<<A_WIDTH)-1];
reg [A_WIDTH-1:0] idx;
reg match;
integer i,j;

// synchronous write + read
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    rd_data  <= 'b0;
    rd_valid <= 'b0;
    is_i3c   <= 'b0;
    idx      <= 'b0;
    for (i=0; i<(1<<A_WIDTH); i=i+1)
      mem[i] <= 'b0;
  end else begin
    is_i3c   <= match;
    if (wr_en) begin
      mem[idx] <= wr_data;
      idx      <= idx + 1;
    end
    rd_valid  <= rd_en;
    // read data on next cycle
    if (rd_en) rd_data <= mem[rd_idx][6:0];
  end
end

// To check weather current device is i3c or i2c 
always @(*) begin
  match = 1'b0;
  for (j=0; j<(1<<A_WIDTH); j=j+1)
    if (mem[j][6:0] == sdr_addr)
      match = 1'b1;
end

endmodule