//----------------------------------------------------------------------
// Created with uvmf_gen version 2022.3
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
//    This interface performs the i3c_m signal driving.  It is
//     accessed by the uvm i3c_m driver through a virtual interface
//     handle in the i3c_m configuration.  It drives the singals passed
//     in through the port connection named bus of type i3c_m_if.
//
//     Input signals from the i3c_m_if are assigned to an internal input
//     signal with a _i suffix.  The _i signal should be used for sampling.
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i 
//
//     This bfm drives signals with a _o suffix.  These signals
//     are driven onto signals within i3c_m_if based on INITIATOR/RESPONDER and/or
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
import i3c_m_pkg_hdl::*;
`include "src/i3c_m_macros.svh"

interface i3c_m_driver_bfm 
  (i3c_m_if bus);
  // The following pragma and additional ones in-lined further below are for running this BFM on Veloce
  // pragma attribute i3c_m_driver_bfm partition_interface_xif

`ifndef XRTL
// This code is to aid in debugging parameter mismatches between the BFM and its corresponding agent.
// Enable this debug by setting UVM_VERBOSITY to UVM_DEBUG
// Setting UVM_VERBOSITY to UVM_DEBUG causes all BFM's and all agents to display their parameter settings.
// All of the messages from this feature have a UVM messaging id value of "CFG"
// The transcript or run.log can be parsed to ensure BFM parameter settings match its corresponding agents parameter settings.
import uvm_pkg::*;
`include "uvm_macros.svh"
initial begin : bfm_vs_agent_parameter_debug
  `uvm_info("CFG", 
      $psprintf("The BFM at '%m' has the following parameters: ", ),
      UVM_DEBUG)
end
`endif

  // Config value to determine if this is an initiator or a responder 
  uvmf_initiator_responder_t initiator_responder;
  // Custom configuration variables.  
  // These are set using the configure function which is called during the UVM connect_phase
  uvm_active_passive_enum is_active ;
  int no_of_slaves ;
  shift_direction_e shift_dir ;
  bit [SLAVE_ADDRESS_WIDTH-1:0] slave_address_array ;
  bit [7:0] slave_register_address_array ;
  bit [2:0] primary_prescalar ;
  bit [2:0] secondary_prescalar ;
  int baudrate_divisor ;
  bit has_coverage ;

  tri clock_i;
  tri reset_i;

  // Signal list (all signals are capable of being inputs and outputs for the sake
  // of supporting both INITIATOR and RESPONDER mode operation. Expectation is that 
  // directionality in the config file was from the point-of-view of the INITIATOR

  // INITIATOR mode input signals
  tri  scl_i_i;
  reg  scl_i_o = 1'b0;
  tri  sda_i_i;
  reg  sda_i_o = 1'b0;

  // INITIATOR mode output signals
  tri  scl_o_i;
  reg  scl_o_o = 1'b0;
  tri  sda_o_i;
  reg  sda_o_o = 1'b0;
  tri  scl_oen_i;
  reg  scl_oen_o = 1'b0;
  tri  sda_oen_i;
  reg  sda_oen_o = 1'b0;

  // Bi-directional signals
  

  assign clock_i = bus.clock;
  assign reset_i = bus.reset;

  // These are signals marked as 'input' by the config file, but the signals will be
  // driven by this BFM if put into RESPONDER mode (flipping all signal directions around)
  assign scl_i_i = bus.scl_i;
  assign bus.scl_i = (initiator_responder == RESPONDER) ? scl_i_o : 'bz;
  assign sda_i_i = bus.sda_i;
  assign bus.sda_i = (initiator_responder == RESPONDER) ? sda_i_o : 'bz;


  // These are signals marked as 'output' by the config file, but the outputs will
  // not be driven by this BFM unless placed in INITIATOR mode.
  assign bus.scl_o = (initiator_responder == INITIATOR) ? scl_o_o : 'bz;
  assign scl_o_i = bus.scl_o;
  assign bus.sda_o = (initiator_responder == INITIATOR) ? sda_o_o : 'bz;
  assign sda_o_i = bus.sda_o;
  assign bus.scl_oen = (initiator_responder == INITIATOR) ? scl_oen_o : 'bz;
  assign scl_oen_i = bus.scl_oen;
  assign bus.sda_oen = (initiator_responder == INITIATOR) ? sda_oen_o : 'bz;
  assign sda_oen_i = bus.sda_oen;

  // Proxy handle to UVM driver
  i3c_m_pkg::i3c_m_driver   proxy;
  // pragma tbx oneway proxy.my_function_name_in_uvm_driver                 

  // ****************************************************************************
  // **************************************************************************** 
  // Macros that define structs located in i3c_m_macros.svh
  // ****************************************************************************
  // Struct for passing configuration data from i3c_m_driver to this BFM
  // ****************************************************************************
  `i3c_m_CONFIGURATION_STRUCT
  // ****************************************************************************
  // Structs for INITIATOR and RESPONDER data flow
  //*******************************************************************
  // Initiator macro used by i3c_m_driver and i3c_m_driver_bfm
  // to communicate initiator driven data to i3c_m_driver_bfm.           
  `i3c_m_INITIATOR_STRUCT
    i3c_m_initiator_s initiator_struct;
  // Responder macro used by i3c_m_driver and i3c_m_driver_bfm
  // to communicate Responder driven data to i3c_m_driver_bfm.
  `i3c_m_RESPONDER_STRUCT
    i3c_m_responder_s responder_struct;

  // ****************************************************************************
// pragma uvmf custom reset_condition_and_response begin
  // Always block used to return signals to reset value upon assertion of reset
  always @( posedge reset_i )
     begin
       // RESPONDER mode output signals
       scl_i_o <= 1'b0;
       sda_i_o <= 1'b0;
       // INITIATOR mode output signals
       scl_o_o <= 1'b0;
       sda_o_o <= 1'b0;
       scl_oen_o <= 1'b0;
       sda_oen_o <= 1'b0;
       // Bi-directional signals
 
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

  function void configure(i3c_m_configuration_s i3c_m_configuration_arg); // pragma tbx xtf  
    initiator_responder = i3c_m_configuration_arg.initiator_responder;
    is_active = i3c_m_configuration_arg.is_active;
    no_of_slaves = i3c_m_configuration_arg.no_of_slaves;
    shift_dir = i3c_m_configuration_arg.shift_dir;
    slave_address_array = i3c_m_configuration_arg.slave_address_array;
    slave_register_address_array = i3c_m_configuration_arg.slave_register_address_array;
    primary_prescalar = i3c_m_configuration_arg.primary_prescalar;
    secondary_prescalar = i3c_m_configuration_arg.secondary_prescalar;
    baudrate_divisor = i3c_m_configuration_arg.baudrate_divisor;
    has_coverage = i3c_m_configuration_arg.has_coverage;
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
       input i3c_m_initiator_s i3c_m_initiator_struct, 
       // This argument is used to send data received from the responder
       // back to the sequence item.  The sequence item is returned to the sequence.
       output i3c_m_responder_s i3c_m_responder_struct 
       );// pragma tbx xtf  
       // 
       // Members within the i3c_m_initiator_struct:
       //   read_write_e read_write ;
       //   bit scl ;
       //   bit sda ;
       //   bit [DATA_WIDTH-1:0] wr_data ;
       //   bit [DATA_WIDTH-1:0]  rd_data ;
       //   bit [SLAVE_ADDRESS_WIDTH-1:0] slave_address ;
       //   bit [REGISTER_ADDRESS_WIDTH-1:0] register_address ;
       //   bit [31:0] size ;
       //   bit ack ;
       //   bit [NO_OF_SLAVES-1:0] index ;
       //   bit [7:0] raddr ;
       //   bit slave_add_ack ;
       //   bit reg_add_ack ;
       //   bit wr_data_ack ;
       // Members within the i3c_m_responder_struct:
       //   read_write_e read_write ;
       //   bit scl ;
       //   bit sda ;
       //   bit [DATA_WIDTH-1:0] wr_data ;
       //   bit [DATA_WIDTH-1:0]  rd_data ;
       //   bit [SLAVE_ADDRESS_WIDTH-1:0] slave_address ;
       //   bit [REGISTER_ADDRESS_WIDTH-1:0] register_address ;
       //   bit [31:0] size ;
       //   bit ack ;
       //   bit [NO_OF_SLAVES-1:0] index ;
       //   bit [7:0] raddr ;
       //   bit slave_add_ack ;
       //   bit reg_add_ack ;
       //   bit wr_data_ack ;
       initiator_struct = i3c_m_initiator_struct;
       //
       // Reference code;
       //    How to wait for signal value
       //      while (control_signal == 1'b1) @(posedge clock_i);
       //    
       //    How to assign a responder struct member, named xyz, from a signal.   
       //    All available initiator input and inout signals listed.
       //    Initiator input signals
       //      i3c_m_responder_struct.xyz = scl_i_i;  //     
       //      i3c_m_responder_struct.xyz = sda_i_i;  //     
       //    Initiator inout signals
       //    How to assign a signal from an initiator struct member named xyz.   
       //    All available initiator output and inout signals listed.
       //    Notice the _o.  Those are storage variables that allow for procedural assignment.
       //    Initiator output signals
       //      scl_o_o <= i3c_m_initiator_struct.xyz;  //     
       //      sda_o_o <= i3c_m_initiator_struct.xyz;  //     
       //      scl_oen_o <= i3c_m_initiator_struct.xyz;  //     
       //      sda_oen_o <= i3c_m_initiator_struct.xyz;  //     
       //    Initiator inout signals
    // Initiate a transfer using the data received.
    @(posedge clock_i);
    @(posedge clock_i);
    // Wait for the responder to complete the transfer then place the responder data into 
    // i3c_m_responder_struct.
    @(posedge clock_i);
    @(posedge clock_i);
    responder_struct = i3c_m_responder_struct;
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
       output i3c_m_initiator_s i3c_m_initiator_struct, 
       // This argument passes transaction variables used by a responder
       // to complete a protocol transfer.  The values come from a sequence item.       
       input i3c_m_responder_s i3c_m_responder_struct 
       );// pragma tbx xtf   
  // Variables within the i3c_m_initiator_struct:
  //   read_write_e read_write ;
  //   bit scl ;
  //   bit sda ;
  //   bit [DATA_WIDTH-1:0] wr_data ;
  //   bit [DATA_WIDTH-1:0]  rd_data ;
  //   bit [SLAVE_ADDRESS_WIDTH-1:0] slave_address ;
  //   bit [REGISTER_ADDRESS_WIDTH-1:0] register_address ;
  //   bit [31:0] size ;
  //   bit ack ;
  //   bit [NO_OF_SLAVES-1:0] index ;
  //   bit [7:0] raddr ;
  //   bit slave_add_ack ;
  //   bit reg_add_ack ;
  //   bit wr_data_ack ;
  // Variables within the i3c_m_responder_struct:
  //   read_write_e read_write ;
  //   bit scl ;
  //   bit sda ;
  //   bit [DATA_WIDTH-1:0] wr_data ;
  //   bit [DATA_WIDTH-1:0]  rd_data ;
  //   bit [SLAVE_ADDRESS_WIDTH-1:0] slave_address ;
  //   bit [REGISTER_ADDRESS_WIDTH-1:0] register_address ;
  //   bit [31:0] size ;
  //   bit ack ;
  //   bit [NO_OF_SLAVES-1:0] index ;
  //   bit [7:0] raddr ;
  //   bit slave_add_ack ;
  //   bit reg_add_ack ;
  //   bit wr_data_ack ;
       // Reference code;
       //    How to wait for signal value
       //      while (control_signal == 1'b1) @(posedge clock_i);
       //    
       //    How to assign a responder struct member, named xyz, from a signal.   
       //    All available responder input and inout signals listed.
       //    Responder input signals
       //      i3c_m_responder_struct.xyz = scl_o_i;  //     
       //      i3c_m_responder_struct.xyz = sda_o_i;  //     
       //      i3c_m_responder_struct.xyz = scl_oen_i;  //     
       //      i3c_m_responder_struct.xyz = sda_oen_i;  //     
       //    Responder inout signals
       //    How to assign a signal, named xyz, from an initiator struct member.   
       //    All available responder output and inout signals listed.
       //    Notice the _o.  Those are storage variables that allow for procedural assignment.
       //    Responder output signals
       //      scl_i_o <= i3c_m_initiator_struct.xyz;  //     
       //      sda_i_o <= i3c_m_initiator_struct.xyz;  //     
       //    Responder inout signals
    
  @(posedge clock_i);
  if (!first_transfer) begin
    // Perform transfer response here.   
    // Reply using data recieved in the i3c_m_responder_struct.
    @(posedge clock_i);
    // Reply using data recieved in the transaction handle.
    @(posedge clock_i);
  end
    // Wait for next transfer then gather info from intiator about the transfer.
    // Place the data into the i3c_m_initiator_struct.
    @(posedge clock_i);
    @(posedge clock_i);
    first_transfer = 0;
  endtask
// pragma uvmf custom respond_and_wait_for_next_transfer end

 
endinterface

// pragma uvmf custom external begin
// pragma uvmf custom external end

