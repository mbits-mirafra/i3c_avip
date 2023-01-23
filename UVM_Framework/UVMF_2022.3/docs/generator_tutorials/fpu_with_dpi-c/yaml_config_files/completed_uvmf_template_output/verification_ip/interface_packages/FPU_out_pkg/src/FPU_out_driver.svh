//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU_out interface agent
// Unit            : Interface UVM Driver
// File            : FPU_out_driver.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class passes transactions between the sequencer
//        and the BFM driver interface.  It accesses the driver BFM 
//        through the bfm handle. This driver
//        passes transactions to the driver BFM through the access
//        task.  
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
class FPU_out_driver extends uvmf_driver_base #(
                   .CONFIG_T(FPU_out_configuration ),
                   .BFM_BIND_T(virtual FPU_out_driver_bfm ),
                   .REQ(FPU_out_transaction ),
                   .RSP(FPU_out_transaction ));

  `uvm_component_utils( FPU_out_driver )

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
//
  function new( string name = "", uvm_component parent=null );
    super.new( name, parent );
  endfunction

// ****************************************************************************
   virtual function void configure(input CONFIG_T cfg);
      bfm.configure(
          cfg.active_passive,
          cfg.initiator_responder
          );                    
   
   endfunction

// ****************************************************************************
   virtual function void set_bfm_proxy_handle();
      bfm.proxy = this;   endfunction

// ****************************************************************************              
  virtual task access( inout REQ txn );
      if (configuration.initiator_responder==RESPONDER) begin
        if (1'b0) begin
          bfm.do_response_ready(
                      );
        end
        bfm.response(
                txn.ine,
                txn.overflow,
                txn.underflow,
                txn.div_zero,
                txn.inf,
                txn.zero,
                txn.qnan,
                txn.snan        
          );
      end else begin    
        bfm.access(
                txn.ine,
                txn.overflow,
                txn.underflow,
                txn.div_zero,
                txn.inf,
                txn.zero,
                txn.qnan,
                txn.snan            );
    end
  endtask

endclass
