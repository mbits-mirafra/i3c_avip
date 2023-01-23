//----------------------------------------------------------------------
// Created with uvmf_gen version 2022.3
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This file contains macros used with the i3c_m package.
//   These macros include packed struct definitions.  These structs are
//   used to pass data between classes, hvl, and BFM's, hdl.  Use of 
//   structs are more efficient and simpler to modify.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//

// ****************************************************************************
// When changing the contents of this struct, be sure to update the to_struct
//      and from_struct methods defined in the macros below that are used in  
//      the i3c_m_configuration class.
//
  `define i3c_m_CONFIGURATION_STRUCT \
typedef struct packed  { \
     uvm_active_passive_enum is_active;\
     int no_of_slaves;\
     shift_direction_e shift_dir;\
     bit [SLAVE_ADDRESS_WIDTH-1:0] slave_address_array;\
     bit [7:0] slave_register_address_array;\
     bit [2:0] primary_prescalar;\
     bit [2:0] secondary_prescalar;\
     int baudrate_divisor;\
     bit has_coverage;\
     uvmf_active_passive_t active_passive; \
     uvmf_initiator_responder_t initiator_responder; \
     } i3c_m_configuration_s;

  `define i3c_m_CONFIGURATION_TO_STRUCT_FUNCTION \
  virtual function i3c_m_configuration_s to_struct();\
    i3c_m_configuration_struct = \
       {\
       this.is_active,\
       this.no_of_slaves,\
       this.shift_dir,\
       this.slave_address_array,\
       this.slave_register_address_array,\
       this.primary_prescalar,\
       this.secondary_prescalar,\
       this.baudrate_divisor,\
       this.has_coverage,\
       this.active_passive,\
       this.initiator_responder\
       };\
    return ( i3c_m_configuration_struct );\
  endfunction

  `define i3c_m_CONFIGURATION_FROM_STRUCT_FUNCTION \
  virtual function void from_struct(i3c_m_configuration_s i3c_m_configuration_struct);\
      {\
      this.is_active,\
      this.no_of_slaves,\
      this.shift_dir,\
      this.slave_address_array,\
      this.slave_register_address_array,\
      this.primary_prescalar,\
      this.secondary_prescalar,\
      this.baudrate_divisor,\
      this.has_coverage,\
      this.active_passive,\
      this.initiator_responder  \
      } = i3c_m_configuration_struct;\
  endfunction

// ****************************************************************************
// When changing the contents of this struct, be sure to update the to_monitor_struct
//      and from_monitor_struct methods of the i3c_m_transaction class.
//
  `define i3c_m_MONITOR_STRUCT typedef struct packed  { \
  read_write_e read_write ; \
  bit scl ; \
  bit sda ; \
  bit [DATA_WIDTH-1:0] wr_data ; \
  bit [DATA_WIDTH-1:0]  rd_data ; \
  bit [SLAVE_ADDRESS_WIDTH-1:0] slave_address ; \
  bit [REGISTER_ADDRESS_WIDTH-1:0] register_address ; \
  bit [31:0] size ; \
  bit ack ; \
  bit [NO_OF_SLAVES-1:0] index ; \
  bit [7:0] raddr ; \
  bit slave_add_ack ; \
  bit reg_add_ack ; \
  bit wr_data_ack ; \
     } i3c_m_monitor_s;

  `define i3c_m_TO_MONITOR_STRUCT_FUNCTION \
  virtual function i3c_m_monitor_s to_monitor_struct();\
    i3c_m_monitor_struct = \
            { \
            this.read_write , \
            this.scl , \
            this.sda , \
            this.wr_data , \
            this.rd_data , \
            this.slave_address , \
            this.register_address , \
            this.size , \
            this.ack , \
            this.index , \
            this.raddr , \
            this.slave_add_ack , \
            this.reg_add_ack , \
            this.wr_data_ack  \
            };\
    return ( i3c_m_monitor_struct);\
  endfunction\

  `define i3c_m_FROM_MONITOR_STRUCT_FUNCTION \
  virtual function void from_monitor_struct(i3c_m_monitor_s i3c_m_monitor_struct);\
            {\
            this.read_write , \
            this.scl , \
            this.sda , \
            this.wr_data , \
            this.rd_data , \
            this.slave_address , \
            this.register_address , \
            this.size , \
            this.ack , \
            this.index , \
            this.raddr , \
            this.slave_add_ack , \
            this.reg_add_ack , \
            this.wr_data_ack  \
            } = i3c_m_monitor_struct;\
  endfunction

// ****************************************************************************
// When changing the contents of this struct, be sure to update the to_initiator_struct
//      and from_initiator_struct methods of the i3c_m_transaction class.
//      Also update the comments in the driver BFM.
//
  `define i3c_m_INITIATOR_STRUCT typedef struct packed  { \
  read_write_e read_write ; \
  bit scl ; \
  bit sda ; \
  bit [DATA_WIDTH-1:0] wr_data ; \
  bit [DATA_WIDTH-1:0]  rd_data ; \
  bit [SLAVE_ADDRESS_WIDTH-1:0] slave_address ; \
  bit [REGISTER_ADDRESS_WIDTH-1:0] register_address ; \
  bit [31:0] size ; \
  bit ack ; \
  bit [NO_OF_SLAVES-1:0] index ; \
  bit [7:0] raddr ; \
  bit slave_add_ack ; \
  bit reg_add_ack ; \
  bit wr_data_ack ; \
     } i3c_m_initiator_s;

  `define i3c_m_TO_INITIATOR_STRUCT_FUNCTION \
  virtual function i3c_m_initiator_s to_initiator_struct();\
    i3c_m_initiator_struct = \
           {\
           this.read_write , \
           this.scl , \
           this.sda , \
           this.wr_data , \
           this.rd_data , \
           this.slave_address , \
           this.register_address , \
           this.size , \
           this.ack , \
           this.index , \
           this.raddr , \
           this.slave_add_ack , \
           this.reg_add_ack , \
           this.wr_data_ack  \
           };\
    return ( i3c_m_initiator_struct);\
  endfunction

  `define i3c_m_FROM_INITIATOR_STRUCT_FUNCTION \
  virtual function void from_initiator_struct(i3c_m_initiator_s i3c_m_initiator_struct);\
           {\
           this.read_write , \
           this.scl , \
           this.sda , \
           this.wr_data , \
           this.rd_data , \
           this.slave_address , \
           this.register_address , \
           this.size , \
           this.ack , \
           this.index , \
           this.raddr , \
           this.slave_add_ack , \
           this.reg_add_ack , \
           this.wr_data_ack  \
           } = i3c_m_initiator_struct;\
  endfunction

// ****************************************************************************
// When changing the contents of this struct, be sure to update the to_responder_struct
//      and from_responder_struct methods of the i3c_m_transaction class.
//      Also update the comments in the driver BFM.
//
  `define i3c_m_RESPONDER_STRUCT typedef struct packed  { \
  read_write_e read_write ; \
  bit scl ; \
  bit sda ; \
  bit [DATA_WIDTH-1:0] wr_data ; \
  bit [DATA_WIDTH-1:0]  rd_data ; \
  bit [SLAVE_ADDRESS_WIDTH-1:0] slave_address ; \
  bit [REGISTER_ADDRESS_WIDTH-1:0] register_address ; \
  bit [31:0] size ; \
  bit ack ; \
  bit [NO_OF_SLAVES-1:0] index ; \
  bit [7:0] raddr ; \
  bit slave_add_ack ; \
  bit reg_add_ack ; \
  bit wr_data_ack ; \
     } i3c_m_responder_s;

  `define i3c_m_TO_RESPONDER_STRUCT_FUNCTION \
  virtual function i3c_m_responder_s to_responder_struct();\
    i3c_m_responder_struct = \
           {\
           this.read_write , \
           this.scl , \
           this.sda , \
           this.wr_data , \
           this.rd_data , \
           this.slave_address , \
           this.register_address , \
           this.size , \
           this.ack , \
           this.index , \
           this.raddr , \
           this.slave_add_ack , \
           this.reg_add_ack , \
           this.wr_data_ack  \
           };\
    return ( i3c_m_responder_struct);\
  endfunction

  `define i3c_m_FROM_RESPONDER_STRUCT_FUNCTION \
  virtual function void from_responder_struct(i3c_m_responder_s i3c_m_responder_struct);\
           {\
           this.read_write , \
           this.scl , \
           this.sda , \
           this.wr_data , \
           this.rd_data , \
           this.slave_address , \
           this.register_address , \
           this.size , \
           this.ack , \
           this.index , \
           this.raddr , \
           this.slave_add_ack , \
           this.reg_add_ack , \
           this.wr_data_ack  \
           } = i3c_m_responder_struct;\
  endfunction
// pragma uvmf custom additional begin
// pragma uvmf custom additional end
