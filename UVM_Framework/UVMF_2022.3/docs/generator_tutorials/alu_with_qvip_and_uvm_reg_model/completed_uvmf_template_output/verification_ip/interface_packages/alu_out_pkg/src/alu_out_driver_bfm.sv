//----------------------------------------------------------------------
// Created with uvmf_gen version 2020.1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
//    This interface performs the alu_out signal driving.  It is
//     accessed by the uvm alu_out driver through a virtual interface
//     handle in the alu_out configuration.  It drives the singals passed
//     in through the port connection named bus of type alu_out_if.
//
//     Input signals from the alu_out_if are assigned to an internal input
//     signal with a _i suffix.  The _i signal should be used for sampling.
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i 
//
//     This bfm drives signals with a _o suffix.  These signals
//     are driven onto signals within alu_out_if based on INITIATOR/RESPONDER and/or
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
import alu_out_pkg_hdl::*;
`include "src/alu_out_macros.svh"

interface alu_out_driver_bfm #(
  int ALU_OUT_RESULT_WIDTH = 16
  )
  (alu_out_if bus);
  // The following pragma and additional ones in-lined further below are for running this BFM on Veloce
  // pragma attribute alu_out_driver_bfm partition_interface_xif
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
  tri  done_i;
  reg  done_o = 'bz;
  tri [ALU_OUT_RESULT_WIDTH-1:0] result_i;
  reg [ALU_OUT_RESULT_WIDTH-1:0] result_o = 'bz;

  // INITIATOR mode output signals

  // Bi-directional signals
  

  assign clk_i = bus.clk;
  assign rst_i = bus.rst;

  // These are signals marked as 'input' by the config file, but the signals will be
  // driven by this BFM if put into RESPONDER mode (flipping all signal directions around)
  assign done_i = bus.done;
  assign bus.done = (initiator_responder == RESPONDER) ? done_o : 'bz;
  assign result_i = bus.result;
  assign bus.result = (initiator_responder == RESPONDER) ? result_o : 'bz;


  // These are signals marked as 'output' by the config file, but the outputs will
  // not be driven by this BFM unless placed in INITIATOR mode.

  // Proxy handle to UVM driver
  alu_out_pkg::alu_out_driver #(
    .ALU_OUT_RESULT_WIDTH(ALU_OUT_RESULT_WIDTH)
    )  proxy;
  // pragma tbx oneway proxy.my_function_name_in_uvm_driver                 

  // ****************************************************************************
  // **************************************************************************** 
  // Macros that define structs located in alu_out_macros.svh
  // ****************************************************************************
  // Struct for passing configuration data from alu_out_driver to this BFM
  // ****************************************************************************
  `alu_out_CONFIGURATION_STRUCT
  // ****************************************************************************
  // Structs for INITIATOR and RESPONDER data flow
  //*******************************************************************
  // Initiator macro used by alu_out_driver and alu_out_driver_bfm
  // to communicate initiator driven data to alu_out_driver_bfm.           
  `alu_out_INITIATOR_STRUCT
    alu_out_initiator_s alu_out_initiator_struct;
  // Responder macro used by alu_out_driver and alu_out_driver_bfm
  // to communicate Responder driven data to alu_out_driver_bfm.
  `alu_out_RESPONDER_STRUCT
    alu_out_responder_s alu_out_responder_struct;

  // ****************************************************************************              
  // Always block used to return signals to reset value upon assertion of reset
  always @( negedge rst_i )
     begin
       // RESPONDER mode output signals
       done_o <= 'bz;
       result_o <= 'bz;
       // INITIATOR mode output signals
       // Bi-directional signals
 
     end    

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

  function void configure(alu_out_configuration_s alu_out_configuration_arg); // pragma tbx xtf  
    initiator_responder = alu_out_configuration_arg.initiator_responder;
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
       input alu_out_initiator_s alu_out_initiator_struct, 
       // This argument is used to send data received from the responder
       // back to the sequence item.  The sequence item is returned to the sequence.
       output alu_out_responder_s alu_out_responder_struct 
       );// pragma tbx xtf  
       // 
       // Members within the alu_out_initiator_struct:
       //   bit [ALU_OUT_RESULT_WIDTH-1:0] result ;
       // Members within the alu_out_responder_struct:
       //   bit [ALU_OUT_RESULT_WIDTH-1:0] result ;
       //
       // Reference code;
       //    How to wait for signal value
       //      while (control_signal == 1'b1) @(posedge clk_i);
       //    
       //    How to assign a responder struct member, named xyz, from a signal.   
       //    All available input signals listed.
       //      alu_out_responder_struct.xyz = done_i;  //     
       //      alu_out_responder_struct.xyz = result_i;  //    [ALU_OUT_RESULT_WIDTH-1:0] 
       //    How to assign a signal, named xyz, from an initiator struct member.   
       //    All available input signals listed.
       //    Notice the _o.  Those are storage variables that allow for procedural assignment.
       //      done_o <= alu_out_initiator_struct.xyz;  //     
       //      result_o <= alu_out_initiator_struct.xyz;  //    [ALU_OUT_RESULT_WIDTH-1:0] 
    // Initiate a transfer using the data received.
    @(posedge clk_i);
    @(posedge clk_i);
    // Wait for the responder to complete the transfer then place the responder data into 
    // alu_out_responder_struct.
    @(posedge clk_i);
    @(posedge clk_i);
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
       output alu_out_initiator_s alu_out_initiator_struct, 
       // This argument passes transaction variables used by a responder
       // to complete a protocol transfer.  The values come from a sequence item.       
       input alu_out_responder_s alu_out_responder_struct 
       );// pragma tbx xtf   
  // Variables within the alu_out_initiator_struct:
  //   bit [ALU_OUT_RESULT_WIDTH-1:0] result ;
  // Variables within the alu_out_responder_struct:
  //   bit [ALU_OUT_RESULT_WIDTH-1:0] result ;
        
  @(posedge clk_i);
  if (!first_transfer) begin
    // Perform transfer response here.   
    // Reply using data recieved in the alu_out_responder_struct.
    @(posedge clk_i);
    // Reply using data recieved in the transaction handle.
    @(posedge clk_i);
  end
    // Wait for next transfer then gather info from intiator about the transfer.
    // Place the data into the alu_out_initiator_struct.
    @(posedge clk_i);
    @(posedge clk_i);
    first_transfer = 0;
  endtask
// pragma uvmf custom respond_and_wait_for_next_transfer end

 
endinterface
