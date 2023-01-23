//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Nov 30
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : gpio_example Simulation Bench 
// Unit            : HDL top level module
// File            : hdl_top.sv
//----------------------------------------------------------------------
//                                          
// Description: This top level module instantiates all synthesizable
//    static content.  This and tb_top.sv are the two top level modules
//    of the simulation.  
//
//    This module instantiates the following:
//        DUT: The Design Under Test
//        Interfaces:  Signal bundles that contain signals connected to DUT
//        Driver BFM's: BFM's that actively drive interface signals
//        Monitor BFM's: BFM's that passively monitor interface signals
//
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
//

import gpio_example_parameters_pkg::*;
import uvmf_base_pkg_hdl::*;



module hdl_top;
// pragma attribute hdl_top partition_module_xrtl                                            


bit rst = 0;
bit clk;
   // Instantiate a clk driver 
   // tbx clkgen
   initial begin
      #9ns;
      clk = ~clk;
      forever #5ns clk = ~clk;
   end
   // Instantiate a rst driver
   initial begin
      #200ns;
      rst <= ~rst;
   end



// Instantiate the signal bundle, monitor bfm and driver bfm for each interface.
// The signal bundle, _if, contains signals to be connected to the DUT.
// The monitor, monitor_bfm, observes the bus, _if, and captures transactions.
// The driver, driver_bfm, drives transactions onto the bus, _if.

gpio_if #(.WRITE_PORT_WIDTH(32),.READ_PORT_WIDTH(16))  gpio_a_bus(.clk(clk), .rst(rst));
gpio_if #(.WRITE_PORT_WIDTH(16),.READ_PORT_WIDTH(32))  gpio_b_bus(.clk(clk), .rst(rst));

gpio_monitor_bfm #(.WRITE_PORT_WIDTH(32),.READ_PORT_WIDTH(16))  gpio_a_mon_bfm(gpio_a_bus);
gpio_monitor_bfm #(.WRITE_PORT_WIDTH(16),.READ_PORT_WIDTH(32))  gpio_b_mon_bfm(gpio_b_bus);

gpio_driver_bfm #(.WRITE_PORT_WIDTH(32),.READ_PORT_WIDTH(16))  gpio_a_drv_bfm(gpio_a_bus);
gpio_driver_bfm #(.WRITE_PORT_WIDTH(16),.READ_PORT_WIDTH(32))  gpio_b_drv_bfm(gpio_b_bus);


// UVMF_CHANGE_ME : Add DUT and connect to signals in _bus interfaces listed above
// Instantiate DUT here

  bit [15:0] read_port_a;
  bit [31:0] read_port_b;

  always @(posedge gpio_a_bus.clk) begin
    if (read_port_a != gpio_b_bus.write_port) read_port_a = gpio_b_bus.write_port;
    if (read_port_b != gpio_a_bus.write_port) read_port_b = gpio_a_bus.write_port;
  end
  
  assign gpio_a_bus.read_port = read_port_a;
  assign gpio_b_bus.read_port = read_port_b;

initial begin  // tbx vif_binding_block 
    import uvm_pkg::uvm_config_db;
// The monitor_bfm and driver_bfm for each interface is placed into the uvm_config_db.
// They are placed into the uvm_config_db using the string names defined in the parameters package.
// The string names are passed to the agent configurations by test_top through the top level configuration.
// They are retrieved by the agents configuration class for use by the agent.

uvm_config_db #( virtual gpio_monitor_bfm #(.WRITE_PORT_WIDTH(32),.READ_PORT_WIDTH(16))  )::set( null , UVMF_VIRTUAL_INTERFACES , gpio_pkg_gpio_a_BFM , gpio_a_mon_bfm ); 
uvm_config_db #( virtual gpio_monitor_bfm #(.WRITE_PORT_WIDTH(16),.READ_PORT_WIDTH(32))  )::set( null , UVMF_VIRTUAL_INTERFACES , gpio_pkg_gpio_b_BFM , gpio_b_mon_bfm ); 

uvm_config_db #( virtual gpio_driver_bfm #(.WRITE_PORT_WIDTH(32),.READ_PORT_WIDTH(16))  )::set( null , UVMF_VIRTUAL_INTERFACES , gpio_pkg_gpio_a_BFM , gpio_a_drv_bfm  );
uvm_config_db #( virtual gpio_driver_bfm #(.WRITE_PORT_WIDTH(16),.READ_PORT_WIDTH(32))  )::set( null , UVMF_VIRTUAL_INTERFACES , gpio_pkg_gpio_b_BFM , gpio_b_drv_bfm  );


  end

endmodule

