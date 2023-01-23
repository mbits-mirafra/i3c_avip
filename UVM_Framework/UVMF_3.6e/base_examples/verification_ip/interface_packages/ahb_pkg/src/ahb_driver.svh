//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 15
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb interface agent
// Unit            : Interface UVM Driver
// File            : ahb_driver.svh
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
class ahb_driver extends uvmf_driver_base #(
                   .CONFIG_T(ahb_configuration),
                   .BFM_BIND_T(virtual ahb_driver_bfm),
                   .REQ(ahb_transaction),
                   .RSP(ahb_transaction));

  `uvm_component_utils( ahb_driver )

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
          cfg.master_slave
);                    
   
   endfunction

// ****************************************************************************              
  virtual task access( inout ahb_transaction txn );
      bfm.access(
    txn.op,
    txn.data,
    txn.addr          );
  endtask

endclass
