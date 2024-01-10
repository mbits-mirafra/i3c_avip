`ifndef I3C_IF_INCLUDED_
`define I3C_IF_INCLUDED_

interface i3c_if(input pclk, input areset, inout SCL, inout SDA);
  
  // i3c serial input clocl signal
  logic scl_i;
	
  // i3c serial output clock signal
  logic scl_o;
	
  // i3c serial output enable signal
  logic scl_oen;
  
  // i3c serial input data signal
  logic  sda_i;
  
  // i3c serial output data signal
	logic sda_o;
  
  // i3c serial output enable signal
	logic sda_oen; 
  
  // Tri-state buffer implementation 
  assign SCL = (scl_oen) ? scl_o : 1'bz;
  assign SDA = (sda_oen) ? sda_o : 1'bz;

  // Used for sampling the I3C interface signals
  assign scl_i = SCL;
  assign sda_i = SDA;

endinterface : i3c_if

`endif
