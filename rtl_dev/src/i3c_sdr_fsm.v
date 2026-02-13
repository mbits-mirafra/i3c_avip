module i3c_sdr_fsm (
  input  wire        clk,
  input  wire        rst_n,

  input  wire        start,
  input  wire [6:0]  addr,
  input  wire        dir,        // 0 = write, 1 = read
  input  wire [7:0]  len,

  input  wire [7:0]  tx_data,
  input  wire        tx_valid,
  output reg         tx_ready,

  output reg  [7:0]  rx_data,
  output reg         rx_valid,
  input  wire        rx_ready,

  output reg         be_valid,
  output reg         be_rd_wr,
  output reg  [7:0]  be_tx_data,
  input  wire [7:0]  be_rx_data,
  input  wire        be_busy,
  input  wire        be_nack,

  output reg         busy,
  output reg         done,
  output reg         error,
  input  wire        be_done,
  input  wire        stop_done,
  output reg         push_pull,
  output reg  [6:0]  sdr_addr,
  input  wire        is_i3c
);

localparam [3:0]
  IDLE      = 4'd0,
  SEND_ADDR = 4'd1,
  WAIT_ADDR = 4'd2,
  SEND_WR   = 4'd3,
  WAIT_WR   = 4'd4,
  SEND_RD   = 4'd5,
  WAIT_RD   = 4'd6,
  STOP      = 4'd7,
  ERROR     = 4'd8;

reg [3:0] state, next_state;
reg [7:0] byte_cnt;

always @(posedge clk or negedge rst_n) begin
  if (!rst_n)
    state <= IDLE;
  else
    state <= next_state;
end

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    byte_cnt <= 8'd0;
    rx_valid <= 1'b0;
  end else begin
    rx_valid <= 1'b0;

    case (state)

      IDLE: begin
        if (start)
          byte_cnt <= len;
      end

      WAIT_WR: begin
        if (be_done)
          byte_cnt <= byte_cnt - 1'b1;
      end

      WAIT_RD: begin
        if (!be_busy && be_done) begin
          rx_data  <= be_rx_data;
          rx_valid <= 1'b1;
          byte_cnt <= byte_cnt - 1'b1;
        end
      end

      default: ;
    endcase
  end
end

reg push_pull_hold;

always @(posedge clk or negedge rst_n) begin
  if (!rst_n)
    push_pull_hold <= 1'b0;
  else begin
    case (state)
      SEND_WR,
      WAIT_WR:
        push_pull_hold <= is_i3c;

      STOP,
      IDLE,
      ERROR:
        push_pull_hold <= 1'b0;
    endcase
  end
end

always @(*) begin
  push_pull = push_pull_hold;

  next_state = state;
  be_valid   = 1'b0;
  tx_ready   = 1'b0;

  busy  = (state != IDLE);
  done  = 1'b0;
  error = 1'b0;

  case (state)

    IDLE: begin
      if (start)
        next_state = SEND_ADDR;
    end

    SEND_ADDR: begin
      be_valid   = 1'b1;
      be_rd_wr   = 1'b0;
      be_tx_data = {addr, dir};
      sdr_addr   = addr;

      if (!be_busy)
        next_state = WAIT_ADDR;
    end

    WAIT_ADDR: begin
      if (!be_busy && be_done) begin
        if (be_nack)
          next_state = ERROR;
        else if (dir)
          next_state = SEND_RD;
        else
          next_state = SEND_WR;
      end
    end

    SEND_WR: begin
      if (tx_valid) begin
        tx_ready   = 1'b1;
        be_valid   = 1'b1;
        be_rd_wr   = 1'b0;
        next_state = WAIT_WR;
      end
    end

    WAIT_WR: begin
      be_tx_data = tx_data;

      if (!be_busy && be_done) begin
        if (be_nack)
          next_state = ERROR;
        else if (byte_cnt == 8'd1)
          next_state = STOP;
        else
          next_state = SEND_WR;
      end
    end

    SEND_RD: begin
      be_valid = 1'b1;
      be_rd_wr = 1'b1;

      if (!be_busy)
        next_state = WAIT_RD;
    end

    WAIT_RD: begin
      be_rd_wr = 1'b1;

      if (stop_done) begin
        if (!rx_ready)
          next_state = ERROR;
        else if (byte_cnt <= 8'd1)
          next_state = STOP;
        else
          next_state = SEND_RD;
      end
    end

    STOP: begin
      done       = 1'b1;
      next_state = IDLE;
    end

    ERROR: begin
      error      = 1'b1;
      done       = 1'b1;
      next_state = IDLE;
    end

    default: begin
      next_state = IDLE;
      be_valid   = 1'b0;
    end

  endcase
end

endmodule