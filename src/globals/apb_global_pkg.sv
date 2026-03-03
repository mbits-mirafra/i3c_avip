`ifndef APB_GLOBAL_PKG_INCLUDED_
`define APB_GLOBAL_PKG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Package : apb_global_pkg
//  Used for storing required enums, parameters and defines
//--------------------------------------------------------------------------------------------
package apb_global_pkg;

  //Parameter : NO_OF_SLAVES
  //Used to set number of slaves required
  parameter int NO_OF_SLAVES = 1;

  //Parameter : MASTER_AGENT_ACTIVE
  //Used to set the master agent either active or passive
  parameter bit MASTER_AGENT_ACTIVE = 1;

  //Parameter : SLAVE_AGENT_ACTIVE
  //Used to set the slave agent either active or passive
  parameter bit SLAVE_AGENT_ACTIVE = 1;

  //Parameter : ADDRESS_WIDTH
  //Used to set the address width to the address bus
  //Maximum Value is 32
  parameter int ADDRESS_WIDTH = 32;

  //Parameter : DATA_WIDTH
  //Used to set the data width 
  //Maximum Value is 8
  parameter int DATA_WIDTH = 32;

  //Parameter : SLAVE_MEMORY_SIZE
  //Sets the memory size of the slave in KB
  parameter int SLAVE_MEMORY_SIZE = 12;

  //Parameter : SLAVE_MEMORY_GAP
  //Sets the memory gap size of the slave
  parameter int SLAVE_MEMORY_GAP = 5;

  //Parameter : MEMORY_WIDTH
  //Sets the width it can store in each loaction
  parameter int MEMORY_WIDTH = 8;

  //-------------------------------------------------------
  // Enum : transfer_size_e
  //  Used to declare enum type for all transfer sizes
  //-------------------------------------------------------
  typedef enum bit[31:0]{
    BIT_8  = 32'd8,
    BIT_16 = 32'd16,
    BIT_24 = 32'd24,
    BIT_32 = 32'd32
  }transfer_size_e;

  //-------------------------------------------------------
  // Enum : slave_error_e
  //  Used to declare enum type for the pslverr
  //-------------------------------------------------------
  typedef enum bit{
    NO_ERROR = 1'b0,
    ERROR    = 1'b1
  }slave_error_e;

  //-------------------------------------------------------
  // Enum : endian_e
  //  Used to declare enum type for the endians
  //-------------------------------------------------------
  typedef enum bit{
    LITTL_ENDIAN = 1'b0,
    BIG_ENDIAN   = 1'b1
  }endian_e;

  //-------------------------------------------------------
  // Enum : tx_type_e 
  //  Used to declare the type of transaction done
  //-------------------------------------------------------
  typedef enum bit{
    WRITE = 1'b1,
    READ  = 1'b0 
  }tx_type_e; 

  //-------------------------------------------------------
  // Enum : apb_fsm_state_e
  //  Used to declare the type of fsm state
  //-------------------------------------------------------
  typedef enum bit[2:0] {
    NO_STATE,
    IDLE,
    SETUP,
    ACCESS,
    WAIT_STATE
  }apb_fsm_state_e; 

  //-------------------------------------------------------
  // Enum : protection_type_e 
  //  Used to declare the type of protection of the 
  //  transaction
  //-------------------------------------------------------
  typedef enum logic[2:0]{
    NORMAL_SECURE_DATA              = 3'b000,
    NORMAL_SECURE_INSTRUCTION       = 3'b001,
    NORMAL_NONSECURE_DATA           = 3'b010,
    NORMAL_NONSECURE_INSTRUCTION    = 3'b011,
    PRIVILEGED_SECURE_DATA          = 3'b100,
    PRIVILEGED_SECURE_INSTRUCTION   = 3'b101,
    PRIVILEGED_NONSECURE_DATA       = 3'b110,
    PRIVILEGED_NONSECURE_INSTUCTION = 3'b111
  }protection_type_e;

  //-------------------------------------------------------
  // Enum : slave_no_e
  //  Used to declare the slave number by assigning the 
  //  value for encoding
  //-------------------------------------------------------
  typedef enum bit [15:0]{
    SLAVE_0  = 16'b0000_0000_0000_0001,
    SLAVE_1  = 16'b0000_0000_0000_0010,
    SLAVE_2  = 16'b0000_0000_0000_0100,
    SLAVE_3  = 16'b0000_0000_0000_1000,
    SLAVE_4  = 16'b0000_0000_0001_0000,
    SLAVE_5  = 16'b0000_0000_0010_0000,
    SLAVE_6  = 16'b0000_0000_0100_0000,
    SLAVE_7  = 16'b0000_0000_1000_0000,
    SLAVE_8  = 16'b0000_0001_0000_0000,
    SLAVE_9  = 16'b0000_0010_0000_0000,
    SLAVE_10 = 16'b0000_0100_0000_0000,
    SLAVE_11 = 16'b0000_1000_0000_0000,
    SLAVE_12 = 16'b0001_0000_0000_0000,
    SLAVE_13 = 16'b0010_0000_0000_0000,
    SLAVE_14 = 16'b0100_0000_0000_0000,
    SLAVE_15 = 16'b1000_0000_0000_0000
  }slave_no_e;

  //-------------------------------------------------------
  // Struct : apb_transfer_char_s
  //  This struct datatype consists of all signals which 
  //  are used for seq item conversion
  //-------------------------------------------------------
  typedef struct{
    bit pwrite;
    bit pslverr;
    bit [2:0]pprot;
    bit [NO_OF_SLAVES-1:0]pselx;
    bit [(DATA_WIDTH/8)-1:0]pstrb;
    bit [DATA_WIDTH-1:0]prdata;
    bit [ADDRESS_WIDTH-1:0]paddr; 
    bit [DATA_WIDTH-1:0]pwdata;
    int no_of_wait_states;
  }apb_transfer_char_s;
  
  //-------------------------------------------------------
  // Struct : apb_cfg_char_s
  //  This struct datatype consists of all configurations
  //  which are used for seq item conversion
  //-------------------------------------------------------
  typedef struct{
    bit [ADDRESS_WIDTH-1:0]min_address;
    bit [ADDRESS_WIDTH-1:0]max_address;
    bit [ADDRESS_WIDTH-1:0]paddr;
    int slave_id;
  }apb_transfer_cfg_s;

endpackage : apb_global_pkg

`endif
