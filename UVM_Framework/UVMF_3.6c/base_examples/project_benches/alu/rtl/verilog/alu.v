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
module alu( clk, rst, ready, valid, op, a, b, done, result);

//parameter declaration
parameter OP_WIDTH = 8;
parameter RESULT_WIDTH = 16;

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
       

// datatype declaration
bit                    ready_o;
reg                    done_o = 0;
reg [RESULT_WIDTH-1:0] result_o;
bit [2:0]              op_i;
bit [OP_WIDTH-1:0]     a_i;
bit [OP_WIDTH-1:0]     b_i;

assign ready  = ready_o;
assign done   = done_o;
assign result = result_o;
       
//*******************************************************************
// logic
//*******************************************************************
initial begin
  for (int i=0; i < 5; i++) @(posedge clk);
	ready_o = 1'b1;
  result_o = {RESULT_WIDTH{1'bx}};    // data input from wishbone slave
end

always @ (posedge clk ) begin
  if (valid) begin
		op_i = op;
		a_i = a;
		b_i = b;
    ready_o = 'b0;
    for (int i=0; i < 5; i++) @(posedge clk);
		if ( (op_i == 3'b001) || 
         (op_i == 3'b010) || 
         (op_i == 3'b011) || 
         (op_i == 3'b100) ) begin
      // no_op  = 3'b000,
      // add_op = 3'b001, 
      // and_op = 3'b010,
      // xor_op = 3'b011,
      // mul_op = 3'b100,
      // rst_op = 3'b111
      case (op_i)
        3'b001: result_o = a_i + b_i;
        3'b010: result_o = a_i & b_i;
        3'b011: result_o = a_i ^ b_i;
        3'b100: result_o = a_i * b_i;
      endcase
      done_o = 'b1;
      @(posedge clk);
      done_o = 'b0;
      result_o = {RESULT_WIDTH{1'bx}}; 
		end
    @(posedge clk);
    ready_o = 'b1;
  end
end
              
endmodule

