//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
//    This interface performs the gpio signal driving.  It is
//     accessed by the uvm gpio driver through a virtual interface
//     handle in the gpio configuration.  It drives the singals passed
//     in through the port connection named bus of type gpio_if.
//
//     Input signals from the gpio_if are assigned to an internal input
//     signal with a _i suffix.  The _i signal should be used for sampling.
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i 
//
//     This bfm drives signals with a _o suffix.  These signals
//     are driven onto signals within gpio_if based on INITIATOR/RESPONDER and/or
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
import gpio_pkg_hdl::*;
`include "src/gpio_macros.svh"

interface gpio_driver_bfm #(
  int READ_PORT_WIDTH = 4,
  int WRITE_PORT_WIDTH = 4
  )
  (gpio_if bus);
  // The following pragma and additional ones in-lined further below are for running this BFM on Veloce
  // pragma attribute gpio_driver_bfm partition_interface_xif
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
  tri [READ_PORT_WIDTH-1:0] read_port_i;
  reg [READ_PORT_WIDTH-1:0] read_port_o = 'bz;

  // INITIATOR mode output signals
  tri [WRITE_PORT_WIDTH-1:0] write_port_i;
  reg [WRITE_PORT_WIDTH-1:0] write_port_o = 'bz;

  // Bi-directional signals
  

  assign clk_i = bus.clk;
  assign rst_i = bus.rst;

  // These are signals marked as 'input' by the config file, but the signals will be
  // driven by this BFM if put into RESPONDER mode (flipping all signal directions around)
  assign read_port_i = bus.read_port;
  assign bus.read_port = (initiator_responder == RESPONDER) ? read_port_o : 'bz;


  // These are signals marked as 'output' by the config file, but the outputs will
  // not be driven by this BFM unless placed in INITIATOR mode.
  assign bus.write_port = (initiator_responder == INITIATOR) ? write_port_o : 'bz;
  assign write_port_i = bus.write_port;

  // Proxy handle to UVM driver
  gpio_pkg::gpio_driver #(
    .READ_PORT_WIDTH(READ_PORT_WIDTH),
    .WRITE_PORT_WIDTH(WRITE_PORT_WIDTH)
    )  proxy;
  // pragma tbx oneway proxy.my_function_name_in_uvm_driver                 

  // ****************************************************************************
  // **************************************************************************** 
  // Macros that define structs located in gpio_macros.svh
  // ****************************************************************************
  // Struct for passing configuration data from gpio_driver to this BFM
  // ****************************************************************************
  `gpio_CONFIGURATION_STRUCT
  // ****************************************************************************
  // Structs for INITIATOR and RESPONDER data flow
  //*******************************************************************
  // Initiator macro used by gpio_driver and gpio_driver_bfm
  // to communicate initiator driven data to gpio_driver_bfm.           
  `gpio_INITIATOR_STRUCT
    gpio_initiator_s gpio_initiator_struct;
  // Responder macro used by gpio_driver and gpio_driver_bfm
  // to communicate Responder driven data to gpio_driver_bfm.
  `gpio_RESPONDER_STRUCT
    gpio_responder_s gpio_responder_struct;

  // ****************************************************************************              
  // Always block used to return signals to reset value upon assertion of reset
  always @( posedge rst_i )
     begin
       // RESPONDER mode output signals
       read_port_o <= 'b0;
       // INITIATOR mode output signals
       write_port_o <= 'b0;
       // Bi-directional signals
 
     end    

  // pragma uvmf custom interface_item_additional begin
  bit                        init_xfer = 1'b1;

  // ****************************************************************************
  //task write(input bit [WRITE_PORT_WIDTH-1:0] data); // pragma tbx xtf
  function void write(input bit [WRITE_PORT_WIDTH-1:0] data); // pragma tbx xtf
    //@(posedge clk_i);
    write_port_o <= data;
  endfunction
  //endtask

  // ****************************************************************************
  event                      do_start_read_daemon;
  bit [READ_PORT_WIDTH-1:0]  read_port_reg;

  function void start_read_daemon(); // pragma tbx xtf
    -> do_start_read_daemon;
  endfunction

  initial begin
    @do_start_read_daemon;
    forever begin
      @(posedge clk_i);
      if (init_xfer == 1'b1) begin
        read_port_reg = read_port_i;
        proxy.notify_read_port_change(read_port_reg);
        init_xfer = 1'b0;
      end
      while (read_port_reg == read_port_i) // Wait until any bit in read bus changes
        @(posedge clk_i);
      read_port_reg = read_port_i;
      proxy.notify_read_port_change(read_port_reg);
    end
  end
  // pragma uvmf custom interface_item_additional end

  //******************************************************************
  // The configure() function is used to pass agent configuration
  // variables to the driver BFM.  It is called by the driver within
  // the agent at the beginning of the simulation.  It may be called 
  // during the simulation if agent configuration variables are updated
  // and the driver BFM needs to be aware of the new configuration 
  // variables.
  //

  function void configure(gpio_configuration_s gpio_configuration_arg); // pragma tbx xtf  
    initiator_responder = gpio_configuration_arg.initiator_responder;
  // pragma uvmf custom configure begin
  // pragma uvmf custom configure end
  endfunction                                                                             

// pragma uvmf custom initiate_and_get_response begin
// pragma uvmf custom initiate_and_get_response end

// pragma uvmf custom respond_and_wait_for_next_transfer begin
// pragma uvmf custom respond_and_wait_for_next_transfer end

 
endinterface
