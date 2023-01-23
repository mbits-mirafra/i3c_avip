// *****************************************************************************
//
// Copyright 2007-2014 Mentor Graphics Corporation
// All Rights Reserved.
//
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
// MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
//
// *****************************************************************************
// SystemVerilog           Version: 20140826
// *****************************************************************************

//-------------------------------------------------------------------------
//
// Section: mgc_ace
//
//-------------------------------------------------------------------------
interface mgc_ace_signal_if #(int ADDRESS_WIDTH = 64, int RDATA_WIDTH = 1024, int WDATA_WIDTH = 1024, int ID_WIDTH = 30, int USER_WIDTH = 4, int REGION_MAP_SIZE = 16, int SNOOP_DATA_WIDTH = 1024, int CACHE_LINE_SIZE = 7)
    (input wire iACLK, input wire iARESETn);

    //-------------------------------------------------------------------------
    //
    // Group: ACE Signals
    //
    //-------------------------------------------------------------------------


    // Wire: ACVALID
    //  Valid signal for the snoop address channel. (SPECACE(C2.2.1))
    // 
    // (begin inline source)
    wire ACVALID;
    // (end inline source)


    // Wire: ACREADY
    //  The ready signal for the snoop address channel. (SPECACE(C2.2.1))
    // 
    // (begin inline source)
    wire ACREADY;
    // (end inline source)


    // Wire: ACADDR
    //  Snoop address. (SPECACE(C2.2.1))
    // 
    // (begin inline source)
    wire [((ADDRESS_WIDTH) - 1):0]  ACADDR;
    // (end inline source)


    // Wire: ACSNOOP
    //  Snoop transaction type. (SPECACE(C2.2.1))
    // 
    // (begin inline source)
    wire [3:0] ACSNOOP;
    // (end inline source)


    // Wire: ACPROT
    //  Snoop protection information. (SPECACE(C2.2.1))
    // 
    // (begin inline source)
    wire [2:0] ACPROT;
    // (end inline source)


    // Wire: CDVALID
    //  Valid signal for the snoop data channel. (SPECACE(C2.2.3))
    // 
    // (begin inline source)
    wire CDVALID;
    // (end inline source)


    // Wire: CDREADY
    //  The ready signal for the snoop data channel. (SPECACE(C2.2.3))
    // 
    // (begin inline source)
    wire CDREADY;
    // (end inline source)


    // Wire: CDDATA
    //  The data bus used for transferring data from a master. (SPECACE(C2.2.3))
    // 
    // (begin inline source)
    wire [((SNOOP_DATA_WIDTH) - 1):0]  CDDATA;
    // (end inline source)


    // Wire: CDLAST
    //  Asserted for the last data transfer of a snoop transaction. (SPECACE(C2.2.3))
    // 
    // (begin inline source)
    wire CDLAST;
    // (end inline source)


    // Wire: CRVALID
    //  Valid signal for the snoop response channel. (SPECACE(C2.2.2))
    // 
    // (begin inline source)
    wire CRVALID;
    // (end inline source)


    // Wire: CRREADY
    //  The ready signal for the snoop response channel. (SPECACE(C2.2.2))
    // 
    // (begin inline source)
    wire CRREADY;
    // (end inline source)


    // Wire: CRRESP
    //  Snoop response. Used to indicate how a snoop transaction will complete. (SPECACE(C2.2.2))
    // 
    // (begin inline source)
    wire [4:0] CRRESP;
    // (end inline source)


    // Wire: ACLK
    //  The clock signal (SPEC3(A2.1))
    // 
    // (begin inline source)
    wire ACLK;
    // (end inline source)


    // Wire: ARESETn
    // Note, no reference to X/Z, as they don't appear in emulation 
    // (begin inline source)
    wire ARESETn;
    // (end inline source)


    // Wire: AWVALID
    //  The address-channel valid signal (SPEC3(A3.1 and A3.2))
    // 
    // (begin inline source)
    wire AWVALID;
    // (end inline source)


    // Wire: AWADDR
    //  The write address signal (SPEC3(A2.2))
    // 
    // (begin inline source)
    wire [((ADDRESS_WIDTH) - 1):0]  AWADDR;
    // (end inline source)


    // Wire: AWPROT
    //  The write-channel protection type (SPEC3(A2.2))
    // 
    // (begin inline source)
    wire [2:0] AWPROT;
    // (end inline source)


    // Wire: AWREGION
    //  The write-channel region signal (SPEC3(A2.2))
    // 
    // (begin inline source)
    wire [3:0] AWREGION;
    // (end inline source)


    // Wire: AWLEN
    //  The write-channel burst-length signal (SPEC3(A2.2))
    // 
    // (begin inline source)
    wire [7:0] AWLEN;
    // (end inline source)


    // Wire: AWSIZE
    //  The write-channel burst size signal (SPEC3(A2.2))
    // 
    // (begin inline source)
    wire [2:0] AWSIZE;
    // (end inline source)


    // Wire: AWBURST
    //  The write-channel burst type signal (SPEC3(A2.2.))
    // 
    // (begin inline source)
    wire [1:0] AWBURST;
    // (end inline source)


    // Wire: AWLOCK
    //  The write-channel lock type (SPEC3(A2.2))
    // 
    // (begin inline source)
    wire AWLOCK;
    // (end inline source)


    // Wire: AWCACHE
    //  The write-channel cache type signal (SPEC3(A2.2))
    // 
    // (begin inline source)
    wire [3:0] AWCACHE;
    // (end inline source)


    // Wire: AWQOS
    //  The write-channel Quality-of-Service signal (SPEC3(A2.2))
    // 
    // (begin inline source)
    wire [3:0] AWQOS;
    // (end inline source)


    // Wire: AWID
    //  The write-channel master ID signal (SPEC3(A2.2))
    // 
    // (begin inline source)
    wire [((ID_WIDTH) - 1):0]  AWID;
    // (end inline source)


    // Wire: AWUSER
    //  User-defined write-channel signals (SPEC4(A8.3))
    // 
    // (begin inline source)
    wire [((USER_WIDTH) - 1):0]  AWUSER;
    // (end inline source)


    // Wire: AWDOMAIN
    //  Indicates the shareability domain of a write transaction. (SPECACE(C2.1))
    // 
    // (begin inline source)
    wire [1:0] AWDOMAIN;
    // (end inline source)


    // Wire: AWSNOOP
    //  For shareable transactions, indicates the transaction type. (SPECACE(C2.1))
    // 
    // (begin inline source)
    wire [2:0] AWSNOOP;
    // (end inline source)


    // Wire: AWBAR
    //  Used to inidicate a barrier transaction. (SPECACE(C2.1))
    // 
    // (begin inline source)
    wire [1:0] AWBAR;
    // (end inline source)


    // Wire: ARDOMAIN
    //  Indicates the shareability domain of a read transaction. (SPECACE(C2.1))
    // 
    // (begin inline source)
    wire [1:0] ARDOMAIN;
    // (end inline source)


    // Wire: ARSNOOP
    //  For shareable read transactions, indicates the transaction type. (SPECACE(C2.1))
    // 
    // (begin inline source)
    wire [3:0] ARSNOOP;
    // (end inline source)


    // Wire: ARBAR
    //  Used to inidicate a barrier transaction. (SPECACE(C2.1))
    // 
    // (begin inline source)
    wire [1:0] ARBAR;
    // (end inline source)


    // Wire: RRESP
    //  The read data channel response signal (SPEC3(A2.6))
    //    In ACE interface additional read response bits, used to provide additional information to
    //    complete a shareable read transaction. (SPECACE(C2.1))
    // 
    // (begin inline source)
    wire [3:0] RRESP;
    // (end inline source)


    // Wire: RACK
    //  Indicates that a master has completed a read transaction. (SPECACE(C2.1))
    // 
    // (begin inline source)
    wire RACK;
    // (end inline source)


    // Wire: WACK
    //  Indicates that a master has completed a write transaction. (SPECACE(C2.1))
    // 
    // (begin inline source)
    wire WACK;
    // (end inline source)


    // Wire: AWREADY
    //  The write-channel handshake ready signal (SPEC3(A2.2 and A3.2))
    // 
    // (begin inline source)
    wire AWREADY;
    // (end inline source)


    // Wire: ARVALID
    //  The read address channel valid signal (SPEC3(A2.5 and A3.2))
    // 
    // (begin inline source)
    wire ARVALID;
    // (end inline source)


    // Wire: ARADDR
    //  The read address channel address signal (SPEC3(A2.5))
    // 
    // (begin inline source)
    wire [((ADDRESS_WIDTH) - 1):0]  ARADDR;
    // (end inline source)


    // Wire: ARPROT
    //  The read address channel protection type signal (SPEC3(A2.5))
    // 
    // (begin inline source)
    wire [2:0] ARPROT;
    // (end inline source)


    // Wire: ARREGION
    //  The read address channel region signal (SPEC3(A2.5))
    // 
    // (begin inline source)
    wire [3:0] ARREGION;
    // (end inline source)


    // Wire: ARLEN
    //  The read address channel burst length signal (SPEC3(A2.5))
    // 
    // (begin inline source)
    wire [7:0] ARLEN;
    // (end inline source)


    // Wire: ARSIZE
    //  The read address channel burst size signal (SPEC3(A2.5))
    // 
    // (begin inline source)
    wire [2:0] ARSIZE;
    // (end inline source)


    // Wire: ARBURST
    //  The read address channel burst type signal (SPEC3(A2.5))
    // 
    // (begin inline source)
    wire [1:0] ARBURST;
    // (end inline source)


    // Wire: ARLOCK
    //  The read address channel lock type signal (SPEC3(A2.5))
    // 
    // (begin inline source)
    wire ARLOCK;
    // (end inline source)


    // Wire: ARCACHE
    //  The read address channel cache type signal (SPEC3(A2.5))
    // 
    // (begin inline source)
    wire [3:0] ARCACHE;
    // (end inline source)


    // Wire: ARQOS
    //  The read address channel Quality-of-Service signal (SPEC3(A2.5))
    // 
    // (begin inline source)
    wire [3:0] ARQOS;
    // (end inline source)


    // Wire: ARID
    //  The read address channel master ID signal (SPEC3(A2.5))
    // 
    // (begin inline source)
    wire [((ID_WIDTH) - 1):0]  ARID;
    // (end inline source)


    // Wire: ARUSER
    //  User-defined read address channel signals (SPEC4(A8.3))
    // 
    // (begin inline source)
    wire [((USER_WIDTH) - 1):0]  ARUSER;
    // (end inline source)


    // Wire: ARREADY
    //  The read address channel handshake ready signal (SPEC3(A2.5 and A3.2))
    // 
    // (begin inline source)
    wire ARREADY;
    // (end inline source)


    // Wire: RVALID
    //  The read data channel handshake valid signal (SPEC3(A2.6 and A3.2))
    // 
    // (begin inline source)
    wire RVALID;
    // (end inline source)


    // Wire: RDATA
    //  The read data channel data signal (SPEC3(A2.6))
    // 
    // (begin inline source)
    wire [((RDATA_WIDTH) - 1):0]  RDATA;
    // (end inline source)


    // Wire: RLAST
    //  The read data channel LAST signal (SPEC3(A2.6))
    // 
    // (begin inline source)
    wire RLAST;
    // (end inline source)


    // Wire: RID
    //  The read data channel master ID signal (SPEC3(A2.6))
    // 
    // (begin inline source)
    wire [((ID_WIDTH) - 1):0]  RID;
    // (end inline source)


    // Wire: RUSER
    //  User-defined read data channel signals (SPEC4(A8.3))
    // 
    // (begin inline source)
    wire [((USER_WIDTH) - 1):0]  RUSER;
    // (end inline source)


    // Wire: RREADY
    //  The read data channel handshake ready signals (SPEC3(A2.6))
    // 
    // (begin inline source)
    wire RREADY;
    // (end inline source)


    // Wire: WVALID
    //  The write data channel handshake valid signal (SPEC3(A2.3))
    // 
    // (begin inline source)
    wire WVALID;
    // (end inline source)


    // Wire: WDATA
    //  The write data channel data signal (SPEC3(A2.3))
    // 
    // (begin inline source)
    wire [((WDATA_WIDTH) - 1):0]  WDATA;
    // (end inline source)


    // Wire: WSTRB
    //  The write data channel strobe signal (SPEC3(A2.3))
    // 
    // (begin inline source)
    wire [(((WDATA_WIDTH / 8)) - 1):0]  WSTRB;
    // (end inline source)


    // Wire: WLAST
    //  The write data channel LAST signal (SPEC3(A2.3))
    // 
    // (begin inline source)
    wire WLAST;
    // (end inline source)


    // Wire: WUSER
    //  User-defined write data channel signals (SPEC3(A8.3))
    // 
    // (begin inline source)
    wire [((USER_WIDTH) - 1):0]  WUSER;
    // (end inline source)


    // Wire: WREADY
    //  The write data channel handshake ready signal (SPEC3(A2.3))
    // 
    // (begin inline source)
    wire WREADY;
    // (end inline source)


    // Wire: BVALID
    //  The write response channel handshake valid signal (SPEC3(A2.4))
    // 
    // (begin inline source)
    wire BVALID;
    // (end inline source)


    // Wire: BRESP
    //  The write response channel response signal (SPEC3(A2.4))
    // 
    // (begin inline source)
    wire [1:0] BRESP;
    // (end inline source)


    // Wire: BID
    //  The write response channel ID signal (SPEC3(A2.4))
    // 
    // (begin inline source)
    wire [((ID_WIDTH) - 1):0]  BID;
    // (end inline source)


    // Wire: BUSER
    //  User-defined write response channel signal (SPEC4(A8.3))
    // 
    // (begin inline source)
    wire [((USER_WIDTH) - 1):0]  BUSER;
    // (end inline source)


    // Wire: BREADY
    //  The write response channel handshake ready signal (SPEC3(A2.4))
    // 
    // (begin inline source)
    wire BREADY;
    // (end inline source)


    // Propagate global signals onto interface wires
    assign ACLK = iACLK;
    assign ARESETn = iARESETn;

endinterface


