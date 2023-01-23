//----------------------------------------------------------------------
// Created with uvmf_gen version 2020.1
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

import alu_parameters_pkg::*;
import qvip_agents_params_pkg::*;
import uvmf_base_pkg_hdl::*;

module hdl_top;
  // pragma attribute hdl_top partition_module_xrtl                                            
  hdl_qvip_agents 
      #(
        .APB_MASTER_0_ACTIVE(1),
        .UNIQUE_ID("uvm_test_top.environment.qvip_agents_env."),
        .EXT_CLK_RESET(1) 
       ) uvm_test_top_environment_qvip_agents_env_qvip_hdl();

// pragma uvmf custom clock_generator begin
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
// pragma uvmf custom clock_generator end

// pragma uvmf custom reset_generator begin
  bit rst;
  // Instantiate a rst driver
  // tbx clkgen
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
  alu_in_if #(
        .ALU_IN_OP_WIDTH(TEST_ALU_IN_OP_WIDTH)
        ) alu_in_agent_bus(
     // pragma uvmf custom alu_in_agent_bus_connections begin
     .clk(clk), .rst(rst)
     // pragma uvmf custom alu_in_agent_bus_connections end
     );
  alu_out_if #(
        .ALU_OUT_RESULT_WIDTH(TEST_ALU_OUT_RESULT_WIDTH)
        ) alu_out_agent_bus(
     // pragma uvmf custom alu_out_agent_bus_connections begin
     .clk(clk), .rst(rst)
     // pragma uvmf custom alu_out_agent_bus_connections end
     );
  // pragma uvmf custom alu_in_monitor_bus_connections begin
  alu_in_if #(.ALU_IN_OP_WIDTH(TEST_ALU_IN_OP_WIDTH)
             ) alu_in_mon_bus(.clk(clk), .rst(rst));

  assign alu_in_mon_bus.alu_rst = alu_in_agent_bus.alu_rst;
  assign alu_in_mon_bus.ready   = DUT.ready_o;
  assign alu_in_mon_bus.valid   = DUT.valid_i;
  assign alu_in_mon_bus.op      = DUT.op_i;
  assign alu_in_mon_bus.a       = DUT.a_i;
  assign alu_in_mon_bus.b       = DUT.b_i;

  alu_in_monitor_bfm #(
        .ALU_IN_OP_WIDTH(TEST_ALU_IN_OP_WIDTH)
        ) alu_in_agent_mon_bfm(alu_in_mon_bus.monitor_port);
  // pragma uvmf custom alu_in_monitor_bus_connections end
  alu_out_monitor_bfm #(
        .ALU_OUT_RESULT_WIDTH(TEST_ALU_OUT_RESULT_WIDTH)
        ) alu_out_agent_mon_bfm(alu_out_agent_bus.monitor_port);
  alu_in_driver_bfm #(
        .ALU_IN_OP_WIDTH(TEST_ALU_IN_OP_WIDTH)
        ) alu_in_agent_drv_bfm(alu_in_agent_bus.initiator_port);

  // pragma uvmf custom dut_instantiation begin
  // UVMF_CHANGE_ME : Add DUT and connect to signals in _bus interfaces listed above
  assign uvm_test_top_environment_qvip_agents_env_qvip_hdl.default_clk_gen_CLK     = clk;
  assign uvm_test_top_environment_qvip_agents_env_qvip_hdl.default_reset_gen_RESET = rst;

  // Instantiate your DUT here
  alu #(.OP_WIDTH     (TEST_ALU_IN_OP_WIDTH),
        .RESULT_WIDTH (TEST_ALU_OUT_RESULT_WIDTH)
  )
    DUT (.clk     ( alu_in_agent_bus.clk                                                   ),
         .rst     ( alu_in_agent_bus.alu_rst                                               ),
         .ready   ( alu_in_agent_bus.ready                                                 ),
         .valid   ( alu_in_agent_bus.valid                                                 ),
         .op      ( alu_in_agent_bus.op                                                    ),
         .a       ( alu_in_agent_bus.a                                                     ),
         .b       ( alu_in_agent_bus.b                                                     ),
         .done    ( alu_out_agent_bus.done                                                 ),
         .result  ( alu_out_agent_bus.result                                               ),
         .PADDR   ( uvm_test_top_environment_qvip_agents_env_qvip_hdl.apb_master_0_PADDR   ),
         .PSEL    ( uvm_test_top_environment_qvip_agents_env_qvip_hdl.apb_master_0_PSEL    ),
         .PENABLE ( uvm_test_top_environment_qvip_agents_env_qvip_hdl.apb_master_0_PENABLE ),
         .PWRITE  ( uvm_test_top_environment_qvip_agents_env_qvip_hdl.apb_master_0_PWRITE  ),
         .PWDATA  ( uvm_test_top_environment_qvip_agents_env_qvip_hdl.apb_master_0_PWDATA  ),
         .PRDATA  ( uvm_test_top_environment_qvip_agents_env_qvip_hdl.apb_master_0_PRDATA  ),
         .PREADY  ( uvm_test_top_environment_qvip_agents_env_qvip_hdl.apb_master_0_PREADY  ),
         .PSLVERR ( uvm_test_top_environment_qvip_agents_env_qvip_hdl.apb_master_0_PSLVERR ),
         .PPROT   (                                                                    'h0 ),
         .PSTRB   (                                                                    'hf )
  );
    // pragma uvmf custom dut_instantiation end

  initial begin      // tbx vif_binding_block 
    import uvm_pkg::uvm_config_db;
    // The monitor_bfm and driver_bfm for each interface is placed into the uvm_config_db.
    // They are placed into the uvm_config_db using the string names defined in the parameters package.
    // The string names are passed to the agent configurations by test_top through the top level configuration.
    // They are retrieved by the agents configuration class for use by the agent.
    uvm_config_db #( virtual alu_in_monitor_bfm #(
        .ALU_IN_OP_WIDTH(TEST_ALU_IN_OP_WIDTH)
        ) )::set( null , UVMF_VIRTUAL_INTERFACES , alu_in_agent_BFM , alu_in_agent_mon_bfm ); 
    uvm_config_db #( virtual alu_out_monitor_bfm #(
        .ALU_OUT_RESULT_WIDTH(TEST_ALU_OUT_RESULT_WIDTH)
        ) )::set( null , UVMF_VIRTUAL_INTERFACES , alu_out_agent_BFM , alu_out_agent_mon_bfm ); 
    uvm_config_db #( virtual alu_in_driver_bfm #(
        .ALU_IN_OP_WIDTH(TEST_ALU_IN_OP_WIDTH)
        ) )::set( null , UVMF_VIRTUAL_INTERFACES , alu_in_agent_BFM , alu_in_agent_drv_bfm  );
  end

endmodule
