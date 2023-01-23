//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU_out interface agent
// Unit            : Interface Driver BFM
// File            : FPU_out_driver_bfm.sv
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
//    This interface performs the FPU_out signal driving.  It is
//     accessed by the uvm FPU_out driver through a virtual interface
//     handle in the FPU_out configuration.  It drives the singals passed
//     in through the port connection named bus of type FPU_out_if.
//
//     Input signals from the FPU_out_if are assigned to an internal input
//     signal with a _i suffix.  The _i signal should be used for sampling.
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i 
//
//     This bfm drives signals with a _o suffix.  These signals
//     are driven onto signals within FPU_out_if based on INITIATOR/RESPONDER and/or
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
//       bit ine ,
//       bit overflow ,
//       bit underflow ,
//       bit div_zero ,
//       bit inf ,
//       bit zero ,
//       bit qnan ,
//       bit snan  );//                   );
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
import FPU_out_pkg_hdl::*;

interface FPU_out_driver_bfm (FPU_out_if  bus);
// pragma attribute FPU_out_driver_bfm partition_interface_xif
// The above pragma and additional ones in-lined below are for running this BFM on Veloce


  // Config value to determine if this is an initiator or a responder 
  uvmf_initiator_responder_t initiator_responder;

  tri        clk_i;
  tri        rst_i;

// Signal list (all signals are capable of being inputs and outputs for the sake
// of supporting both INITIATOR and RESPONDER mode operation. Expectation is that 
// directionality in the config file was from the point-of-view of the INITIATOR

// INITIATOR mode input signals
  tri         ine_i;
  reg         ine_o;
  tri         overflow_i;
  reg         overflow_o;
  tri         underflow_i;
  reg         underflow_o;
  tri         div_zero_i;
  reg         div_zero_o;
  tri         inf_i;
  reg         inf_o;
  tri         zero_i;
  reg         zero_o;
  tri         qnan_i;
  reg         qnan_o;
  tri         snan_i;
  reg         snan_o;
  tri         ready_i;
  reg         ready_o;

// INITIATOR mode output signals

// Bi-directional signals
  

  assign     clk_i    =   bus.clk;
  assign     rst_i    =   bus.rst;

  // These are signals marked as 'input' by the config file, but the signals will be
  // driven by this BFM if put into RESPONDER mode (flipping all signal directions around)
  assign     ine_i = bus.ine;
  assign     bus.ine = (initiator_responder == RESPONDER) ? ine_o : 'bz;
  assign     overflow_i = bus.overflow;
  assign     bus.overflow = (initiator_responder == RESPONDER) ? overflow_o : 'bz;
  assign     underflow_i = bus.underflow;
  assign     bus.underflow = (initiator_responder == RESPONDER) ? underflow_o : 'bz;
  assign     div_zero_i = bus.div_zero;
  assign     bus.div_zero = (initiator_responder == RESPONDER) ? div_zero_o : 'bz;
  assign     inf_i = bus.inf;
  assign     bus.inf = (initiator_responder == RESPONDER) ? inf_o : 'bz;
  assign     zero_i = bus.zero;
  assign     bus.zero = (initiator_responder == RESPONDER) ? zero_o : 'bz;
  assign     qnan_i = bus.qnan;
  assign     bus.qnan = (initiator_responder == RESPONDER) ? qnan_o : 'bz;
  assign     snan_i = bus.snan;
  assign     bus.snan = (initiator_responder == RESPONDER) ? snan_o : 'bz;
  assign     ready_i = bus.ready;
  assign     bus.ready = (initiator_responder == RESPONDER) ? ready_o : 'bz;


  // These are signals marked as 'output' by the config file, but the outputs will
  // not be driven by this BFM unless placed in INITIATOR mode.

   // Proxy handle to UVM driver
   FPU_out_pkg::FPU_out_driver  proxy;
  // pragma tbx oneway proxy.my_function_name_in_uvm_driver                 

//******************************************************************  

function void configure(
          uvmf_active_passive_t active_passive,
          uvmf_initiator_responder_t   init_resp
); // pragma tbx xtf                   
      initiator_responder = init_resp;
 

   endfunction                                                                               


// ****************************************************************************
  task do_transfer(                input bit ine ,
                input bit overflow ,
                input bit underflow ,
                input bit div_zero ,
                input bit inf ,
                input bit zero ,
                input bit qnan ,
                input bit snan                );                                                  
  // UVMF_CHANGE_ME : 
  // 1) Implement protocol signaling.
  //    Transfers are protocol specific and therefore not generated by the templates.
  //    Use the following as examples of transferring data between a sequence and the bus
  //    In the FPU_out_pkg - FPU_out_master_access_sequence.svh, FPU_out_driver_bfm.sv
  // 2) To return the value of a variable from this protocol operation to the sequence, 
  //    change the direction of the variable from input to output in the list of arguments
  //    in the above do_transfer task declaration.  Also change the direction from input 
  //    to output in the declaration of the access task within this BFM.
  // 
  // Reference code;
  //    while (control_signal == 1'b1) @(posedge clk_i);
  //    INITIATOR mode input signals
  //    ine_i;        //    
  //    ine_o <= xyz; //     
  //    overflow_i;        //    
  //    overflow_o <= xyz; //     
  //    underflow_i;        //    
  //    underflow_o <= xyz; //     
  //    div_zero_i;        //    
  //    div_zero_o <= xyz; //     
  //    inf_i;        //    
  //    inf_o <= xyz; //     
  //    zero_i;        //    
  //    zero_o <= xyz; //     
  //    qnan_i;        //    
  //    qnan_o <= xyz; //     
  //    snan_i;        //    
  //    snan_o <= xyz; //     
  //    ready_i;        //    
  //    ready_o <= xyz; //     
  //    INITIATOR mode output signals
  //    Bi-directional signals
 

  @(posedge clk_i);
  @(posedge clk_i);
  @(posedge clk_i);
  @(posedge clk_i);
  @(posedge clk_i);
  $display("FPU_out_driver_bfm: Inside do_transfer()");
endtask        

  // UVMF_CHANGE_ME : Implement response protocol signaling.
  // Templates also do not generate protocol specific response signaling. Use the 
  // following as examples for transferring data between a sequence and the bus
  // In wb_pkg - wb_memory_slave_sequence.svh, wb_driver_bfm.sv

  task do_response(                 output bit ine ,
                 output bit overflow ,
                 output bit underflow ,
                 output bit div_zero ,
                 output bit inf ,
                 output bit zero ,
                 output bit qnan ,
                 output bit snan        );
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
    input   bit ine ,
    input   bit overflow ,
    input   bit underflow ,
    input   bit div_zero ,
    input   bit inf ,
    input   bit zero ,
    input   bit qnan ,
    input   bit snan  );
  // pragma tbx xtf                    
  @(posedge clk_i);                                                                     
  $display("FPU_out_driver_bfm: Inside access()");
  do_transfer(
    ine,
    overflow,
    underflow,
    div_zero,
    inf,
    zero,
    qnan,
    snan          );                                                  


  endtask      

// ****************************************************************************              
// UVMF_CHANGE_ME : Note that all transaction variables are passed into the response
//   task as outputs.  Some of these may need to be changed to inputs based on
//   protocol needs.  

  task response(
 output bit ine ,
 output bit overflow ,
 output bit underflow ,
 output bit div_zero ,
 output bit inf ,
 output bit zero ,
 output bit qnan ,
 output bit snan  );
  // pragma tbx xtf
     @(posedge clk_i);
     $display("FPU_out_driver_bfm: Inside response()");
    do_response(
                ine,
                overflow,
                underflow,
                div_zero,
                inf,
                zero,
                qnan,
                snan        );

  endtask             
 
endinterface
