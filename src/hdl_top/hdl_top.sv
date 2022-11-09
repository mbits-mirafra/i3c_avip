`ifndef HDL_TOP_INCLUDED_
`define HDL_TOP_INCLUDED_
//--------------------------------------------------------------------------------------------
// module : hdl_top
// Description : hdl top has a interface and master and slave agent bfm
//--------------------------------------------------------------------------------------------
module hdl_top;
 //-------------------------------------------------------
 // Clock Reset Initialization
 //-------------------------------------------------------
 bit clk;
 bit rst;

 //-------------------------------------------------------
 // Display statement for HDL_TOP
 //-------------------------------------------------------
 initial begin
 $display("HDL TOP");
 end

 //-------------------------------------------------------
 // System Clock Generation
 //-------------------------------------------------------
 initial begin
   clk = 1'b0;
   forever #10 clk = ~clk;
 end

 //-------------------------------------------------------
 // System Reset Generation
 // Active low reset
 //-------------------------------------------------------
 initial begin
   rst = 1'b1;

   repeat (2) begin
     @(posedge clk);
   end
   rst = 1'b0;

   repeat (2) begin
     @(posedge clk);
   end
   rst = 1'b1;
 end

 // Variable : intf
 // SPI Interface Instantiation
 i3c_if intf(.pclk(clk),
             .areset(rst));

 // Variable : master_agent_bfm_h
 // I2c Master BFM Agent Instantiation 
 i3c_master_agent_bfm i3c_master_agent_bfm_h(intf); 
 
 // Variable : slave_agent_bfm_h
 // SPI Slave BFM Agent Instantiation
 i3c_slave_agent_bfm i3c_slave_agent_bfm_h(intf);

endmodule : hdl_top

`endif
