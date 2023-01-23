//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 26
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb2wb Simulation Bench 
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

import ahb2wb_parameters_pkg::*;
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
wb_if  #(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH))  wb_bus(.clk(clk), .rst(rst));

ahb_monitor_bfm ahb_mon_bfm(ahb_bus);
wb_monitor_bfm #(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH)) wb_mon_bfm(wb_bus);

ahb_driver_bfm  ahb_drv_bfm(ahb_bus);
wb_driver_bfm #(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH)) wb_drv_bfm(wb_bus);


// Instantiate DUT here
  ahb2wb   #(.ADDR_WIDTH(32), .DATA_WIDTH(16)) DUT  (
       // AHB connections
      .hclk    (ahb_bus.hclk ) ,
      .hresetn (ahb_bus.hresetn ) ,
      .haddr   (ahb_bus.haddr ) ,
      .hwdata  (ahb_bus.hwdata ) ,
      .htrans  (ahb_bus.htrans ) ,
      .hburst  (ahb_bus.hburst ) ,
      .hsize   (ahb_bus.hsize ) ,
      .hwrite  (ahb_bus.hwrite ) ,
      .hsel    (ahb_bus.hsel ) ,
      .hready  (ahb_bus.hready ) ,
      .hrdata  (ahb_bus.hrdata ) ,
      .hresp   (ahb_bus.hresp ) ,

      // Wishbone connections
      .wb_clk      (wb_bus.clk),
      .wb_rst      (wb_bus.rst) ,
      .wb_cyc      (wb_bus.cyc ) ,
      .wb_stb      (wb_bus.stb ),
      .wb_addr     (wb_bus.adr ) ,
      .wb_we       (wb_bus.we ) ,
      .wb_data_in  (wb_bus.din ) ,
      .wb_data_out (wb_bus.dout ) ,
      .wb_ack      (wb_bus.ack ) );

initial begin     import uvm_pkg::uvm_config_db;
// The monitor_bfm and driver_bfm for each interface is placed into the uvm_config_db.
// They are placed into the uvm_config_db using the string names defined in the parameters package.
// The string names are passed to the agent configurations by test_top through the top level configuration.
// They are retrieved by the agents configuration class for use by the agent.

uvm_config_db #( virtual ahb_monitor_bfm )::set( null , UVMF_VIRTUAL_INTERFACES , ahb_pkg_ahb_BFM , ahb_mon_bfm ); 
uvm_config_db #( virtual wb_monitor_bfm#(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH)) )::set( null , UVMF_VIRTUAL_INTERFACES , wb_pkg_wb_BFM , wb_mon_bfm ); 

uvm_config_db #( virtual ahb_driver_bfm  )::set( null , UVMF_VIRTUAL_INTERFACES , ahb_pkg_ahb_BFM , ahb_drv_bfm  );
uvm_config_db #( virtual wb_driver_bfm#(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH)) )::set( null , UVMF_VIRTUAL_INTERFACES , wb_pkg_wb_BFM , wb_drv_bfm  );


  end

endmodule

