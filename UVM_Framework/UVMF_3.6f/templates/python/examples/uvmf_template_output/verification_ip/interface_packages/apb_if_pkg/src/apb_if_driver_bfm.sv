//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : shwetapatil
// Creation Date   : 2022 Jun 06
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : apb_if interface agent
// Unit            : Interface Driver BFM
// File            : apb_if_driver_bfm.sv
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
//    This interface performs the apb_if signal driving.  It is
//     accessed by the uvm apb_if driver through a virtual interface
//     handle in the apb_if configuration.  It drives the singals passed
//     in through the port connection named bus of type apb_if_if.
//
//     Input signals from the apb_if_if are assigned to an internal input
//     signal with a _i suffix.  The _i signal should be used for sampling.
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i 
//
//     This bfm drives signals with a _o suffix.  These signals
//     are driven onto signals within apb_if_if based on INITIATOR/RESPONDER and/or
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
//       bit [DATA_WIDTH-1:0] prdata,
//       bit [DATA_WIDTH-1:0] pwdata,
//       bit [ADDR_WIDTH-1:0] paddr,
//       bit [2:0] pprot,
//       int pselx );//                   );
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
import apb_if_pkg_hdl::*;

interface apb_if_driver_bfm       #(
      int DATA_WIDTH = 32,                                
      int ADDR_WIDTH = 32                                
      )
(apb_if_if  bus);
// pragma attribute apb_if_driver_bfm partition_interface_xif
// The above pragma and additional ones in-lined below are for running this BFM on Veloce

  // Config value to determine if this is an initiator or a responder 
  uvmf_initiator_responder_t initiator_responder;

  tri        defaultClk_i;
  tri        defaultRst_i;

// Signal list (all signals are capable of being inputs and outputs for the sake
// of supporting both INITIATOR and RESPONDER mode operation. Expectation is that 
// directionality in the config file was from the point-of-view of the INITIATOR

// INITIATOR mode input signals
  tri         pready_i;
  bit         pready_o;
  tri         pslverr_i;
  bit         pslverr_o;
  tri       [[DATA_WIDTH-1:0]-1:0]  prdata_i;
  bit       [[DATA_WIDTH-1:0]-1:0]  prdata_o;
  tri       [DATA_WIDTH-1:0]  rdata_i;
  bit       [DATA_WIDTH-1:0]  rdata_o;

// INITIATOR mode output signals
  tri         pselx_i;
  bit         pselx_o;
  tri         penable_i;
  bit         penable_o;
  tri         pwrite_i;
  bit         pwrite_o;
  tri         pprot_i;
  bit         pprot_o;
  tri       [[ADDR_WIDTH-1:0]-1:0]  paddr_i;
  bit       [[ADDR_WIDTH-1:0]-1:0]  paddr_o;
  tri       [[DATA_WIDTH-1:0]-1:0]  pwdata_i;
  bit       [[DATA_WIDTH-1:0]-1:0]  pwdata_o;
  tri       [[(DATA_WIDTH/8)-1:0]-1:0]  pstrb_i;
  bit       [[(DATA_WIDTH/8)-1:0]-1:0]  pstrb_o;

// Bi-directional signals
  

  assign     defaultClk_i    =   bus.defaultClk;
  assign     defaultRst_i    =   bus.defaultRst;

  // These are signals marked as 'input' by the config file, but the signals will be
  // driven by this BFM if put into RESPONDER mode (flipping all signal directions around)
  assign     pready_i = bus.pready;
  assign     bus.pready = (initiator_responder == RESPONDER) ? pready_o : 'bz;
  assign     pslverr_i = bus.pslverr;
  assign     bus.pslverr = (initiator_responder == RESPONDER) ? pslverr_o : 'bz;
  assign     prdata_i = bus.prdata;
  assign     bus.prdata = (initiator_responder == RESPONDER) ? prdata_o : 'bz;
  assign     rdata_i = bus.rdata;
  assign     bus.rdata = (initiator_responder == RESPONDER) ? rdata_o : 'bz;


  // These are signals marked as 'output' by the config file, but the outputs will
  // not be driven by this BFM unless placed in INITIATOR mode.
  assign bus.pselx = (initiator_responder == INITIATOR) ? pselx_o : 'bz;
  assign pselx_i = bus.pselx;
  assign bus.penable = (initiator_responder == INITIATOR) ? penable_o : 'bz;
  assign penable_i = bus.penable;
  assign bus.pwrite = (initiator_responder == INITIATOR) ? pwrite_o : 'bz;
  assign pwrite_i = bus.pwrite;
  assign bus.pprot = (initiator_responder == INITIATOR) ? pprot_o : 'bz;
  assign pprot_i = bus.pprot;
  assign bus.paddr = (initiator_responder == INITIATOR) ? paddr_o : 'bz;
  assign paddr_i = bus.paddr;
  assign bus.pwdata = (initiator_responder == INITIATOR) ? pwdata_o : 'bz;
  assign pwdata_i = bus.pwdata;
  assign bus.pstrb = (initiator_responder == INITIATOR) ? pstrb_o : 'bz;
  assign pstrb_i = bus.pstrb;

   // Proxy handle to UVM driver
   apb_if_pkg::apb_if_driver  #(
              .DATA_WIDTH(DATA_WIDTH),                                
              .ADDR_WIDTH(ADDR_WIDTH)                                
                    )  proxy;
  // pragma tbx oneway proxy.my_function_name_in_uvm_driver                 

//******************************************************************                         
   function void configure(
          uvmf_active_passive_t active_passive,
          uvmf_initiator_responder_t   init_resp
          ,bit [31:0] transfer_size
); // pragma tbx xtf                   
      initiator_responder = init_resp;
   
   endfunction                                                                               


// ****************************************************************************
  task do_transfer(                input bit [DATA_WIDTH-1:0] prdata,
                input bit [DATA_WIDTH-1:0] pwdata,
                input bit [ADDR_WIDTH-1:0] paddr,
                input bit [2:0] pprot,
                input int pselx               );                                                  
  // UVMF_CHANGE_ME : Implement protocol signaling.
  // Transfers are protocol specific and therefore not generated by the templates.
  // Use the following as examples of transferring data between a sequence and the bus
  // In the wb_pkg - wb_master_access_sequence.svh, wb_driver_bfm.sv
  // Reference code;
  //    while (control_signal == 1'b1) @(posedge defaultClk_i);
  //    INITIATOR mode input signals
  //    pready_i;        //    
  //    pready_o <= xyz; //     
  //    pslverr_i;        //    
  //    pslverr_o <= xyz; //     
  //    prdata_i;        //   [[DATA_WIDTH-1:0]-1:0] 
  //    prdata_o <= xyz; //   [[DATA_WIDTH-1:0]-1:0]  
  //    rdata_i;        //   [DATA_WIDTH-1:0] 
  //    rdata_o <= xyz; //   [DATA_WIDTH-1:0]  
  //    INITIATOR mode output signals
  //    pselx_i;        //     
  //    pselx_o <= xyz; //     
  //    penable_i;        //     
  //    penable_o <= xyz; //     
  //    pwrite_i;        //     
  //    pwrite_o <= xyz; //     
  //    pprot_i;        //     
  //    pprot_o <= xyz; //     
  //    paddr_i;        //   [[ADDR_WIDTH-1:0]-1:0]  
  //    paddr_o <= xyz; //   [[ADDR_WIDTH-1:0]-1:0]  
  //    pwdata_i;        //   [[DATA_WIDTH-1:0]-1:0]  
  //    pwdata_o <= xyz; //   [[DATA_WIDTH-1:0]-1:0]  
  //    pstrb_i;        //   [[(DATA_WIDTH/8)-1:0]-1:0]  
  //    pstrb_o <= xyz; //   [[(DATA_WIDTH/8)-1:0]-1:0]  
  //    Bi-directional signals
 

  @(posedge defaultClk_i);
  @(posedge defaultClk_i);
  @(posedge defaultClk_i);
  @(posedge defaultClk_i);
  @(posedge defaultClk_i);
  $display("apb_if_driver_bfm: Inside do_transfer()");
endtask        

  // UVMF_CHANGE_ME : Implement response protocol signaling.
  // Templates also do not generate protocol specific response signaling. Use the 
  // following as examples for transferring data between a sequence and the bus
  // In wb_pkg - wb_memory_slave_sequence.svh, wb_driver_bfm.sv

  task do_response(                 output bit [DATA_WIDTH-1:0] prdata,
                 output bit [DATA_WIDTH-1:0] pwdata,
                 output bit [ADDR_WIDTH-1:0] paddr,
                 output bit [2:0] pprot,
                 output int pselx       );
    @(posedge defaultClk_i);
    @(posedge defaultClk_i);
    @(posedge defaultClk_i);
    @(posedge defaultClk_i);
    @(posedge defaultClk_i);
  endtask

  // The resp_ready bit is intended to act as a simple event scheduler and does
  // not have anything to do with the protocol. It is intended to be set by
  // a proxy call to do_response_ready() and ultimately cleared somewhere within the always
  // block below.  In this simple situation, resp_ready will be cleared on the
  // clock cycle immediately following it being set.  In a more complex protocol,
  // the resp_ready signal could be an input to an explicit FSM to properly
  // time the responses to transactions.  
  bit resp_ready;
  always @(posedge defaultClk_i) begin
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
//   protocol needs.
//
  task access(
    input   bit [DATA_WIDTH-1:0] prdata,
    input   bit [DATA_WIDTH-1:0] pwdata,
    input   bit [ADDR_WIDTH-1:0] paddr,
    input   bit [2:0] pprot,
    input   int pselx );
  // pragma tbx xtf                    
  @(posedge defaultClk_i);                                                                     
  $display("apb_if_driver_bfm: Inside access()");
  do_transfer(
    prdata,
    pwdata,
    paddr,
    pprot,
    pselx          );                                                  
  endtask      

// ****************************************************************************              
// UVMF_CHANGE_ME : Note that all transaction variables are passed into the response
//   task as outputs.  Some of these may need to be changed to inputs based on
//   protocol needs.
  task response(
 output bit [DATA_WIDTH-1:0] prdata,
 output bit [DATA_WIDTH-1:0] pwdata,
 output bit [ADDR_WIDTH-1:0] paddr,
 output bit [2:0] pprot,
 output int pselx );
  // pragma tbx xtf
     @(posedge defaultClk_i);
     $display("apb_if_driver_bfm: Inside response()");
    do_response(
      prdata,
      pwdata,
      paddr,
      pprot,
      pselx        );
  endtask             
  
endinterface
