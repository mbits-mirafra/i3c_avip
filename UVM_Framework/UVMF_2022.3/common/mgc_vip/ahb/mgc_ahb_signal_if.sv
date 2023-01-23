// *****************************************************************************
//
// Copyright 2007-2014 Mentor Graphics Corporation
// All Rights Reserved.
//
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
// MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
//
// *****************************************************************************
// SystemVerilog           Version: 20141119
// *****************************************************************************

interface mgc_ahb_signal_if #(int NUM_MASTERS = 16, int NUM_MASTER_BITS = 4, int NUM_SLAVES = 32, int ADDRESS_WIDTH = 32, int WDATA_WIDTH = 1024, int RDATA_WIDTH = 1024)
    (input wire iHCLK, input wire iHRESETn);

    //------------------------------------------------------------------------------
    // HCLK              - AHB Clock Signal. Main Clock Signal for the AHB Bus. 
    //                        
    // HRESETn           - AHB Reset Signal. Main Reset Signal for the AHB Bus. This Reset Signal is Active Low. 
    //                        
    // (begin inline source)
    wire HCLK;
    wire HRESETn;
    // (end inline source)



    //------------------------------------------------------------------------------
    // 
    //     Wires: Master Signals
    //     
    //     This is the group of signals for master(s)
    //     
    //------------------------------------------------------------------------------
    // master_HBUSREQ    - Master Bus Request Signal. A signal from bus master to the bus arbiter which indicates that the bus master requires the bus. 
    //                           There is an HBUSREQx signal for each bus master in the system, up to a maximum of 16 bus masters.
    //                         
    // master_HLOCK      - Lock wire requesting locked access of the AHB Bus. When HIGH this signal indicates that the master requires locked access
    //                           to the bus and no other master should be granted the bus until this
    //                           signal is LOW.
    //                         
    // HGRANT            - Grant wire indicates Bus Master. This signal indicates that bus master is currently the highest priority master. 
    //                           Ownership of the address/control signals changes at the end of a transfer when HREADY is HIGH, so a master gets access to the bus when both HREADY and HGRANTx are HIGH.
    //                         
    // master_HADDR      - The 32-bit system address bus.
    //                         
    // master_HTRANS     - Transfer Type wire. This wire indicates the type of the current transfer, which can be NONSEQUENTIAL, SEQUENTIAL, IDLE or BUSY.
    //                         
    // master_HWRITE     - Read or Write access being performed. This wire when set to 1 indicates a write transfer otherwise it indicates a read transfer.
    //                         
    // master_HSIZE      - Transfer Size wire. This wire indicates the size of the transfer, which is typically byte (8-bit), halfword (16-bit) or word (32-bit). 
    //                           The protocol allows for larger transfer sizes up to a maximum of 1024 bits.
    //                     
    //                         
    // master_HBURST     - Burst wire indicating length of the current transfer. This wire indicates the lenght of the transfer the master is performing.
    //                           Four, eight and sixteen beat bursts are supported and the burst may be either incrementing or wrapping.
    //                         
    // master_HPROT      - Protection Control wire. The protection control signals provide additional information about a bus access and are primarily intended for use by any module that wishes
    //                           to implement some level of protection. The signals indicate if the transfer is an opcode fetch or data access, 
    //                           as well as if the transfer is a privileged mode access or user mode access. 
    //                           For bus masters with a memory management unit these signals also indicate whether the current access is cacheable or bufferable.
    //                         
    // master_HWDATA     - Write data wire. The write data bus is used to transfer data from the master to the bus slaves during write operations.  
    //                           A minimum data bus width of 32 bits is recommended.  However, this may easily be extended to allow for higher bandwidth operation.
    //                         
    // master_HRDATA     - Read data wire. The read data bus is used to transfer data from bus slaves to the bus master during read operations. 
    //                           A minimum data bus width of 32 bits is recommended. However, this may easily be extended to allow for higher bandwidth operation.
    //                         
    // master_HRESP      - Slave response wire. The transfer response provides additional information on the status of a transfer.  
    //                           Four different responses are provided OKAY, ERROR, RETRY and SPLIT.
    //                         
    // master_HREADY     - HREADY wire. When HIGH the HREADY signal indicates that a transfer has finished on the bus. This signal may be driven LOW to extend a transfer.
    //                         
    // user_HDATA        - This is non-protocol user data signal. It is driven by master device for both read and write transfers.
    //                         
    // user_HADDR        - This is non-protocol user Address signal. It is driven by master device for both read and write transfers.
    //                         
    // (begin inline source)
    wire master_HBUSREQ[NUM_MASTERS];
    wire master_HLOCK[NUM_MASTERS];
    wire HGRANT[NUM_MASTERS];
    wire [ADDRESS_WIDTH - 1:0]  master_HADDR[NUM_MASTERS];
    wire [1:0] master_HTRANS[NUM_MASTERS];
    wire master_HWRITE[NUM_MASTERS];
    wire [2:0] master_HSIZE[NUM_MASTERS];
    wire [2:0] master_HBURST[NUM_MASTERS];
//    wire [5:0]/*[3:0]*/ master_HPROT[NUM_MASTERS]; // HANS: Smaller width for VTL BFM compared to QVIP
    wire [6:0]/*[3:0]*/ master_HPROT[NUM_MASTERS]; // HANS: Smaller width for VTL BFM compared to QVIP
    wire [WDATA_WIDTH - 1:0]  master_HWDATA[NUM_MASTERS];
    wire [RDATA_WIDTH - 1:0]  master_HRDATA[NUM_MASTERS];
    wire [2:0]/*[1:0]*/ master_HRESP[NUM_MASTERS]; // HANS: Smaller width for VTL BFM compared to QVIP
    wire master_HREADY[NUM_MASTERS];
    wire [63:0] user_HDATA[NUM_MASTERS];
    wire [63:0] user_HADDR[NUM_MASTERS];
    // (end inline source)



    //------------------------------------------------------------------------------
    // 
    //     Wires: Slave Signals
    //      
    //     This is the group of signals for slave(s)
    //    
    //------------------------------------------------------------------------------
    // slave_HSEL        - HSEL wire used to select a slave. Each Slave has it own slave select signal and this signal indicates that the current transfer is intended for the selected slave. 
    //                           This signals is simple a combinatorial decode of the address bus.
    //                         
    // slave_HADDR       - The 32-bit system address bus.
    //                         
    // slave_HTRANS      - Transfer Type wire. Indicates the type of the current transfer, which can be NONSEQUENTIAL, SEQUENTIAL, IDLE or BUSY.
    //                         
    // slave_HWRITE      - Read or Write access being performed. When HIGH this signal indicates a write transfer and when LOW a read transfer.
    //                         
    // slave_HSIZE       - Transfer Size wire. Transfer size Master Indicates the size of the transfer, which is typically byte (8-bit), halfword (16-bit) or word (32-bit). 
    //                           The protocol allows for larger transfer sizes up to a maximum of 1024 bits.
    //                         
    // slave_HBURST      - Burst length of the current transfer. Burst type Master Indicates if the transfer forms part of a burst. 
    //                           Four, eight and sixteen beat bursts are supported and the burst may be either incrementing or wrapping.
    //                         
    // slave_HPROT       - Protection Control wire. The protection control signals provide additional information about a bus access and are primarily intended for use by any module that wishes 
    //                           to implement some level of protection.  The signals indicate if the transfer is an opcode fetch or data access, as well as if the transfer is 
    //                           a privileged mode access or user mode access. For bus masters with a memory management unit these signals also indicate whether the current access is cacheable or bufferable.
    //                         
    // slave_HWDATA      - Write data wire. The write data bus is used to transfer data from the master to the bus slaves during write operations.  
    //                           A minimum data bus width of 32 bits is recommended. However, this may easily be extended to allow for higher bandwidth operation.
    //                         
    // slave_user_HDATA  - User data wire. This is non-protocol user data signal.  
    //                           The user data bus is used to transfer user data from the master to the bus slaves.  
    //                        
    // slave_user_HADDR  - User address wire. This is non-protocol sideband user address signal.  
    //                           The user address bus is used to transfer user address from the master to the bus slaves during address/control phase.  
    //                        
    // slave_HMASTER     - slave_HMASTER wire indicates the current master accessing the slave. These signals from the arbiter indicate which bus master is currently performing a transfer and is used by the slaves which 
    //                           support SPLIT transfers to determine which master is attempting an access. The timing of slave_HMASTER is aligned with the timing of the address and control signals.
    //                         
    // slave_HRDATA      - Read data wire. The read data bus is used to transfer data from bus slaves to the bus master during read operations. 
    //                           A minimum data bus width of 32 bits is recommended. However, this may easily be extended to allow for higher bandwidth operation.
    //                         
    // slave_HREADY      - HREADY Output from the slave indicating the readiness of the slave. When HIGH the HREADY signal indicates that a transfer has finished on the bus. The slave may drive the signal LOW to extend a transfer.
    //                         
    // slave_HRESP       - Slave response wire. The transfer response provides additional information on the status of a transfer.  Four different responses are provided OKAY, ERROR, RETRY and SPLIT.
    //                         
    // slave_HSPLIT      - HSPLIT wire indicating the split completion request for a master. The split bus is used by a slave to indicate to the arbiter which bus master should be allowed to re-attempt a split transaction. 
    //                           Each bit of the split corresponds to a single bus master.
    //                         
    // (begin inline source)
    wire slave_HSEL[NUM_SLAVES];
    wire [ADDRESS_WIDTH - 1:0]  slave_HADDR[NUM_SLAVES];
    wire [1:0] slave_HTRANS[NUM_SLAVES];
    wire slave_HWRITE[NUM_SLAVES];
    wire [2:0] slave_HSIZE[NUM_SLAVES];
    wire [2:0] slave_HBURST[NUM_SLAVES];
    wire [5:0]/*[3:0]*/ slave_HPROT[NUM_SLAVES]; // HANS: Smaller width for VTL BFM compared to QVIP
    wire [WDATA_WIDTH - 1:0]  slave_HWDATA[NUM_SLAVES];
    wire [63:0] slave_user_HDATA[NUM_SLAVES];
    wire [63:0] slave_user_HADDR[NUM_SLAVES];
    wire [NUM_MASTER_BITS - 1:0]  slave_HMASTER[NUM_SLAVES];
    wire [RDATA_WIDTH - 1:0]  slave_HRDATA[NUM_SLAVES];
    wire slave_HREADY[NUM_SLAVES];
    wire [2:0]/*[1:0]*/ slave_HRESP[NUM_SLAVES]; // HANS: Smaller width for VTL BFM compared to QVIP
    wire [NUM_MASTERS - 1:0]  slave_HSPLIT[NUM_SLAVES];
    // (end inline source)



    //------------------------------------------------------------------------------
    //  
    //      Wires: Arbiter Signals
    //       
    //      This is the group of signals for arbiter
    //     
    //------------------------------------------------------------------------------
    // arbiter_HBURST    - Burst wire indicating length of the current transfer. Burst type Master Indicates if the transfer forms part of a burst. Four, eight and sixteen beat bursts are supported and the burst may be either incrementing or wrapping.
    //                         
    // arbiter_HBUSREQ   - Bus request wire indicating the requesting master. The bus request signal is used by a bus master to request access to the bus. 
    //                           Each bus master has its own HBUSREQx signal to the arbiter and there can be up to 16 separate bus masters in any system.
    //                         
    // arbiter_HLOCK     - Lock wire requesting locked access of the AHB Bus. The lock signal is asserted by a master at the same time as the bus request signal. This indicates to the arbiter that the master is performing a number 
    //                           of indivisible transfers and the arbiter must not grant any other bus master access to the bus once the first transfer of the locked transfers has commenced. 
    //                           HLOCKx must be asserted at least a cycle before the address to which it refers, in order to prevent the arbiter from changing the grant signals.
    //                         
    // arbiter_HRESP     - Slave response wire. The transfer response provides additional information on the status of a transfer.  Four different responses are provided OKAY, ERROR, RETRY and SPLIT.
    //                         
    // HREADY            - HREADY wire. When HIGH the HREADY signal indicates that a transfer has finished on the bus. This signal will be driven LOW to extend a transfer.
    //                         
    // HREADYin          - HREADYin wire. Please note that normally the calculation of the HREADYin signal is done internally by the QVIP.
    //                           However, if the user wants to provide an external HREADYin signal, then this wire is specifically used to connect with the external HREADYin signal, provided by the user. 
    //                           When HIGH the HREADYin signal indicates that a transfer has finished on the bus.
    //                         
    // HSPLIT            - HSPLIT wire indicating the split completion request for a master. The Split Complete bus is used by a SPLIT-capable slave to indicate which bus master can complete a SPLIT transaction. 
    //                           This information is needed by the arbiter so that it can grant the master access to the bus to complete the transfer.
    //                         
    // arbiter_HGRANT    - Arbiter Grant wire indicates the current bus master. The grant signal is generated by the arbiter and indicates that the appropriate master is currently the highest priority master requesting the bus, 
    //                           taking into account locked transfers and SPLIT transfers. A master gains ownership of the address bus when HGRANTx is HIGH and HREADY is HIGH at the rising edge of HCLK.
    //                         
    // HMASTER           - HMASTER wire indicates the current bus master. The arbiter indicates which master is currently granted the bus using the HMASTER signals and this can be used to control the central address and control multiplexor.
    //                           The master number is also required by SPLIT-capable slaves so that they can indicate to the arbiter which master is able to complete a SPLIT transaction.
    //                         
    // arbiter_HMASTLOCK - Arbiter HMASTLOCK wire indicating the bus has a locked access. The arbiter indicates that the current transfer is part of a locked sequence by asserting the HMASTLOCK signal, which has the same timing as the address and control signals.
    //                         
    // HMASTLOCK         - HMASTLOCK wire indicating the bus has a locked access. The arbiter indicates that the current transfer is part of a locked sequence by asserting the HMASTLOCK signal, which has the same timing as the address and control signals.
    //                         
    // (begin inline source)
    wire [2:0] arbiter_HBURST;
    wire [NUM_MASTERS - 1:0]  arbiter_HBUSREQ;
    wire [NUM_MASTERS - 1:0]  arbiter_HLOCK;
    wire [2:0]/*[1:0]*/ arbiter_HRESP; // HANS: Smaller width for VTL BFM compared to QVIP
    wire [1:0] arbiter_HTRANS; // HANS: Added for VTL BFM compared to QVIP if
    wire HREADY;
    wire HREADYin;
    wire [NUM_MASTERS - 1:0]  HSPLIT;
    wire [NUM_MASTERS - 1:0]  arbiter_HGRANT;
    wire [NUM_MASTER_BITS - 1:0]  HMASTER;
    wire [NUM_MASTER_BITS - 1:0]  HDOMAIN;
    wire arbiter_HMASTLOCK;
    wire HMASTLOCK;
    // (end inline source)



    //------------------------------------------------------------------------------
    //  Wires: Decoder Signals
    //       
    //      This is the group of signals for decoder
    //     
    //------------------------------------------------------------------------------
    // decoder_HSEL      - HSEL wire used to select a slave. Each Slave has it own slave select signal and this signal indicates that the current transfer is intended for the selected slave. 
    //                           This signals is simple a combinatorial decode of the address bus.
    //                         
    // decoder_HADDR     - Decoder HADDR wire is the input to the decoder. This wire contains the ADDRESS from the selected master which is currently the bus master.
    //                         
    // (begin inline source)
    wire decoder_HSEL[NUM_SLAVES];
    wire [ADDRESS_WIDTH - 1:0]  decoder_HADDR;

    // HANS: Added for VTL BFM compared to QVIP
    wire external_core_HSEL [NUM_SLAVES];
    wire [ADDRESS_WIDTH -1:0] core_HADDR_to_ex_decoder;
    wire [NUM_MASTERS -1 :0] default_Master;
    // (end inline source)



    //------------------------------------------------------------------------------
    // 
    //     Wires: ARM11 AHB Signals
    //      
    //     This is the group of signals in addition to the AHB signals which are specific to only ARM11 AHB
    //     
    //------------------------------------------------------------------------------
    // master_HBSTROBE   - The Data width in Bytes width strobe bus.  This signal is used only in ARM11_AHB.
    //                         
    // master_HUNALIGN   - The HUNALIGN Signal for unaligned transfers. This signal is used only in ARM11_AHB.
    //                         
    // slave_HBSTROBE    - The Data width in Bytes width strobe bus. This signal is used only in ARM11_AHB.
    //                         
    // slave_HUNALIGN    - The HUNALIGN Signal for unaligned transfers. This signal is used only in ARM11_AHB.
    //                         
    // slave_HDOMAIN     - HDOMAIN is an addtional signal to represent group of masters for Exclusive. This signal is used only in ARM11_AHB.
    //                         
    // (begin inline source)
    wire [((WDATA_WIDTH > RDATA_WIDTH) ? (WDATA_WIDTH / 8) : (RDATA_WIDTH / 8) - 1):0]  master_HBSTROBE[NUM_MASTERS];
    wire master_HUNALIGN[NUM_MASTERS];
    wire [((WDATA_WIDTH > RDATA_WIDTH) ? (WDATA_WIDTH / 8) : (RDATA_WIDTH / 8) - 1):0]  slave_HBSTROBE[NUM_SLAVES];
    wire slave_HUNALIGN[NUM_SLAVES];
    wire [NUM_MASTER_BITS - 1:0]  slave_HDOMAIN[NUM_SLAVES];
    // (end inline source)


    // Propagate global signals onto interface wires
    assign HCLK = iHCLK;
    assign HRESETn = iHRESETn;

endinterface


