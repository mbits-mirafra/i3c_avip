//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : shwetapatil
// Creation Date   : 2022 Jun 06
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : apb_if interface agent
// Unit            : Interface Sequence Base
// File            : apb_if_sequence_base.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This file contains the class used as the base class for all sequences
// for this interface.
//
// ****************************************************************************
// ****************************************************************************
class apb_if_sequence_base  #(
      int DATA_WIDTH = 32,                                
      int ADDR_WIDTH = 32                                
      ) extends uvmf_sequence_base #(
                             .REQ(apb_if_transaction  #(
                                 .DATA_WIDTH(DATA_WIDTH),                                
                                 .ADDR_WIDTH(ADDR_WIDTH)                                
                             ) ),
                             .RSP(apb_if_transaction  #(
                                 .DATA_WIDTH(DATA_WIDTH),                                
                                 .ADDR_WIDTH(ADDR_WIDTH)                                
                             ) ));

  `uvm_object_param_utils( apb_if_sequence_base #(
                              DATA_WIDTH,
                              ADDR_WIDTH
                            ))

  // variables
  apb_if_transaction  #(
                     .DATA_WIDTH(DATA_WIDTH),                                
                     .ADDR_WIDTH(ADDR_WIDTH)                                
                     )  req;
  apb_if_transaction  #(
                     .DATA_WIDTH(DATA_WIDTH),                                
                     .ADDR_WIDTH(ADDR_WIDTH)                                
                     )  rsp;

// Event for identifying when a response was received from the sequencer
event new_rsp;
// ****************************************************************************
// TASK : get_responses()
// This task recursively gets sequence item responses from the sequencer.
//
virtual task get_responses();
   fork
      begin
         // Block until new rsp available
         get_response(rsp);
         // New rsp received.  Indicate to sequence using event.
         ->new_rsp;
         // Display the received response transaction
         `uvm_info("NEW_RSP", {"New response transaction:",rsp.convert2string()}, UVM_MEDIUM)
      end
   join_none
endtask

// ****************************************************************************
// TASK : pre_body()
// This task is called automatically when start is called with call_pre_post set to 1 (default).
// By calling get_responses() within pre_body() any derived sequences are automatically 
// processing response transactions.
//
virtual task pre_body();
   get_responses();
endtask

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
