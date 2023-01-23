//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
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
//
//             configure:
//                   This function gets configuration attributes from the
//                   UVM driver to set any required BFM configuration
//                   variables such as 'initiator_responder'.                                       
//                                                                                           
//             initiate_and_get_response:
//                   This task is used to perform signaling activity for initiating
//                   a protocol transfer.  The task initiates the transfer, using
//                   input data from the initiator struct.  Then the task captures
//                   response data, placing the data into the response struct.
//                   The response struct is returned to the driver class.
//
//             respond_and_wait_for_next_transfer:
//                   This task is used to complete a current transfer as a responder
//                   and then wait for the initiator to start the next transfer.
//                   The task uses data in the responder struct to drive protocol
//                   signals to complete the transfer.  The task then waits for 
//                   the next transfer.  Once the next transfer begins, data from
//                   the initiator is placed into the initiator struct and sent
//                   to the responder sequence for processing to determine 
//                   what data to respond with.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import wb_pkg_hdl::*;
`include "src/wb_macros.svh"

interface wb_driver_bfm #(
  int WB_ADDR_WIDTH = 32,
  int WB_DATA_WIDTH = 16
  )
  (wb_if bus);
  // The following pragma and additional ones in-lined further below are for running this BFM on Veloce
  // pragma attribute wb_driver_bfm partition_interface_xif
  // Config value to determine if this is an initiator or a responder 
  uvmf_initiator_responder_t initiator_responder;
  // Custom configuration variables.  
  // These are set using the configure function which is called during the UVM connect_phase

  tri clk_i;
  tri rst_i;

  // Signal list (all signals are capable of being inputs and outputs for the sake
  // of supporting both INITIATOR and RESPONDER mode operation. Expectation is that 
  // directionality in the config file was from the point-of-view of the INITIATOR

  // INITIATOR mode input signals
  tri [WB_DATA_WIDTH-1:0] din_i;
  reg [WB_DATA_WIDTH-1:0] din_o = 'bz;
  tri [WB_DATA_WIDTH/8-1:0] sel_i;
  reg [WB_DATA_WIDTH/8-1:0] sel_o = 'bz;
  tri [WB_DATA_WIDTH-1:0] q_i;
  reg [WB_DATA_WIDTH-1:0] q_o = 'bz;
  tri  ack_i;
  reg  ack_o = 1'b0;

  // INITIATOR mode output signals
  tri  inta_i;
  reg  inta_o = 'bz;
  tri  cyc_i;
  reg  cyc_o = 0;
  tri  stb_i;
  reg  stb_o = 0;
  tri [WB_ADDR_WIDTH-1:0] adr_i;
  reg [WB_ADDR_WIDTH-1:0] adr_o = 'bz;
  tri  we_i;
  reg  we_o = 0;
  tri [WB_DATA_WIDTH-1:0] dout_i;
  reg [WB_DATA_WIDTH-1:0] dout_o = 'bz;
  tri  err_i;
  reg  err_o = 'bz;
  tri  rty_i;
  reg  rty_o = 'bz;

  // Bi-directional signals
  

  assign clk_i = bus.clk;
  assign rst_i = bus.rst;

  // These are signals marked as 'input' by the config file, but the signals will be
  // driven by this BFM if put into RESPONDER mode (flipping all signal directions around)
  assign din_i = bus.din;
  assign bus.din = (initiator_responder == RESPONDER) ? din_o : 'bz;
  assign sel_i = bus.sel;
  assign bus.sel = (initiator_responder == RESPONDER) ? sel_o : 'bz;
  assign q_i = bus.q;
  assign bus.q = (initiator_responder == RESPONDER) ? q_o : 'bz;
  assign ack_i = bus.ack;
  assign bus.ack = (initiator_responder == RESPONDER) ? ack_o : 'bz;


  // These are signals marked as 'output' by the config file, but the outputs will
  // not be driven by this BFM unless placed in INITIATOR mode.
  assign bus.inta = (initiator_responder == INITIATOR) ? inta_o : 'bz;
  assign inta_i = bus.inta;
  assign bus.cyc = (initiator_responder == INITIATOR) ? cyc_o : 'bz;
  assign cyc_i = bus.cyc;
  assign bus.stb = (initiator_responder == INITIATOR) ? stb_o : 'bz;
  assign stb_i = bus.stb;
  assign bus.adr = (initiator_responder == INITIATOR) ? adr_o : 'bz;
  assign adr_i = bus.adr;
  assign bus.we = (initiator_responder == INITIATOR) ? we_o : 'bz;
  assign we_i = bus.we;
  assign bus.dout = (initiator_responder == INITIATOR) ? dout_o : 'bz;
  assign dout_i = bus.dout;
  assign bus.err = (initiator_responder == INITIATOR) ? err_o : 'bz;
  assign err_i = bus.err;
  assign bus.rty = (initiator_responder == INITIATOR) ? rty_o : 'bz;
  assign rty_i = bus.rty;

  // Proxy handle to UVM driver
  wb_pkg::wb_driver #(
    .WB_ADDR_WIDTH(WB_ADDR_WIDTH),
    .WB_DATA_WIDTH(WB_DATA_WIDTH)
    )  proxy;
  // pragma tbx oneway proxy.my_function_name_in_uvm_driver                 

  // ****************************************************************************
  // **************************************************************************** 
  // Macros that define structs located in wb_macros.svh
  // ****************************************************************************
  // Struct for passing configuration data from wb_driver to this BFM
  // ****************************************************************************
  `wb_CONFIGURATION_STRUCT
  // ****************************************************************************
  // Structs for INITIATOR and RESPONDER data flow
  //*******************************************************************
  // Initiator macro used by wb_driver and wb_driver_bfm
  // to communicate initiator driven data to wb_driver_bfm.           
  `wb_INITIATOR_STRUCT
    wb_initiator_s wb_initiator_struct;
  // Responder macro used by wb_driver and wb_driver_bfm
  // to communicate Responder driven data to wb_driver_bfm.
  `wb_RESPONDER_STRUCT
    wb_responder_s wb_responder_struct;

  // ****************************************************************************              
  // Always block used to return signals to reset value upon assertion of reset
  always @( negedge rst_i )
     begin
       // RESPONDER mode output signals
       din_o <= 'b0;
       sel_o <= 'b0;
       q_o <= 'b0;
       ack_o <= 1'b0;
       // INITIATOR mode output signals
       inta_o <= 'b0;
       cyc_o <= 0;
       stb_o <= 0;
       adr_o <= 'b0;
       we_o <= 0;
       dout_o <= 'b0;
       err_o <= 'b0;
       rty_o <= 'b0;
       // Bi-directional signals
 
     end    

  // pragma uvmf custom interface_item_additional begin
  bit cyc_q, stb_q;
  always @(posedge clk_i) begin
    cyc_q <= cyc_i;
    stb_q <= stb_i;
  end
  // Need to detect rising edge on cyc and stb in order to begin a new operation
  wire cycle_ready = (!cyc_q & cyc_i) & (!stb_q & stb_i);





  // pragma uvmf custom interface_item_additional end

  //******************************************************************
  // The configure() function is used to pass agent configuration
  // variables to the driver BFM.  It is called by the driver within
  // the agent at the beginning of the simulation.  It may be called 
  // during the simulation if agent configuration variables are updated
  // and the driver BFM needs to be aware of the new configuration 
  // variables.
  //

  function void configure(wb_configuration_s wb_configuration_arg); // pragma tbx xtf  
    initiator_responder = wb_configuration_arg.initiator_responder;
  // pragma uvmf custom configure begin
  // pragma uvmf custom configure end
  endfunction                                                                             

// pragma uvmf custom initiate_and_get_response begin
// ****************************************************************************
// UVMF_CHANGE_ME
// This task is used by an initator.  The task first initiates a transfer then
// waits for the responder to complete the transfer.
    task initiate_and_get_response( 
       // This argument passes transaction variables used by an initiator
       // to perform the initial part of a protocol transfer.  The values
       // come from a sequence item created in a sequence.
       input wb_initiator_s wb_initiator_struct, 
       // This argument is used to send data received from the responder
       // back to the sequence item.  The sequence item is returned to the sequence.
       output wb_responder_s wb_responder_struct 
       );// pragma tbx xtf  
       // 
       // Members within the wb_initiator_struct:
       //   wb_op_t op ;
       //   bit [WB_DATA_WIDTH-1:0] data ;
       //   bit [WB_ADDR_WIDTH-1:0] addr ;
       //   bit [(WB_DATA_WIDTH/8)-1:0] byte_select ;
       // Members within the wb_responder_struct:
       //   wb_op_t op ;
       //   bit [WB_DATA_WIDTH-1:0] data ;
       //   bit [WB_ADDR_WIDTH-1:0] addr ;
       //   bit [(WB_DATA_WIDTH/8)-1:0] byte_select ;
       //
       // Reference code;
       //    How to wait for signal value
       //      while (control_signal == 1'b1) @(posedge clk_i);
       //    
       //    How to assign a responder struct member, named xyz, from a signal.   
       //    All available input signals listed.
       //      wb_responder_struct.xyz = inta_i;  //     
       //      wb_responder_struct.xyz = cyc_i;  //     
       //      wb_responder_struct.xyz = stb_i;  //     
       //      wb_responder_struct.xyz = adr_i;  //    [WB_ADDR_WIDTH-1:0] 
       //      wb_responder_struct.xyz = we_i;  //     
       //      wb_responder_struct.xyz = dout_i;  //    [WB_DATA_WIDTH-1:0] 
       //      wb_responder_struct.xyz = din_i;  //    [WB_DATA_WIDTH-1:0] 
       //      wb_responder_struct.xyz = err_i;  //     
       //      wb_responder_struct.xyz = rty_i;  //     
       //      wb_responder_struct.xyz = sel_i;  //    [WB_DATA_WIDTH/8-1:0] 
       //      wb_responder_struct.xyz = q_i;  //    [WB_DATA_WIDTH-1:0] 
       //      wb_responder_struct.xyz = ack_i;  //     
       //    How to assign a signal, named xyz, from an initiator struct member.   
       //    All available input signals listed.
       //    Notice the _o.  Those are storage variables that allow for procedural assignment.
       //      inta_o <= wb_initiator_struct.xyz;  //     
       //      cyc_o <= wb_initiator_struct.xyz;  //     
       //      stb_o <= wb_initiator_struct.xyz;  //     
       //      adr_o <= wb_initiator_struct.xyz;  //    [WB_ADDR_WIDTH-1:0] 
       //      we_o <= wb_initiator_struct.xyz;  //     
       //      dout_o <= wb_initiator_struct.xyz;  //    [WB_DATA_WIDTH-1:0] 
       //      din_o <= wb_initiator_struct.xyz;  //    [WB_DATA_WIDTH-1:0] 
       //      err_o <= wb_initiator_struct.xyz;  //     
       //      rty_o <= wb_initiator_struct.xyz;  //     
       //      sel_o <= wb_initiator_struct.xyz;  //    [WB_DATA_WIDTH/8-1:0] 
       //      q_o <= wb_initiator_struct.xyz;  //    [WB_DATA_WIDTH-1:0] 
       //      ack_o <= wb_initiator_struct.xyz;  //     
    @(posedge clk_i);
    case (wb_initiator_struct.op)
      WB_WRITE : begin
        adr_o <= wb_initiator_struct.addr;
        dout_o <= wb_initiator_struct.data;
        cyc_o <= 1'b1;
        stb_o <= 1'b1;
        we_o <= 1'b1;
        sel_o <= wb_initiator_struct.byte_select;
        while (!ack_i) @(posedge clk_i);
        cyc_o <= 1'b0;
        stb_o <= 1'b0;
        adr_o <= 'bx;
        dout_o <= 'bx;
        we_o <= 1'b0;
        sel_o <= 1'b0;
        wb_responder_struct.data = wb_initiator_struct.data;
        @(posedge clk_i);
        @(posedge clk_i);
      end
      WB_READ : begin
        adr_o <= wb_initiator_struct.addr;
        dout_o <= 'bx;
        cyc_o <= 1'b1;
        stb_o <= 1'b1;
        we_o <= 1'b0;
        sel_o <= wb_initiator_struct.byte_select;
        @(posedge clk_i);
        while (!ack_i) @(posedge clk_i);
        cyc_o <= 1'b0;
        stb_o <= 1'b0;
        adr_o <= 'bx;
        dout_o <= 'bx;
        we_o <= 1'b0;
        sel_o <= 'b0;
        wb_responder_struct.data = din_i;
      end
    endcase

  endtask        



// pragma uvmf custom initiate_and_get_response end

// pragma uvmf custom respond_and_wait_for_next_transfer begin
// ****************************************************************************
// The first_transfer variable is used to prevent completing a transfer in the 
// first call to this task.  For the first call to this task, there is not
// current transfer to complete.
bit first_transfer=1;

// UVMF_CHANGE_ME
// This task is used by a responder.  The task first completes the current 
// transfer in progress then waits for the initiator to start the next transfer.
  task respond_and_wait_for_next_transfer( 
       // This argument is used to send data received from the initiator
       // back to the sequence item.  The sequence determines how to respond.
       output wb_initiator_s wb_initiator_struct, 
       // This argument passes transaction variables used by a responder
       // to complete a protocol transfer.  The values come from a sequence item.       
       input wb_responder_s wb_responder_struct 
       );// pragma tbx xtf   
  // Variables within the wb_initiator_struct:
  //   wb_op_t op ;
  //   bit [WB_DATA_WIDTH-1:0] data ;
  //   bit [WB_ADDR_WIDTH-1:0] addr ;
  //   bit [(WB_DATA_WIDTH/8)-1:0] byte_select ;
  // Variables within the wb_responder_struct:
  //   wb_op_t op ;
  //   bit [WB_DATA_WIDTH-1:0] data ;
  //   bit [WB_ADDR_WIDTH-1:0] addr ;
  //   bit [(WB_DATA_WIDTH/8)-1:0] byte_select ;
        
    @(posedge clk_i);
    if (!first_transfer) begin
      din_o <= wb_responder_struct.data;
      ack_o <= 1'b1;
      @(posedge clk_i);
      din_o <= 'b0;
      ack_o <= 1'b0;
    end
    // Wait for next transfer then gather info from intiator about the transfer.
    // Place the data into the wb_initiator_struct.
    while (cycle_ready!==1'b1) @(posedge clk_i);
    wb_initiator_struct.addr = adr_i;
    wb_initiator_struct.data = dout_i;
    if (we_i) begin
      wb_initiator_struct.op = WB_WRITE;
    end else begin
      wb_initiator_struct.op = WB_READ;
    end
    first_transfer = 0;


  endtask



// pragma uvmf custom respond_and_wait_for_next_transfer end

 
endinterface
