`ifndef I3C_IF_INCLUDED_
`define I3C_IF_INCLUDED_

//--------------------------------------------------------------------------------------------
// class     : I3C_intf
// Description  : Declaring the signals for i3c interface
//--------------------------------------------------------------------------------------------
interface i3c_if(input pclk, input areset);
  
  // Variable: scl
  // i3c serial clock signal
  wire scl;

  // Variable: sda
  // i3c serial data signal
  wire sda;
  
  // Variable: scl_i
  // i3c serial input clocl signal
  logic scl_i;
	
  // Variable: scl_o
  // i3c serial output clock signal
  logic scl_o;
	
  // Variable: scl_oen
  // i3c serial output enable signal
  logic scl_oen;
  
  // Variable: sda_i
  // i3c serial input data signal
  logic  sda_i;
  
  // Variable: sda_o
  // i3c serial output data signal
	logic sda_o;
  
  // Variable: sda_oen
  // i3c serial output enable signal
	logic sda_oen; 
  
  // Tri-state buffer implementation 
  assign scl = (scl_oen) ? scl_o : 1'bz;
  assign sda = (sda_oen) ? sda_o : 1'bz;

  // Implementing week0 and week1 concept
  // Logic for Pull-up registers using opne-drain concept
  assign (weak0,weak1) scl = 1'b1;
  assign (weak0,weak1) sda = 1'b1;

  // Used for sampling the I3C interface signals
  assign scl_i = scl;
  assign sda_i = sda;


endinterface : i3c_if

`endif
