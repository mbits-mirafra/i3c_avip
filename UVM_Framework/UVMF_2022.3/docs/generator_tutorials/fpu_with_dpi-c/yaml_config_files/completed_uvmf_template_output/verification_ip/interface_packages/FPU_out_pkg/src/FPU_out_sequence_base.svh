//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU_out interface agent
// Unit            : Interface Sequence Base
// File            : FPU_out_sequence_base.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This file contains the class used as the base class for all sequences
// for this interface.
//
// ****************************************************************************
// ****************************************************************************
class FPU_out_sequence_base extends uvmf_sequence_base #(
                             .REQ(FPU_out_transaction ),
                             .RSP(FPU_out_transaction ));

  `uvm_object_utils( FPU_out_sequence_base )

  // variables
  typedef FPU_out_transaction  FPU_out_transaction_req_t;
FPU_out_transaction_req_t req;
  typedef FPU_out_transaction  FPU_out_transaction_rsp_t;
FPU_out_transaction_rsp_t rsp;

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
         `uvm_info("SEQ", {"New response transaction:",rsp.convert2string()}, UVM_MEDIUM)
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
// TASK : body()
// This task is called automatically when start is called.  This sequence sends
// a req sequence item to the sequencer identified as an argument in the call
// to start.
//
virtual task body();
	start_item(req);
	finish_item(req);
endtask

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
//
  function new( string name ="");
    super.new( name );
    req = FPU_out_transaction_req_t::type_id::create("req");
    rsp = FPU_out_transaction_rsp_t::type_id::create("rsp");
  endfunction

endclass
//----------------------------------------------------------------------
//
