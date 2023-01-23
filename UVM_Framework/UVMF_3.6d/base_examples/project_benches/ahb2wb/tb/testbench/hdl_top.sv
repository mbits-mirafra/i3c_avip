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
// Project         : AHB to WB Simulation Bench
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
import ahb2wb_parameters_pkg::*;
import uvmf_base_pkg_hdl::*;

module hdl_top;
// pragma attribute hdl_top partition_module_xrtl

  ahb_if          ahb_bus(.hclk(),.hresetn(),.haddr(),.hwdata(),.htrans(),.hburst(),
                          .hsize(),.hwrite(),.hsel(),.hready(),.hrdata(),.hresp());
  ahb_monitor_bfm ahb_mon_bfm(ahb_bus);
  ahb_driver_bfm  ahb_drv_bfm(ahb_bus);

  wb_if           wb_bus(.clk(),.rst(),.inta(),.cyc(),.stb(),.adr(),.we(),
                         .din(),.dout(),.ack(),.err(),.rty(),.sel(),.q());
  wb_monitor_bfm  wb_mon_bfm(wb_bus);
  wb_driver_bfm   wb_drv_bfm(wb_bus);

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


  initial begin // tbx vif_binding_block
   import uvm_pkg::uvm_config_db;

   uvm_config_db #( virtual ahb_monitor_bfm )::
      set( null , UVMF_VIRTUAL_INTERFACES , AHB_BFM , ahb_mon_bfm );
   uvm_config_db #( virtual ahb_driver_bfm  )::
      set( null , UVMF_VIRTUAL_INTERFACES , AHB_BFM  , ahb_drv_bfm  );

   uvm_config_db #( virtual wb_monitor_bfm )::
      set( null , UVMF_VIRTUAL_INTERFACES  , WB_BFM  , wb_mon_bfm );
   uvm_config_db #( virtual wb_driver_bfm  )::
      set( null , UVMF_VIRTUAL_INTERFACES  , WB_BFM   , wb_drv_bfm  );

  end

endmodule
