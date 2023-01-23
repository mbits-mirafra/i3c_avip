module nandgate(input clk,
  input rst,
  input a,
  input b,
  output reg y);
  always @(posedge clk)begin
    if(!rst)begin
      y= ~(a&b);
    end
    else 
      y=0;

    end
    endmodule
