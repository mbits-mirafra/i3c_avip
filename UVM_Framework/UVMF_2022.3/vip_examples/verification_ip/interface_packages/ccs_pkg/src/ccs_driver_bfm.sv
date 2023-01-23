//----------------------------------------------------------------------
// Created with uvmf_gen version 2021.1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
//    This interface performs the ccs signal driving.  It is
//     accessed by the uvm ccs driver through a virtual interface
//     handle in the ccs configuration.  It drives the singals passed
//     in through the port connection named bus of type ccs_if.
//
//     Input signals from the ccs_if are assigned to an internal input
//     signal with a _i suffix.  The _i signal should be used for sampling.
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i 
//
//     This bfm drives signals with a _o suffix.  These signals
//     are driven onto signals within ccs_if based on INITIATOR/RESPONDER and/or
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
import ccs_pkg_hdl::*;
`include "src/ccs_macros.svh"

interface ccs_driver_bfm #(
  int WIDTH = 32
  )
  (ccs_if bus);
  // The following pragma and additional ones in-lined further below are for running this BFM on Veloce
  // pragma attribute ccs_driver_bfm partition_interface_xif
  // Config value to determine if this is an initiator or a responder 
  uvmf_initiator_responder_t initiator_responder;
  // Custom configuration variables.  
  // These are set using the configure function which is called during the UVM connect_phase
  bit [2:0] protocol_kind;
  bit reset_polarity;

  tri clk_i;
  tri rst_i;

  // Signal list (all signals are capable of being inputs and outputs for the sake
  // of supporting both INITIATOR and RESPONDER mode operation. Expectation is that 
  // directionality in the config file was from the point-of-view of the INITIATOR

  // INITIATOR mode input signals
  tri  rdy_i;
  reg  rdy_o = 'b0;

  // INITIATOR mode output signals
  tri  vld_i;
  reg  vld_o = 'b0;
  tri [WIDTH-1:0] dat_i;
  reg [WIDTH-1:0] dat_o = 'b0;

  // Bi-directional signals
  

  assign clk_i = bus.clk;
  assign rst_i = bus.rst;

  // These are signals marked as 'input' by the config file, but the signals will be
  // driven by this BFM if put into RESPONDER mode (flipping all signal directions around)
  assign rdy_i = bus.rdy;
  assign bus.rdy = (initiator_responder == RESPONDER) ? rdy_o : 'bz;


  // These are signals marked as 'output' by the config file, but the outputs will
  // not be driven by this BFM unless placed in INITIATOR mode.
  assign bus.vld = (initiator_responder == INITIATOR) ? vld_o : 'bz;
  assign vld_i = bus.vld;
  assign bus.dat = (initiator_responder == INITIATOR) ? dat_o : 'bz;
  assign dat_i = bus.dat;

  // Proxy handle to UVM driver
  ccs_pkg::ccs_driver #(
    .WIDTH(WIDTH)
    )  proxy;
  // pragma tbx oneway proxy.my_function_name_in_uvm_driver                 

  // ****************************************************************************
  // **************************************************************************** 
  // Macros that define structs located in ccs_macros.svh
  // ****************************************************************************
  // Struct for passing configuration data from ccs_driver to this BFM
  // ****************************************************************************
  `ccs_CONFIGURATION_STRUCT
  // ****************************************************************************
  // Structs for INITIATOR and RESPONDER data flow
  //*******************************************************************
  // Initiator macro used by ccs_driver and ccs_driver_bfm
  // to communicate initiator driven data to ccs_driver_bfm.           
  `ccs_INITIATOR_STRUCT
    ccs_initiator_s initiator_struct;
  // Responder macro used by ccs_driver and ccs_driver_bfm
  // to communicate Responder driven data to ccs_driver_bfm.
  `ccs_RESPONDER_STRUCT
    ccs_responder_s responder_struct;

  // ****************************************************************************
// pragma uvmf custom reset_condition_and_response begin
always @(rst_i)
begin
  if ( rst_i == reset_polarity )
  begin
    $display("ccs_driver_bfm in RESET\n");
    // RESPONDER mode output signals
    rdy_o <= 'b0;
    // INITIATOR mode output signals
    vld_o <= 'b0;
    dat_o <= 'b0;
    // Bi-directional signals
  end
end
// pragma uvmf custom reset_condition_and_response end

  // pragma uvmf custom interface_item_additional begin
  // pragma uvmf custom interface_item_additional end

  //******************************************************************
  // The configure() function is used to pass agent configuration
  // variables to the driver BFM.  It is called by the driver within
  // the agent at the beginning of the simulation.  It may be called 
  // during the simulation if agent configuration variables are updated
  // and the driver BFM needs to be aware of the new configuration 
  // variables.
  //

  function void configure(ccs_configuration_s ccs_configuration_arg); // pragma tbx xtf  
    initiator_responder = ccs_configuration_arg.initiator_responder;
    protocol_kind = ccs_configuration_arg.protocol_kind;
    reset_polarity = ccs_configuration_arg.reset_polarity;
  // pragma uvmf custom configure begin
  // pragma uvmf custom configure end
  endfunction                                                                             

// pragma uvmf custom initiate_and_get_response begin
bit transfer_active = 0;

// ****************************************************************************
// UVMF_CHANGE_ME
// This task is used by an initator.  The task first initiates a transfer then
// waits for the responder to complete the transfer.
    task initiate_and_get_response(
       // This argument passes transaction variables used by an initiator
       // to perform the initial part of a protocol transfer.  The values
       // come from a sequence item created in a sequence.
       input ccs_initiator_s ccs_initiator_struct,
       // This argument is used to send data received from the responder
       // back to the sequence item.  The sequence item is returned to the sequence.
       output ccs_responder_s ccs_responder_struct
       );// pragma tbx xtf
       //
       // Members within the ccs_initiator_struct:
       //   bit [WIDTH-1:0] rtl_data ;
       //   int unsigned wait_cycles ;
       //   int unsigned iteration_count ;
       // Members within the ccs_responder_struct:
       //   bit [WIDTH-1:0] rtl_data ;
       //   int unsigned wait_cycles ;
       //   int unsigned iteration_count ;
       //
       // Reference code;
       //    How to wait for signal value
       //      while (control_signal == 1'b1) @(posedge clk_i);
       //
       //    How to assign a responder struct member, named xyz, from a signal.
       //    All available input signals listed.
       //      ccs_responder_struct.xyz = rdy_i;  //
       //      ccs_responder_struct.xyz = vld_i;  //
       //      ccs_responder_struct.xyz = dat_i;  //    [WIDTH-1:0]
       //    How to assign a signal, named xyz, from an initiator struct member.
       //    All available input signals listed.
       //    Notice the _o.  Those are storage variables that allow for procedural assignment.
       //      rdy_o <= ccs_initiator_struct.xyz;  //
       //      vld_o <= ccs_initiator_struct.xyz;  //
       //      dat_o <= ccs_initiator_struct.xyz;  //    [WIDTH-1:0]
/*
    // Initiate a transfer using the data received.
    @(posedge clk_i);
    @(posedge clk_i);
    // Wait for the responder to complete the transfer then place the responder data into
    // ccs_responder_struct.
    @(posedge clk_i);
    @(posedge clk_i);
*/
    @(posedge clk_i); // required by Veloce TBX

    if ( rst_i == reset_polarity ) begin
      dat_o = {WIDTH{1'b0}};
      vld_o = 1'b0;
      transfer_active = 1'b0;
      while ( rst_i == reset_polarity ) @(posedge clk_i);
    end

    if ( ccs_initiator_struct.empty ) begin
      if ((protocol_kind == CCS_RDY || protocol_kind == CCS_WAIT || protocol_kind == CCS_SYNC) && transfer_active) begin // only for those protocols which use rdy
          while ( !rdy_i ) @(posedge clk_i);
      end
      vld_o = 1'b0;
      transfer_active = 0;
    end
    else begin
      case (protocol_kind)
        CCS : begin // drive input data
          dat_o = ccs_initiator_struct.rtl_data;
        end
        CCS_RDY : begin // drive input data and hold until rdy=1
          if (transfer_active) begin
            while ( !rdy_i ) @(posedge clk_i);
          end
          dat_o = ccs_initiator_struct.rtl_data;
          transfer_active = 1;
        end
        CCS_VLD : begin // drive input data after i/o stalling (vld -> 0) for wait_cycles>0
          if ( ccs_initiator_struct.wait_cycles > 0 ) begin
            vld_o = 1'b0;
            repeat( ccs_initiator_struct.wait_cycles ) @(posedge clk_i);
          end
          vld_o = 1'b1;
          dat_o = ccs_initiator_struct.rtl_data;
        end
        CCS_WAIT : begin // drive input data and hold until rdy=1 after i/o stalling (vld -> 0) for wait_cycles>0
          if (transfer_active) begin
            while ( !rdy_i ) @(posedge clk_i);
          end

          if ( ccs_initiator_struct.wait_cycles > 0 ) begin
            vld_o = 1'b0;
            repeat( ccs_initiator_struct.wait_cycles ) @(posedge clk_i);
          end
          vld_o = 1'b1;
          dat_o = ccs_initiator_struct.rtl_data;
          transfer_active = 1;
        end
        CCS_SYNC : begin // hold until rdy=1 after i/o stalling (vld -> 0) for wait_cycles>0
          if (transfer_active) begin
            while ( !rdy_i ) @(posedge clk_i);
          end
          if ( ccs_initiator_struct.wait_cycles > 0 ) begin
            vld_o = 1'b0;
            repeat( ccs_initiator_struct.wait_cycles ) @(posedge clk_i);
          end
          vld_o = 1'b1;
          dat_o = vld_o;
          transfer_active = 1;
        end
      endcase
    end

  endtask
// pragma uvmf custom initiate_and_get_response end

// pragma uvmf custom respond_and_wait_for_next_transfer begin
// The first_transfer variable is used to prevent completing a transfer in the
// first call to this task.  For the first call to this task, there is no
// current transfer to complete.
bit first_transfer = 1;
bit mon_transfer_active = 0;

// UVMF_CHANGE_ME
// This task is used by a responder.  The task first completes the current
// transfer in progress then waits for the initiator to start the next transfer.
  task respond_and_wait_for_next_transfer(
       // This argument is used to send data received from the initiator
       // back to the sequence item.  The sequence determines how to respond.
       output ccs_initiator_s ccs_initiator_struct,
       // This argument passes transaction variables used by a responder
       // to complete a protocol transfer.  The values come from a sequence item.
       input ccs_responder_s ccs_responder_struct
       );// pragma tbx xtf
  // Variables within the ccs_initiator_struct:
  //   bit [WIDTH-1:0] rtl_data ;
  //   int unsigned wait_cycles ;
  //   int unsigned iteration_count ;
  // Variables within the ccs_responder_struct:
  //   bit [WIDTH-1:0] rtl_data ;
  //   int unsigned wait_cycles ;
  //   int unsigned iteration_count ;

/*
  @(posedge clk_i);
  if (!first_transfer) begin
    // Perform transfer response here.
    // Reply using data recieved in the ccs_responder_struct.
    @(posedge clk_i);
    // Reply using data recieved in the transaction handle.
    @(posedge clk_i);
  end
    // Wait for next transfer then gather info from intiator about the transfer.
    // Place the data into the ccs_initiator_struct.
    @(posedge clk_i);
    @(posedge clk_i);
    first_transfer = 0;
*/

  @(posedge clk_i);  // required by Veloce TBX

    if ( rst_i == reset_polarity ) begin
      rdy_o = 1'b0;
      mon_transfer_active = 1'b0;
      while ( rst_i == reset_polarity ) @(posedge clk_i);
    end

    if ( !first_transfer ) begin
      case (protocol_kind)
        CCS : begin // drive response data
          ccs_responder_struct.rtl_data = dat_i;
        end
        CCS_RDY : begin // drive response data after i/o stalling (rdy -> 0) for wait_cycles>0
          if ( ccs_responder_struct.wait_cycles > 0 ) begin
            rdy_o = 1'b0;
            repeat( ccs_responder_struct.wait_cycles ) @(posedge clk_i);
          end
          rdy_o = 1'b1;
          ccs_responder_struct.rtl_data = dat_i;
          mon_transfer_active = 1;
        end
        CCS_VLD : begin // drive response data when vld=1
          if (mon_transfer_active) begin
            while ( !vld_i ) @(posedge clk_i);
          end
          ccs_responder_struct.rtl_data = dat_i;
        end
        CCS_WAIT : begin // drive response data when vld=1 after i/o stalling (rdy -> 0) for wait_cycles>0
          if (mon_transfer_active) begin
            while ( !vld_i ) @(posedge clk_i);
          end
          if ( ccs_responder_struct.wait_cycles > 0 ) begin
            rdy_o = 1'b0;
            repeat( ccs_responder_struct.wait_cycles ) @(posedge clk_i);
          end
          rdy_o = 1'b1;
          ccs_responder_struct.rtl_data = dat_i;
          mon_transfer_active = 1;
        end
        CCS_SYNC : begin //  vld=1 after i/o stalling (rdy -> 0) for wait_cycles>0
          if (mon_transfer_active) begin
            while ( !vld_i ) @(posedge clk_i);
          end
          if ( ccs_responder_struct.wait_cycles > 0 ) begin
            rdy_o = 1'b0;
            repeat( ccs_responder_struct.wait_cycles ) @(posedge clk_i);
          end
          rdy_o = 1'b1;
          mon_transfer_active = 1;
          ccs_responder_struct.rtl_data = rdy_o;
        end
      endcase
    end
    first_transfer = 0;

  endtask
// pragma uvmf custom respond_and_wait_for_next_transfer end

 
endinterface
