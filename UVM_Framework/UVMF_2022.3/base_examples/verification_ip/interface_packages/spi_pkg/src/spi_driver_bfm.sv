//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
//    This interface performs the spi signal driving.  It is
//     accessed by the uvm spi driver through a virtual interface
//     handle in the spi configuration.  It drives the singals passed
//     in through the port connection named bus of type spi_if.
//
//     Input signals from the spi_if are assigned to an internal input
//     signal with a _i suffix.  The _i signal should be used for sampling.
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i 
//
//     This bfm drives signals with a _o suffix.  These signals
//     are driven onto signals within spi_if based on INITIATOR/RESPONDER and/or
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
import spi_pkg_hdl::*;
`include "src/spi_macros.svh"

interface spi_driver_bfm 
  (spi_if bus);
  // The following pragma and additional ones in-lined further below are for running this BFM on Veloce
  // pragma attribute spi_driver_bfm partition_interface_xif
  // Config value to determine if this is an initiator or a responder 
  uvmf_initiator_responder_t initiator_responder;
  // Custom configuration variables.  
  // These are set using the configure function which is called during the UVM connect_phase

  tri sck_i;
  tri rst_i;

  // Signal list (all signals are capable of being inputs and outputs for the sake
  // of supporting both INITIATOR and RESPONDER mode operation. Expectation is that 
  // directionality in the config file was from the point-of-view of the INITIATOR

  // INITIATOR mode input signals
  tri  miso_i;
  reg  miso_o = 'bz;

  // INITIATOR mode output signals
  tri  mosi_i;
  reg  mosi_o = 'bz;

  // Bi-directional signals
  

  assign sck_i = bus.sck;
  assign rst_i = bus.rst;

  // These are signals marked as 'input' by the config file, but the signals will be
  // driven by this BFM if put into RESPONDER mode (flipping all signal directions around)
  assign miso_i = bus.miso;
  assign bus.miso = (initiator_responder == RESPONDER) ? miso_o : 'bz;


  // These are signals marked as 'output' by the config file, but the outputs will
  // not be driven by this BFM unless placed in INITIATOR mode.
  assign bus.mosi = (initiator_responder == INITIATOR) ? mosi_o : 'bz;
  assign mosi_i = bus.mosi;

  // Proxy handle to UVM driver
  spi_pkg::spi_driver   proxy;
  // pragma tbx oneway proxy.my_function_name_in_uvm_driver                 

  // ****************************************************************************
  // **************************************************************************** 
  // Macros that define structs located in spi_macros.svh
  // ****************************************************************************
  // Struct for passing configuration data from spi_driver to this BFM
  // ****************************************************************************
  `spi_CONFIGURATION_STRUCT
  // ****************************************************************************
  // Structs for INITIATOR and RESPONDER data flow
  //*******************************************************************
  // Initiator macro used by spi_driver and spi_driver_bfm
  // to communicate initiator driven data to spi_driver_bfm.           
  `spi_INITIATOR_STRUCT
    spi_initiator_s spi_initiator_struct;
  // Responder macro used by spi_driver and spi_driver_bfm
  // to communicate Responder driven data to spi_driver_bfm.
  `spi_RESPONDER_STRUCT
    spi_responder_s spi_responder_struct;

  // ****************************************************************************              
  // Always block used to return signals to reset value upon assertion of reset
  always @( posedge rst_i )
     begin
       // RESPONDER mode output signals
       miso_o <= 'b0;
       // INITIATOR mode output signals
       mosi_o <= 'b0;
       // Bi-directional signals
 
     end    

  // pragma uvmf custom interface_item_additional begin
// ****************************************************************************
/*   bit spi_active;

   function void put_spi_dout(input spi_transaction_s spi_txn); // pragma tbx xtf
      spi_driver_dout = spi_txn.spi_data;
      spi_output <= spi_driver_dout[SPI_XFER_WIDTH-1];
      put_spi_dout_active = 1;
   endfunction
   
   always begin
      wait(spi_active);
      @(posedge bus.sck);
      for (int i=6;i>=0;i--) begin
          miso_o <= miso_data[i]; @(posedge bus.sck);
      end
      spi_active = 0;
   end

// ****************************************************************************
   task get_spi_din(input spi_transaction_s spi_txn, 
                    output bit [SPI_XFER_WIDTH-1:0] spi_driver_din); // pragma tbx xtf
      @(posedge bus.sck);
      spi_driver_din[SPI_XFER_WIDTH-1]=spi_input;
      for (int i=(SPI_XFER_WIDTH-2);i>=0;i--) begin
          @(posedge bus.sck) spi_driver_din[i]=spi_input;
      end
   endtask
*/



  // pragma uvmf custom interface_item_additional end

  //******************************************************************
  // The configure() function is used to pass agent configuration
  // variables to the driver BFM.  It is called by the driver within
  // the agent at the beginning of the simulation.  It may be called 
  // during the simulation if agent configuration variables are updated
  // and the driver BFM needs to be aware of the new configuration 
  // variables.
  //

  function void configure(spi_configuration_s spi_configuration_arg); // pragma tbx xtf  
    initiator_responder = spi_configuration_arg.initiator_responder;
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
       input spi_initiator_s spi_initiator_struct, 
       // This argument is used to send data received from the responder
       // back to the sequence item.  The sequence item is returned to the sequence.
       output spi_responder_s spi_responder_struct 
       );// pragma tbx xtf  
       // 
       // Members within the spi_initiator_struct:
       //   spi_dir_t dir ;
       //   bit [7:0] mosi_data ;
       //   bit [7:0] miso_data ;
       // Members within the spi_responder_struct:
       //   spi_dir_t dir ;
       //   bit [7:0] mosi_data ;
       //   bit [7:0] miso_data ;
       //
       // Reference code;
       //    How to wait for signal value
       //      while (control_signal == 1'b1) @(posedge sck_i);
       //    
       //    How to assign a responder struct member, named xyz, from a signal.   
       //    All available input signals listed.
       //      spi_responder_struct.xyz = mosi_i;  //     
       //      spi_responder_struct.xyz = miso_i;  //     
       //    How to assign a signal, named xyz, from an initiator struct member.   
       //    All available input signals listed.
       //    Notice the _o.  Those are storage variables that allow for procedural assignment.
       //      mosi_o <= spi_initiator_struct.xyz;  //     
       //      miso_o <= spi_initiator_struct.xyz;  //     
    // Initiate a transfer using the data received.
    @(posedge sck_i);
    @(posedge sck_i);
    // Wait for the responder to complete the transfer then place the responder data into 
    // spi_responder_struct.
    @(posedge sck_i);
    @(posedge sck_i);
  endtask   



// pragma uvmf custom initiate_and_get_response end

// pragma uvmf custom respond_and_wait_for_next_transfer begin
bit [7:0] miso_data;
bit miso_valid = 0;

  function void set_miso_data( 
       // This argument passes transaction variables used by a responder
       // to complete a protocol transfer.  The values come from a sequence item.       
       input spi_responder_s spi_responder_struct 
       );// pragma tbx xtf 
       miso_data = spi_responder_struct.miso_data; 
       miso_o <= miso_data[7]; 
       miso_valid =1;
  endfunction

   always begin
      wait(miso_valid);
      @(posedge sck_i);
      for (int i=6;i>=0;i--) begin
          miso_o <= miso_data[i]; 
          @(posedge sck_i);
      end
      miso_valid = 0;
   end
// ****************************************************************************
// The first_transfer variable is used to prevent completing a transfer in the 
// first call to this task.  For the first call to this task, there is not
// current transfer to complete.
bit first_transfer=1;

// UVMF_CHANGE_ME
// This task is used by a responder.  The task first completes the current 
// transfer in progress then waits for the initiator to start the next transfer.
  task get_mosi_data( 
       // This argument is used to send data received from the initiator
       // back to the sequence item.  The sequence determines how to respond.
       output spi_initiator_s spi_initiator_struct       
       );// pragma tbx xtf   
  // Variables within the spi_initiator_struct:
  //   spi_dir_t dir ;
  //   bit [7:0] mosi_data ;
  //   bit [7:0] miso_data ;
  // Variables within the spi_responder_struct:
  //   spi_dir_t dir ;
  //   bit [7:0] mosi_data ;
  //   bit [7:0] miso_data ;

    @(posedge sck_i);   
    spi_initiator_struct.mosi_data[7] = mosi_i; 
    for (int i=6;i>=0;i--) begin
       @(posedge sck_i);       
       spi_initiator_struct.mosi_data[i] = mosi_i;
    end
  endtask



// pragma uvmf custom respond_and_wait_for_next_transfer end

 
endinterface
