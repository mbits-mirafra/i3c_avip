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

// This module is a self-contained monitor module for APB. The user can connect
// this module to an APB bus and use it to stimulate the bus for the monitor
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
module apb_monitor_hdl_wrapper #( SLAVE_COUNT   = 1,
                     		  ADDR_WIDTH    = 32,
                     		  WDATA_WIDTH   = 32,
                     		  RDATA_WIDTH   = 32,
                     		  string IF_NAME = "null",
                     		  string PATH_NAME ="uvm_test_top")
                    		(
                    		   // clock and reset signals
                    		   input                       PCLK,
                    		   input                       PRESETn,
                    		   input [ADDR_WIDTH-1:0]      PADDR,
                    		   input [SLAVE_COUNT-1:0]     PSEL,
                    		   input                       PENABLE,
                    		   input                       PWRITE,
                    		   input [WDATA_WIDTH-1:0]     PWDATA,
                    		   input [RDATA_WIDTH-1:0]     PRDATA,
                    		   input                       PREADY,
                    		   input                       PSLVERR,
                    		   input [2:0]                 PPROT,
                    		   input [(WDATA_WIDTH/8)-1:0] PSTRB
                    		);

`ifdef USE_VTL
      vtl_apb_monitor_module #(ADDR_WIDTH, WDATA_WIDTH, RDATA_WIDTH)
      apb3_monitor
      ( .clk(PCLK),         // Clock input
        .rst_n(PRESETn),     // Active low reset
        .psel(PSEL), 
        .penable(PENABLE),   
        .paddr(PADDR), 
        .pwrite(PWRITE),   
        .pwdata(PWDATA),
        .prdata(PRDATA), 
        .pready(PREADY),
        .pslverr(PSLVERR) 
      );
`else
  apb_monitor #(.SLAVE_COUNT(SLAVE_COUNT),
               .ADDR_WIDTH(ADDR_WIDTH),
               .WDATA_WIDTH(WDATA_WIDTH),
               .RDATA_WIDTH(RDATA_WIDTH),
               .IF_NAME(IF_NAME),
	       .PATH_NAME(PATH_NAME))
  monitor(
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
          .PPROT(),
          .PSTRB()
        );
`endif

endmodule
