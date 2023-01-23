//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 26
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb2spi Simulation Bench 
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

import ahb2spi_parameters_pkg::*;
import uvmf_base_pkg_hdl::*;



module hdl_top;


bit rst;
bit clk;
   // Instantiate a clk driver 
   // tbx clkgen
   initial begin
      clk = 0;
      #5ns;
      forever #10ns clk = ~clk;
   end
   // Instantiate a rst driver
   initial begin
      repeat (10) @(posedge clk);
      rst <= 1'b1;
   end



// Instantiate the signal bundle, monitor bfm and driver bfm for each interface.
// The signal bundle, _if, contains signals to be connected to the DUT.
// The monitor, monitor_bfm, observes the bus, _if, and captures transactions.
// The driver, driver_bfm, drives transactions onto the bus, _if.

ahb_if          ahb_bus(.hclk(clk), .hresetn(rst));

spi_if          spi_bus();

ahb_monitor_bfm ahb_mon_bfm(ahb_bus);
spi_monitor_bfm spi_mon_bfm(spi_bus);

ahb_driver_bfm  ahb_drv_bfm(ahb_bus);
spi_driver_bfm  spi_drv_bfm(spi_bus);


// UVMF_CHANGE_ME : Add DUT and connect to signals in _bus interfaces listed above
// Instantiate DUT here
  ahb2spi    DUT  (
       // AHB connections
       .ahb(ahb_bus),
      // SPI connections
      .spi(spi_bus)
  );

  wb_if wb_bus (
        .clk( DUT.clk ), .rst( DUT.rst ), 
        .inta( DUT.inta ), .cyc( DUT.cyc ), .stb( DUT.stb ), .adr( DUT.adr ), 
        .we( DUT.we ), .din( DUT.din ), .dout( DUT.dout ), .ack( DUT.ack ),
        .err( DUT.err ), .rty( DUT.rty ), .sel( DUT.sel ), .q( DUT.q )
        );

  wb_monitor_bfm  wb_mon_bfm(/*DUT.*/wb_bus);

initial begin     import uvm_pkg::uvm_config_db;
// The monitor_bfm and driver_bfm for each interface is placed into the uvm_config_db.
// They are placed into the uvm_config_db using the string names defined in the parameters package.
// The string names are passed to the agent configurations by test_top through the top level configuration.
// They are retrieved by the agents configuration class for use by the agent.

uvm_config_db #( virtual ahb_monitor_bfm )::set( null , UVMF_VIRTUAL_INTERFACES , ahb_pkg_ahb_BFM , ahb_mon_bfm ); 
uvm_config_db #( virtual wb_monitor_bfm )::set( null , UVMF_VIRTUAL_INTERFACES , wb_pkg_wb_BFM , wb_mon_bfm ); 
uvm_config_db #( virtual spi_monitor_bfm )::set( null , UVMF_VIRTUAL_INTERFACES , spi_pkg_spi_BFM , spi_mon_bfm ); 

uvm_config_db #( virtual ahb_driver_bfm  )::set( null , UVMF_VIRTUAL_INTERFACES , ahb_pkg_ahb_BFM , ahb_drv_bfm  );
uvm_config_db #( virtual spi_driver_bfm  )::set( null , UVMF_VIRTUAL_INTERFACES , spi_pkg_spi_BFM , spi_drv_bfm  );


  end

endmodule

