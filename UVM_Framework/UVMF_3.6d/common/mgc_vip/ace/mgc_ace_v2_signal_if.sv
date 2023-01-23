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
// Section: mgc_ace
//
//-------------------------------------------------------------------------
interface mgc_ace_signal_if #(type PARAMS = int)
    (input wire iACLK, input wire iARESETn);

    // Group: Parameters


    // (begin autotag)

    localparam int ADDR_WIDTH  = PARAMS::ADDR_WIDTH;
    localparam int RDATA_WIDTH = PARAMS::RDATA_WIDTH;
    localparam int WDATA_WIDTH = PARAMS::WDATA_WIDTH;
    localparam int SDATA_WIDTH = PARAMS::SDATA_WIDTH;
    localparam int ID_WIDTH    = PARAMS::ID_WIDTH;
    localparam int USER_WIDTH  = PARAMS::USER_WIDTH;
    localparam int LINE_WIDTH  = PARAMS::LINE_WIDTH;

    // (end autotag)

    //-------------------------------------------------------------------------
    //
    // Group: ACE Signals
    //
    //-------------------------------------------------------------------------


    // Wire: ACLK
    // (begin inline source)
    wire ACLK;
    // (end inline source)


    // Wire: ARESETn
    // Note, no reference to X/Z, as they don't appear in emulation 
    // (begin inline source)
    wire ARESETn;
    // (end inline source)



    //------------------------------------------------------------------------------
    // 
    // Wires: Read Address Channel
    // This group consists of signals related to read address channel
    // 
    //------------------------------------------------------------------------------
    // ARDOMAIN - Indicates the shareability domain of a read transaction. (ACE Spec C2.1)
    // ARSNOOP  - For shareable read transactions, indicates the transaction type. (ACE Spec C2.1)
    // ARBAR    - Used to indicate a barrier transaction. (ACE Spec C2.1)
    // RRESP    - The read data channel response signal (ACE Spec A2.6, C2.1)
    // ARADDR   - The read address channel address signal (ACE Spec A2.5)
    // ARPROT   - The read address channel protection type signal (ACE Spec A2.5)
    // ARREGION - The read address channel region signal (ACE Spec A2.5)
    // ARLEN    - The read address channel burst length signal (ACE Spec A2.5)
    // ARSIZE   - The read address channel burst size signal (ACE Spec A2.5)
    // ARBURST  - The read address channel burst type signal (ACE Spec A2.5)
    // ARLOCK   - The read address channel lock type signal (ACE Spec A2.5)
    // ARCACHE  - The read address channel cache type signal (ACE Spec A2.5)
    // ARQOS    - The read address channel Quality-of-Service signal (ACE Spec A2.5)
    // ARID     - The read address channel master ID signal (ACE Spec A2.5)
    // ARUSER   - User-defined read address channel signals (ACE Spec A8.3)
    // ARVALID  - The read address channel valid signal (ACE Spec A2.5 and A3.2)
    // ARREADY  - The read address channel handshake ready signal (ACE Spec A2.5 and A3.2)
    // RACK     - Indicates that a master has completed a read transaction. (ACE Spec C2.1)
    // (begin inline source)
    wire [1:0] ARDOMAIN;
    wire [3:0] ARSNOOP;
    wire [1:0] ARBAR;
    wire [3:0] RRESP;
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
    wire ARVALID;
    wire ARREADY;
    wire RACK;
    // (end inline source)



    //------------------------------------------------------------------------------
    //  
    // Wires: Read Response/Data Channel
    // This group consists of signals related to read response/data channel
    // 
    //------------------------------------------------------------------------------
    // RDATA    - The read data channel data signal (ACE Spec A2.6)
    // RLAST    - The read data channel LAST signal (ACE Spec A2.6)
    // RID      - The read data channel master ID signal (ACE Spec A2.6)
    // RREADY   - The read data channel handshake ready signals (ACE Spec A2.6)
    // RVALID   - The read data channel handshake valid signal (ACE Spec A2.6 and A3.2)
    // RUSER    - User-defined read data channel signals (ACE Spec A8.3)
    // (begin inline source)
    wire [((RDATA_WIDTH) - 1):0]  RDATA;
    wire RLAST;
    wire [((ID_WIDTH) - 1):0]  RID;
    wire RREADY;
    wire RVALID;
    wire [((USER_WIDTH) - 1):0]  RUSER;
    // (end inline source)



    //------------------------------------------------------------------------------
    // 
    // Wires: Write Address Channel
    // This group consists of signals related to write address channel
    // 
    //------------------------------------------------------------------------------
    // AWADDR   - The write address signal (ACE Spec A2.2)
    // AWPROT   - The write-channel protection type (ACE Spec A2.2)
    // AWREGION - The write-channel region signal (ACE Spec A2.2)
    // AWLEN    - The write-channel burst-length signal (ACE Spec A2.2)
    // AWSIZE   - The write-channel burst size signal (ACE Spec A2.2)
    // AWBURST  - The write-channel burst type signal (ACE Spec A2.2.)
    // AWLOCK   - The write-channel lock type (ACE Spec A2.2)
    // AWCACHE  - The write-channel cache type signal (ACE Spec A2.2)
    // AWQOS    - The write-channel Quality-of-Service signal (ACE Spec A2.2)
    // AWID     - The write-channel master ID signal (ACE Spec A2.2)
    // AWUSER   - User-defined write-channel signals (ACE Spec A8.3)
    // AWDOMAIN - Indicates the shareability domain of a write transaction. (ACE Spec C2.1)
    // AWSNOOP  - For shareable transactions, indicates the transaction type. (ACE Spec C2.1)
    // AWBAR    - Used to indicate a barrier transaction. (ACE Spec C2.1)
    // AWREADY  - The write-channel handshake ready signal (ACE Spec A2.2 and A3.2)
    // AWVALID  - The address-channel valid signal (ACE Spec A3.1 and A3.2)
    // AWUNIQUE - Indicates if cache line is permitted to be held in unique state. (ACE Spec C2.1)
    // WACK     - Indicates that a master has completed a write transaction. (ACE Spec C2.1)
    // (begin inline source)
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
    wire [1:0] AWDOMAIN;
    wire [2:0] AWSNOOP;
    wire [1:0] AWBAR;
    wire AWREADY;
    wire AWVALID;
    wire AWUNIQUE;
    wire WACK;
    // (end inline source)



    //------------------------------------------------------------------------------
    // 
    // Wires: Write Data Channel
    // This group consists of signals related to write data channel
    // 
    //------------------------------------------------------------------------------
    // WDATA    - The write data channel data signal (ACE Spec A2.3)
    // WSTRB    - The write data channel strobe signal (ACE Spec A2.3)
    // WLAST    - The write data channel LAST signal (ACE Spec A2.3)
    // WREADY   - The write data channel handshake ready signal (ACE Spec A2.3)
    // WVALID   - The write data channel handshake valid signal (ACE Spec A2.3)
    // WUSER    - User-defined write data channel signals (ACE Spec A8.3)
    // (begin inline source)
    wire [((WDATA_WIDTH) - 1):0]  WDATA;
    wire [(((WDATA_WIDTH / 8)) - 1):0]  WSTRB;
    wire WLAST;
    wire WREADY;
    wire WVALID;
    wire [((USER_WIDTH) - 1):0]  WUSER;
    // (end inline source)



    //------------------------------------------------------------------------------
    // 
    // Wires: Write Response Channel
    // This group consists of signals related to write response channel
    // 
    //------------------------------------------------------------------------------
    // BRESP    - The write response channel response signal (ACE Spec A2.4)
    // BID      - The write response channel ID signal (ACE Spec A2.4)
    // BREADY   - The write response channel handshake ready signal (ACE Spec A2.4)
    // BVALID   - The write response channel handshake valid signal (ACE Spec A2.4)
    // BUSER    - User-defined write response channel signal (ACE Spec A8.3)
    // (begin inline source)
    wire [1:0] BRESP;
    wire [((ID_WIDTH) - 1):0]  BID;
    wire BREADY;
    wire BVALID;
    wire [((USER_WIDTH) - 1):0]  BUSER;
    // (end inline source)



    //------------------------------------------------------------------------------
    // 
    // Wires: Snoop Address Channel
    // This group consists of signals related to snoop address channel
    // 
    //------------------------------------------------------------------------------
    // ACVALID  - Valid signal for the snoop address channel (ACE Spec C2.2.1)
    // ACREADY  - Ready signal for the snoop address channel (ACE Spec C2.2.1)
    // ACADDR   - Snoop address (ACE Spec C2.2.1)
    // ACSNOOP  - Snoop transaction type. (ACE Spec C2.2.1)
    // ACPROT   - Snoop protection information. (ACE Spec C2.2.1)
    // (begin inline source)
    wire ACVALID;
    wire ACREADY;
    wire [((ADDR_WIDTH) - 1):0]  ACADDR;
    wire [3:0] ACSNOOP;
    wire [2:0] ACPROT;
    // (end inline source)



    //------------------------------------------------------------------------------
    // 
    // Wires: Snoop Data Channel
    // This group consists of signals related to snoop data channel
    // 
    //------------------------------------------------------------------------------
    // CDVALID  - Valid signal for the snoop data channel. (ACE Spec C2.2.3)
    // CDREADY  - Ready signal for the snoop data channel. (ACE Spec C2.2.3)
    // CDDATA   - Data bus used for transferring data from a master. (ACE Spec C2.2.3)
    // CDLAST   - Asserted for the last data transfer of a snoop transaction. (ACE Spec C2.2.3)
    // (begin inline source)
    wire CDVALID;
    wire CDREADY;
    wire [((SDATA_WIDTH) - 1):0]  CDDATA;
    wire CDLAST;
    // (end inline source)



    //------------------------------------------------------------------------------
    // 
    // Wires: Snoop Response Channel
    // This group consists of signals related to snoop response channel
    // 
    //------------------------------------------------------------------------------
    // CRVALID  - Valid signal for the snoop response channel. (ACE Spec C2.2.2)
    // CRREADY  - Ready signal for the snoop response channel. (ACE Spec C2.2.2)
    // CRRESP   - Snoop response. Used to indicate how a snoop transaction will complete. (ACE Spec C2.2.2)
    // (begin inline source)
    wire CRVALID;
    wire CRREADY;
    wire [4:0] CRRESP;
    // (end inline source)


    // Propagate global signals onto interface wires
    assign ACLK = iACLK;
    assign ARESETn = iARESETn;

endinterface


