//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_5
//----------------------------------------------------------------------
// Created by: Vijay Gill
// E-mail:     vijay_gill@mentor.com
// Date:       2019/11/05
// pragma uvmf custom header begin
// Created by      : vgill
// Creation Date   : 2019 Aug 05
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

import axi4_2x2_fabric_parameters_pkg::*;
import axi4_2x2_fabric_qvip_params_pkg::*;
import uvmf_base_pkg_hdl::*;

module hdl_top;
  // pragma attribute hdl_top partition_module_xrtl                                            
  hdl_axi4_2x2_fabric_qvip 
      #(
        .MGC_AXI4_M0_ACTIVE(1),
        .MGC_AXI4_M1_ACTIVE(1),
        .MGC_AXI4_S0_ACTIVE(1),
        .MGC_AXI4_S1_ACTIVE(1),
        .UNIQUE_ID("uvm_test_top.environment.axi4_qvip_subenv.")
        /*.EXT_CLK_RESET(0)*/ 
       ) uvm_test_top_environment_axi4_qvip_subenv_qvip_hdl();

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

  // pragma uvmf custom dut_instantiation begin
  // Add DUT and connect to signals in _bus interfaces listed above

  `define HDL_QVIP_SUBENV uvm_test_top_environment_axi4_qvip_subenv_qvip_hdl

  // tying off (unused) AXI4 USER signals
  assign `HDL_QVIP_SUBENV.mgc_axi4_s0_ARUSER = 'b0;
  assign `HDL_QVIP_SUBENV.mgc_axi4_s1_ARUSER = 'b0;
  assign `HDL_QVIP_SUBENV.mgc_axi4_s0_AWUSER = 'b0;
  assign `HDL_QVIP_SUBENV.mgc_axi4_s1_AWUSER = 'b0;
  assign `HDL_QVIP_SUBENV.mgc_axi4_m0_BUSER  = 'b0;
  assign `HDL_QVIP_SUBENV.mgc_axi4_m1_BUSER  = 'b0;
  assign `HDL_QVIP_SUBENV.mgc_axi4_m0_RUSER  = 'b0;
  assign `HDL_QVIP_SUBENV.mgc_axi4_m1_RUSER  = 'b0;
  assign `HDL_QVIP_SUBENV.mgc_axi4_s0_WUSER  = 'b0;
  assign `HDL_QVIP_SUBENV.mgc_axi4_s1_WUSER  = 'b0;

  // DUT connections parameters and wiring
  parameter int N_MASTERS           = 2;
  parameter int N_SLAVES            = 2;
  parameter int N_MASTERID_BITS     = 1;
  parameter int AXI4_ADDRESS_WIDTH  = mgc_axi4_m0_params::AXI4_ADDRESS_WIDTH;
  parameter int AXI4_DATA_WIDTH     = mgc_axi4_m0_params::AXI4_RDATA_WIDTH; 
  parameter int AXI4_INIT_ID_WIDTH  = mgc_axi4_m0_params::AXI4_ID_WIDTH;
  parameter int AXI4_TARG_ID_WIDTH  = mgc_axi4_s0_params::AXI4_ID_WIDTH;
  parameter bit[AXI4_ADDRESS_WIDTH-1:0]     SLAVE0_ADDR_BASE  = 'h0000_0000;
  parameter bit[AXI4_ADDRESS_WIDTH-1:0]     SLAVE0_ADDR_LIMIT = 'h7FFF_FFFF;
  parameter bit[AXI4_ADDRESS_WIDTH-1:0]     SLAVE1_ADDR_BASE  = 'h8000_0000;
  parameter bit[AXI4_ADDRESS_WIDTH-1:0]     SLAVE1_ADDR_LIMIT = 'hFFFF_FFFF;

  wire                            ACLK;
  wire                            ARESETn;

  // DUT wiring for Master interfaces
  wire[AXI4_ADDRESS_WIDTH-1:0]    AWADDR[N_MASTERS-1:0]   = {`HDL_QVIP_SUBENV.mgc_axi4_m1_AWADDR,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_m0_AWADDR};
  wire[AXI4_INIT_ID_WIDTH-1:0]    AWID[N_MASTERS-1:0]     = {`HDL_QVIP_SUBENV.mgc_axi4_m1_AWID,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_m0_AWID};
  wire[7:0]                       AWLEN[N_MASTERS-1:0]    = {`HDL_QVIP_SUBENV.mgc_axi4_m1_AWLEN,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_m0_AWLEN};
  wire[2:0]                       AWSIZE[N_MASTERS-1:0]   = {`HDL_QVIP_SUBENV.mgc_axi4_m1_AWSIZE,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_m0_AWSIZE};
  wire[1:0]                       AWBURST[N_MASTERS-1:0]  = {`HDL_QVIP_SUBENV.mgc_axi4_m1_AWBURST,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_m0_AWBURST};
  wire                            AWLOCK[N_MASTERS-1:0]   = {`HDL_QVIP_SUBENV.mgc_axi4_m1_AWLOCK,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_m0_AWLOCK}; 
  wire[3:0]                       AWCACHE[N_MASTERS-1:0]  = {`HDL_QVIP_SUBENV.mgc_axi4_m1_AWCACHE,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_m0_AWCACHE};
  wire[2:0]                       AWPROT[N_MASTERS-1:0]   = {`HDL_QVIP_SUBENV.mgc_axi4_m1_AWPROT,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_m0_AWPROT};
  wire[3:0]                       AWQOS[N_MASTERS-1:0]    = {`HDL_QVIP_SUBENV.mgc_axi4_m1_AWQOS,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_m0_AWQOS};
  wire[3:0]                       AWREGION[N_MASTERS-1:0] = {`HDL_QVIP_SUBENV.mgc_axi4_m1_AWREGION,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_m0_AWREGION};
  wire                            AWREADY[N_MASTERS-1:0];
  wire                            AWVALID[N_MASTERS-1:0]  = {`HDL_QVIP_SUBENV.mgc_axi4_m1_AWVALID,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_m0_AWVALID};
  wire[AXI4_ADDRESS_WIDTH-1:0]    ARADDR[N_MASTERS-1:0]   = {`HDL_QVIP_SUBENV.mgc_axi4_m1_ARADDR,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_m0_ARADDR};
  wire[AXI4_INIT_ID_WIDTH-1:0]    ARID[N_MASTERS-1:0]     = {`HDL_QVIP_SUBENV.mgc_axi4_m1_ARID,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_m0_ARID};
  wire[7:0]                       ARLEN[N_MASTERS-1:0]    = {`HDL_QVIP_SUBENV.mgc_axi4_m1_ARLEN,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_m0_ARLEN};
  wire[2:0]                       ARSIZE[N_MASTERS-1:0]   = {`HDL_QVIP_SUBENV.mgc_axi4_m1_ARSIZE,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_m0_ARSIZE};
  wire[1:0]                       ARBURST[N_MASTERS-1:0]  = {`HDL_QVIP_SUBENV.mgc_axi4_m1_ARBURST,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_m0_ARBURST};
  wire                            ARLOCK[N_MASTERS-1:0]   = {`HDL_QVIP_SUBENV.mgc_axi4_m1_ARLOCK,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_m0_ARLOCK};
  wire[3:0]                       ARCACHE[N_MASTERS-1:0]  = {`HDL_QVIP_SUBENV.mgc_axi4_m1_ARCACHE,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_m0_ARCACHE};
  wire[2:0]                       ARPROT[N_MASTERS-1:0]   = {`HDL_QVIP_SUBENV.mgc_axi4_m1_ARPROT,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_m0_ARPROT};
  wire[3:0]                       ARQOS[N_MASTERS-1:0]    = {`HDL_QVIP_SUBENV.mgc_axi4_m1_ARQOS,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_m0_ARQOS};
  wire[3:0]                       ARREGION[N_MASTERS-1:0] = {`HDL_QVIP_SUBENV.mgc_axi4_m1_ARREGION,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_m0_ARREGION};
  wire                            ARREADY[N_MASTERS-1:0];
  wire                            ARVALID[N_MASTERS-1:0]  = {`HDL_QVIP_SUBENV.mgc_axi4_m1_ARVALID,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_m0_ARVALID};
  wire[AXI4_INIT_ID_WIDTH-1:0]    BID[N_MASTERS-1:0];
  wire[1:0]                       BRESP[N_MASTERS-1:0];
  wire                            BVALID[N_MASTERS-1:0];
  wire                            BREADY[N_MASTERS-1:0]   = {`HDL_QVIP_SUBENV.mgc_axi4_m1_BREADY,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_m0_BREADY};
  wire[AXI4_INIT_ID_WIDTH-1:0]    RID[N_MASTERS-1:0];
  wire[AXI4_DATA_WIDTH-1:0]       RDATA[N_MASTERS-1:0];  
  wire[1:0]                       RRESP[N_MASTERS-1:0];
  wire                            RLAST[N_MASTERS-1:0];
  wire                            RVALID[N_MASTERS-1:0];
  wire                            RREADY[N_MASTERS-1:0]   = {`HDL_QVIP_SUBENV.mgc_axi4_m1_RREADY,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_m0_RREADY};
  wire[(AXI4_DATA_WIDTH-1):0]     WDATA[N_MASTERS-1:0]    = {`HDL_QVIP_SUBENV.mgc_axi4_m1_WDATA,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_m0_WDATA};
  wire[((AXI4_DATA_WIDTH/8)-1):0] WSTRB[N_MASTERS-1:0]    = {`HDL_QVIP_SUBENV.mgc_axi4_m1_WSTRB,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_m0_WSTRB};
  wire                            WLAST[N_MASTERS-1:0]    = {`HDL_QVIP_SUBENV.mgc_axi4_m1_WLAST,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_m0_WLAST};
  wire                            WVALID[N_MASTERS-1:0]   = {`HDL_QVIP_SUBENV.mgc_axi4_m1_WVALID,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_m0_WVALID};
  wire                            WREADY[N_MASTERS-1:0];

  assign ACLK    = `HDL_QVIP_SUBENV.default_clk_gen_CLK;
  assign ARESETn = `HDL_QVIP_SUBENV.default_reset_gen_RESET;
  assign `HDL_QVIP_SUBENV.mgc_axi4_m0_AWREADY = AWREADY[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_m1_AWREADY = AWREADY[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_m0_ARREADY = ARREADY[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_m1_ARREADY = ARREADY[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_m0_BID     = BID[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_m1_BID     = BID[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_m0_BRESP   = BRESP[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_m1_BRESP   = BRESP[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_m0_BVALID  = BVALID[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_m1_BVALID  = BVALID[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_m0_RID     = RID[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_m1_RID     = RID[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_m0_RDATA   = RDATA[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_m1_RDATA   = RDATA[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_m0_RRESP   = RRESP[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_m1_RRESP   = RRESP[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_m0_RLAST   = RLAST[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_m1_RLAST   = RLAST[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_m0_RVALID  = RVALID[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_m1_RVALID  = RVALID[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_m0_WREADY  = WREADY[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_m1_WREADY  = WREADY[1];

  // DUT wiring for Slave interface
  wire[AXI4_ADDRESS_WIDTH-1:0]    SAWADDR[N_SLAVES:0];
  wire[AXI4_TARG_ID_WIDTH-1:0]    SAWID[N_SLAVES:0];
  wire[7:0]                       SAWLEN[N_SLAVES:0];
  wire[2:0]                       SAWSIZE[N_SLAVES:0];
  wire[1:0]                       SAWBURST[N_SLAVES:0];
  wire                            SAWLOCK[N_SLAVES:0];
  wire[3:0]                       SAWCACHE[N_SLAVES:0];
  wire[2:0]                       SAWPROT[N_SLAVES:0];
  wire[3:0]                       SAWQOS[N_SLAVES:0];
  wire[3:0]                       SAWREGION[N_SLAVES:0];
  wire                            SAWREADY[N_SLAVES:0]    = {1'b0,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_s1_AWREADY,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_s0_AWREADY};
  wire                            SAWVALID[N_SLAVES:0];
  wire[AXI4_TARG_ID_WIDTH-1:0]    SWID[N_SLAVES:0];
  wire[(AXI4_DATA_WIDTH-1):0]     SWDATA[N_SLAVES:0];
  wire[((AXI4_DATA_WIDTH/8)-1):0] SWSTRB[N_SLAVES:0];
  wire                            SWLAST[N_SLAVES:0];
  wire                            SWVALID[N_SLAVES:0];
  wire                            SWREADY[N_SLAVES:0]     = {1'b0, 
                                                             `HDL_QVIP_SUBENV.mgc_axi4_s1_WREADY,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_s0_WREADY};
  wire[AXI4_TARG_ID_WIDTH-1:0]    SBID[N_SLAVES:0]        = {0,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_s1_BID,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_s0_BID};
  wire[1:0]                       SBRESP[N_SLAVES:0]      = {0,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_s1_BRESP,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_s0_BRESP};
  wire                            SBVALID[N_SLAVES:0]     = {0,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_s1_BVALID,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_s0_BVALID};
  wire                            SBREADY[N_SLAVES:0];
  wire[AXI4_ADDRESS_WIDTH-1:0]    SARADDR[N_SLAVES:0];
  wire[AXI4_TARG_ID_WIDTH-1:0]    SARID[N_SLAVES:0];
  wire[7:0]                       SARLEN[N_SLAVES:0];
  wire[2:0]                       SARSIZE[N_SLAVES:0];
  wire[1:0]                       SARBURST[N_SLAVES:0];
  wire                            SARLOCK[N_SLAVES:0];
  wire[3:0]                       SARCACHE[N_SLAVES:0];
  wire[2:0]                       SARPROT[N_SLAVES:0];
  wire[3:0]                       SARQOS[N_SLAVES:0];
  wire[3:0]                       SARREGION[N_SLAVES:0];
  wire                            SARREADY[N_SLAVES:0]    = {0, 
                                                             `HDL_QVIP_SUBENV.mgc_axi4_s1_ARREADY,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_s0_ARREADY};
  wire                            SARVALID[N_SLAVES:0];
  wire[AXI4_TARG_ID_WIDTH-1:0]    SRID[N_SLAVES:0]        = {0, 
                                                             `HDL_QVIP_SUBENV.mgc_axi4_s1_RID,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_s0_RID};
  wire[AXI4_DATA_WIDTH-1:0]       SRDATA[N_SLAVES:0]      = {0,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_s1_RDATA,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_s0_RDATA};
  wire[1:0]                       SRRESP[N_SLAVES:0]      = {0,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_s1_RRESP,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_s0_RRESP};
  wire                            SRLAST[N_SLAVES:0]      = {0,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_s1_RLAST,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_s0_RLAST};
  wire                            SRVALID[N_SLAVES:0]     = {0,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_s1_RVALID,
                                                             `HDL_QVIP_SUBENV.mgc_axi4_s0_RVALID};
  wire                            SRREADY[N_SLAVES:0];

  assign `HDL_QVIP_SUBENV.mgc_axi4_s0_AWADDR   = SAWADDR[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s1_AWADDR   = SAWADDR[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s0_AWID     = SAWID[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s1_AWID     = SAWID[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s0_AWLEN    = SAWLEN[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s1_AWLEN    = SAWLEN[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s0_AWSIZE   = SAWSIZE[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s1_AWSIZE   = SAWSIZE[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s0_AWBURST  = SAWBURST[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s1_AWBURST  = SAWBURST[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s0_AWLOCK   = SAWLOCK[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s1_AWLOCK   = SAWLOCK[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s0_AWCACHE  = SAWCACHE[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s1_AWCACHE  = SAWCACHE[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s0_AWPROT   = SAWPROT[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s1_AWPROT   = SAWPROT[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s0_AWQOS    = SAWQOS[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s1_AWQOS    = SAWQOS[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s0_AWREGION = SAWREGION[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s1_AWREGION = SAWREGION[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s0_AWVALID  = SAWVALID[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s1_AWVALID  = SAWVALID[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s0_WDATA    = SWDATA[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s1_WDATA    = SWDATA[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s0_WSTRB    = SWSTRB[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s1_WSTRB    = SWSTRB[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s0_WLAST    = SWLAST[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s1_WLAST    = SWLAST[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s0_WVALID   = SWVALID[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s1_WVALID   = SWVALID[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s0_BREADY   = SBREADY[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s1_BREADY   = SBREADY[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s0_ARADDR   = SARADDR[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s1_ARADDR   = SARADDR[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s0_ARID     = SARID[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s1_ARID     = SARID[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s0_ARLEN    = SARLEN[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s1_ARLEN    = SARLEN[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s0_ARSIZE   = SARSIZE[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s1_ARSIZE   = SARSIZE[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s0_ARBURST  = SARBURST[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s1_ARBURST  = SARBURST[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s0_ARLOCK   = SARLOCK[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s1_ARLOCK   = SARLOCK[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s0_ARCACHE  = SARCACHE[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s1_ARCACHE  = SARCACHE[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s0_ARPROT   = SARPROT[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s1_ARPROT   = SARPROT[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s0_ARQOS    = SARQOS[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s1_ARQOS    = SARQOS[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s0_ARREGION = SARREGION[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s1_ARREGION = SARREGION[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s0_ARVALID  = SARVALID[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s1_ARVALID  = SARVALID[1];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s0_RREADY   = SRREADY[0];
  assign `HDL_QVIP_SUBENV.mgc_axi4_s1_RREADY   = SRREADY[1];

  axi4_interconnect_NxN #(
      .AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ),
      .AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH    ),
      .AXI4_ID_WIDTH       (AXI4_INIT_ID_WIDTH ),
      .N_MASTERS           (N_MASTERS          ),
      .N_SLAVES            (N_SLAVES           ),
      .ADDR_RANGES         ({SLAVE0_ADDR_BASE, SLAVE0_ADDR_LIMIT,
                             SLAVE1_ADDR_BASE, SLAVE1_ADDR_LIMIT})
      ) axi4_2x2_fabric (
      .clk                 (ACLK               ),
      .rstn                (ARESETn            ),
      .AWADDR              (AWADDR             ),
      .AWID                (AWID               ),
      .AWLEN               (AWLEN              ),
      .AWSIZE              (AWSIZE             ),
      .AWBURST             (AWBURST            ),
      .AWLOCK              (AWLOCK             ),
      .AWCACHE             (AWCACHE            ),
      .AWPROT              (AWPROT             ),
      .AWQOS               (AWQOS              ),
      .AWREGION            (AWREGION           ),
      .AWREADY             (AWREADY            ),
      .AWVALID             (AWVALID            ),
      .ARADDR              (ARADDR             ),
      .ARID                (ARID               ),
      .ARLEN               (ARLEN              ),
      .ARSIZE              (ARSIZE             ),
      .ARBURST             (ARBURST            ),
      .ARLOCK              (ARLOCK             ),
      .ARCACHE             (ARCACHE            ),
      .ARPROT              (ARPROT             ),
      .ARQOS               (ARQOS              ),
      .ARREGION            (ARREGION           ),
      .ARREADY             (ARREADY            ),
      .ARVALID             (ARVALID            ),
      .BID                 (BID                ),
      .BRESP               (BRESP              ),
      .BVALID              (BVALID             ),
      .BREADY              (BREADY             ),
      .RID                 (RID                ),
      .RDATA               (RDATA              ),
      .RRESP               (RRESP              ),
      .RLAST               (RLAST              ),
      .RVALID              (RVALID             ),
      .RREADY              (RREADY             ),
      .WDATA               (WDATA              ),
      .WSTRB               (WSTRB              ),
      .WLAST               (WLAST              ),
      .WVALID              (WVALID             ),
      .WREADY              (WREADY             ),
      .SAWADDR             (SAWADDR            ),
      .SAWID               (SAWID              ),
      .SAWLEN              (SAWLEN             ),
      .SAWSIZE             (SAWSIZE            ),
      .SAWBURST            (SAWBURST           ),
      .SAWLOCK             (SAWLOCK            ),
      .SAWCACHE            (SAWCACHE           ),
      .SAWPROT             (SAWPROT            ),
      .SAWQOS              (SAWQOS             ),
      .SAWREGION           (SAWREGION          ),
      .SAWREADY            (SAWREADY           ),
      .SAWVALID            (SAWVALID           ),
      .SWDATA              (SWDATA             ),
      .SWSTRB              (SWSTRB             ),
      .SWLAST              (SWLAST             ),
      .SWVALID             (SWVALID            ),
      .SWREADY             (SWREADY            ),
      .SBID                (SBID               ),
      .SBRESP              (SBRESP             ),
      .SBVALID             (SBVALID            ),
      .SBREADY             (SBREADY            ),
      .SARADDR             (SARADDR            ),
      .SARID               (SARID              ),
      .SARLEN              (SARLEN             ),
      .SARSIZE             (SARSIZE            ),
      .SARBURST            (SARBURST           ),
      .SARLOCK             (SARLOCK            ),
      .SARCACHE            (SARCACHE           ),
      .SARPROT             (SARPROT            ),
      .SARQOS              (SARQOS             ),
      .SARREGION           (SARREGION          ),
      .SARREADY            (SARREADY           ),
      .SARVALID            (SARVALID           ),
      .SRID                (SRID               ),
      .SRDATA              (SRDATA             ),
      .SRRESP              (SRRESP             ),
      .SRLAST              (SRLAST             ),
      .SRVALID             (SRVALID            ),
      .SRREADY             (SRREADY            ));

  // pragma uvmf custom dut_instantiation end

  initial begin      // tbx vif_binding_block 
    import uvm_pkg::uvm_config_db;
    // The monitor_bfm and driver_bfm for each interface is placed into the uvm_config_db.
    // They are placed into the uvm_config_db using the string names defined in the parameters package.
    // The string names are passed to the agent configurations by test_top through the top level configuration.
    // They are retrieved by the agents configuration class for use by the agent.
  end

endmodule
