//----------------------------------------------------------------------
//   Copyright 2013 Mentor Graphics Corporation
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//                   Mentor Graphics Inc
//----------------------------------------------------------------------
// Project         : GPIO Example Project Bench
// Unit            : DUT Top Module
// File            : hdl_top.sv
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This top level module instantiates all synthesizable
//    static content.  This and hvl_top.sv are the two top level modules
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
import gpio_example_parameters_pkg::*;
import uvmf_base_pkg_hdl::*;


module hdl_top;
// pragma attribute hdl_top partition_module_xrtl

bit clk;

  // tbx clkgen
  initial begin
     clk = 0;
     forever #5ns clk = ~clk;
  end


  gpio_if #(
     .READ_PORT_WIDTH(TEST_GPIO_READ_PORT_WIDTH), 
     .WRITE_PORT_WIDTH(TEST_GPIO_WRITE_PORT_WIDTH)) gpio_bus();
  gpio_monitor_bfm #(
     .READ_PORT_WIDTH(TEST_GPIO_READ_PORT_WIDTH), 
     .WRITE_PORT_WIDTH(TEST_GPIO_WRITE_PORT_WIDTH)) gpio_mon_bfm(gpio_bus);
  gpio_driver_bfm #(
     .READ_PORT_WIDTH(TEST_GPIO_READ_PORT_WIDTH), 
     .WRITE_PORT_WIDTH(TEST_GPIO_WRITE_PORT_WIDTH)) gpio_drv_bfm(gpio_bus);

  assign gpio_bus.clk = clk;

  bit [TEST_GPIO_READ_PORT_WIDTH:0] read_port_;
  always @(posedge gpio_bus.clk) begin
    if (read_port_ != gpio_bus.write_port) read_port_ = gpio_bus.write_port;
  end
  assign gpio_bus.read_port = read_port_;

  initial begin // tbx vif_binding_block
   import uvm_pkg::uvm_config_db;

    uvm_config_db #( virtual gpio_monitor_bfm #(TEST_GPIO_READ_PORT_WIDTH, TEST_GPIO_WRITE_PORT_WIDTH))::
       set( null , UVMF_VIRTUAL_INTERFACES , "gpio_bfm" , gpio_mon_bfm );
    uvm_config_db #( virtual gpio_driver_bfm #(TEST_GPIO_READ_PORT_WIDTH, TEST_GPIO_WRITE_PORT_WIDTH) )::
       set( null , UVMF_VIRTUAL_INTERFACES , "gpio_bfm"  , gpio_drv_bfm  );

  end

endmodule
