//----------------------------------------------------------------------
// Created with uvmf_gen version 2021.1
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

import scatter_gather_dma_parameters_pkg::*;
import scatter_gather_dma_qvip_params_pkg::*;
import uvmf_base_pkg_hdl::*;

  // pragma attribute hdl_top partition_module_xrtl                                            
  hdl_scatter_gather_dma_qvip 
      #(
        .MGC_AXI4_M0_ACTIVE(1),
        .MGC_AXI4_S0_ACTIVE(1),
        .UNIQUE_ID("uvm_test_top.environment.scatter_gather_dma_qvip_subenv.")
        /*.EXT_CLK_RESET(0)*/ 
       ) uvm_test_top_environment_scatter_gather_dma_qvip_subenv_qvip_hdl();

// pragma uvmf custom clock_generator begin
       bit clk;
       // Instantiate a clk driver
       // tbx clkgen
       initial begin
         clk = 0;
         forever begin
           #5ns;
           clk = ~clk;
         end
       end
// pragma uvmf custom clock_generator end

// pragma uvmf custom reset_generator begin
       bit rst;
       // Instantiate a rst driver
       // tbx clkgen
       initial begin
         rst = 1;
         #1ns;
         rst = 0;
         #30ns;
         rst =  1;
       end
// pragma uvmf custom reset_generator end

  // pragma uvmf custom module_item_additional begin
  // pragma uvmf custom module_item_additional end

  // Instantiate the signal bundle, monitor bfm and driver bfm for each interface.
  // The signal bundle, _if, contains signals to be connected to the DUT.
  // The monitor, monitor_bfm, observes the bus, _if, and captures transactions.
  // The driver, driver_bfm, drives transactions onto the bus, _if.
  ccs_if #(
        .WIDTH(1)
        ) dma_done_rsc_bus(
     // pragma uvmf custom dma_done_rsc_bus_connections begin
     .clk(clk), .rst(rst)
     // pragma uvmf custom dma_done_rsc_bus_connections end
     );
  ccs_monitor_bfm #(
        .WIDTH(1)
        ) dma_done_rsc_mon_bfm(dma_done_rsc_bus.monitor_port);
  ccs_driver_bfm #(
        .WIDTH(1)
        ) dma_done_rsc_drv_bfm(dma_done_rsc_bus.responder_port);

  // pragma uvmf custom dut_instantiation begin
// UVMF_CHANGE_ME : Add DUT and connect to signals in _bus interfaces listed above
// Instantiate your DUT here
// These DUT's instantiated to show verilog and vhdl instantiation
// verilog_dut         dut_verilog(.clk(clk), .rst(rst), .in_signal(vhdl_to_verilog_signal), .out_signal(verilog_to_vhdl_signal));
// \work.vhdl_dut(rtl) dut_vhdl(   .clk(clk), .rst(rst), .in_signal(verilog_to_vhdl_signal), .out_signal(vhdl_to_verilog_signal));
// use ifdef to conditionally determine which DUT to include
`define QVIP_HDL uvm_test_top_environment_scatter_gather_dma_qvip_subenv_qvip_hdl
`ifdef SCATTER_GATHER_DMA_SYSC
     scatter_gather_dma_wrap scatter_gather_dma_wrap_INST (
`else
     scatter_gather_dma scatter_gather_dma_rtl_INST (
`endif
          .clk(clk)
        , .rst_bar(rst)
        , .dma_done_dat(dma_done_rsc_bus.dat)
        , .dma_done_vld(dma_done_rsc_bus.vld)
        , .dma_done_rdy(dma_done_rsc_bus.rdy)
        , .r_master0_ar_dat( { `QVIP_HDL.mgc_axi4_s0_ARLEN, `QVIP_HDL.mgc_axi4_s0_ARADDR, `QVIP_HDL.mgc_axi4_s0_ARID } )
        , .r_master0_ar_vld(`QVIP_HDL.mgc_axi4_s0_ARVALID)
        , .r_master0_ar_rdy(`QVIP_HDL.mgc_axi4_s0_ARREADY)
        , .r_master0_r_dat( { `QVIP_HDL.mgc_axi4_s0_RLAST, `QVIP_HDL.mgc_axi4_s0_RRESP, `QVIP_HDL.mgc_axi4_s0_RDATA, `QVIP_HDL.mgc_axi4_s0_RID } )
        , .r_master0_r_vld(`QVIP_HDL.mgc_axi4_s0_RVALID)
        , .r_master0_r_rdy(`QVIP_HDL.mgc_axi4_s0_RREADY)
        , .w_master0_aw_dat( { `QVIP_HDL.mgc_axi4_s0_AWLEN, `QVIP_HDL.mgc_axi4_s0_AWADDR, `QVIP_HDL.mgc_axi4_s0_AWID } )
        , .w_master0_aw_vld(`QVIP_HDL.mgc_axi4_s0_AWVALID)
        , .w_master0_aw_rdy(`QVIP_HDL.mgc_axi4_s0_AWREADY)
        , .w_master0_w_dat( { `QVIP_HDL.mgc_axi4_s0_WSTRB, `QVIP_HDL.mgc_axi4_s0_WLAST, `QVIP_HDL.mgc_axi4_s0_WDATA } )
        , .w_master0_w_vld(`QVIP_HDL.mgc_axi4_s0_WVALID)
        , .w_master0_w_rdy(`QVIP_HDL.mgc_axi4_s0_WREADY)
        , .w_master0_b_dat( { `QVIP_HDL.mgc_axi4_s0_BRESP, `QVIP_HDL.mgc_axi4_s0_BID } )
        , .w_master0_b_vld(`QVIP_HDL.mgc_axi4_s0_BVALID)
        , .w_master0_b_rdy(`QVIP_HDL.mgc_axi4_s0_BREADY)
        , .r_slave0_ar_dat(`QVIP_HDL.mgc_axi4_m0_ARADDR)
        , .r_slave0_ar_vld(`QVIP_HDL.mgc_axi4_m0_ARVALID)
        , .r_slave0_ar_rdy(`QVIP_HDL.mgc_axi4_m0_ARREADY)
        , .r_slave0_r_dat( { `QVIP_HDL.mgc_axi4_m0_RRESP, `QVIP_HDL.mgc_axi4_m0_RDATA } )
        , .r_slave0_r_vld(`QVIP_HDL.mgc_axi4_m0_RVALID)
        , .r_slave0_r_rdy(`QVIP_HDL.mgc_axi4_m0_RREADY)
        , .w_slave0_aw_dat(`QVIP_HDL.mgc_axi4_m0_AWADDR)
        , .w_slave0_aw_vld(`QVIP_HDL.mgc_axi4_m0_AWVALID)
        , .w_slave0_aw_rdy(`QVIP_HDL.mgc_axi4_m0_AWREADY)
        , .w_slave0_w_dat(`QVIP_HDL.mgc_axi4_m0_WDATA)
        , .w_slave0_w_vld(`QVIP_HDL.mgc_axi4_m0_WVALID)
        , .w_slave0_w_rdy(`QVIP_HDL.mgc_axi4_m0_WREADY)
        , .w_slave0_b_dat(`QVIP_HDL.mgc_axi4_m0_BRESP)
        , .w_slave0_b_vld(`QVIP_HDL.mgc_axi4_m0_BVALID)
        , .w_slave0_b_rdy(`QVIP_HDL.mgc_axi4_m0_BREADY)
        );
  // pragma uvmf custom dut_instantiation end

  initial begin      // tbx vif_binding_block 
    import uvm_pkg::uvm_config_db;
    // The monitor_bfm and driver_bfm for each interface is placed into the uvm_config_db.
    // They are placed into the uvm_config_db using the string names defined in the parameters package.
    // The string names are passed to the agent configurations by test_top through the top level configuration.
    // They are retrieved by the agents configuration class for use by the agent.
    uvm_config_db #( virtual ccs_monitor_bfm #(
        .WIDTH(1)
        ) )::set( null , UVMF_VIRTUAL_INTERFACES , dma_done_rsc_BFM , dma_done_rsc_mon_bfm ); 
    uvm_config_db #( virtual ccs_driver_bfm #(
        .WIDTH(1)
        ) )::set( null , UVMF_VIRTUAL_INTERFACES , dma_done_rsc_BFM , dma_done_rsc_drv_bfm  );
  end

endmodule
