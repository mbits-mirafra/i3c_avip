//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This file contains macros used with the ahb package.
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
//      the ahb_configuration class.
//
  `define ahb_CONFIGURATION_STRUCT \
typedef struct packed  { \
     uvmf_active_passive_t active_passive; \
     uvmf_initiator_responder_t initiator_responder; \
     } ahb_configuration_s;

  `define ahb_CONFIGURATION_TO_STRUCT_FUNCTION \
  virtual function ahb_configuration_s to_struct();\
    ahb_configuration_struct = \
       {\
       this.active_passive,\
       this.initiator_responder\
       };\
    return ( ahb_configuration_struct );\
  endfunction

  `define ahb_CONFIGURATION_FROM_STRUCT_FUNCTION \
  virtual function void from_struct(ahb_configuration_s ahb_configuration_struct);\
      {\
      this.active_passive,\
      this.initiator_responder  \
      } = ahb_configuration_struct;\
  endfunction

// ****************************************************************************
// When changing the contents of this struct, be sure to update the to_monitor_struct
//      and from_monitor_struct methods of the ahb_transaction class.
//
  `define ahb_MONITOR_STRUCT typedef struct packed  { \
  ahb_op_t op ; \
  bit [15:0] data ; \
  bit [31:0] addr ; \
     } ahb_monitor_s;

  `define ahb_TO_MONITOR_STRUCT_FUNCTION \
  virtual function ahb_monitor_s to_monitor_struct();\
    ahb_monitor_struct = \
            { \
            this.op , \
            this.data , \
            this.addr  \
            };\
    return ( ahb_monitor_struct);\
  endfunction\

  `define ahb_FROM_MONITOR_STRUCT_FUNCTION \
  virtual function void from_monitor_struct(ahb_monitor_s ahb_monitor_struct);\
            {\
            this.op , \
            this.data , \
            this.addr  \
            } = ahb_monitor_struct;\
  endfunction

// ****************************************************************************
// When changing the contents of this struct, be sure to update the to_initiator_struct
//      and from_initiator_struct methods of the ahb_transaction class.
//      Also update the comments in the driver BFM.
//
  `define ahb_INITIATOR_STRUCT typedef struct packed  { \
  ahb_op_t op ; \
  bit [15:0] data ; \
  bit [31:0] addr ; \
     } ahb_initiator_s;

  `define ahb_TO_INITIATOR_STRUCT_FUNCTION \
  virtual function ahb_initiator_s to_initiator_struct();\
    ahb_initiator_struct = \
           {\
           this.op , \
           this.data , \
           this.addr  \
           };\
    return ( ahb_initiator_struct);\
  endfunction

  `define ahb_FROM_INITIATOR_STRUCT_FUNCTION \
  virtual function void from_initiator_struct(ahb_initiator_s ahb_initiator_struct);\
           {\
           this.op , \
           this.data , \
           this.addr  \
           } = ahb_initiator_struct;\
  endfunction

// ****************************************************************************
// When changing the contents of this struct, be sure to update the to_responder_struct
//      and from_responder_struct methods of the ahb_transaction class.
//      Also update the comments in the driver BFM.
//
  `define ahb_RESPONDER_STRUCT typedef struct packed  { \
  ahb_op_t op ; \
  bit [15:0] data ; \
  bit [31:0] addr ; \
     } ahb_responder_s;

  `define ahb_TO_RESPONDER_STRUCT_FUNCTION \
  virtual function ahb_responder_s to_responder_struct();\
    ahb_responder_struct = \
           {\
           this.op , \
           this.data , \
           this.addr  \
           };\
    return ( ahb_responder_struct);\
  endfunction

  `define ahb_FROM_RESPONDER_STRUCT_FUNCTION \
  virtual function void from_responder_struct(ahb_responder_s ahb_responder_struct);\
           {\
           this.op , \
           this.data , \
           this.addr  \
           } = ahb_responder_struct;\
  endfunction
// pragma uvmf custom additional begin
// pragma uvmf custom additional end
