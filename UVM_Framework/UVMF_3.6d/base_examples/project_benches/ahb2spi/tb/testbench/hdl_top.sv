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
// Project         : AHB to SPI Project Bench
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
import ahb2spi_parameters_pkg::*;
import uvmf_base_pkg_hdl::*;

module hdl_top;
// pragma attribute hdl_top partition_module_xrtl

  ahb_if          ahb_bus(.hclk(),.hresetn(),.haddr(),.hwdata(),.htrans(),.hburst(),
                          .hsize(),.hwrite(),.hsel(),.hready(),.hrdata(),.hresp());
  ahb_monitor_bfm ahb_mon_bfm(ahb_bus);
  ahb_driver_bfm  ahb_drv_bfm(ahb_bus);

  spi_if          spi_bus(.sck(),.mosi(),.miso());
  spi_monitor_bfm spi_mon_bfm(spi_bus);
  spi_driver_bfm  spi_drv_bfm(spi_bus);

  ahb2spi    DUT  (
       // AHB connections
       .ahb(ahb_bus),
      // SPI connections
      .spi(spi_bus)
  );

  wb_if wb (
        .clk( DUT.clk ), .rst( DUT.rst ), 
        .inta( DUT.inta ), .cyc( DUT.cyc ), .stb( DUT.stb ), .adr( DUT.adr ), 
        .we( DUT.we ), .din( DUT.din ), .dout( DUT.dout ), .ack( DUT.ack ),
        .err( DUT.err ), .rty( DUT.rty ), .sel( DUT.sel ), .q( DUT.q )
        );

  wb_monitor_bfm  wb_mon_bfm(/*DUT.*/wb);

/*
  bind DUT wb_if wb (
        .clk( clk ),
        .rst( rst ),
        .inta( inta ),
        .cyc( cyc ),
        .stb( stb ),
        .adr( adr ),
        .we( we ),
        .din( din ),
        .dout( dout ),
        .ack( ack ),
        .err( err ),
        .rty( rty ),
        .sel( sel ),
        .q( q )
        );
*/


  initial begin // tbx vif_binding_block
   import uvm_pkg::uvm_config_db;

   uvm_config_db #( virtual ahb_monitor_bfm )::
      set( null , UVMF_VIRTUAL_INTERFACES , AHB_BFM , ahb_mon_bfm );
   uvm_config_db #( virtual ahb_driver_bfm  )::
      set( null , UVMF_VIRTUAL_INTERFACES , AHB_BFM , ahb_drv_bfm  );

   uvm_config_db #( virtual wb_monitor_bfm )::
      set( null , UVMF_VIRTUAL_INTERFACES  , WB_BFM  , wb_mon_bfm );

   uvm_config_db #( virtual spi_monitor_bfm )::
      set( null , UVMF_VIRTUAL_INTERFACES , SPI_BFM , spi_mon_bfm );
   uvm_config_db #( virtual spi_driver_bfm  )::
      set( null , UVMF_VIRTUAL_INTERFACES , SPI_BFM , spi_drv_bfm  );

  end

endmodule
