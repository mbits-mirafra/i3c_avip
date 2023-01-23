//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : shwetapatil
// Creation Date   : 2022 Jun 06
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : mem interface agent
// Unit            : Interface infact sequence
// File            : mem_infact_sequence.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This sequences is a place holder for the infact sequence which will 
// reach full coverage for the mem transaction without redundancy.
//
// ****************************************************************************
// 
class mem_infact_sequence  #(
      int DATA_WIDTH = 32,                                
      int ADDR_WIDTH = 32                                
      ) extends mem_sequence_base  #(
                             .DATA_WIDTH(DATA_WIDTH),                                
                             .ADDR_WIDTH(ADDR_WIDTH)                                
                             ) ;

  `uvm_object_param_utils( mem_infact_sequence #(
                              DATA_WIDTH,
                              ADDR_WIDTH
                            ))

//*****************************************************************
  function new(string name = "");
    super.new(name);
  endfunction: new

endclass: mem_infact_sequence
//----------------------------------------------------------------------
//
