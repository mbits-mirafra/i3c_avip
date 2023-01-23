//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This file contains macros used with the wb package.
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
//      the wb_configuration class.
//
  `define wb_CONFIGURATION_STRUCT \
typedef struct packed  { \
     uvmf_active_passive_t active_passive; \
     uvmf_initiator_responder_t initiator_responder; \
     } wb_configuration_s;

  `define wb_CONFIGURATION_TO_STRUCT_FUNCTION \
  virtual function wb_configuration_s to_struct();\
    wb_configuration_struct = \
       {\
       this.active_passive,\
       this.initiator_responder\
       };\
    return ( wb_configuration_struct );\
  endfunction

  `define wb_CONFIGURATION_FROM_STRUCT_FUNCTION \
  virtual function void from_struct(wb_configuration_s wb_configuration_struct);\
      {\
      this.active_passive,\
      this.initiator_responder  \
      } = wb_configuration_struct;\
  endfunction

// ****************************************************************************
// When changing the contents of this struct, be sure to update the to_monitor_struct
//      and from_monitor_struct methods of the wb_transaction class.
//
  `define wb_MONITOR_STRUCT typedef struct packed  { \
  wb_op_t op ; \
  bit [WB_DATA_WIDTH-1:0] data ; \
  bit [WB_ADDR_WIDTH-1:0] addr ; \
  bit [(WB_DATA_WIDTH/8)-1:0] byte_select ; \
     } wb_monitor_s;

  `define wb_TO_MONITOR_STRUCT_FUNCTION \
  virtual function wb_monitor_s to_monitor_struct();\
    wb_monitor_struct = \
            { \
            this.op , \
            this.data , \
            this.addr , \
            this.byte_select  \
            };\
    return ( wb_monitor_struct);\
  endfunction\

  `define wb_FROM_MONITOR_STRUCT_FUNCTION \
  virtual function void from_monitor_struct(wb_monitor_s wb_monitor_struct);\
            {\
            this.op , \
            this.data , \
            this.addr , \
            this.byte_select  \
            } = wb_monitor_struct;\
  endfunction

// ****************************************************************************
// When changing the contents of this struct, be sure to update the to_initiator_struct
//      and from_initiator_struct methods of the wb_transaction class.
//      Also update the comments in the driver BFM.
//
  `define wb_INITIATOR_STRUCT typedef struct packed  { \
  wb_op_t op ; \
  bit [WB_DATA_WIDTH-1:0] data ; \
  bit [WB_ADDR_WIDTH-1:0] addr ; \
  bit [(WB_DATA_WIDTH/8)-1:0] byte_select ; \
     } wb_initiator_s;

  `define wb_TO_INITIATOR_STRUCT_FUNCTION \
  virtual function wb_initiator_s to_initiator_struct();\
    wb_initiator_struct = \
           {\
           this.op , \
           this.data , \
           this.addr , \
           this.byte_select  \
           };\
    return ( wb_initiator_struct);\
  endfunction

  `define wb_FROM_INITIATOR_STRUCT_FUNCTION \
  virtual function void from_initiator_struct(wb_initiator_s wb_initiator_struct);\
           {\
           this.op , \
           this.data , \
           this.addr , \
           this.byte_select  \
           } = wb_initiator_struct;\
  endfunction

// ****************************************************************************
// When changing the contents of this struct, be sure to update the to_responder_struct
//      and from_responder_struct methods of the wb_transaction class.
//      Also update the comments in the driver BFM.
//
  `define wb_RESPONDER_STRUCT typedef struct packed  { \
  wb_op_t op ; \
  bit [WB_DATA_WIDTH-1:0] data ; \
  bit [WB_ADDR_WIDTH-1:0] addr ; \
  bit [(WB_DATA_WIDTH/8)-1:0] byte_select ; \
     } wb_responder_s;

  `define wb_TO_RESPONDER_STRUCT_FUNCTION \
  virtual function wb_responder_s to_responder_struct();\
    wb_responder_struct = \
           {\
           this.op , \
           this.data , \
           this.addr , \
           this.byte_select  \
           };\
    return ( wb_responder_struct);\
  endfunction

  `define wb_FROM_RESPONDER_STRUCT_FUNCTION \
  virtual function void from_responder_struct(wb_responder_s wb_responder_struct);\
           {\
           this.op , \
           this.data , \
           this.addr , \
           this.byte_select  \
           } = wb_responder_struct;\
  endfunction
// pragma uvmf custom additional begin
// pragma uvmf custom additional end
