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
// Project         : WB to SPI Project Bench
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
import wb2spi_parameters_pkg::*;
import uvmf_base_pkg_hdl::*;

module hdl_top;
// pragma attribute hdl_top partition_module_xrtl

  spi_if          spi_bus(.sck(),.mosi(),.miso());
  spi_monitor_bfm spi_mon_bfm(spi_bus);
  spi_driver_bfm  spi_drv_bfm(spi_bus);

  wb_if #(.DWIDTH(8),.AWIDTH(2)) wb_bus(.clk(),.rst(),.inta(),.cyc(),.stb(),.adr(),.we(),
                                        .din(),.dout(),.ack(),.err(),.rty(),.sel(),.q());

  wb_monitor_bfm  wb_mon_bfm(wb_bus);
  wb_driver_bfm   wb_drv_bfm(wb_bus);

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


  initial begin // tbx vif_binding_block
   import uvm_pkg::uvm_config_db;

   uvm_config_db #( virtual spi_monitor_bfm )::
      set( null , UVMF_VIRTUAL_INTERFACES , SPI_BFM , spi_mon_bfm );
   uvm_config_db #( virtual spi_driver_bfm  )::
      set( null , UVMF_VIRTUAL_INTERFACES , SPI_BFM  , spi_drv_bfm  );

   uvm_config_db #( virtual wb_monitor_bfm )::
      set( null , UVMF_VIRTUAL_INTERFACES  , WB_BFM  , wb_mon_bfm );
   uvm_config_db #( virtual wb_driver_bfm  )::
      set( null , UVMF_VIRTUAL_INTERFACES  , WB_BFM   , wb_drv_bfm  );

  end

endmodule
