`ifndef HDL_TOP_INCLUDED_
`define HDL_TOP_INCLUDED_
//--------------------------------------------------------------------------------------------
// module : hdl_top
// Description : hdl top has a interface and controller and target agent bfm
//--------------------------------------------------------------------------------------------
module hdl_top;
 //-------------------------------------------------------
 // Clock Reset Initialization
 //-------------------------------------------------------
 bit clk;
 bit rst;

 // MSHA:tri1 SCL;
 // MSHA:tri1 SDA;

 wire I3C_SCL;
 wire I3C_SDA;

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

 // Variable : intf_controller
 // SPI Interface Instantiation
 i3c_if intf_controller(.pclk(clk),
                    .areset(rst),
                    .SCL(I3C_SCL),
                    .SDA(I3C_SDA));

 // Variable : intf_target
 // SPI Interface Instantiation
 i3c_if intf_target(.pclk(clk),
                   .areset(rst),
                   .SCL(I3C_SCL),
                   .SDA(I3C_SDA));

 // MSHA: // Implementing week0 and week1 concept
 // MSHA: // Logic for Pull-up registers using opne-drain concept
 // MSHA: assign (weak0,weak1) SCL = 1'b1;
 // MSHA: assign (weak0,weak1) SDA = 1'b1;

  // Below table shows different values for each strength .
  //
  // Strength    Value     Value displayed by display tasks
  //   supply       7         Su
  //   strong       6         St
  //   pull         5         Pu
  //   large        4         La
  //   weak         3         We
  //   medium       2         Me
  //   small        1         Sm
  //   highz        0         HiZ

  //  To display strength of a signal %v is used with the signal name
  //  assign (weak1, weak0) io_dq = (direction) ? io : 1'bz;
  //  ex: $display("%v",io_dq);
    
 // Pullup for I3C interface
 pullup p1 (I3C_SCL);
 pullup p2 (I3C_SDA);

 // Variable : controller_agent_bfm_h
 // I2c controller BFM Agent Instantiation 
 i3c_controller_agent_bfm i3c_controller_agent_bfm_h(intf_controller); 
 
 // Variable : target_agent_bfm_h
 // SPI target BFM Agent Instantiation
 i3c_target_agent_bfm i3c_target_agent_bfm_h(intf_target);

 // To dump the waveforms
 initial begin
   $dumpfile("i3c_avip.vcd");
   $dumpvars();
 end

endmodule : hdl_top

`endif
