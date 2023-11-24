`ifndef I3C_GLOBALS_PKG_INCLUDED_
`define I3C_GLOBALS_PKG_INCLUDED_

//--------------------------------------------------------------------------------------------
// global pkg for all variables 
//--------------------------------------------------------------------------------------------
package i3c_globals_pkg;

  // NO_OF_SLAVES to be connected to the i3c_interface
  parameter int NO_OF_MASTERS = 1;

  // NO_OF_MASTERS to be connected to the i3c_interface
  parameter int NO_OF_SLAVES = 1;
  
  // The parameter NO_OF_REG is to assign number of registers in a slave
  parameter int NO_OF_REG = 1;
  
  // The parameter for the data width
  parameter int DATA_WIDTH = 8;
  
  // The parameter for the register address width
  // parameter int SLAVE_ADDRESS_WIDTH  = 10;
  
  // The parameter for the slave address width
  parameter int SLAVE_ADDRESS_WIDTH  = 7;
  
  // The parameter for the register address width
  parameter int REGISTER_ADDRESS_WIDTH  = 8;
  
  // The parameter for MAXIMUM_BITS supported per transfer
  parameter int MAXIMUM_BITS = 1024;
  
  // The parameter for MAXIMUM_BYTES supported per transfer
  parameter int MAXIMUM_BYTES = MAXIMUM_BITS/DATA_WIDTH ;
  
  // The parameter for Slave addresses
  parameter SLAVE0_ADDRESS = 7'b110_1000;  // 7'h68
  parameter SLAVE1_ADDRESS = 7'b110_1100;  // 7'h6C 
  parameter SLAVE2_ADDRESS = 7'b111_1100;  // 7'h7C
  parameter SLAVE3_ADDRESS = 7'b100_1100;  // 7'h4C
  
  // The parameter for enabling tristate buffer
  parameter bit TRISTATE_BUF_ON  = 1;

  // The parameter for disaling tristate buffer
  parameter bit TRISTATE_BUF_OFF = 0;
  
  parameter BUS_IDLE_TIME = 1;  // 200ns as per spec table 86
  parameter BUS_FREE_TIME = 1;  // 0.5us as per spec page no 365 Table 85
  // Enum: shift_direction_e
  // 
  // Specifies the shift direction
  //
  // LSB_FIRST - LSB is shifted out first
  // MSB_FIRST - MSB is shifted out first
  //
  typedef enum bit {
    MSB_FIRST = 1'b1,
    LSB_FIRST = 1'b0
  } shift_direction_e;
  
  
  // Enum: operationType_e
  // 
  // Specifies the read or write request
  // READ - READ request 
  // WRITE - WRITE request
  //
  typedef enum bit {
    WRITE = 1'b0,
    READ = 1'b1
  } operationType_e;
  
  // struct: i3c_bits_transfer_s
  // 
  // slave_address : array which holds the slave address  
  // read_write : specifies the read or write condition after the slave address
  // register_address : array which holds the register address 
  // no_of_sda_bits_transfer: specifies how many sda bits to trasnfer 
  // slave_add_ack : specifies the acknowledgement after receiving slave adddress  
  // reg_add_ack :specifies the acknowledgement after receiving reg address
  // wr_data_ack :specifies the acknowledgement after receiving data
  //
  typedef struct {
    bit [SLAVE_ADDRESS_WIDTH-1:0]slave_address;
    bit read_write;
    bit [DATA_WIDTH-1:0] wr_data[];
    bit [DATA_WIDTH-1:0] rd_data[];
    int size;
    bit ack;
    int no_of_i3c_bits_transfer; 
    bit slave_add_ack;
    bit reg_add_ack;
    bit [MAXIMUM_BYTES-1:0] wr_data_ack;
    bit [REGISTER_ADDRESS_WIDTH-1:0]register_address;
   } i3c_transfer_bits_s;
  
  
  // struct: i3c_transfer_cfg_s
  // 
  // msb_first: specifies the shift direction
  // read_write : read from or write to slave 
  //
  typedef struct {
    bit msb_first;
    bit read_write;
    int baudrate_divisor;
    bit[SLAVE_ADDRESS_WIDTH-1:0] slave_address;
    bit [7:0]slave_memory[longint];
  } i3c_transfer_cfg_s;
  
  // TODO(mshariff): Comments 
  typedef enum int{
    IDLE,
    FREE,
    START, 
    ADDRESS,
    SLAVE_ADDR_ACK,
    WRITE_DATA,
    READ_DATA,
    SAMPLE_WRITE_DATA,
    STOP
  }i3c_fsm_state_e;

  
  // Enum: edge_detect_e
  //
  // Used for detecting the edge on the signal
  //
  // POSEDGE - posedge on the signal, the transition from 0->1
  // NEGEDGE - negedge on the signal, the transition from 0->1
  //
  typedef enum bit[1:0] {
    POSEDGE = 2'b01,
    NEGEDGE = 2'b10
  } edge_detect_e;

  // Enum: acknowledge_e
  //
  // Specifies the acknowledgement type
  //
  // POS_ACK - positive acknowledgement 
  // NEG_ACK - negative acknowledgement
  typedef enum bit {
    ACK = 1'b0,
    NACK = 1'b1
  } acknowledge_e;

endpackage : i3c_globals_pkg 

`endif


