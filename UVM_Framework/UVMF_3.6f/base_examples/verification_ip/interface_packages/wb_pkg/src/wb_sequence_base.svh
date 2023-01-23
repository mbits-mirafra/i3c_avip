//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : jcraft
// Creation Date   : 2016 Nov 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : wb interface agent
// Unit            : Interface Sequence Base
// File            : wb_sequence_base.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This file contains the class used as the base class for all sequences
// for this interface.
//
// ****************************************************************************
// ****************************************************************************
class wb_sequence_base  #(
      int WB_ADDR_WIDTH = 32,                                
      int WB_DATA_WIDTH = 16                                
      ) extends uvmf_sequence_base #(
                             .REQ(wb_transaction  #(
                                 .WB_ADDR_WIDTH(WB_ADDR_WIDTH),                                
                                 .WB_DATA_WIDTH(WB_DATA_WIDTH)                                
                             ) ),
                             .RSP(wb_transaction  #(
                                 .WB_ADDR_WIDTH(WB_ADDR_WIDTH),                                
                                 .WB_DATA_WIDTH(WB_DATA_WIDTH)                                
                             ) ));

  `uvm_object_param_utils( wb_sequence_base #(
                              WB_ADDR_WIDTH,
                              WB_DATA_WIDTH
                            ))

  // variables
  wb_transaction  #(
                     .WB_ADDR_WIDTH(WB_ADDR_WIDTH),                                
                     .WB_DATA_WIDTH(WB_DATA_WIDTH)                                
                     )  req;
  wb_transaction  #(
                     .WB_ADDR_WIDTH(WB_ADDR_WIDTH),                                
                     .WB_DATA_WIDTH(WB_DATA_WIDTH)                                
                     )  rsp;

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
//
  function new( string name ="");
    super.new( name );
  endfunction

endclass
//----------------------------------------------------------------------
//
