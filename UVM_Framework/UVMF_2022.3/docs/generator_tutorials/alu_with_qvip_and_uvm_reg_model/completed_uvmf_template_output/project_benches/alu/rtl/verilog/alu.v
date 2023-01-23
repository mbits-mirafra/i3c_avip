//----------------------------------------------------------------------
//                   Mentor Graphics Inc
//----------------------------------------------------------------------
// Project         : AHB to WB DUT
// Unit            : DUT
// File            : ahb2wb.v
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This module is from OpenCores and performs AHB to WB 
//    bridge operations.
//
//----------------------------------------------------------------------
//
//     $LastChangedRevision$
//     $LastChangedBy$
//     $LastChangedDate$
//     $Log$
//
//----------------------------------------------------------------------
//
module alu( clk, rst, ready, valid, op, a, b, done, result, PADDR, PSEL, PENABLE, PWRITE, PWDATA, PRDATA, PREADY, PSLVERR, PPROT, PSTRB);

//parameter declaration
parameter OP_WIDTH         = 8;
parameter RESULT_WIDTH     = 16;
parameter APB_ADDR_WIDTH   = 32;
parameter APB_WDATA_WIDTH  = 32;
parameter APB_RDATA_WIDTH  = 32;

//**************************************
// input ports
//**************************************
input                     clk;      // acknowledment from wishbone slave
input                     rst;      // acknowledment from wishbone slave
output                    ready;    // acknowledment from wishbone slave
input                     valid;    // acknowledment from wishbone slave
input  [2:0]              op;
input  [OP_WIDTH-1:0]     a;
input  [OP_WIDTH-1:0]     b;
output                    done;     // acknowledment from wishbone slave
output [RESULT_WIDTH-1:0] result;   // data input from wishbone slave

//**************************************
// APB Interface
//**************************************
input  [APB_ADDR_WIDTH-1:0]      PADDR;
input                            PSEL;
input                            PENABLE;
input                            PWRITE;
input  [APB_WDATA_WIDTH-1:0]     PWDATA;
output [APB_RDATA_WIDTH-1:0]     PRDATA;
output                           PREADY;
output                           PSLVERR;
input  [2:0]                     PPROT;
input  [(APB_WDATA_WIDTH/8)-1:0] PSTRB;


// datatype declaration
bit                    ready_o;
reg                    done_o = 0;
reg [RESULT_WIDTH-1:0] result_o;
bit [2:0]              op_i, op_iq;
bit [OP_WIDTH-1:0]     a_i, a_iq;
bit [OP_WIDTH-1:0]     b_i, b_iq;
bit                    valid_i;

  logic [31:0] a_reg;
  logic [31:0] b_reg;
  logic [31:0] op_reg;
  logic [31:0] result_reg;
  logic [31:0] ctrl_reg;

assign ready   = ready_o;
assign done    = done_o;
assign result  = result_o;
assign valid_i = valid || ctrl_reg[0];

//*******************************************************************
// logic
//*******************************************************************
initial begin
  for (int i=0; i < 5; i++) @(posedge clk);
  ready_o = 1'b1;
  result_o = {RESULT_WIDTH{1'bx}};    // data input from wishbone slave
end

assign op_i = (valid) ? op : op_reg[2:0];
assign a_i  = (valid) ? a  :  a_reg[7:0];
assign b_i  = (valid) ? b  :  b_reg[7:0];

always @ (posedge clk ) begin
  if (valid_i) begin
    op_iq   <= op_i;
    a_iq    <= a_i;
    b_iq    <= b_i;
    ready_o <= 'b0;
    for (int i=0; i < 5; i++) @(posedge clk);
    if ( (op_iq == 3'b001) || 
         (op_iq == 3'b010) || 
         (op_iq == 3'b011) || 
         (op_iq == 3'b100) ) begin
      // no_op  = 3'b000,
      // add_op = 3'b001, 
      // and_op = 3'b010,
      // xor_op = 3'b011,
      // mul_op = 3'b100,
      // rst_op = 3'b111
      case (op_iq)
        3'b001: result_o <= a_iq + b_iq;
        3'b010: result_o <= a_iq & b_iq;
        3'b011: result_o <= a_iq ^ b_iq;
        3'b100: result_o <= a_iq * b_iq;
      endcase
      done_o <= 'b1;
      @(posedge clk);
      done_o  <= 'b0;
      result_o <= {RESULT_WIDTH{1'bx}};
    end
    @(posedge clk);
    ready_o <= 'b1;
  end
end

//*******************************************************************
// APB3 Slave Logic
//*******************************************************************
// Used to decode bus control signals
  localparam IDLE    = 2'b00;
  localparam SETUP   = 2'b10;
  localparam ACCESS  = 2'b11;
  localparam UNKNOWN = 2'b01;

  bit [(APB_WDATA_WIDTH - 1) : 0]  memory [int];
  bit [(APB_WDATA_WIDTH - 1) : 0]  local_memory;
  int i;

  integer wait_count = 0;
  bit slverr         = 1'b0;

  logic g_pready;
  logic g_pslverr;
  logic [APB_RDATA_WIDTH-1:0] g_prdata;

  assign PREADY  = g_pready;
  assign PSLVERR = g_pslverr;
  assign PRDATA  = g_prdata; 


// Evaluate cycle accurate bus controls for protocol

  always @(posedge clk or negedge rst) begin
    
    if (rst !== 1'b1) begin
      g_pready   <= 1'b0;
      g_pslverr  <= 1'b0;
      g_prdata   <= 0;
      a_reg      <= 32'h0;
      b_reg      <= 32'h0;
      op_reg     <= 32'h0;
      result_reg <= 32'h0;
      ctrl_reg   <= 32'h0;
    end

    else begin

      result_reg <= (done_o) ? {16'h0,result_o} : result_reg;

      // Control register only issues pulses
      ctrl_reg   <= 32'h0;

      // Conceptual state-machine to decode bus protocol transitions
      case( {PSEL,PENABLE} )
        IDLE :
          begin
              g_pready  <= 1'b0;
              g_pslverr <= 1'b0;
              g_prdata <= 0;
          end
        SETUP, ACCESS :
          begin
            g_pready  <= (wait_count)? 1'b0 : 1'b1;
            g_pslverr <= (wait_count)? 1'b0 : slverr;
            if(wait_count)
              wait_count--;
            if (~PWRITE) begin
              case (PADDR)
                12'h00000000 : g_prdata <= a_reg;
                12'h00000004 : g_prdata <= b_reg;
                12'h00000008 : g_prdata <= op_reg;
                12'h0000000C : g_prdata <= result_reg;
                12'h00000010 : g_prdata <= ctrl_reg;
                default : begin
                  if(memory.exists(PADDR))
                    g_prdata <= (wait_count)? 0 : memory[PADDR];
                  else
                    g_prdata <= 0;
                end
              endcase
            end
            else
              case (PADDR)
                'h00000000 : a_reg      <= PWDATA;
                'h00000004 : b_reg      <= PWDATA;
                'h00000008 : op_reg     <= PWDATA;
                'h0000000C : result_reg <= result_reg;
                'h00000010 : ctrl_reg   <= PWDATA;
                default : begin
                  if (!wait_count)
                    memory[PADDR] = PWDATA;
                end
              endcase
          end
      endcase
    end
  end

// This properties are used to check the input muxes 
property a_mux_in1;
@(posedge clk) disable iff(!rst) 
  ( !valid ##1 valid ) |-> ( a_i == a )
endproperty

property a_mux_in2;
@(posedge clk) disable iff(!rst) 
  ( valid ##1 !valid ) |-> ( a_i == a_reg[7:0] );
endproperty

property b_mux_in1;
@(posedge clk) disable iff(!rst) 
  ( !valid ##1 valid ) |-> ( b_i == b )
endproperty

property b_mux_in2;
@(posedge clk) disable iff(!rst) 
  ( valid ##1 !valid ) |-> ( b_i == b_reg[7:0] );
endproperty

property op_mux_in1;
@(posedge clk) disable iff(!rst) 
  ( !valid ##1 valid ) |-> ( op_i == op )
endproperty

property op_mux_in2;
@(posedge clk) disable iff(!rst) 
  ( valid ##1 !valid ) |-> ( op_i == op_reg[7:0] );
endproperty

a_mux_in1_a  : assert property(a_mux_in1)  else $error("The a input1 mux functionality failed");
a_mux_in2_a  : assert property(a_mux_in2)  else $error("The a input2 mux functionality failed");
b_mux_in1_a  : assert property(b_mux_in1)  else $error("The b input1 mux functionality failed");
b_mux_in2_a  : assert property(b_mux_in2)  else $error("The b input2 mux functionality failed");
op_mux_in1_a : assert property(op_mux_in1) else $error("The op input1 mux functionality failed");
op_mux_in2_a : assert property(op_mux_in2) else $error("The op input2 mux functionality failed");

a_mux_in1_c  : cover property(a_mux_in1);
a_mux_in2_c  : cover property(a_mux_in2);
b_mux_in1_c  : cover property(b_mux_in1);
b_mux_in2_c  : cover property(b_mux_in2);
op_mux_in1_c : cover property(op_mux_in1);
op_mux_in2_c : cover property(op_mux_in2);

endmodule
