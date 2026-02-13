// ---------------- REGISTER MAP ----------------
`define REG_CONFIG       12'h004
/*
Master configuration:
Enable I3C
Enable HDR?
Enable IBI support?
Enable DAA
*/
`define REG_STATUS       12'h008
/*
BUSY
ERROR
DAA_ACTIVE
RX_READY
TX_EMPTY
TRANSFER_DONE
*/
`define REG_CTRL         12'h00C
/*
START_CMD
STOP
R/W direction
Trigger CCC
Trigger SDR transfer
Trigger ENTDAA
*/
`define REG_WDATAB       7'h30 //Master write data - FIFO input
`define REG_RDATAB       7'h40 //Master read data - FIFO output

///For future use///////////////////////
/*`define REG_DYNADDR      7'h64 //This stores the slave address selected for the NEXT transfer
`define REG_INTSET       7'h10
`define REG_INTCLR       7'h14
`define REG_INTMASKED    7'h18 // This 3 Use only if we want interrupt support
//`define REG_ERRWARN      12'h01C
//`define REG_DATACTRL     12'h02C
//`define REG_WDATABE      12'h034
//`define REG_MWDATAH      12'h038
//`define REG_MWDATAHE     12'h03C
//`define REG_RDATAH       12'h048
//`define REG_WDATAB1      12'h054
//`define REG_CAPABILITIES 12'h060
//`define REG_ID           12'hFFC
*/
//CCC_CODES
// --------- BROADCAST CCCs ---------
//`define CCC_RSTDAA    8'h06   // Reset Dynamic Address Assignment
`define CCC_ENTDAA    8'h07   // Start Dynamic Address Assignment
/*
`define CCC_SETMWL    8'h09   // Set Max Write Length for all slaves
`define CCC_SETMRL    8'h0A   // Set Max Read Length for all slaves
`define CCC_SETASA    8'h29   // (Optional) Use Static Address as Dynamic

// --------- DIRECT CCCs ---------
`define CCC_SETDASA   8'h87   // Assign Dynamic Address to slave using Static Address
`define CCC_SETNEWDA  8'h88   // Assign a new Dynamic Address
`define CCC_SETMWL_D  8'h89   // Direct Set Max Write Length
`define CCC_SETMRL_D  8'h8A   // Direct Set Max Read Length
`define CCC_GETMWL    8'h8B   // Read Max Write Length
`define CCC_GETMRL    8'h8C   // Read Max Read Length
`define CCC_GETPID    8'h8D   // Read Provisional ID
`define CCC_GETBCR    8'h8E   // Read Bus Characteristics Register
`define CCC_GETDCR    8'h8F   // Read Device Characteristics Register
`define CCC_GETSTATUS 8'h90   // Read device status
*/