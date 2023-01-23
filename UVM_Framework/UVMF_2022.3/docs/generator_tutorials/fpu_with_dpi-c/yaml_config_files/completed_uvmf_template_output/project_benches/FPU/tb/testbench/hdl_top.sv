//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU Simulation Bench 
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

import FPU_parameters_pkg::*;
import uvmf_base_pkg_hdl::*;



module hdl_top;
// pragma attribute hdl_top partition_module_xrtl                                            


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

bit rst;
   // Instantiate a rst driver
   // tbx clkgen
   initial begin
      rst = 0; 
      #200ns;
      rst =  1; 
   end



// Instantiate the signal bundle, monitor bfm and driver bfm for each interface.
// The signal bundle, _if, contains signals to be connected to the DUT.
// The monitor, monitor_bfm, observes the bus, _if, and captures transactions.
// The driver, driver_bfm, drives transactions onto the bus, _if.

FPU_in_if  FPU_in_agent_bus(.clk(clk), .rst(rst));
FPU_out_if  FPU_out_agent_bus(.clk(clk), .rst(rst), .ready(FPU_in_agent_bus.ready));

FPU_in_monitor_bfm  FPU_in_agent_mon_bfm(FPU_in_agent_bus);
FPU_out_monitor_bfm  FPU_out_agent_mon_bfm(FPU_out_agent_bus);

FPU_in_driver_bfm  FPU_in_agent_drv_bfm(FPU_in_agent_bus);


// UVMF_CHANGE_ME : Add DUT and connect to signals in _bus interfaces listed above
// Instantiate your DUT here
// These DUT's instantiated to show verilog and vhdl instantiation
//verilog_dut         dut_verilog(.clk(clk), .rst(rst), .in_signal(vhdl_to_verilog_signal), .out_signal(verilog_to_vhdl_signal));
//\work.vhdl_dut(rtl) dut_vhdl(   .clk(clk), .rst(rst), .in_signal(verilog_to_vhdl_signal), .out_signal(vhdl_to_verilog_signal));
   fpu fpu_dut(.clk_i(clk),
	       .opa_i(FPU_in_agent_bus.a),
	       .opb_i(FPU_in_agent_bus.b),
	       .fpu_op_i(FPU_in_agent_bus.op),
	       .rmode_i(FPU_in_agent_bus.rmode),
	       .output_o(FPU_in_agent_bus.result),
	       .start_i(FPU_in_agent_bus.start),
	       .ready_o(FPU_in_agent_bus.ready),
	       .ine_o(FPU_out_agent_bus.ine),
	       .overflow_o(FPU_out_agent_bus.overflow),
	       .underflow_o(FPU_out_agent_bus.underflow),
	       .div_zero_o(FPU_out_agent_bus.div_zero),
	       .inf_o(FPU_out_agent_bus.inf),
	       .zero_o(FPU_out_agent_bus.zero),
	       .qnan_o(FPU_out_agent_bus.qnan),
	       .snan_o(FPU_out_agent_bus.snan));

initial begin   // tbx vif_binding_block 
import uvm_pkg::uvm_config_db;

// The monitor_bfm and driver_bfm for each interface is placed into the uvm_config_db.
// They are placed into the uvm_config_db using the string names defined in the parameters package.
// The string names are passed to the agent configurations by test_top through the top level configuration.
// They are retrieved by the agents configuration class for use by the agent.

uvm_config_db #( virtual FPU_in_monitor_bfm  )::set( null , UVMF_VIRTUAL_INTERFACES , FPU_in_agent_BFM , FPU_in_agent_mon_bfm ); 
uvm_config_db #( virtual FPU_out_monitor_bfm  )::set( null , UVMF_VIRTUAL_INTERFACES , FPU_out_agent_BFM , FPU_out_agent_mon_bfm ); 

uvm_config_db #( virtual FPU_in_driver_bfm  )::set( null , UVMF_VIRTUAL_INTERFACES , FPU_in_agent_BFM , FPU_in_agent_drv_bfm  );


  end

endmodule

