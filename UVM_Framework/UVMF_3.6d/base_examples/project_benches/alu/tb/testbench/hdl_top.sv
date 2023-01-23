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
import alu_parameters_pkg::*;
import uvmf_base_pkg_hdl::*;

module hdl_top;
// pragma attribute hdl_top partition_module_xrtl

  alu_out_if          alu_out_bus(.clk(),.rst(),.done(),.result());
  alu_out_monitor_bfm alu_out_mon_bfm(alu_out_bus);
  alu_out_driver_bfm  alu_out_drv_bfm(alu_out_bus);

  alu_in_if           alu_in_bus(.clk(),.rst(),.valid(),.ready(),.op(),.a(),.b());
  alu_in_monitor_bfm  alu_in_mon_bfm(alu_in_bus);
  alu_in_driver_bfm   alu_in_drv_bfm(alu_in_bus);

  assign alu_out_bus.clk = alu_in_bus.clk;
  assign alu_out_bus.rst = alu_in_bus.rst;


  alu   #(.OP_WIDTH(8), .RESULT_WIDTH(16)) DUT  (
       // AHB connections
      .clk    (alu_in_bus.clk ) ,
      .rst    (alu_in_bus.rst ) ,
      .ready  (alu_in_bus.ready ) ,
      .valid  (alu_in_bus.valid ) ,
      .op     (alu_in_bus.op ) ,
      .a      (alu_in_bus.a ) ,
      .b      (alu_in_bus.b ) ,
      .done   (alu_out_bus.done ) ,
      .result (alu_out_bus.result ) );


  initial begin // tbx vif_binding_block
   import uvm_pkg::uvm_config_db;

   uvm_config_db #( virtual alu_out_monitor_bfm )::
      set( null , UVMF_VIRTUAL_INTERFACES , ALU_OUT_BFM , alu_out_mon_bfm );
   uvm_config_db #( virtual alu_out_driver_bfm  )::
      set( null , UVMF_VIRTUAL_INTERFACES , ALU_OUT_BFM  , alu_out_drv_bfm  );

   uvm_config_db #( virtual alu_in_monitor_bfm )::
      set( null , UVMF_VIRTUAL_INTERFACES  , ALU_IN_BFM  , alu_in_mon_bfm );
   uvm_config_db #( virtual alu_in_driver_bfm  )::
      set( null , UVMF_VIRTUAL_INTERFACES  , ALU_IN_BFM   , alu_in_drv_bfm  );

  end
    
endmodule
