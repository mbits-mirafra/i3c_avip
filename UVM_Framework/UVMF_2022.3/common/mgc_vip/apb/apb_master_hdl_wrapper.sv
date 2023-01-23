/*****************************************************************************
 *
 * Copyright 2007-2015 Mentor Graphics Corporation
 * All Rights Reserved.
 *
 * THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE
 * PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO
 * LICENSE TERMS.
 *
 *****************************************************************************/

// This module is a self-contained master module for APB. The user can connect
// this module to an APB bus and use it to stimulate the bus for the master
// side.
//
// Input Parameters:
// SLAVE_COUNT   - Indicates number of slaves.
// ADDR_WIDTH    - Indicates address bus width.
// WDATA_WIDTH   - Indicates write data bus width.
// RDATA_WIDTH   - Indicates read data bus width.
// IF_NAME       - Indicates interface name for which this module
//                 will be instantiated.

// (inline source)
module apb_master_hdl_wrapper # (SLAVE_COUNT      = 1,
                                 ADDR_WIDTH       = 32,
                                 WDATA_WIDTH      = 32,
                                 RDATA_WIDTH      = 32,
                                 string IF_NAME   = "null",
                                 string PATH_NAME ="uvm_test_top",
                                 bit HAS_MON      = 1)
                    (
                     // clock and reset signals
                     input                        PCLK,
                     input                        PRESETn,
                     // Master output signals to be connected 
                     // in all types of interface.
                     output [ADDR_WIDTH-1:0]      PADDR,
                     output [SLAVE_COUNT-1:0]     PSEL,
                     output                       PENABLE,
                     output                       PWRITE,
                     output [WDATA_WIDTH-1:0]     PWDATA,
                     // Master input signals to be connected 
                     // in all types of interface.
                     input [RDATA_WIDTH-1:0]      PRDATA,
                     // Master input signals to be connected 
                     // in case of APB3 or APB4 only.
                     input                        PREADY,
                     input                        PSLVERR,
                     // Master output signals to be connected 
                     // in case of APB4 only. 
                     output [2:0]                 PPROT,
                     output [(WDATA_WIDTH/8)-1:0] PSTRB
                    );

`ifdef USE_VTL

  vtl_apb_master_module #(  SLAVE_COUNT, 
                            ADDR_WIDTH, 
                            WDATA_WIDTH, 
                            RDATA_WIDTH
                            )
  apb3_master
    ( 
      .clk(PCLK),         // Clock input
      .rst_n(PRESETn),     // Active low reset
      .prdata(PRDATA), 
      .psel(PSEL), 
      .penable(PENABLE),   
      .paddr(PADDR), 
      .pwrite(PWRITE),   
      .pwdata(PWDATA),
      .pready(PREADY),
      .pslverr(PSLVERR)    
      );
  //VTL doesn't currently support PPROT and PSTRB signals.  Tying them off
  assign PPROT = '0;
  assign PSTRB = {(WDATA_WIDTH/8){PWRITE}};

  generate
    if (HAS_MON) begin  : monitor_block
    vtl_apb_monitor_module #(ADDR_WIDTH, WDATA_WIDTH, RDATA_WIDTH)
    apb3_monitor
      ( .clk(PCLK),         // Clock input
        .rst_n(PRESETn),     // Active low reset
        .psel( |(PSEL) ), 
        .penable(PENABLE),   
        .paddr(PADDR), 
        .pwrite(PWRITE),   
        .pwdata(PWDATA),
        .prdata(PRDATA), 
        .pready(PREADY),
        .pslverr(PSLVERR) 
      );
  end  : monitor_block
  endgenerate
`else
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  // Instantiation of Master module
  apb_master #(.SLAVE_COUNT(SLAVE_COUNT),
               .ADDR_WIDTH(ADDR_WIDTH),
               .WDATA_WIDTH(WDATA_WIDTH),
               .RDATA_WIDTH(RDATA_WIDTH),
               .IF_NAME(IF_NAME),
               .PATH_NAME(PATH_NAME))
  master(
          .PCLK(PCLK),
          .PRESETn(PRESETn),
          .PADDR(PADDR),
          .PSEL(PSEL),
          .PENABLE(PENABLE),
          .PWRITE(PWRITE),
          .PWDATA(PWDATA),
          .PRDATA(PRDATA),
          .PREADY(PREADY),
          .PSLVERR(PSLVERR),
          .PPROT(PPROT),
          .PSTRB(PSTRB)
        );
`endif

endmodule



