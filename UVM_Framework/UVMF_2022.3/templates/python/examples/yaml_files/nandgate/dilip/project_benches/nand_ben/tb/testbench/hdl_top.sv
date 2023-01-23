//----------------------------------------------------------------------
// Created with uvmf_gen version 2022.3
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

module hdl_top;

import nand_ben_parameters_pkg::*;
import uvmf_base_pkg_hdl::*;

// pragma uvmf custom clock_generator begin
  bit clk;
  // Instantiate a clk driver 
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
  nand_in_if  nand_in_agent_bus(
     // pragma uvmf custom nand_in_agent_bus_connections begin
     .clk(clk), .rst(rst)
     // pragma uvmf custom nand_in_agent_bus_connections end
     );
  nand_out_if  nand_out_agent_bus(
     // pragma uvmf custom nand_out_agent_bus_connections begin
     .clk(clk), .rst(rst)
     // pragma uvmf custom nand_out_agent_bus_connections end
     );
  nand_in_monitor_bfm  nand_in_agent_mon_bfm(nand_in_agent_bus.monitor_port);
  nand_out_monitor_bfm  nand_out_agent_mon_bfm(nand_out_agent_bus.monitor_port);
  nand_in_driver_bfm  nand_in_agent_drv_bfm(nand_in_agent_bus.initiator_port);

  // pragma uvmf custom dut_instantiation begin
  // UVMF_CHANGE_ME : Add DUT and connect to signals in _bus interfaces listed above
  // Instantiate your DUT here
  // These DUT's instantiated to show verilog and vhdl instantiation
nandgate n1(.clk(clk), .rst(rst), .a(nand_in_agent_bus.a), .b(nand_in_agent_bus.b), .y(nand_out_agent_bus.y)); 
// pragma uvmf custom dut_iinstantiation end

  initial begin      import uvm_pkg::uvm_config_db;
    // The monitor_bfm and driver_bfm for each interface is placed into the uvm_config_db.
    // They are placed into the uvm_config_db using the string names defined in the parameters package.
    // The string names are passed to the agent configurations by test_top through the top level configuration.
    // They are retrieved by the agents configuration class for use by the agent.
    uvm_config_db #( virtual nand_in_monitor_bfm  )::set( null , UVMF_VIRTUAL_INTERFACES , nand_in_agent_BFM , nand_in_agent_mon_bfm ); 
    uvm_config_db #( virtual nand_out_monitor_bfm  )::set( null , UVMF_VIRTUAL_INTERFACES , nand_out_agent_BFM , nand_out_agent_mon_bfm ); 
    uvm_config_db #( virtual nand_in_driver_bfm  )::set( null , UVMF_VIRTUAL_INTERFACES , nand_in_agent_BFM , nand_in_agent_drv_bfm  );
  end

endmodule

// pragma uvmf custom external begin
// pragma uvmf custom external end

