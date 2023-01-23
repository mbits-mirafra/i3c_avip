//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU_in interface agent
// Unit            : Interface Driver BFM
// File            : FPU_in_driver_bfm.sv
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
//    This interface performs the FPU_in signal driving.  It is
//     accessed by the uvm FPU_in driver through a virtual interface
//     handle in the FPU_in configuration.  It drives the singals passed
//     in through the port connection named bus of type FPU_in_if.
//
//     Input signals from the FPU_in_if are assigned to an internal input
//     signal with a _i suffix.  The _i signal should be used for sampling.
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i 
//
//     This bfm drives signals with a _o suffix.  These signals
//     are driven onto signals within FPU_in_if based on INITIATOR/RESPONDER and/or
//     ARBITRATION/GRANT status.  
//
//     The output signal connections are as follows:
//        signal_o -> bus.signal
//
//                                                                                           
//      Interface functions and tasks used by UVM components:                                
//             configure(uvmf_initiator_responder_t mst_slv);                                       
//                   This function gets configuration attributes from the                    
//                   UVM driver to set any required BFM configuration                        
//                   variables such as 'initiator_responder'.                                       
//                                                                                           
//             access(
//       fpu_op_t op ,
//       fpu_rnd_t rmode ,
//       bit [FP_WIDTH-1:0] a ,
//       bit [FP_WIDTH-1:0] b ,
//       bit [FP_WIDTH-1:0] result  );//                   );
//                   This task receives transaction attributes from the                      
//                   UVM driver and then executes the corresponding                          
//                   bus operation on the bus. 
//
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import FPU_in_pkg_hdl::*;

interface FPU_in_driver_bfm       #(
      int FP_WIDTH = 32                                
      )
(FPU_in_if  bus);
// pragma attribute FPU_in_driver_bfm partition_interface_xif
// The above pragma and additional ones in-lined below are for running this BFM on Veloce


  // Config value to determine if this is an initiator or a responder 
  uvmf_initiator_responder_t initiator_responder;

  tri        clk_i;
  tri        rst_i;

// Signal list (all signals are capable of being inputs and outputs for the sake
// of supporting both INITIATOR and RESPONDER mode operation. Expectation is that 
// directionality in the config file was from the point-of-view of the INITIATOR

// INITIATOR mode input signals
  tri         ready_i;
  reg         ready_o;
  tri       [FP_WIDTH-1:0]  result_i;
  reg       [FP_WIDTH-1:0]  result_o;

// INITIATOR mode output signals
  tri         start_i;
  reg         start_o;
  tri       [2:0]  op_i;
  reg       [2:0]  op_o;
  tri       [1:0]  rmode_i;
  reg       [1:0]  rmode_o;
  tri       [FP_WIDTH-1:0]  a_i;
  reg       [FP_WIDTH-1:0]  a_o;
  tri       [FP_WIDTH-1:0]  b_i;
  reg       [FP_WIDTH-1:0]  b_o;

// Bi-directional signals
  

  assign     clk_i    =   bus.clk;
  assign     rst_i    =   bus.rst;

  // These are signals marked as 'input' by the config file, but the signals will be
  // driven by this BFM if put into RESPONDER mode (flipping all signal directions around)
  assign     ready_i = bus.ready;
  assign     bus.ready = (initiator_responder == RESPONDER) ? ready_o : 'bz;
  assign     result_i = bus.result;
  assign     bus.result = (initiator_responder == RESPONDER) ? result_o : 'bz;


  // These are signals marked as 'output' by the config file, but the outputs will
  // not be driven by this BFM unless placed in INITIATOR mode.
  assign bus.start = (initiator_responder == INITIATOR) ? start_o : 'bz;
  assign start_i = bus.start;
  assign bus.op = (initiator_responder == INITIATOR) ? op_o : 'bz;
  assign op_i = bus.op;
  assign bus.rmode = (initiator_responder == INITIATOR) ? rmode_o : 'bz;
  assign rmode_i = bus.rmode;
  assign bus.a = (initiator_responder == INITIATOR) ? a_o : 'bz;
  assign a_i = bus.a;
  assign bus.b = (initiator_responder == INITIATOR) ? b_o : 'bz;
  assign b_i = bus.b;

   // Proxy handle to UVM driver
   FPU_in_pkg::FPU_in_driver  #(
              .FP_WIDTH(FP_WIDTH)                                
                    )  proxy;
  // pragma tbx oneway proxy.my_function_name_in_uvm_driver                 

  
  
    always@(negedge rst_i)
    begin
          start_o   <= 1'b0;
     end  
  
//******************************************************************  

function void configure(
          uvmf_active_passive_t active_passive,
          uvmf_initiator_responder_t   init_resp
); // pragma tbx xtf                   
      initiator_responder = init_resp;
 

   endfunction                                                                               


// ****************************************************************************
  task do_transfer(                input fpu_op_t op ,
                input fpu_rnd_t rmode ,
                input bit [FP_WIDTH-1:0] a ,
                input bit [FP_WIDTH-1:0] b ,
                input bit [FP_WIDTH-1:0] result                );                                                  
  // UVMF_CHANGE_ME : 
  // 1) Implement protocol signaling.
  //    Transfers are protocol specific and therefore not generated by the templates.
  //    Use the following as examples of transferring data between a sequence and the bus
  //    In the FPU_in_pkg - FPU_in_master_access_sequence.svh, FPU_in_driver_bfm.sv
  // 2) To return the value of a variable from this protocol operation to the sequence, 
  //    change the direction of the variable from input to output in the list of arguments
  //    in the above do_transfer task declaration.  Also change the direction from input 
  //    to output in the declaration of the access task within this BFM.
  // 
  // Reference code;
  //    while (control_signal == 1'b1) @(posedge clk_i);
  //    INITIATOR mode input signals
  //    ready_i;        //    
  //    ready_o <= xyz; //     
  //    result_i;        //   [FP_WIDTH-1:0] 
  //    result_o <= xyz; //   [FP_WIDTH-1:0]  
  //    INITIATOR mode output signals
  //    start_i;        //     
  //    start_o <= xyz; //     
  //    op_i;        //   [2:0]  
  //    op_o <= xyz; //   [2:0]  
  //    rmode_i;        //   [1:0]  
  //    rmode_o <= xyz; //   [1:0]  
  //    a_i;        //   [FP_WIDTH-1:0]  
  //    a_o <= xyz; //   [FP_WIDTH-1:0]  
  //    b_i;        //   [FP_WIDTH-1:0]  
  //    b_o <= xyz; //   [FP_WIDTH-1:0]  
  //    Bi-directional signals
  $display("FPU_in_driver_bfm: Inside do_transfer()");
  repeat ($urandom_range(0,10)) @(posedge clk_i);      // random idle time
  start_o <= 1'b1;
  a_o     <= a;
  b_o     <= b;
  op_o    <= op;
  rmode_o <= rmode;
  @(posedge clk_i) 
  start_o <= 1'b0;
  
  // Wait for FPU result for DUT
  while (ready_i == 1'b0) begin
      @(posedge clk_i);
  end
  result <= result_i;
endtask        

  // UVMF_CHANGE_ME : Implement response protocol signaling.
  // Templates also do not generate protocol specific response signaling. Use the 
  // following as examples for transferring data between a sequence and the bus
  // In wb_pkg - wb_memory_slave_sequence.svh, wb_driver_bfm.sv

  task do_response(                 output fpu_op_t op ,
                 output fpu_rnd_t rmode ,
                 output bit [FP_WIDTH-1:0] a ,
                 output bit [FP_WIDTH-1:0] b ,
                 output bit [FP_WIDTH-1:0] result        );
    @(posedge clk_i);
    @(posedge clk_i);
    @(posedge clk_i);
    @(posedge clk_i);
    @(posedge clk_i);
  endtask

  // The resp_ready bit is intended to act as a simple event scheduler and does
  // not have anything to do with the protocol. It is intended to be set by
  // a proxy call to do_response_ready() and ultimately cleared somewhere within the always
  // block below.  In this simple situation, resp_ready will be cleared on the
  // clock cycle immediately following it being set.  In a more complex protocol,
  // the resp_ready signal could be an input to an explicit FSM to properly
  // time the responses to transactions.  
  bit resp_ready;
  always @(posedge clk_i) begin
    if (resp_ready) begin
      resp_ready <= 1'b0;
    end
  end

  function void do_response_ready(    );  // pragma tbx xtf
    // UVMF_CHANGE_ME : Implement response - drive BFM outputs based on the arguments
    // passed into this function.  IMPORTANT - Must not consume time (it must remain
    // a function)
    resp_ready <= 1'b1;
  endfunction

// ****************************************************************************              
// UVMF_CHANGE_ME : Note that all transaction variables are passed into the access
//   task as inputs.  Some of these may need to be changed to outputs based on
//   protocol needs.  To return the value of a variable from this protocol operation to the sequence, 
//   change the direction of the variable from input to output in the list of arguments
//   in the access task declaration.  Also change the direction from input 
//   to output in the declaration of the do_transfer task within this BFM.
//
  task access(
    input   fpu_op_t op ,
    input   fpu_rnd_t rmode ,
    input   bit [FP_WIDTH-1:0] a ,
    input   bit [FP_WIDTH-1:0] b ,
    input   bit [FP_WIDTH-1:0] result  );
  // pragma tbx xtf                    
  @(posedge clk_i);                                                                     
  $display("FPU_in_driver_bfm: Inside access()");
  do_transfer(
    op,
    rmode,
    a,
    b,
    result          );                                                  


  endtask      

// ****************************************************************************              
// UVMF_CHANGE_ME : Note that all transaction variables are passed into the response
//   task as outputs.  Some of these may need to be changed to inputs based on
//   protocol needs.  

  task response(
 output fpu_op_t op ,
 output fpu_rnd_t rmode ,
 output bit [FP_WIDTH-1:0] a ,
 output bit [FP_WIDTH-1:0] b ,
 output bit [FP_WIDTH-1:0] result  );
  // pragma tbx xtf
     @(posedge clk_i);
     $display("FPU_in_driver_bfm: Inside response()");
    do_response(
                op,
                rmode,
                a,
                b,
                result        );

  endtask             
 
endinterface
