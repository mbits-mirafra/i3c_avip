module i3c_bit_engine (
  input   wire        clk,
  input   wire        rst_n,
  
  // from higher level FSMs
  input   wire        valid,    // new high-level command available
  input   wire        rd_wr,    // 1: read; 0: write
  input   wire  [7:0] tx_data,  // byte to be sent
  output  reg   [7:0] rx_data,  // byte to be byte to be received
  input   wire        arb_mode, // for DAA
  input   wire        s_r,      // indicates repeated start
  input   wire        push_pull,// 1: push-pull; 0: open-drain

  // PHY / SDA interface
  input   wire        scl_i,    // sampled SCL input (from sampler)
  input   wire        sda_i,    // sampled SDA input (from sampler)
  output  reg         sda_o,    // drive value (0/1) when sda_oe=1
  output  reg         sda_oe,   // 1=drive, 0=tri-state (OD high)

  // Status / error reporting
  output  reg         busy,     // bit engine is performing a transfer
  output  reg         nack,     // a NACK was observed
  output  wire        txn_done, // transaction done (pulse),
  output  reg         start_done,
  output  reg         stop_done
);
//assign sda_i = sda_oe ? sda_o : 1'b1; // debug 

// FSM encoding 
localparam [2:0]
  IDLE  = 3'd0,   // wait for valid and tx_data
  START = 3'd1,   // generate i3c start
  SHIFT = 3'd2,   // perform read/write byte
  ACK   = 3'd3,   // send/receive ack/nack
  WAIT  = 3'd4,   // wait for next byte request 
  STOP  = 3'd5;   // generate stop condition
  
reg [2:0] state, next; // FSM registers
reg [7:0] shift_reg;   // bit-shift register for sending/receiving current byte / address (MSB-first_n)
reg [2:0] bit_cnt;     // counts 0..7 for byte bits
reg       s_o, s_oe;   // signal hold registers (resolved combo loops)
reg       tpulse;      // helper for txn_done 
reg       sr_latch;    // helper for atart repeat

// SCL edge detection logic
reg   scl_q, scl_qq;
wire  scl_rise = (scl_q == 1'b1) && (scl_qq == 1'b0);
wire  scl_fall = (scl_q == 1'b0) && (scl_qq == 1'b1);
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    scl_q  <= 1'b1;
    scl_qq <= 1'b1;
  end else begin
    scl_q  <= scl_i;
    scl_qq <= scl_q;
  end
end

// latch incoming valid until scl_fall for multi byte transaction
reg   v_latch;
always @(posedge clk or negedge rst_n) begin
  if (!rst_n)
    v_latch <= 1'b0;
  else begin
    if (valid && !busy) v_latch <= 1'b1;    // Latch
    else if (scl_fall)  v_latch <= 1'b0;    // Release
    else                v_latch <= v_latch;
  end
end


// FSM: reset logic
always @ (posedge clk or negedge rst_n) begin
  if (!rst_n) state <= IDLE;
  else      state <= next;
end

// FSM: next state logic
always @ * begin
  if (arb_mode) next = WAIT; // for DAA, keep bit engine idle
  else begin
    case (state)
      IDLE   : next = valid && !busy             ? START : IDLE;
      START  : next = scl_fall                   ? SHIFT : START;
      SHIFT  : next = (bit_cnt == 0) && scl_fall ? ACK   : SHIFT;
      ACK    : next = scl_rise                   ? WAIT  : ACK;
      WAIT   : next = s_r                        ? IDLE  :   
                      v_latch && scl_fall        ? SHIFT : 
                      !v_latch && scl_fall       ? STOP  : WAIT;
      STOP   : next = stop_done                  ? IDLE  : STOP;
      default: next = IDLE;
    endcase
  end
end

// FSM: output logic
always @ * begin
  if (push_pull) begin // push-pull
    case (state)
      IDLE   : {sda_oe, sda_o} = 2'b01;
      START  : {sda_oe, sda_o} = {s_oe, s_o};
      SHIFT  : {sda_oe, sda_o} = rd_wr ? 2'b01 : {1'b1, shift_reg[7]};
      ACK    : {sda_oe, sda_o} = rd_wr ? 2'b10 : 2'b01;
      WAIT   : {sda_oe, sda_o} = 2'b01;
      STOP   : {sda_oe, sda_o} = {s_oe, s_o};
      default: {sda_oe, sda_o} = 2'b01;
    endcase
  end else begin      // open-drain
    sda_o = 1'b0;
    case (state)
      IDLE   : sda_oe          = 1'b0;
      START  : {sda_oe, sda_o} = {s_oe, s_o};
      SHIFT  : sda_oe          = rd_wr ? 1'b0 : ~shift_reg[7];
      ACK    : sda_oe          = rd_wr ? 1'b1 : 1'b0;
      WAIT   : sda_oe          = 1'b0;
      STOP   : {sda_oe, sda_o} = {s_oe, s_o};
      default: {sda_oe, sda_o} = 2'b01;
    endcase
  end
end

// Registers and flags
always @ (posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    bit_cnt   <= 'b0;
    tpulse    <= 'b0;
    sr_latch  <= 'b0;
    shift_reg <= 'b0;
    busy      <= 'b0;
    nack      <= 'b0;
    rx_data   <= 'b0;
    start_done<= 'b0;
    stop_done <= 'b0;
    s_oe      <= 'b0;
    s_o       <= 1'b1;
  end else begin
    // hold outputs for combo loop
    tpulse  <= 'b0;
    case (state)
      IDLE   : begin
        bit_cnt   <= 3'd7;
        shift_reg <= rd_wr ? 8'b0 : tx_data;
        //busy      <= valid ? 1'b1 : 1'b0;
        busy <= valid;
        start_done<= valid ? 1'b1 : 1'b0;
        stop_done <= 1'b0;
        if (sr_latch) begin
          s_o     <= 1'b1;
          s_oe    <= 1'b1;
        end else begin
          s_o     <= 1'b1;
          s_oe    <= 1'b0;
        end
      end
      START  : begin 
        busy <= 1'b1;
        s_o  <= sda_o;
        s_oe <= sda_oe;
        if (scl_i) begin
          s_o  <= 1'b0;
          s_oe <= 1'b1;
        end
      end
      SHIFT  : begin
        busy <= 1'b1;
        sr_latch    <= 1'b0;
        if (scl_fall) begin
          bit_cnt   <= bit_cnt == 0 ? 3'd7 : bit_cnt - 1'b1;
        end
          if (rd_wr && scl_rise) begin
            shift_reg <= {shift_reg[6:0], sda_i};
          end else if (!rd_wr && scl_fall) begin
            shift_reg <= {shift_reg[6:0], 1'b0};
          end
      end
      ACK    : begin
        busy    <= 1'b0;
        if (rd_wr && scl_rise) begin
          nack    <= 1'b0;
          rx_data <= shift_reg;
         // busy    <= 1'b0;
        end else if (!rd_wr && scl_rise) begin
          nack    <= sda_i;
          rx_data <= 8'b0;
         // busy    <= 1'b0;
        end
      end
      WAIT   : begin
        tpulse    <= 1'b1;
        nack      <= 1'b0;
        bit_cnt   <= 3'd7;
        shift_reg <= rd_wr   ? 8'b0 : tx_data;
       // busy      <= v_latch ? 1'b1 : 1'b0;
       busy       <= v_latch; 
        sr_latch  <= s_r     ? 1'b1 : sr_latch;
      end
      STOP   : begin
        busy <= 1'b1;
        s_oe <= 1'b1;             // Ensure SDA is driven
        if (!scl_i) s_o <= 1'b0;  // Hold SDA low until SCL is high
        else begin                // Raise SDA on SCL high → STOP condition
          s_o       <= 1'b1;
          stop_done <= 1'b1;
        end
      end
      default: begin
        bit_cnt   <= bit_cnt;
        shift_reg <= shift_reg;
        busy      <= busy;
        nack      <= nack;
        s_o       <= sda_o;
        s_oe      <= sda_oe;
        stop_done <= 1'b0;
         start_done<=1'b0;
      end
    endcase    
  end 
end
assign txn_done = (state == WAIT) && !busy && !tpulse;
endmodule