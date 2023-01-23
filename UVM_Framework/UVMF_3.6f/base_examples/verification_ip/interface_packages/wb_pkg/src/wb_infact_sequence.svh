//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : jcraft
// Creation Date   : 2016 Nov 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : wb interface agent
// Unit            : Interface infact sequence
// File            : wb_infact_sequence.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This sequences is a place holder for the infact sequence which will 
// reach full coverage for the wb transaction without redundancy.
//
// ****************************************************************************
// 
class wb_infact_sequence  #(
      int WB_ADDR_WIDTH = 32,                                
      int WB_DATA_WIDTH = 16                                
      ) extends wb_sequence_base  #(
                             .WB_ADDR_WIDTH(WB_ADDR_WIDTH),                                
                             .WB_DATA_WIDTH(WB_DATA_WIDTH)                                
                             ) ;

  `uvm_object_param_utils( wb_infact_sequence #(
                              WB_ADDR_WIDTH,
                              WB_DATA_WIDTH
                            ))

//*****************************************************************
  function new(string name = "");
    super.new(name);
  endfunction: new

endclass: wb_infact_sequence
//----------------------------------------------------------------------
//
