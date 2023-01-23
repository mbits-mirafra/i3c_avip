//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU_in interface agent
// Unit            : Interface Monitor BFM
// File            : FPU_in_monitor_bfm.sv
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface performs the FPU_in signal monitoring.
//      It is accessed by the uvm FPU_in monitor through a virtual
//      interface handle in the FPU_in configuration.  It monitors the
//      signals passed in through the port connection named bus of
//      type FPU_in_if.
//
//     Input signals from the FPU_in_if are assigned to an internal input
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
//                   blocks until an operation on the FPU_in bus is complete.
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import FPU_in_pkg_hdl::*;

interface FPU_in_monitor_bfm       #(
      int FP_WIDTH = 32                                
      )
( FPU_in_if  bus );
// pragma attribute FPU_in_monitor_bfm partition_interface_xif                                  
// The above pragma and additional ones in-lined below are for running this BFM on Veloce

   tri        clk_i;
   tri        rst_i;
   tri         ready_i;
   tri         start_i;
   tri        [2:0] op_i;
   tri        [1:0] rmode_i;
   tri        [FP_WIDTH-1:0] a_i;
   tri        [FP_WIDTH-1:0] b_i;
   tri        [FP_WIDTH-1:0] result_i;

   assign     clk_i    =   bus.clk;
   assign     rst_i    =   bus.rst;
   assign     ready_i = bus.ready;
   assign     start_i = bus.start;
   assign     op_i = bus.op;
   assign     rmode_i = bus.rmode;
   assign     a_i = bus.a;
   assign     b_i = bus.b;
   assign     result_i = bus.result;

   // Proxy handle to UVM monitor
   FPU_in_pkg::FPU_in_monitor  #(
              .FP_WIDTH(FP_WIDTH)                                
                    )  proxy;
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
        fpu_op_t op ;
        fpu_rnd_t rmode ;
        bit [FP_WIDTH-1:0] a ;
        bit [FP_WIDTH-1:0] b ;
        bit [FP_WIDTH-1:0] result ;
        @(posedge clk_i);                                                                   

        do_monitor(
                   op,
                   rmode,
                   a,
                   b,
                   result                  );
 
        proxy.notify_transaction(
                   op,
                   rmode,
                   a,
                   b,
                   result                                );     
     end                                                                                    
  end                                                                                       

//******************************************************************
   function void configure(          uvmf_active_passive_t active_passive,
          uvmf_initiator_responder_t   initiator_responder
); // pragma tbx xtf
   endfunction


// ****************************************************************************              
     task do_monitor(
                   output fpu_op_t op ,
                   output fpu_rnd_t rmode ,
                   output bit [FP_WIDTH-1:0] a ,
                   output bit [FP_WIDTH-1:0] b ,
                   output bit [FP_WIDTH-1:0] result                     );
// UVMF_CHANGE_ME : Implement protocol monitoring.
// Reference code;
//    while (control_signal == 1'b1) @(posedge clk_i);
//    xyz = ready_i;  //     
//    xyz = start_i;  //     
//    xyz = op_i;  //    [2:0] 
//    xyz = rmode_i;  //    [1:0] 
//    xyz = a_i;  //    [FP_WIDTH-1:0] 
//    xyz = b_i;  //    [FP_WIDTH-1:0] 
//    xyz = result_i;  //    [FP_WIDTH-1:0] 

    // Hold here until signal event happens to capture bus values
    while (start_i == 1'b0) begin
      @(posedge clk_i);
    end
	
    op    = fpu_op_t'(op_i);
	rmode = fpu_rnd_t'(rmode_i);
    a     = a_i;
    b     = b_i;

	while (ready_i == 1'b0) begin
       @(posedge clk_i);
	end
	result = result_i;

     endtask         
  
 
endinterface
