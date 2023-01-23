// *****************************************************************************
//
// Copyright 2007-2015 Mentor Graphics Corporation
// All Rights Reserved.
//
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
// MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
//
// *****************************************************************************
// SystemVerilog           Version: 20150219
// *****************************************************************************

//-------------------------------------------------------------------------
//
// Section: mgc_axi4
//
//-------------------------------------------------------------------------
interface mgc_axi4_signal_if #(int ADDR_WIDTH = 64, int RDATA_WIDTH = 32, int WDATA_WIDTH = 32, int ID_WIDTH = 30, int USER_WIDTH = 4, int REGION_MAP_SIZE = 16)
    (input wire iACLK, input wire iARESETn);

    //-------------------------------------------------------------------------
    //
    // Group: AXI4 Signals
    //
    //-------------------------------------------------------------------------



    //------------------------------------------------------------------------------
    // 
    // Wires: Clock & Reset
    // 
    //------------------------------------------------------------------------------
    // ACLK     - The clock signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.1)
    // ARESETn  - The reset signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.1)
    // (begin inline source)
    wire ACLK;
    wire ARESETn;
    // (end inline source)



    //------------------------------------------------------------------------------
    // 
    // Wires: Write Address Channel Signals
    // 
    //------------------------------------------------------------------------------
    // AWVALID  - The address-channel valid signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.2, A3.2 and A3.3)
    // AWADDR   - The write address signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.2)
    // AWPROT   - The write-channel protection type. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.2)
    // AWREGION - The write-channel region signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.2)
    // AWLEN    - The write-channel burst-length signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.2)
    // AWSIZE   - The write-channel burst size signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.2)
    // AWBURST  - The write-channel burst type signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.2.)
    // AWLOCK   - The write-channel lock type. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.2)
    // AWCACHE  - The write-channel cache type signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.2)
    // AWQOS    - The write-channel Quality-of-Service signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.2)
    // AWID     - The write-channel master ID signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.2)
    // AWUSER   - User-defined write-channel signals. (see AMBA AXI and ACE Protocol Specification IHI0022D section A8.3)
    // AWREADY  - The write-channel handshake ready signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.2 and A3.2)
    // (begin inline source)
    wire AWVALID;
    wire [((ADDR_WIDTH) - 1):0]  AWADDR;
    wire [2:0] AWPROT;
    wire [3:0] AWREGION;
    wire [7:0] AWLEN;
    wire [2:0] AWSIZE;
    wire [1:0] AWBURST;
    wire AWLOCK;
    wire [3:0] AWCACHE;
    wire [3:0] AWQOS;
    wire [((ID_WIDTH) - 1):0]  AWID;
    wire [((USER_WIDTH) - 1):0]  AWUSER;
    wire AWREADY;
    // (end inline source)



    //------------------------------------------------------------------------------
    // 
    // Wires: Read Address Channel Signals
    // 
    //------------------------------------------------------------------------------
    // ARVALID  - The read address channel valid signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.5 and A3.2)
    // ARADDR   - The read address channel address signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.5)
    // ARPROT   - The read address channel protection type signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.5)
    // ARREGION - The read address channel region signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.5)
    // ARLEN    - The read address channel burst length signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.5)
    // ARSIZE   - The read address channel burst size signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.5)
    // ARBURST  - The read address channel burst type signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.5)
    // ARLOCK   - The read address channel lock type signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.5)
    // ARCACHE  - The read address channel cache type signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.5)
    // ARQOS    - The read address channel Quality-of-Service signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.5)
    // ARID     - The read address channel master ID signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.5)
    // ARUSER   - User-defined read address channel signals. (see AMBA AXI and ACE Protocol Specification IHI0022D section A8.3)
    // ARREADY  - The read address channel handshake ready signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.5 and A3.2)
    // (begin inline source)
    wire ARVALID;
    wire [((ADDR_WIDTH) - 1):0]  ARADDR;
    wire [2:0] ARPROT;
    wire [3:0] ARREGION;
    wire [7:0] ARLEN;
    wire [2:0] ARSIZE;
    wire [1:0] ARBURST;
    wire ARLOCK;
    wire [3:0] ARCACHE;
    wire [3:0] ARQOS;
    wire [((ID_WIDTH) - 1):0]  ARID;
    wire [((USER_WIDTH) - 1):0]  ARUSER;
    wire ARREADY;
    // (end inline source)



    //------------------------------------------------------------------------------
    // 
    // Wires: Read Data Channel Signals
    // 
    //------------------------------------------------------------------------------
    // RVALID   - The read data channel handshake valid signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.6 and A3.2)
    // RDATA    - The read data channel data signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.6)
    // RRESP    - The read data channel response signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.6)
    // RLAST    - The read data channel LAST signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.6)
    // RID      - The read data channel master ID signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.6)
    // RUSER    - User-defined read data channel signals. (see AMBA AXI and ACE Protocol Specification IHI0022D section A8.3)
    // RREADY   - The read data channel handshake ready signals. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.6)
    // (begin inline source)
    wire RVALID;
    wire [((RDATA_WIDTH) - 1):0]  RDATA;
    wire [1:0] RRESP;
    wire RLAST;
    wire [((ID_WIDTH) - 1):0]  RID;
    wire [((USER_WIDTH) - 1):0]  RUSER;
    wire RREADY;
    // (end inline source)



    //------------------------------------------------------------------------------
    // 
    // Wires: Write Data Channel Signals
    // 
    //------------------------------------------------------------------------------
    // WVALID   - The write data channel handshake valid signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.3)
    // WDATA    - The write data channel data signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.3)
    // WSTRB    - The write data channel strobe signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.3)
    // WLAST    - The write data channel LAST signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.3)
    // WUSER    - User-defined write data channel signals. (see AMBA AXI and ACE Protocol Specification IHI0022D section A8.3)
    // WREADY   - The write data channel handshake ready signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.3)
    // (begin inline source)
    wire WVALID;
    wire [((WDATA_WIDTH) - 1):0]  WDATA;
    wire [(((WDATA_WIDTH / 8)) - 1):0]  WSTRB;
    wire WLAST;
    wire [((USER_WIDTH) - 1):0]  WUSER;
    wire WREADY;
    // (end inline source)



    //------------------------------------------------------------------------------
    // 
    // Wires: Write Response Channel Signals
    // 
    //------------------------------------------------------------------------------
    // BVALID   - The write response channel handshake valid signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.4)
    // BRESP    - The write response channel response signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.4)
    // BID      - The write response channel ID signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.4)
    // BUSER    - User-defined write response channel signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.4, A8.3)
    // BREADY   - The write response channel handshake ready signal. (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.4)
    // (begin inline source)
    wire BVALID;
    wire [1:0] BRESP;
    wire [((ID_WIDTH) - 1):0]  BID;
    wire [((USER_WIDTH) - 1):0]  BUSER;
    wire BREADY;
    // (end inline source)


    // Propagate global signals onto interface wires
    assign ACLK = iACLK;
    assign ARESETn = iARESETn;

endinterface


