// Copyright 2007-2015 Mentor Graphics Corporation
// All Rights Reserved.
//
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
// MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
//
// *****************************************************************************
// SystemVerilog           Version: 
// *****************************************************************************

//-------------------------------------------------------------------------
//
// Section: mgc_axi
//
//-------------------------------------------------------------------------
interface mgc_axi_signal_if #(int ADDR_WIDTH = 64, int RDATA_WIDTH = 1024, int WDATA_WIDTH = 1024, int ID_WIDTH = 30)
    (input wire iACLK, input wire iARESETn);

    //-------------------------------------------------------------------------
    //
    // Group: AXI Signals
    //
    //-------------------------------------------------------------------------



    //------------------------------------------------------------------------------
    //  Wires: Clock & Reset
    // Specifies clock and reset wires.
    // 
    //------------------------------------------------------------------------------
    // ACLK    - Global Clock Signal
    // ARESETn - Global Reset Signal. This signal is Active Low.
    // (begin inline source)
    wire ACLK;
    wire ARESETn;
    // (end inline source)



    //------------------------------------------------------------------------------
    //  Wires: Write Address Channel Signals
    // Specifies signals of write address channel
    // 
    //------------------------------------------------------------------------------
    // AWVALID - Write Address Valid. 
    //           The source of this signal is Master and this signal indicates that valid write 
    //           address and control information are available.
    // AWADDR  - Write Address Signal.
    //           The source of this signal is Master.
    // AWLEN   - Write Burst Length Signal.
    //           The source of this signal is Master. The default width of this signal is set to 
    //           10. If the signal width of 4 is required, a wrapper can be made over the DUT to 
    //           do so.
    // AWSIZE  - Write Burst Size Signal.
    //           The source of this signal is Master.
    // AWBURST - Write Burst Type Signal.
    //           The source of this signal is Master.
    // AWLOCK  - Write Lock Type Signal. 
    //           The source of this signal is Master and this signal provides the 
    //           atomic characteristics of the transfer.
    // AWCACHE - Write Cache type Signal. 
    //           The source of this signal is Master and this signal indicates the 
    //           bufferable, cacheable, write-through, write-back, and allocate 
    //           attributes of the transaction.
    // AWPROT  - Write Protection Type Signal. 
    //           The source of this signal is Master and this signal indicates the 
    //           normal, privileged, or secure protection level of the transaction 
    //           and whether it is a data access or instruction access.
    // AWID    - Write Address ID.
    //           The source of this signal is Master and this signal is the 
    //           identification tag for the write address group of signals.
    // AWREADY - Write Address Ready Signal.
    //           The source of this signal is Slave and this signal indicates that 
    //           the valid write address and control information are available.
    // AWUSER  - Write Address User Signal.
    // (begin inline source)
    wire AWVALID;
    wire [((ADDR_WIDTH) - 1):0]  AWADDR;
    wire [9:0] AWLEN;
    wire [2:0] AWSIZE;
    wire [1:0] AWBURST;
    wire [1:0] AWLOCK;
    wire [3:0] AWCACHE;
    wire [2:0] AWPROT;
    wire [((ID_WIDTH) - 1):0]  AWID;
    wire AWREADY;
    wire [63:0] AWUSER;
    // (end inline source)



    //------------------------------------------------------------------------------
    //  Wires: Read Address Channel Signals
    // Specifies signals of read address channel
    // 
    //------------------------------------------------------------------------------
    // ARVALID - Read Address Valid. 
    //           The source of this signal is Master and this signal indicates that 
    //           valid write address and control information are available.
    // ARADDR  - Read Address Signal.
    //           The source of this signal is Master.
    // ARLEN   - Read Burst Length Signal.
    //           The source of this signal is Master.
    //           The default width of this signal is 10. 
    //           If the signal width of 4 is required, a wrapper can be made over the DUT to 
    //           do so.
    // ARSIZE  - Read Burst Size Signal.
    //           The source of this signal is Master.
    // ARBURST - Read Burst Type Signal.
    //           The source of this signal is Master.
    // ARLOCK  - Read Lock Type Signal. 
    //           The source of this signal is Master and this signal provides the 
    //           atomic characteristics of the transfer.
    // ARCACHE - Read Cache type Signal. 
    //           The source of this signal is Master and this signal indicates the 
    //           bufferable, cacheable, write-through, write-back, and allocate 
    //           attributes of the transaction.
    // ARPROT  - Read Protection Type Signal. 
    //           The source of this signal is Master and this signal indicates the 
    //           normal, privileged, or secure protection level of the transaction 
    //           and whether it is a data access or instruction access.
    // ARID    - Read Address ID.
    //           The source of this signal is Master and this signal is the 
    //           identification tag for the write address group of signals.
    // ARREADY - Read Address Ready Signal.
    //           The source of this signal is Slave and this signal indicates that 
    //           the valid write address and control information are available.
    // ARUSER  - Read Address User Signal.
    // (begin inline source)
    wire ARVALID;
    wire [((ADDR_WIDTH) - 1):0]  ARADDR;
    wire [9:0] ARLEN;
    wire [2:0] ARSIZE;
    wire [1:0] ARBURST;
    wire [1:0] ARLOCK;
    wire [3:0] ARCACHE;
    wire [2:0] ARPROT;
    wire [((ID_WIDTH) - 1):0]  ARID;
    wire ARREADY;
    wire [63:0] ARUSER;
    // (end inline source)



    //------------------------------------------------------------------------------
    //  Wires: Read Data Channel Signals
    // Specifies signals of read data channel
    // 
    //------------------------------------------------------------------------------
    // RVALID  - Read Valid Signal.
    //           The source of this signal is Slave and this signal indicates that 
    //           the read data is available and read transfer can complete.
    // RLAST   - Read Last Signal.
    //           The source of this signal is Slave and this signal indicates 
    //           the last transfer in the read burst.
    // RDATA   - Read Data Signal.
    //           The source of this signal is Slave and the read data bus can be 
    //           8, 16, 24, 32, 64, 128, 256, 512 or 1024 bits wide.
    // RRESP   - Read Response Signal.
    //           The source of this signal is Slave and it indicates the status of read transfer.
    //           The allowable responses are OKAY, EXOKAY, SLVERR and DECERR.
    // RID     - Read ID Tag Signal.
    //           The source of this signal is Slave and it is the ID tag of the read data 
    //           group of signals.
    // RREADY  - Read Ready Signal.
    //           The source of this signal is Master and it indicates that the Master can
    //           accept the read data and response information.
    // RUSER   - Read Data User Signal.
    // (begin inline source)
    wire RVALID;
    wire RLAST;
    wire [((RDATA_WIDTH) - 1):0]  RDATA;
    wire [1:0] RRESP;
    wire [((ID_WIDTH) - 1):0]  RID;
    wire RREADY;
    wire [63:0] RUSER;
    // (end inline source)



    //------------------------------------------------------------------------------
    //  Wires: Write Data Channel Signals
    // Specifies signals of write data channel
    // 
    //------------------------------------------------------------------------------
    // WVALID  - Write Valid Signal.
    //           The source of this signal is Master and this signal indicates that 
    //           the read data is available and read transfer can complete.
    // WLAST   - Write Last Signal.
    //           The source of this signal is Master and this signal indicates 
    //           the last transfer in the read burst.
    // WDATA   - Write Data Signal.
    //           The source of this signal is Master and the read data bus can be 
    //           8, 16, 24, 32, 64, 128, 256, 512 or 1024 bits wide.
    // WSTRB   - Write Strobes Signal.
    //           The source of this signal is Master and this signal indicates which 
    //           byte lanes to update in the memory.
    // WID     - Write ID Tag Signal.
    //           The source of this signal is Master and it is the ID tag of the write 
    //           data transfer.
    // WREADY  - Write Ready Signal.
    //           The source of this signal is Slave and it indicates that the Slave can
    //           accept the write data.
    // WUSER   - Write Data User Signal.
    // (begin inline source)
    wire WVALID;
    wire WLAST;
    wire [((WDATA_WIDTH) - 1):0]  WDATA;
    wire [(((WDATA_WIDTH / 8)) - 1):0]  WSTRB;
    wire [((ID_WIDTH) - 1):0]  WID;
    wire WREADY;
    wire [63:0] WUSER;
    // (end inline source)



    //------------------------------------------------------------------------------
    //  Wires: Write Response Channel Signals
    // Specifies signals of write response channel
    // 
    //------------------------------------------------------------------------------
    // BVALID  - Write Response Valid Signal.
    //           The source of this signal is Slave and it indicates that a valid write
    //           response is available.
    // BRESP   - Write Response Signal.
    //           The source of this signal is Slave and it indicates the status of the 
    //           write transaction. The allowable responses are OKAY, EXOKAY, SLVERR 
    //           and DECERR.
    // BID     - Write Response ID Signal.
    //           The source of this signal is Slave and it indicates the identifciation 
    //           tag of a write response.
    // BREADY  - Write Response Ready Signal.
    //           The source of this signal is Master and it indicates that the master 
    //           can accept the response information.
    // BUSER   - Write Response User Signal.
    // (begin inline source)
    wire BVALID;
    wire [1:0] BRESP;
    wire [((ID_WIDTH) - 1):0]  BID;
    wire BREADY;
    wire [63:0] BUSER;
    // (end inline source)


    // Propagate global signals onto interface wires
    assign ACLK = iACLK;
    assign ARESETn = iARESETn;

endinterface


