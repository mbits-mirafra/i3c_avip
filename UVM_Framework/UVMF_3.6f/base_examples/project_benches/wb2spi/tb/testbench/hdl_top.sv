//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 26
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : wb2spi Simulation Bench 
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

import wb2spi_parameters_pkg::*;
import uvmf_base_pkg_hdl::*;



module hdl_top;


bit clk;
   // Instantiate a clk driver 
   // tbx clkgen
   initial begin
      clk = 0;
      #5ns;
      forever #10ns clk = ~clk;
   end

// Instantiate the signal bundle, monitor bfm and driver bfm for each interface.
// The signal bundle, _if, contains signals to be connected to the DUT.
// The monitor, monitor_bfm, observes the bus, _if, and captures transactions.
// The driver, driver_bfm, drives transactions onto the bus, _if.

wb_if    #(.WB_DATA_WIDTH(WB_DATA_WIDTH),.WB_ADDR_WIDTH(WB_ADDR_WIDTH))      wb_bus(.clk(clk), .rst());
spi_if          spi_bus(.sck());

wb_monitor_bfm #(.WB_DATA_WIDTH(WB_DATA_WIDTH),.WB_ADDR_WIDTH(WB_ADDR_WIDTH))wb_mon_bfm(wb_bus);
spi_monitor_bfm spi_mon_bfm(spi_bus);

wb_driver_bfm  #(.WB_DATA_WIDTH(WB_DATA_WIDTH),.WB_ADDR_WIDTH(WB_ADDR_WIDTH))wb_drv_bfm(wb_bus);
spi_driver_bfm  spi_drv_bfm(spi_bus);


// Instantiate DUT here
wb2spi DUT(
  // 8bit WISHBONE bus slave interface
  .wb_clk(wb_bus.clk),         // clock
  .wb_rst(wb_bus.rst),         // reset (asynchronous active low)
  .wb_cyc(wb_bus.cyc),         // cycle
  .wb_stb(wb_bus.stb),         // strobe
  .wb_addr(wb_bus.adr),         // address [1:0]
  .wb_we(wb_bus.we),          // write enable
  .wb_data_in(wb_bus.dout),         // data input [7:0]
  .wb_data_out(wb_bus.din),         // data output [7:0]
  .wb_ack(wb_bus.ack),         // normal bus termination

  // SPI port
  .sck(spi_bus.sck),         // serial clock output
  .mosi(spi_bus.mosi),        // MasterOut SlaveIN
  .miso(spi_bus.miso)         // MasterIn SlaveOut
);

initial begin     import uvm_pkg::uvm_config_db;
// The monitor_bfm and driver_bfm for each interface is placed into the uvm_config_db.
// They are placed into the uvm_config_db using the string names defined in the parameters package.
// The string names are passed to the agent configurations by test_top through the top level configuration.
// They are retrieved by the agents configuration class for use by the agent.

uvm_config_db #( virtual wb_monitor_bfm#(.WB_DATA_WIDTH(WB_DATA_WIDTH),.WB_ADDR_WIDTH(WB_ADDR_WIDTH)) )::set( null , UVMF_VIRTUAL_INTERFACES , wb_pkg_wb_BFM , wb_mon_bfm ); 
uvm_config_db #( virtual spi_monitor_bfm )::set( null , UVMF_VIRTUAL_INTERFACES , spi_pkg_spi_BFM , spi_mon_bfm ); 

uvm_config_db #( virtual wb_driver_bfm#(.WB_DATA_WIDTH(WB_DATA_WIDTH),.WB_ADDR_WIDTH(WB_ADDR_WIDTH))  )::set( null , UVMF_VIRTUAL_INTERFACES , wb_pkg_wb_BFM , wb_drv_bfm  );
uvm_config_db #( virtual spi_driver_bfm  )::set( null , UVMF_VIRTUAL_INTERFACES , spi_pkg_spi_BFM , spi_drv_bfm  );


  end

endmodule

