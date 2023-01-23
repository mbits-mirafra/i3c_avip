//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : shwetapatil
// Creation Date   : 2022 Jun 06
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : apb_if interface agent
// Unit            : Interface UVM Driver
// File            : apb_if_driver.svh
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
class apb_if_driver  #(
      int DATA_WIDTH = 32,                                
      int ADDR_WIDTH = 32                                
      ) extends uvmf_driver_base #(
                   .CONFIG_T(apb_if_configuration  #(
                             .DATA_WIDTH(DATA_WIDTH),                                
                             .ADDR_WIDTH(ADDR_WIDTH)                                
                             ) ),
                   .BFM_BIND_T(virtual apb_if_driver_bfm #(
                             .DATA_WIDTH(DATA_WIDTH),                                
                             .ADDR_WIDTH(ADDR_WIDTH)                                
                             ) ),
                   .REQ(apb_if_transaction  #(
                             .DATA_WIDTH(DATA_WIDTH),                                
                             .ADDR_WIDTH(ADDR_WIDTH)                                
                             ) ),
                   .RSP(apb_if_transaction  #(
                             .DATA_WIDTH(DATA_WIDTH),                                
                             .ADDR_WIDTH(ADDR_WIDTH)                                
                             ) ));

  `uvm_component_param_utils( apb_if_driver #(
                              DATA_WIDTH,
                              ADDR_WIDTH
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
          ,cfg.transfer_size
);                    
   
   endfunction

// ****************************************************************************
   virtual function void set_bfm_proxy_handle();
      bfm.proxy = this;
   endfunction

// ****************************************************************************              
  virtual task access( inout REQ txn );
      if (configuration.initiator_responder==RESPONDER) begin
        if (1'b1) begin
          bfm.do_response_ready(
                      );
        end
        bfm.response(
      txn.prdata,
      txn.pwdata,
      txn.paddr,
      txn.pprot,
      txn.pselx        
          );
      end else begin    
        bfm.access(
      txn.prdata,
      txn.pwdata,
      txn.paddr,
      txn.pprot,
      txn.pselx            );
    end
  endtask

endclass
