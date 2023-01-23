//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
//    This interface performs the alu_in signal driving.  It is
//     accessed by the uvm alu_in driver through a virtual interface
//     handle in the alu_in configuration.  It drives the singals passed
//     in through the port connection named bus of type alu_in_if.
//
//     Input signals from the alu_in_if are assigned to an internal input
//     signal with a _i suffix.  The _i signal should be used for sampling.
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i 
//
//     This bfm drives signals with a _o suffix.  These signals
//     are driven onto signals within alu_in_if based on INITIATOR/RESPONDER and/or
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
import alu_in_pkg_hdl::*;
`include "src/alu_in_macros.svh"

interface alu_in_driver_bfm #(
  int ALU_IN_OP_WIDTH = 8
  )
  (alu_in_if bus);
  // The following pragma and additional ones in-lined further below are for running this BFM on Veloce
  // pragma attribute alu_in_driver_bfm partition_interface_xif
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
  tri  ready_i;
  reg  ready_o = 'bz;

  // INITIATOR mode output signals
  tri  alu_rst_i;
  reg  alu_rst_o = 'bz;
  tri  valid_i;
  reg  valid_o = 'b0;
  tri [2:0] op_i;
  reg [2:0] op_o = 'bz;
  tri [ALU_IN_OP_WIDTH-1:0] a_i;
  reg [ALU_IN_OP_WIDTH-1:0] a_o = 'bz;
  tri [ALU_IN_OP_WIDTH-1:0] b_i;
  reg [ALU_IN_OP_WIDTH-1:0] b_o = 'bz;

  // Bi-directional signals
  

  assign clk_i = bus.clk;
  assign rst_i = bus.rst;

  // These are signals marked as 'input' by the config file, but the signals will be
  // driven by this BFM if put into RESPONDER mode (flipping all signal directions around)
  assign ready_i = bus.ready;
  assign bus.ready = (initiator_responder == RESPONDER) ? ready_o : 'bz;


  // These are signals marked as 'output' by the config file, but the outputs will
  // not be driven by this BFM unless placed in INITIATOR mode.
  assign bus.alu_rst = (initiator_responder == INITIATOR) ? alu_rst_o : 'bz;
  assign alu_rst_i = bus.alu_rst;
  assign bus.valid = (initiator_responder == INITIATOR) ? valid_o : 'bz;
  assign valid_i = bus.valid;
  assign bus.op = (initiator_responder == INITIATOR) ? op_o : 'bz;
  assign op_i = bus.op;
  assign bus.a = (initiator_responder == INITIATOR) ? a_o : 'bz;
  assign a_i = bus.a;
  assign bus.b = (initiator_responder == INITIATOR) ? b_o : 'bz;
  assign b_i = bus.b;

  // Proxy handle to UVM driver
  alu_in_pkg::alu_in_driver #(
    .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)
    )  proxy;
  // pragma tbx oneway proxy.my_function_name_in_uvm_driver                 

  // ****************************************************************************
  // **************************************************************************** 
  // Macros that define structs located in alu_in_macros.svh
  // ****************************************************************************
  // Struct for passing configuration data from alu_in_driver to this BFM
  // ****************************************************************************
  `alu_in_CONFIGURATION_STRUCT
  // ****************************************************************************
  // Structs for INITIATOR and RESPONDER data flow
  //*******************************************************************
  // Initiator macro used by alu_in_driver and alu_in_driver_bfm
  // to communicate initiator driven data to alu_in_driver_bfm.           
  `alu_in_INITIATOR_STRUCT
    alu_in_initiator_s alu_in_initiator_struct;
  // Responder macro used by alu_in_driver and alu_in_driver_bfm
  // to communicate Responder driven data to alu_in_driver_bfm.
  `alu_in_RESPONDER_STRUCT
    alu_in_responder_s alu_in_responder_struct;

  // ****************************************************************************              
  // Always block used to return signals to reset value upon assertion of reset
  always @( negedge rst_i )
     begin
       // RESPONDER mode output signals
       ready_o <= 'b0;
       // INITIATOR mode output signals
       alu_rst_o <= 'b0;
       valid_o <= 'b0;
       op_o <= 'b0;
       a_o <= 'b0;
       b_o <= 'b0;
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

  function void configure(alu_in_configuration_s alu_in_configuration_arg); // pragma tbx xtf  
    initiator_responder = alu_in_configuration_arg.initiator_responder;
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
       input alu_in_initiator_s alu_in_initiator_struct, 
       // This argument is used to send data received from the responder
       // back to the sequence item.  The sequence item is returned to the sequence.
       output alu_in_responder_s alu_in_responder_struct 
       );// pragma tbx xtf  
       // 
       // Members within the alu_in_initiator_struct:
       //   alu_in_op_t op ;
       //   bit [ALU_IN_OP_WIDTH-1:0] a ;
       //   bit [ALU_IN_OP_WIDTH-1:0] b ;
       // Members within the alu_in_responder_struct:
       //   alu_in_op_t op ;
       //   bit [ALU_IN_OP_WIDTH-1:0] a ;
       //   bit [ALU_IN_OP_WIDTH-1:0] b ;
       //
       // Reference code;
       //    How to wait for signal value
       //      while (control_signal == 1'b1) @(posedge clk_i);
       //    
       //    How to assign a responder struct member, named xyz, from a signal.   
       //    All available input signals listed.
       //      alu_in_responder_struct.xyz = alu_rst_i;  //     
       //      alu_in_responder_struct.xyz = ready_i;  //     
       //      alu_in_responder_struct.xyz = valid_i;  //     
       //      alu_in_responder_struct.xyz = op_i;  //    [2:0] 
       //      alu_in_responder_struct.xyz = a_i;  //    [ALU_IN_OP_WIDTH-1:0] 
       //      alu_in_responder_struct.xyz = b_i;  //    [ALU_IN_OP_WIDTH-1:0] 
       //    How to assign a signal, named xyz, from an initiator struct member.   
       //    All available input signals listed.
       //    Notice the _o.  Those are storage variables that allow for procedural assignment.
       //      alu_rst_o <= alu_in_initiator_struct.xyz;  //     
       //      ready_o <= alu_in_initiator_struct.xyz;  //     
       //      valid_o <= alu_in_initiator_struct.xyz;  //     
       //      op_o <= alu_in_initiator_struct.xyz;  //    [2:0] 
       //      a_o <= alu_in_initiator_struct.xyz;  //    [ALU_IN_OP_WIDTH-1:0] 
       //      b_o <= alu_in_initiator_struct.xyz;  //    [ALU_IN_OP_WIDTH-1:0] 
    // Initiate a transfer using the data received.
     @(posedge clk_i) ;
     while ( ready_i == 1'b0 ) @(posedge clk_i) ;
     valid_o <= 1'b1;
     op_o <= alu_in_initiator_struct.op;
     a_o <= alu_in_initiator_struct.a;
     b_o <= alu_in_initiator_struct.b;
     @(posedge clk_i);
     valid_o <= 1'b0;
     op_o <= {3{1'bx}};
     a_o <= {ALU_IN_OP_WIDTH{1'bx}};
     b_o <= {ALU_IN_OP_WIDTH{1'bx}};
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
       output alu_in_initiator_s alu_in_initiator_struct, 
       // This argument passes transaction variables used by a responder
       // to complete a protocol transfer.  The values come from a sequence item.       
       input alu_in_responder_s alu_in_responder_struct 
       );// pragma tbx xtf   
  // Variables within the alu_in_initiator_struct:
  //   alu_in_op_t op ;
  //   bit [ALU_IN_OP_WIDTH-1:0] a ;
  //   bit [ALU_IN_OP_WIDTH-1:0] b ;
  // Variables within the alu_in_responder_struct:
  //   alu_in_op_t op ;
  //   bit [ALU_IN_OP_WIDTH-1:0] a ;
  //   bit [ALU_IN_OP_WIDTH-1:0] b ;
        
  @(posedge clk_i);
  if (!first_transfer) begin
    // Perform transfer response here.   
    // Reply using data recieved in the alu_in_responder_struct.
    @(posedge clk_i);
    // Reply using data recieved in the transaction handle.
    @(posedge clk_i);
  end
    // Wait for next transfer then gather info from intiator about the transfer.
    // Place the data into the alu_in_initiator_struct.
    @(posedge clk_i);
    @(posedge clk_i);
    first_transfer = 0;
  endtask


// pragma uvmf custom respond_and_wait_for_next_transfer end

 
endinterface
