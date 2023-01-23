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

import ahb2spi_parameters_pkg::*;
import uvmf_base_pkg_hdl::*;

module hdl_top;
  // pragma attribute hdl_top partition_module_xrtl                                            
// pragma uvmf custom clock_generator begin
  bit clk;
  // Instantiate a clk driver 
  // tbx clkgen
  initial begin
    clk = 0;
    #21ns;
    forever begin
      clk = ~clk;
      #6ns;
    end
  end



// pragma uvmf custom clock_generator end

// pragma uvmf custom reset_generator begin
  bit rst;
  // Instantiate a rst driver
  // tbx clkgen
  initial begin
    rst = 0; 
    #250ns;
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
        ) ahb2wb_wb_bus(
     // pragma uvmf custom ahb2wb_wb_bus_connections begin
        .clk( DUT.clk ), .rst( DUT.rst ), 
        .inta( DUT.inta ), .cyc( DUT.cyc ), .stb( DUT.stb ), .adr( DUT.adr ), 
        .we( DUT.we ), .din( DUT.din ), .dout( DUT.dout ), .ack( DUT.ack ),
        .err( DUT.err ), .rty( DUT.rty ), .sel( DUT.sel ), .q( DUT.q )        


     // pragma uvmf custom ahb2wb_wb_bus_connections end
     );
  ahb_if  ahb2wb_ahb_bus(
     // pragma uvmf custom ahb2wb_ahb_bus_connections begin
     .hclk(clk), .hresetn(rst)
     // pragma uvmf custom ahb2wb_ahb_bus_connections end
     );
  wb_if #(
        .WB_DATA_WIDTH(WB_DATA_WIDTH),
        .WB_ADDR_WIDTH(WB_ADDR_WIDTH)
        ) wb2spi_wb_bus(
     // pragma uvmf custom wb2spi_wb_bus_connections begin
        .clk( DUT.clk ), .rst( DUT.rst ), 
        .inta( DUT.inta ), .cyc( DUT.cyc ), .stb( DUT.stb ), .adr( DUT.adr ), 
        .we( DUT.we ), .din( DUT.din ), .dout( DUT.dout ), .ack( DUT.ack ),
        .err( DUT.err ), .rty( DUT.rty ), .sel( DUT.sel ), .q( DUT.q )        


     // pragma uvmf custom wb2spi_wb_bus_connections end
     );
  spi_if  wb2spi_spi_bus(
     // pragma uvmf custom wb2spi_spi_bus_connections begin
       .sck(), .rst(rst)
     // pragma uvmf custom wb2spi_spi_bus_connections end
     );
  wb_monitor_bfm #(
        .WB_DATA_WIDTH(WB_DATA_WIDTH),
        .WB_ADDR_WIDTH(WB_ADDR_WIDTH)
        ) ahb2wb_wb_mon_bfm(ahb2wb_wb_bus.monitor_port);
  ahb_monitor_bfm  ahb2wb_ahb_mon_bfm(ahb2wb_ahb_bus.monitor_port);
  wb_monitor_bfm #(
        .WB_DATA_WIDTH(WB_DATA_WIDTH),
        .WB_ADDR_WIDTH(WB_ADDR_WIDTH)
        ) wb2spi_wb_mon_bfm(wb2spi_wb_bus.monitor_port);
  spi_monitor_bfm  wb2spi_spi_mon_bfm(wb2spi_spi_bus.monitor_port);
  ahb_driver_bfm  ahb2wb_ahb_drv_bfm(ahb2wb_ahb_bus.initiator_port);
  spi_driver_bfm  wb2spi_spi_drv_bfm(wb2spi_spi_bus.responder_port);

  // pragma uvmf custom dut_instantiation begin
  // UVMF_CHANGE_ME : Add DUT and connect to signals in _bus interfaces listed above
  // Instantiate your DUT here
  // These DUT's instantiated to show verilog and vhdl instantiation
  ahb2spi    DUT  (
       // AHB connections
       .ahb(ahb2wb_ahb_bus),
      // SPI connections
      .spi(wb2spi_spi_bus)
  );
  /* Connection for internal signals
  wb_if wb_bus (
        .clk( DUT.clk ), .rst( DUT.rst ), 
        .inta( DUT.inta ), .cyc( DUT.cyc ), .stb( DUT.stb ), .adr( DUT.adr ), 
        .we( DUT.we ), .din( DUT.din ), .dout( DUT.dout ), .ack( DUT.ack ),
        .err( DUT.err ), .rty( DUT.rty ), .sel( DUT.sel ), .q( DUT.q )
        );
  */



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
        ) )::set( null , UVMF_VIRTUAL_INTERFACES , ahb2wb_wb_BFM , ahb2wb_wb_mon_bfm ); 
    uvm_config_db #( virtual ahb_monitor_bfm  )::set( null , UVMF_VIRTUAL_INTERFACES , ahb2wb_ahb_BFM , ahb2wb_ahb_mon_bfm ); 
    uvm_config_db #( virtual wb_monitor_bfm #(
        .WB_DATA_WIDTH(WB_DATA_WIDTH),
        .WB_ADDR_WIDTH(WB_ADDR_WIDTH)
        ) )::set( null , UVMF_VIRTUAL_INTERFACES , wb2spi_wb_BFM , wb2spi_wb_mon_bfm ); 
    uvm_config_db #( virtual spi_monitor_bfm  )::set( null , UVMF_VIRTUAL_INTERFACES , wb2spi_spi_BFM , wb2spi_spi_mon_bfm ); 
    uvm_config_db #( virtual ahb_driver_bfm  )::set( null , UVMF_VIRTUAL_INTERFACES , ahb2wb_ahb_BFM , ahb2wb_ahb_drv_bfm  );
    uvm_config_db #( virtual spi_driver_bfm  )::set( null , UVMF_VIRTUAL_INTERFACES , wb2spi_spi_BFM , wb2spi_spi_drv_bfm  );
  end

endmodule
