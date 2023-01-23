//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : jcraft
// Creation Date   : 2016 Nov 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : wb interface agent
// Unit            : Interface UVM Driver
// File            : wb_driver.svh
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
class wb_driver  #(
      int WB_ADDR_WIDTH = 32,                                
      int WB_DATA_WIDTH = 16                                
      ) extends uvmf_driver_base #(
                   .CONFIG_T(wb_configuration  #(
                             .WB_ADDR_WIDTH(WB_ADDR_WIDTH),                                
                             .WB_DATA_WIDTH(WB_DATA_WIDTH)                                
                             ) ),
                   .BFM_BIND_T(virtual wb_driver_bfm #(
                             .WB_ADDR_WIDTH(WB_ADDR_WIDTH),                                
                             .WB_DATA_WIDTH(WB_DATA_WIDTH)                                
                             ) ),
                   .REQ(wb_transaction  #(
                             .WB_ADDR_WIDTH(WB_ADDR_WIDTH),                                
                             .WB_DATA_WIDTH(WB_DATA_WIDTH)                                
                             ) ),
                   .RSP(wb_transaction  #(
                             .WB_ADDR_WIDTH(WB_ADDR_WIDTH),                                
                             .WB_DATA_WIDTH(WB_DATA_WIDTH)                                
                             ) ));

  `uvm_component_param_utils( wb_driver #(
                              WB_ADDR_WIDTH,
                              WB_DATA_WIDTH
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
  virtual task access( inout REQ txn );
      if (configuration.initiator_responder==RESPONDER) begin
        if (1'b1 && txn.dummy_start==0) begin
          bfm.do_response_ready(
             txn.data                      );
        end
        bfm.response(
      txn.op,
      txn.data,
      txn.addr,
      txn.byte_select        
          );
      end else begin    
        bfm.access(
      txn.op,
      txn.data,
      txn.addr,
      txn.byte_select            );
    end
  endtask

endclass
