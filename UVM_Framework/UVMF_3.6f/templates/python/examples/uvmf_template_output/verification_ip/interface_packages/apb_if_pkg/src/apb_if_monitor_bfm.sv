//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : shwetapatil
// Creation Date   : 2022 Jun 06
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : apb_if interface agent
// Unit            : Interface Monitor BFM
// File            : apb_if_monitor_bfm.sv
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface performs the apb_if signal monitoring.
//      It is accessed by the uvm apb_if monitor through a virtual
//      interface handle in the apb_if configuration.  It monitors the
//      signals passed in through the port connection named bus of
//      type apb_if_if.
//
//     Input signals from the apb_if_if are assigned to an internal input
//     signal with a _i suffix.  The _i signal should be used for sampling.
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i 
//
//      Interface functions and tasks used by UVM components:
//             monitor(inout TRANS_T txn);
//                   This task receives the transaction, txn, from the
//                   UVM monitor and then populates variables in txn
//                   from values observed on bus activity.  This task
//                   blocks until an operation on the apb_if bus is complete.
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import apb_if_pkg_hdl::*;

interface apb_if_monitor_bfm       #(
      int DATA_WIDTH = 32,                                
      int ADDR_WIDTH = 32                                
      )
( apb_if_if  bus );
// pragma attribute apb_if_monitor_bfm partition_interface_xif                                  
// The above pragma and additional ones in-lined below are for running this BFM on Veloce


   tri        defaultClk_i;
   tri        defaultRst_i;
   tri         pselx_i;
   tri         penable_i;
   tri         pwrite_i;
   tri         pready_i;
   tri         pslverr_i;
   tri         pprot_i;
   tri        [[ADDR_WIDTH-1:0]-1:0] paddr_i;
   tri        [[DATA_WIDTH-1:0]-1:0] pwdata_i;
   tri        [[DATA_WIDTH-1:0]-1:0] prdata_i;
   tri        [[(DATA_WIDTH/8)-1:0]-1:0] pstrb_i;
   tri        [DATA_WIDTH-1:0] rdata_i;

   assign     defaultClk_i    =   bus.defaultClk;
   assign     defaultRst_i    =   bus.defaultRst;
   assign     pselx_i = bus.pselx;
   assign     penable_i = bus.penable;
   assign     pwrite_i = bus.pwrite;
   assign     pready_i = bus.pready;
   assign     pslverr_i = bus.pslverr;
   assign     pprot_i = bus.pprot;
   assign     paddr_i = bus.paddr;
   assign     pwdata_i = bus.pwdata;
   assign     prdata_i = bus.prdata;
   assign     pstrb_i = bus.pstrb;
   assign     rdata_i = bus.rdata;

   // Proxy handle to UVM monitor
   apb_if_pkg::apb_if_monitor  #(
              .DATA_WIDTH(DATA_WIDTH),                                
              .ADDR_WIDTH(ADDR_WIDTH)                                
                    )  proxy;
  // pragma tbx oneway proxy.notify_transaction                 

//******************************************************************                         
   task wait_for_reset(); // pragma tbx xtf                                                  
      @(posedge defaultClk_i) ;                                                                    
      do_wait_for_reset();                                                                   
   endtask                                                                                   

// ****************************************************************************              
   task do_wait_for_reset();                                                                 
      wait ( defaultRst_i == 0 ) ;                                                              
      @(posedge defaultClk_i) ;                                                                    
   endtask    
   
//******************************************************************                         
   task wait_for_num_clocks( input int unsigned count); // pragma tbx xtf                           
      @(posedge defaultClk_i);                                                                     
      repeat (count-1) @(posedge defaultClk_i);                                                    
   endtask      

//******************************************************************                         
  event go;                                                                                 
  function void start_monitoring(); // pragma tbx xtf      
     -> go;                                                                                 
  endfunction                                                                               
  
  // ****************************************************************************              
  initial begin                                                                             
     @go;                                                                                   
     forever begin                                                                          
        bit [DATA_WIDTH-1:0] prdata;
        bit [DATA_WIDTH-1:0] pwdata;
        bit [ADDR_WIDTH-1:0] paddr;
        bit [2:0] pprot;
        int pselx;
        @(posedge defaultClk_i);                                                                   

        do_monitor(
                   prdata,
                   pwdata,
                   paddr,
                   pprot,
                   pselx                  );
        proxy.notify_transaction(
                   prdata,
                   pwdata,
                   paddr,
                   pprot,
                   pselx                                );     
     end                                                                                    
  end                                                                                       

//******************************************************************
   function void configure(
          uvmf_active_passive_t active_passive,
          uvmf_initiator_responder_t   initiator_responder
          ,bit [31:0] transfer_size
); // pragma tbx xtf

   endfunction


// ****************************************************************************              
     task do_monitor(
                   output bit [DATA_WIDTH-1:0] prdata,
                   output bit [DATA_WIDTH-1:0] pwdata,
                   output bit [ADDR_WIDTH-1:0] paddr,
                   output bit [2:0] pprot,
                   output int pselx                    );
// UVMF_CHANGE_ME : Implement protocol monitoring.
// Reference code;
//    while (control_signal == 1'b1) @(posedge defaultClk_i);
//    xyz = pselx_i;  //     
//    xyz = penable_i;  //     
//    xyz = pwrite_i;  //     
//    xyz = pready_i;  //     
//    xyz = pslverr_i;  //     
//    xyz = pprot_i;  //     
//    xyz = paddr_i;  //    [[ADDR_WIDTH-1:0]-1:0] 
//    xyz = pwdata_i;  //    [[DATA_WIDTH-1:0]-1:0] 
//    xyz = prdata_i;  //    [[DATA_WIDTH-1:0]-1:0] 
//    xyz = pstrb_i;  //    [[(DATA_WIDTH/8)-1:0]-1:0] 
//    xyz = rdata_i;  //    [DATA_WIDTH-1:0] 

      @(posedge defaultClk_i);
      @(posedge defaultClk_i);
      @(posedge defaultClk_i);
      @(posedge defaultClk_i);

     endtask         
  
endinterface
