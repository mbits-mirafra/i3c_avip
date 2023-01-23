//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : jcraft
// Creation Date   : 2016 Nov 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : wb interface agent
// Unit            : Interface Driver BFM
// File            : wb_driver_bfm.sv
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
//    This interface performs the wb signal driving.  It is
//     accessed by the uvm wb driver through a virtual interface
//     handle in the wb configuration.  It drives the singals passed
//     in through the port connection named bus of type wb_if.
//
//     Input signals from the wb_if are assigned to an internal input
//     signal with a _i suffix.  The _i signal should be used for sampling.
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i 
//
//     This bfm drives signals with a _o suffix.  These signals
//     are driven onto signals within wb_if based on INITIATOR/RESPONDER and/or
//     ARBITRATION/GRANT status.  
//
//     The output signal connections are as follows:
//        signal_o -> bus.signal
//
//                                                                                           
//      Interface functions and tasks used by UVM components:                                
//             configure(uvmf_initiator_responder_t initiator_responder);                                       
//                   This function gets configuration attributes from the                    
//                   UVM driver to set any required BFM configuration                        
//                   variables such as 'initiator_responder'.                                       
//                                                                                           
//             assert_resetn();                                                             
//                   This task performs a reset operation on the bus.                    
//                                                                                           
//             access(
//       wb_op_t op,
//       bit [WB_DATA_WIDTH-1:0] data,
//       bit [WB_ADDR_WIDTH-1:0] addr,
//       bit [(WB_DATA_WIDTH/8)-1:0] byte_select );//                   );
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
import wb_pkg_hdl::*;

interface wb_driver_bfm       #(
      int WB_ADDR_WIDTH = 32,                                
      int WB_DATA_WIDTH = 16                                
      )
(wb_if  bus);
// pragma attribute wb_driver_bfm partition_interface_xif
// The above pragma and additional ones in-lined below are for running this BFM on Veloce

  uvmf_initiator_responder_t initiator_responder;

  tri        clk_i;

// Output signals
  bit         rst_o;

// Bi-directional signals
  tri         inta_i;
  bit         inta_o;
  tri         cyc_i;
  bit         cyc_o;
  tri         stb_i;
  bit         stb_o;
  tri       [WB_ADDR_WIDTH-1:0]  adr_i;
  bit       [WB_ADDR_WIDTH-1:0]  adr_o;
  tri         we_i;
  bit         we_o;
  tri       [WB_DATA_WIDTH-1:0]  dout_i;
  bit       [WB_DATA_WIDTH-1:0]  dout_o;
  tri       [WB_DATA_WIDTH-1:0]  din_i;
  bit       [WB_DATA_WIDTH-1:0]  din_o;
  tri         err_i;
  bit         err_o;
  tri         rty_i;
  bit         rty_o;
  tri       [(WB_DATA_WIDTH/8)-1:0]  sel_i;
  bit       [(WB_DATA_WIDTH/8)-1:0]  sel_o;
  tri       [WB_DATA_WIDTH-1:0]  q_i;
  bit       [WB_DATA_WIDTH-1:0]  q_o;
  tri         ack_i;
  bit         ack_o;

  assign bus.rst  = (initiator_responder == INITIATOR)?  rst_o:'bz;
  assign bus.adr  = (initiator_responder == INITIATOR)?  adr_o:'bz;
  assign bus.dout = (initiator_responder == INITIATOR)?  dout_o:'bz;
  assign bus.cyc  = (initiator_responder == INITIATOR)?  cyc_o:'bz;
  assign bus.stb  = (initiator_responder == INITIATOR)?  stb_o:'bz;
  assign bus.we   = (initiator_responder == INITIATOR)?  we_o:'bz;
  assign bus.sel  = (initiator_responder == INITIATOR)?  sel_o:'bz;
  assign bus.q    = (initiator_responder == INITIATOR)?  q_o:'bz;

  assign bus.din  = (initiator_responder == RESPONDER)?  din_o:'bz;
  assign bus.err  = (initiator_responder == RESPONDER)?  err_o:'bz;
  assign bus.rty  = (initiator_responder == RESPONDER)?  rty_o:'bz;
  assign bus.ack  = (initiator_responder == RESPONDER)?  ack_o:'bz;

  assign     clk_i    =   bus.clk;
  assign     inta_i = bus.inta;
  assign     cyc_i = bus.cyc;
  assign     stb_i = bus.stb;
  assign     adr_i = bus.adr;
  assign     we_i = bus.we;
  assign     dout_i = bus.dout;
  assign     din_i = bus.din;
  assign     err_i = bus.err;
  assign     rty_i = bus.rty;
  assign     sel_i = bus.sel;
  assign     q_i = bus.q;
  assign     ack_i = bus.ack;

  assign bus.inta = inta_o;
  assign bus.q = q_o;

//******************************************************************                         
   function void configure(
          uvmf_active_passive_t act_pass,
          uvmf_initiator_responder_t   init_resp
); // pragma tbx xtf                   
      initiator_responder = init_resp;
   endfunction                                                                               

// ****************************************************************************
  task do_transfer(                input wb_op_t op,
                inout bit [WB_DATA_WIDTH-1:0] data,
                input bit [WB_ADDR_WIDTH-1:0] addr,
                input bit [(WB_DATA_WIDTH/8)-1:0] byte_select               );                                                  
    case (op)
      WB_RESET : begin
        rst_o = 1;
        @(posedge clk_i);
        rst_o = 0;
        repeat (3) @(posedge clk_i);
        rst_o = 1;
      end
      WB_WRITE : begin
        adr_o <= addr;
        dout_o <= data;
        cyc_o <= 1'b1;
        stb_o <= 1'b1;
        we_o <= 1'b1;
        sel_o <= byte_select;
        while (!ack_i) @(posedge clk_i);
        cyc_o <= 1'b0;
        stb_o <= 1'b0;
        adr_o <= 'bx;
        dout_o <= 'bx;
        we_o <= 1'b0;
        sel_o <= 1'b0;
        @(posedge clk_i);
        @(posedge clk_i);
      end
      WB_READ : begin
        adr_o <= addr;
        dout_o <= 'bx;
        cyc_o <= 1'b1;
        stb_o <= 1'b1;
        we_o <= 1'b0;
        sel_o <= byte_select;
        @(posedge clk_i);
        while (!ack_i) @(posedge clk_i);
        cyc_o <= 1'b0;
        stb_o <= 1'b0;
        adr_o <= 'bx;
        dout_o <= 'bx;
        we_o <= 1'b0;
        sel_o <= 'b0;
        data = din_i;
      end
    endcase
    $display("wb_driver_bfm: Inside do_transfer()");
endtask        

  // Need to detect rising edge on cyc and stb in order to begin a new operation
  bit cyc_q, stb_q;
  wire cycle_ready = (!cyc_q & cyc_i) & (!stb_q & stb_i);

  // Called by the proxy driver when in RESPONDER mode, blocks until the BFM notices
  // a new transaction - initial data (address, write data, direction) is sent back
  // to the proxy with the expectation of seeing a call to read_ack(data) to finish
  // out the transaction, followed by a new blocking call to do_response()
  task do_response( 
                 output wb_op_t op,
                 inout  bit [WB_DATA_WIDTH-1:0] data,
                 output bit [WB_ADDR_WIDTH-1:0] addr,
                 output bit [(WB_DATA_WIDTH/8)-1:0] byte_select       ); 
    while (cycle_ready!==1'b1) @(posedge clk_i);
    addr = adr_i;
    data = dout_i;
    if (we_i) begin
      op = WB_WRITE;
    end else begin
      op = WB_READ;
    end
  endtask

  bit [WB_DATA_WIDTH-1:0] resp_data;
  bit resp_ready;

  // Internal always block does edge detection on cyc/stb signals as well
  // as drive ack bus data back to inactive after it was driven high by
  // read_ack
  always @(posedge clk_i) begin
    cyc_q <= cyc_i;
    stb_q <= stb_i;
    if (resp_ready) begin
      din_o <= 'b0;
      ack_o <= 1'b0;
      resp_ready <= 1'b0;
    end
  end

  function void do_response_ready(      input bit [WB_DATA_WIDTH-1:0] data    );  // pragma tbx xtf
    din_o <= data;
    ack_o <= 1'b1;
    resp_ready <= 1'b1;
  endfunction

// ****************************************************************************              
// UVMF_CHANGE_ME : Note that all transaction variables are passed into the access
//   task as inputs.  Some of these may need to be changed to outputs based on
//   protocol needs.
//
  task access(
    input   wb_op_t op,
    inout   bit [WB_DATA_WIDTH-1:0] data,
    input   bit [WB_ADDR_WIDTH-1:0] addr,
    input   bit [(WB_DATA_WIDTH/8)-1:0] byte_select );
  // pragma tbx xtf                    
  @(posedge clk_i);                                                                     
  $display("wb_driver_bfm: Inside access()");
  do_transfer(
    op,
    data,
    addr,
    byte_select          );                                                  
  endtask      

// ****************************************************************************              
// UVMF_CHANGE_ME : Note that all transaction variables are passed into the response
//   task as outputs.  Some of these may need to be changed to inputs based on
//   protocol needs.
  task response(
 output wb_op_t op,
 inout bit [WB_DATA_WIDTH-1:0] data,
 output bit [WB_ADDR_WIDTH-1:0] addr,
 output bit [(WB_DATA_WIDTH/8)-1:0] byte_select );
  // pragma tbx xtf
     @(posedge clk_i);
     $display("wb_driver_bfm: Inside response()");
    do_response(
      op,
      data,
      addr,
      byte_select        );
  endtask             
  
endinterface