//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This file contains macros used with the spi package.
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
//      the spi_configuration class.
//
  `define spi_CONFIGURATION_STRUCT \
typedef struct packed  { \
     uvmf_active_passive_t active_passive; \
     uvmf_initiator_responder_t initiator_responder; \
     } spi_configuration_s;

  `define spi_CONFIGURATION_TO_STRUCT_FUNCTION \
  virtual function spi_configuration_s to_struct();\
    spi_configuration_struct = \
       {\
       this.active_passive,\
       this.initiator_responder\
       };\
    return ( spi_configuration_struct );\
  endfunction

  `define spi_CONFIGURATION_FROM_STRUCT_FUNCTION \
  virtual function void from_struct(spi_configuration_s spi_configuration_struct);\
      {\
      this.active_passive,\
      this.initiator_responder  \
      } = spi_configuration_struct;\
  endfunction

// ****************************************************************************
// When changing the contents of this struct, be sure to update the to_monitor_struct
//      and from_monitor_struct methods of the spi_transaction class.
//
  `define spi_MONITOR_STRUCT typedef struct packed  { \
  spi_dir_t dir ; \
  bit [7:0] mosi_data ; \
  bit [7:0] miso_data ; \
     } spi_monitor_s;

  `define spi_TO_MONITOR_STRUCT_FUNCTION \
  virtual function spi_monitor_s to_monitor_struct();\
    spi_monitor_struct = \
            { \
            this.dir , \
            this.mosi_data , \
            this.miso_data  \
            };\
    return ( spi_monitor_struct);\
  endfunction\

  `define spi_FROM_MONITOR_STRUCT_FUNCTION \
  virtual function void from_monitor_struct(spi_monitor_s spi_monitor_struct);\
            {\
            this.dir , \
            this.mosi_data , \
            this.miso_data  \
            } = spi_monitor_struct;\
  endfunction

// ****************************************************************************
// When changing the contents of this struct, be sure to update the to_initiator_struct
//      and from_initiator_struct methods of the spi_transaction class.
//      Also update the comments in the driver BFM.
//
  `define spi_INITIATOR_STRUCT typedef struct packed  { \
  spi_dir_t dir ; \
  bit [7:0] mosi_data ; \
  bit [7:0] miso_data ; \
     } spi_initiator_s;

  `define spi_TO_INITIATOR_STRUCT_FUNCTION \
  virtual function spi_initiator_s to_initiator_struct();\
    spi_initiator_struct = \
           {\
           this.dir , \
           this.mosi_data , \
           this.miso_data  \
           };\
    return ( spi_initiator_struct);\
  endfunction

  `define spi_FROM_INITIATOR_STRUCT_FUNCTION \
  virtual function void from_initiator_struct(spi_initiator_s spi_initiator_struct);\
           {\
           this.dir , \
           this.mosi_data , \
           this.miso_data  \
           } = spi_initiator_struct;\
  endfunction

// ****************************************************************************
// When changing the contents of this struct, be sure to update the to_responder_struct
//      and from_responder_struct methods of the spi_transaction class.
//      Also update the comments in the driver BFM.
//
  `define spi_RESPONDER_STRUCT typedef struct packed  { \
  spi_dir_t dir ; \
  bit [7:0] mosi_data ; \
  bit [7:0] miso_data ; \
     } spi_responder_s;

  `define spi_TO_RESPONDER_STRUCT_FUNCTION \
  virtual function spi_responder_s to_responder_struct();\
    spi_responder_struct = \
           {\
           this.dir , \
           this.mosi_data , \
           this.miso_data  \
           };\
    return ( spi_responder_struct);\
  endfunction

  `define spi_FROM_RESPONDER_STRUCT_FUNCTION \
  virtual function void from_responder_struct(spi_responder_s spi_responder_struct);\
           {\
           this.dir , \
           this.mosi_data , \
           this.miso_data  \
           } = spi_responder_struct;\
  endfunction
// pragma uvmf custom additional begin
// pragma uvmf custom additional end
