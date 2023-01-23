//----------------------------------------------------------------------
// Created with uvmf_gen version 2020.2
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This file contains macros used with the ALU_out package.
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
//      the ALU_out_configuration class.
//
  `define ALU_out_CONFIGURATION_STRUCT \
typedef struct packed  { \
     uvmf_active_passive_t active_passive; \
     uvmf_initiator_responder_t initiator_responder; \
     } ALU_out_configuration_s;

  `define ALU_out_CONFIGURATION_TO_STRUCT_FUNCTION \
  virtual function ALU_out_configuration_s to_struct();\
    ALU_out_configuration_struct = \
       {\
       this.active_passive,\
       this.initiator_responder\
       };\
    return ( ALU_out_configuration_struct );\
  endfunction

  `define ALU_out_CONFIGURATION_FROM_STRUCT_FUNCTION \
  virtual function void from_struct(ALU_out_configuration_s ALU_out_configuration_struct);\
      {\
      this.active_passive,\
      this.initiator_responder  \
      } = ALU_out_configuration_struct;\
  endfunction

// ****************************************************************************
// When changing the contents of this struct, be sure to update the to_monitor_struct
//      and from_monitor_struct methods of the ALU_out_transaction class.
//
  `define ALU_out_MONITOR_STRUCT typedef struct packed  { \
  bit [ALU_OUT_RESULT_WIDTH-1:0] result ; \
     } ALU_out_monitor_s;

  `define ALU_out_TO_MONITOR_STRUCT_FUNCTION \
  virtual function ALU_out_monitor_s to_monitor_struct();\
    ALU_out_monitor_struct = \
            { \
            this.result  \
            };\
    return ( ALU_out_monitor_struct);\
  endfunction\

  `define ALU_out_FROM_MONITOR_STRUCT_FUNCTION \
  virtual function void from_monitor_struct(ALU_out_monitor_s ALU_out_monitor_struct);\
            {\
            this.result  \
            } = ALU_out_monitor_struct;\
  endfunction

// ****************************************************************************
// When changing the contents of this struct, be sure to update the to_initiator_struct
//      and from_initiator_struct methods of the ALU_out_transaction class.
//      Also update the comments in the driver BFM.
//
  `define ALU_out_INITIATOR_STRUCT typedef struct packed  { \
  bit [ALU_OUT_RESULT_WIDTH-1:0] result ; \
     } ALU_out_initiator_s;

  `define ALU_out_TO_INITIATOR_STRUCT_FUNCTION \
  virtual function ALU_out_initiator_s to_initiator_struct();\
    ALU_out_initiator_struct = \
           {\
           this.result  \
           };\
    return ( ALU_out_initiator_struct);\
  endfunction

  `define ALU_out_FROM_INITIATOR_STRUCT_FUNCTION \
  virtual function void from_initiator_struct(ALU_out_initiator_s ALU_out_initiator_struct);\
           {\
           this.result  \
           } = ALU_out_initiator_struct;\
  endfunction

// ****************************************************************************
// When changing the contents of this struct, be sure to update the to_responder_struct
//      and from_responder_struct methods of the ALU_out_transaction class.
//      Also update the comments in the driver BFM.
//
  `define ALU_out_RESPONDER_STRUCT typedef struct packed  { \
  bit [ALU_OUT_RESULT_WIDTH-1:0] result ; \
     } ALU_out_responder_s;

  `define ALU_out_TO_RESPONDER_STRUCT_FUNCTION \
  virtual function ALU_out_responder_s to_responder_struct();\
    ALU_out_responder_struct = \
           {\
           this.result  \
           };\
    return ( ALU_out_responder_struct);\
  endfunction

  `define ALU_out_FROM_RESPONDER_STRUCT_FUNCTION \
  virtual function void from_responder_struct(ALU_out_responder_s ALU_out_responder_struct);\
           {\
           this.result  \
           } = ALU_out_responder_struct;\
  endfunction
// pragma uvmf custom additional begin
// pragma uvmf custom additional end
