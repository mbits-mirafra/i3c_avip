//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 15
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb interface agent
// Unit            : Interface Sequence Base
// File            : ahb_sequence_base.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This file contains the class used as the base class for all sequences
// for this interface.
//
// ****************************************************************************
// ****************************************************************************
class ahb_sequence_base extends uvmf_sequence_base #(.REQ(ahb_transaction),.RSP(ahb_transaction));

  `uvm_object_utils( ahb_sequence_base )

  // variables
  ahb_transaction req;
  ahb_transaction rsp;

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
