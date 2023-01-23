//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU_out interface agent
// Unit            : Interface Monitor BFM
// File            : FPU_out_monitor_bfm.sv
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface performs the FPU_out signal monitoring.
//      It is accessed by the uvm FPU_out monitor through a virtual
//      interface handle in the FPU_out configuration.  It monitors the
//      signals passed in through the port connection named bus of
//      type FPU_out_if.
//
//     Input signals from the FPU_out_if are assigned to an internal input
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
//                   blocks until an operation on the FPU_out bus is complete.
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import FPU_out_pkg_hdl::*;

interface FPU_out_monitor_bfm ( FPU_out_if  bus );
// pragma attribute FPU_out_monitor_bfm partition_interface_xif                                  
// The above pragma and additional ones in-lined below are for running this BFM on Veloce

   tri        clk_i;
   tri        rst_i;
   tri         ine_i;
   tri         overflow_i;
   tri         underflow_i;
   tri         div_zero_i;
   tri         inf_i;
   tri         zero_i;
   tri         qnan_i;
   tri         snan_i;
   tri         ready_i;

   assign     clk_i    =   bus.clk;
   assign     rst_i    =   bus.rst;
   assign     ine_i = bus.ine;
   assign     overflow_i = bus.overflow;
   assign     underflow_i = bus.underflow;
   assign     div_zero_i = bus.div_zero;
   assign     inf_i = bus.inf;
   assign     zero_i = bus.zero;
   assign     qnan_i = bus.qnan;
   assign     snan_i = bus.snan;
   assign     ready_i = bus.ready;

   // Proxy handle to UVM monitor
   FPU_out_pkg::FPU_out_monitor  proxy;
  // pragma tbx oneway proxy.notify_transaction                 

//******************************************************************                         
   task wait_for_reset(); // pragma tbx xtf                                                  
      @(posedge clk_i) ;                                                                    
      do_wait_for_reset();                                                                   
   endtask                                                                                   

// ****************************************************************************              
   task do_wait_for_reset();                                                                 
      wait ( rst_i == 1 ) ;                                                              
      @(posedge clk_i) ;                                                                    
   endtask    
   
   
//******************************************************************                         
 
   task wait_for_num_clocks( input int unsigned count); // pragma tbx xtf 
      @(posedge clk_i);  
                                                                     
      repeat (count-1) @(posedge clk_i);                                                    
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
        bit ine ;
        bit overflow ;
        bit underflow ;
        bit div_zero ;
        bit inf ;
        bit zero ;
        bit qnan ;
        bit snan ;
        @(posedge clk_i);                                                                   

        do_monitor(
                   ine,
                   overflow,
                   underflow,
                   div_zero,
                   inf,
                   zero,
                   qnan,
                   snan                  );
 
        proxy.notify_transaction(
                   ine,
                   overflow,
                   underflow,
                   div_zero,
                   inf,
                   zero,
                   qnan,
                   snan                                );     
     end                                                                                    
  end                                                                                       

//******************************************************************
   function void configure(          uvmf_active_passive_t active_passive,
          uvmf_initiator_responder_t   initiator_responder
); // pragma tbx xtf
   endfunction


// ****************************************************************************              
     task do_monitor(
                   output bit ine ,
                   output bit overflow ,
                   output bit underflow ,
                   output bit div_zero ,
                   output bit inf ,
                   output bit zero ,
                   output bit qnan ,
                   output bit snan                     );
// UVMF_CHANGE_ME : Implement protocol monitoring.
// Reference code;
//    while (control_signal == 1'b1) @(posedge clk_i);
//    xyz = ine_i;  //     
//    xyz = overflow_i;  //     
//    xyz = underflow_i;  //     
//    xyz = div_zero_i;  //     
//    xyz = inf_i;  //     
//    xyz = zero_i;  //     
//    xyz = qnan_i;  //     
//    xyz = snan_i;  //     
//    xyz = ready_i;  //     

      @(posedge clk_i);
      @(posedge clk_i);
      @(posedge clk_i);
      @(posedge clk_i);

     endtask         
  
 
endinterface
