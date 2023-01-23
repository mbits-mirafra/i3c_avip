//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU_in interface agent
// Unit            : Interface UVM Driver
// File            : FPU_in_driver.svh
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
class FPU_in_driver  #(
      int FP_WIDTH = 32                                
      ) extends uvmf_driver_base #(
                   .CONFIG_T(FPU_in_configuration  #(
                             .FP_WIDTH(FP_WIDTH)                                
                             ) ),
                   .BFM_BIND_T(virtual FPU_in_driver_bfm  #(
                             .FP_WIDTH(FP_WIDTH)                                
                             ) ),
                   .REQ(FPU_in_transaction  #(
                             .FP_WIDTH(FP_WIDTH)                                
                             ) ),
                   .RSP(FPU_in_transaction  #(
                             .FP_WIDTH(FP_WIDTH)                                
                             ) ));

  `uvm_component_param_utils( FPU_in_driver #(
                              FP_WIDTH
                            ))

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
                txn.op,
                txn.rmode,
                txn.a,
                txn.b,
                txn.result        
          );
      end else begin    
        bfm.access(
                txn.op,
                txn.rmode,
                txn.a,
                txn.b,
                txn.result            );
    end
  endtask

endclass
