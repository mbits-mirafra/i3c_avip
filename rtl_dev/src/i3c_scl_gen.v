module i3c_scl_gen #(
  parameter integer CLK_FREQ_HZ    = 100_000_000,   // input clock freq
  parameter integer DEFAULT_SCL_HZ = 1_000_000,     // default SCL
  parameter integer MIN_SCL_HZ     = 1_000_000,     // min allowed SCL
  parameter integer MAX_SCL_HZ     = 12_500_000     // SDR limit
) (
  input  wire        clk,
  input  wire        rst_n,       // active-low async reset 
  
  // START/STOP handshake (from SDR FSM)
  input  wire        scl_start, // enable continuous generation
  input  wire        scl_stop,  // keep scl high
  input  wire        push_pull, // 1=push-pull, 0=open-drain
  input  wire [31:0] scl_hz_cfg,// requested SCL in Hz (0 => DEFAULT_SCL_HZ)
  
  // PHY interface (all outputs are registered)
  output reg         scl_o,   // drive value when scl_oe==1
  output reg         scl_oe    // 1=drive, 0=tri-state (for OD-high)
);


// FSM Parameters grey endoded
localparam [1:0] IDLE = 2'b00,
                RUN  = 2'b01,
                STOP = 2'b11;
reg       [1:0] state, next;  // FSM registers

// Internal signals
// divider: half period measured in clk cycles
reg [31:0]  half_period;     // registered half-period (clk cycles)
reg [31:0]  half_period_n;   // combinational next value
reg [31:0]  count;           // registered countdown count for half-period
reg         scl_phase;       // registered phase, 1 = high, 0 = low
reg         bus_idle;        // indicates bus idle after 2us
reg [7:0]   bus_idle_cnt;    // T(idle) timer
integer req_hz = 0;
integer tmp = 0;

// compute next divider (half_period_n)
// formula: N = CLK_FREQ_HZ / (2 * req_hz) (integer division)
always @ * begin
  half_period_n = 32'd1;
  
  req_hz = (scl_hz_cfg == 32'd0) ? DEFAULT_SCL_HZ : scl_hz_cfg;
  if (req_hz < MIN_SCL_HZ) req_hz = MIN_SCL_HZ;
  if (req_hz > MAX_SCL_HZ) req_hz = MAX_SCL_HZ;
  
  tmp = CLK_FREQ_HZ / (2 * req_hz);
  if (tmp < 1) tmp = 1;
  half_period_n = tmp;
end

// FSM: reset logic
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) state <= IDLE;
  else      state <= next;
end

// FSM: next state logic
always @ * begin
  case (state)
    IDLE   : next = scl_start ? RUN  : IDLE;
    RUN    : next = scl_stop  ? STOP : RUN;
    STOP   : next = bus_idle  ? IDLE : STOP; // To-Do
    default: next = IDLE;
  endcase
end

// FSM: output logic
always @ * begin
  case (state)
    IDLE: {scl_o, scl_oe} = 2'b10;
    RUN: begin
      if (push_pull) begin
        scl_oe  = 1'b1;
        scl_o   = scl_phase;
      end else begin
        scl_oe  = scl_phase ? 1'b0 : 1'b1;
        scl_o   = 1'b0;
      end
    end
    STOP: {scl_o, scl_oe} = 2'b10;
  endcase
end


always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    // synchronous-style register initialization on reset
    half_period <= 'd0;
    count       <= 'd0;
    scl_phase   <= 'b1;    // bus idle = SCL high
    bus_idle    <= 'b0;
    bus_idle_cnt <= 8'b0;
  end else begin
    case (state)
      IDLE : begin

      end
      RUN: begin
        half_period <= half_period_n; // update divider register
        // if count == 0 toggle phase and reload half_period-1
        if (count == half_period - 1) begin
          count     <= 32'd0;
          scl_phase <= ~scl_phase;
        end else begin
          count     <= count + 1;
        end
      end
      STOP: begin
        if (bus_idle_cnt < 19) begin
          bus_idle_cnt <= bus_idle_cnt + 1;
          bus_idle     <= 1'b0;
        end else begin
          bus_idle     <= 1'b1;    // 2us elapsed
          bus_idle_cnt <= 8'b0; // hold value (optional)
        end
      end
      default: begin
        half_period <= 'd0;   
        count       <= 'd0;
        scl_phase   <= 'b1;
        bus_idle    <= 'b0;
        bus_idle_cnt <= 8'b0;
      end
    endcase
  end
end

endmodule