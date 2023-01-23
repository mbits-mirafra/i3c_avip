//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : daerne
// Creation Date   : 2016 Oct 16
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : axi4_2x2_fabric Simulation Bench 
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

import axi4_2x2_fabric_parameters_pkg::*;
import axi4_2x2_fabric_qvip_params_pkg::*;
import uvmf_base_pkg_hdl::*;



module hdl_top;

hdl_axi4_2x2_fabric_qvip qvip_axi4_2x2_fabric_qvip();

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





// UVMF_CHANGE_ME : Add DUT and connect to signals in _bus interfaces listed above
// Instantiate DUT here

initial begin     import uvm_pkg::uvm_config_db;
// The monitor_bfm and driver_bfm for each interface is placed into the uvm_config_db.
// They are placed into the uvm_config_db using the string names defined in the parameters package.
// The string names are passed to the agent configurations by test_top through the top level configuration.
// They are retrieved by the agents configuration class for use by the agent.




  end

endmodule

