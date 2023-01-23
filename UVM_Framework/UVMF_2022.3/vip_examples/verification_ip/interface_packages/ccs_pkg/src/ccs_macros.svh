//----------------------------------------------------------------------
// Created with uvmf_gen version 2021.1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This file contains macros used with the ccs package.
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
//      the ccs_configuration class.
//
  `define ccs_CONFIGURATION_STRUCT \
typedef struct packed  { \
     bit [2:0] protocol_kind;\
     bit reset_polarity;\
     uvmf_active_passive_t active_passive; \
     uvmf_initiator_responder_t initiator_responder; \
     } ccs_configuration_s;

  `define ccs_CONFIGURATION_TO_STRUCT_FUNCTION \
  virtual function ccs_configuration_s to_struct();\
    ccs_configuration_struct = \
       {\
       this.protocol_kind,\
       this.reset_polarity,\
       this.active_passive,\
       this.initiator_responder\
       };\
    return ( ccs_configuration_struct );\
  endfunction

  `define ccs_CONFIGURATION_FROM_STRUCT_FUNCTION \
  virtual function void from_struct(ccs_configuration_s ccs_configuration_struct);\
      {\
      this.protocol_kind,\
      this.reset_polarity,\
      this.active_passive,\
      this.initiator_responder  \
      } = ccs_configuration_struct;\
  endfunction

// ****************************************************************************
// When changing the contents of this struct, be sure to update the to_monitor_struct
//      and from_monitor_struct methods of the ccs_transaction class.
//
  `define ccs_MONITOR_STRUCT typedef struct packed  { \
  bit [WIDTH-1:0] rtl_data ; \
  int unsigned wait_cycles ; \
  int unsigned iteration_count ; \
  bit empty ; \
     } ccs_monitor_s;

  `define ccs_TO_MONITOR_STRUCT_FUNCTION \
  virtual function ccs_monitor_s to_monitor_struct();\
    ccs_monitor_struct = \
            { \
            this.rtl_data , \
            this.wait_cycles , \
            this.iteration_count , \
            this.empty  \
            };\
    return ( ccs_monitor_struct);\
  endfunction\

  `define ccs_FROM_MONITOR_STRUCT_FUNCTION \
  virtual function void from_monitor_struct(ccs_monitor_s ccs_monitor_struct);\
            {\
            this.rtl_data , \
            this.wait_cycles , \
            this.iteration_count , \
            this.empty  \
            } = ccs_monitor_struct;\
  endfunction

// ****************************************************************************
// When changing the contents of this struct, be sure to update the to_initiator_struct
//      and from_initiator_struct methods of the ccs_transaction class.
//      Also update the comments in the driver BFM.
//
  `define ccs_INITIATOR_STRUCT typedef struct packed  { \
  bit [WIDTH-1:0] rtl_data ; \
  int unsigned wait_cycles ; \
  int unsigned iteration_count ; \
  bit empty ; \
     } ccs_initiator_s;

  `define ccs_TO_INITIATOR_STRUCT_FUNCTION \
  virtual function ccs_initiator_s to_initiator_struct();\
    ccs_initiator_struct = \
           {\
           this.rtl_data , \
           this.wait_cycles , \
           this.iteration_count , \
           this.empty  \
           };\
    return ( ccs_initiator_struct);\
  endfunction

  `define ccs_FROM_INITIATOR_STRUCT_FUNCTION \
  virtual function void from_initiator_struct(ccs_initiator_s ccs_initiator_struct);\
           {\
           this.rtl_data , \
           this.wait_cycles , \
           this.iteration_count , \
           this.empty  \
           } = ccs_initiator_struct;\
  endfunction

// ****************************************************************************
// When changing the contents of this struct, be sure to update the to_responder_struct
//      and from_responder_struct methods of the ccs_transaction class.
//      Also update the comments in the driver BFM.
//
  `define ccs_RESPONDER_STRUCT typedef struct packed  { \
  bit [WIDTH-1:0] rtl_data ; \
  int unsigned wait_cycles ; \
  int unsigned iteration_count ; \
  bit empty ; \
     } ccs_responder_s;

  `define ccs_TO_RESPONDER_STRUCT_FUNCTION \
  virtual function ccs_responder_s to_responder_struct();\
    ccs_responder_struct = \
           {\
           this.rtl_data , \
           this.wait_cycles , \
           this.iteration_count , \
           this.empty  \
           };\
    return ( ccs_responder_struct);\
  endfunction

  `define ccs_FROM_RESPONDER_STRUCT_FUNCTION \
  virtual function void from_responder_struct(ccs_responder_s ccs_responder_struct);\
           {\
           this.rtl_data , \
           this.wait_cycles , \
           this.iteration_count , \
           this.empty  \
           } = ccs_responder_struct;\
  endfunction
// pragma uvmf custom additional begin
// pragma uvmf custom additional end
