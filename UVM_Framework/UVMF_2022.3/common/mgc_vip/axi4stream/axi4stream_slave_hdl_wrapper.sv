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

// This module is a self-contained slave module for AXI4STREAM. The user can connect
// this module to an AXI4STREAM bus and use it to stimulate the bus for the slave
// side.
//
// IF_NAME       - Indicates interface name for which this module
//                 will be instantiated.

// (inline source)
module axi4stream_slave_hdl_wrapper # (int    AXI4_ID_WIDTH = 8,
                                       int    AXI4_USER_WIDTH = 4,
                                       int    AXI4_DEST_WIDTH = 4,
                                       int    AXI4_DATA_WIDTH = 32,
                                       int    AXI4_DELAY_WIDTH = 8,
                                       string IF_NAME ="null",
                                       string PATH_NAME ="uvm_test_top",
                                        bit    HAS_MON = 1)
                                       (
                                       input                                     ACLK,
                                       input                                     ARESETn,
                                       input                                    TVALID,
                                       input  [((AXI4_DATA_WIDTH) - 1):0]       TDATA,
                                       input  [(((AXI4_DATA_WIDTH / 8)) - 1):0] TSTRB,
                                       input  [(((AXI4_DATA_WIDTH / 8)) - 1):0] TKEEP,
                                       input                                    TLAST,
                                       input  [((AXI4_ID_WIDTH) - 1):0]         TID,
                                       input  [((AXI4_USER_WIDTH) - 1):0]       TUSER,
                                       input  [((AXI4_DEST_WIDTH) - 1):0]       TDEST,
                                       output                                     TREADY
                                       );

`ifdef USE_VTL
       vtl_axi4stream_xrtl_slave #(
                                    AXI4_DATA_WIDTH,
                                    AXI4_ID_WIDTH,
                                    AXI4_DEST_WIDTH,
                                    AXI4_DELAY_WIDTH,
                                    AXI4_USER_WIDTH     
                                    ) slave (
                                    .ACLK(ACLK),                                
                                    .ARESETn(ARESETn),
                                    .TREADY(TREADY),
                                    .TVALID(TVALID),
                                    .TDATA(TDATA),
                                    .TSTRB(TSTRB),
                                    .TKEEP(TKEEP),
                                    .TID(TID),
                                    .TDEST(TDEST),
                                    .TUSER(TUSER),
                                    .TLAST(TLAST) 
                                    );
  generate
    if (HAS_MON) begin  : monitor_block
      vtl_axi4stream_xrtl_monitor #(
                                    AXI4_DATA_WIDTH,
                                    AXI4_ID_WIDTH,
                                    AXI4_DEST_WIDTH,
                                    AXI4_DELAY_WIDTH,
                                    AXI4_USER_WIDTH     
                                    ) monitor (
                                    .ACLK(ACLK),                                
                                    .ARESETn(ARESETn),
                                    .TREADY(TREADY),
                                    .TVALID(TVALID),
                                    .TDATA(TDATA),
                                    .TSTRB(TSTRB),
                                    .TKEEP(TKEEP),
                                    .TID(TID),
                                    .TDEST(TDEST),
                                    .TUSER(TUSER),
                                    .TLAST(TLAST) 
                                    );
  end  : monitor_block
  endgenerate
`else
  axi4stream_slave #(.AXI4_ID_WIDTH(AXI4_ID_WIDTH),
                     .AXI4_USER_WIDTH(AXI4_USER_WIDTH),
                     .AXI4_DEST_WIDTH(AXI4_DEST_WIDTH),
                     .AXI4_DATA_WIDTH(AXI4_DATA_WIDTH),
                     .IF_NAME(IF_NAME),
                     .PATH_NAME(PATH_NAME))
  slave ( .ACLK    (ACLK),
          .ARESETn (ARESETn),
          .TVALID  (TVALID),
          .TDATA   (TDATA),
          .TSTRB   (TSTRB),
          .TKEEP   (TKEEP),
          .TLAST   (TLAST),
          .TID     (TID),
          .TUSER   (TUSER),
          .TDEST   (TDEST),
          .TREADY  (TREADY));
`endif

endmodule



