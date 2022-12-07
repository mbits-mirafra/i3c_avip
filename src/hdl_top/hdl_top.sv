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

 tri1 SCL;
 tri1 SDA;

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

 // Variable : intf_master
 // SPI Interface Instantiation
 i3c_if intf_master(.pclk(clk),
                    .areset(rst),
                    .SCL(SCL),
                    .SDA(SDA));

 // Variable : intf_slave
 // SPI Interface Instantiation
 i3c_if intf_slave(.pclk(clk),
                   .areset(rst),
                   .SCL(),
                   .SDA());

 // MSHA: assign intf_slave.SCL = intf_master.SCL;
 // MSHA: assign intf_slave.SDA = intf_master.SDA;

 // Variable : master_agent_bfm_h
 // I2c Master BFM Agent Instantiation 
 i3c_master_agent_bfm i3c_master_agent_bfm_h(intf_master); 
 
 // Variable : slave_agent_bfm_h
 // SPI Slave BFM Agent Instantiation
 i3c_slave_agent_bfm i3c_slave_agent_bfm_h(intf_slave);

 // MSHA: SCL = intf_master.SCL;
 // MSHA: SCL = intf_slave.SCL;

 // MSHA: SDA = intf_master.SDA;
 // MSHA: SDA = intf_slave.SDA;

initial begin
  $dumpfile("i3c_avip.vcd");
  $dumpvars();
end

endmodule : hdl_top

`endif
