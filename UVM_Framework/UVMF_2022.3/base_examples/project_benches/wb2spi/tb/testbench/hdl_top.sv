//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
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

//----------------------------------------------------------------------
//

import wb2spi_parameters_pkg::*;
import uvmf_base_pkg_hdl::*;

module hdl_top;
  // pragma attribute hdl_top partition_module_xrtl                                            
// pragma uvmf custom clock_generator begin
  bit clk;
  // Instantiate a clk driver 
  // tbx clkgen
  initial begin
    clk = 0;
    #9ns;
    forever begin
      clk = ~clk;
      #5ns;
    end
  end


// pragma uvmf custom clock_generator end

// pragma uvmf custom reset_generator begin
  bit rst;
  // Instantiate a rst driver
  // tbx clkgen
  initial begin
    rst = 0; 
    #200ns;
    rst =  1; 
  end


// pragma uvmf custom reset_generator end

  // pragma uvmf custom module_item_additional begin
  // pragma uvmf custom module_item_additional end

  // Instantiate the signal bundle, monitor bfm and driver bfm for each interface.
  // The signal bundle, _if, contains signals to be connected to the DUT.
  // The monitor, monitor_bfm, observes the bus, _if, and captures transactions.
  // The driver, driver_bfm, drives transactions onto the bus, _if.
  wb_if #(
        .WB_DATA_WIDTH(WB_DATA_WIDTH),
        .WB_ADDR_WIDTH(WB_ADDR_WIDTH)
        ) wb_bus(
     // pragma uvmf custom wb_bus_connections begin
     .clk(clk), .rst(rst)
     // pragma uvmf custom wb_bus_connections end
     );
  spi_if  spi_bus(
     // pragma uvmf custom spi_bus_connections begin
      .sck(), .rst(rst)
     // pragma uvmf custom spi_bus_connections end
     );
  wb_monitor_bfm #(
        .WB_DATA_WIDTH(WB_DATA_WIDTH),
        .WB_ADDR_WIDTH(WB_ADDR_WIDTH)
        ) wb_mon_bfm(wb_bus.monitor_port);
  spi_monitor_bfm  spi_mon_bfm(spi_bus.monitor_port);
  wb_driver_bfm #(
        .WB_DATA_WIDTH(WB_DATA_WIDTH),
        .WB_ADDR_WIDTH(WB_ADDR_WIDTH)
        ) wb_drv_bfm(wb_bus.initiator_port);
  spi_driver_bfm  spi_drv_bfm(spi_bus.responder_port);

  // pragma uvmf custom dut_instantiation begin
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




  // pragma uvmf custom dut_instantiation end

  initial begin      // tbx vif_binding_block 
    import uvm_pkg::uvm_config_db;
    // The monitor_bfm and driver_bfm for each interface is placed into the uvm_config_db.
    // They are placed into the uvm_config_db using the string names defined in the parameters package.
    // The string names are passed to the agent configurations by test_top through the top level configuration.
    // They are retrieved by the agents configuration class for use by the agent.
    uvm_config_db #( virtual wb_monitor_bfm #(
        .WB_DATA_WIDTH(WB_DATA_WIDTH),
        .WB_ADDR_WIDTH(WB_ADDR_WIDTH)
        ) )::set( null , UVMF_VIRTUAL_INTERFACES , wb_BFM , wb_mon_bfm ); 
    uvm_config_db #( virtual spi_monitor_bfm  )::set( null , UVMF_VIRTUAL_INTERFACES , spi_BFM , spi_mon_bfm ); 
    uvm_config_db #( virtual wb_driver_bfm #(
        .WB_DATA_WIDTH(WB_DATA_WIDTH),
        .WB_ADDR_WIDTH(WB_ADDR_WIDTH)
        ) )::set( null , UVMF_VIRTUAL_INTERFACES , wb_BFM , wb_drv_bfm  );
    uvm_config_db #( virtual spi_driver_bfm  )::set( null , UVMF_VIRTUAL_INTERFACES , spi_BFM , spi_drv_bfm  );
  end

endmodule
