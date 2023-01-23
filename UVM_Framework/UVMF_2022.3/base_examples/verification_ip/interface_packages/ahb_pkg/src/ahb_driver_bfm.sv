//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
//    This interface performs the ahb signal driving.  It is
//     accessed by the uvm ahb driver through a virtual interface
//     handle in the ahb configuration.  It drives the singals passed
//     in through the port connection named bus of type ahb_if.
//
//     Input signals from the ahb_if are assigned to an internal input
//     signal with a _i suffix.  The _i signal should be used for sampling.
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i 
//
//     This bfm drives signals with a _o suffix.  These signals
//     are driven onto signals within ahb_if based on INITIATOR/RESPONDER and/or
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
import ahb_pkg_hdl::*;
`include "src/ahb_macros.svh"

interface ahb_driver_bfm 
  (ahb_if bus);
  // The following pragma and additional ones in-lined further below are for running this BFM on Veloce
  // pragma attribute ahb_driver_bfm partition_interface_xif
  // Config value to determine if this is an initiator or a responder 
  uvmf_initiator_responder_t initiator_responder;
  // Custom configuration variables.  
  // These are set using the configure function which is called during the UVM connect_phase

  tri hclk_i;
  tri hresetn_i;

  // Signal list (all signals are capable of being inputs and outputs for the sake
  // of supporting both INITIATOR and RESPONDER mode operation. Expectation is that 
  // directionality in the config file was from the point-of-view of the INITIATOR

  // INITIATOR mode input signals
  tri  hready_i;
  reg  hready_o = 'bz;
  tri [15:0] hrdata_i;
  reg [15:0] hrdata_o = 'bz;
  tri [1:0] hresp_i;
  reg [1:0] hresp_o = 'bz;

  // INITIATOR mode output signals
  tri [31:0] haddr_i;
  reg [31:0] haddr_o = 'bz;
  tri [15:0] hwdata_i;
  reg [15:0] hwdata_o = 'bz;
  tri [1:0] htrans_i;
  reg [1:0] htrans_o = 'bz;
  tri [2:0] hburst_i;
  reg [2:0] hburst_o = 'bz;
  tri [2:0] hsize_i;
  reg [2:0] hsize_o = 'bz;
  tri  hwrite_i;
  reg  hwrite_o = 'bz;
  tri  hsel_i;
  reg  hsel_o = 'bz;

  // Bi-directional signals
  

  assign hclk_i = bus.hclk;
  assign hresetn_i = bus.hresetn;

  // These are signals marked as 'input' by the config file, but the signals will be
  // driven by this BFM if put into RESPONDER mode (flipping all signal directions around)
  assign hready_i = bus.hready;
  assign bus.hready = (initiator_responder == RESPONDER) ? hready_o : 'bz;
  assign hrdata_i = bus.hrdata;
  assign bus.hrdata = (initiator_responder == RESPONDER) ? hrdata_o : 'bz;
  assign hresp_i = bus.hresp;
  assign bus.hresp = (initiator_responder == RESPONDER) ? hresp_o : 'bz;


  // These are signals marked as 'output' by the config file, but the outputs will
  // not be driven by this BFM unless placed in INITIATOR mode.
  assign bus.haddr = (initiator_responder == INITIATOR) ? haddr_o : 'bz;
  assign haddr_i = bus.haddr;
  assign bus.hwdata = (initiator_responder == INITIATOR) ? hwdata_o : 'bz;
  assign hwdata_i = bus.hwdata;
  assign bus.htrans = (initiator_responder == INITIATOR) ? htrans_o : 'bz;
  assign htrans_i = bus.htrans;
  assign bus.hburst = (initiator_responder == INITIATOR) ? hburst_o : 'bz;
  assign hburst_i = bus.hburst;
  assign bus.hsize = (initiator_responder == INITIATOR) ? hsize_o : 'bz;
  assign hsize_i = bus.hsize;
  assign bus.hwrite = (initiator_responder == INITIATOR) ? hwrite_o : 'bz;
  assign hwrite_i = bus.hwrite;
  assign bus.hsel = (initiator_responder == INITIATOR) ? hsel_o : 'bz;
  assign hsel_i = bus.hsel;

  // Proxy handle to UVM driver
  ahb_pkg::ahb_driver   proxy;
  // pragma tbx oneway proxy.my_function_name_in_uvm_driver                 

  // ****************************************************************************
  // **************************************************************************** 
  // Macros that define structs located in ahb_macros.svh
  // ****************************************************************************
  // Struct for passing configuration data from ahb_driver to this BFM
  // ****************************************************************************
  `ahb_CONFIGURATION_STRUCT
  // ****************************************************************************
  // Structs for INITIATOR and RESPONDER data flow
  //*******************************************************************
  // Initiator macro used by ahb_driver and ahb_driver_bfm
  // to communicate initiator driven data to ahb_driver_bfm.           
  `ahb_INITIATOR_STRUCT
    ahb_initiator_s ahb_initiator_struct;
  // Responder macro used by ahb_driver and ahb_driver_bfm
  // to communicate Responder driven data to ahb_driver_bfm.
  `ahb_RESPONDER_STRUCT
    ahb_responder_s ahb_responder_struct;

  // ****************************************************************************              
  // Always block used to return signals to reset value upon assertion of reset
  always @( negedge hresetn_i )
     begin
       // RESPONDER mode output signals
       hready_o <= 'b0;
       hrdata_o <= 'b0;
       hresp_o <= 'b0;
       // INITIATOR mode output signals
       haddr_o <= 'b0;
       hwdata_o <= 'b0;
       htrans_o <= 'b0;
       hburst_o <= 'b0;
       hsize_o <= 'b0;
       hwrite_o <= 'b0;
       hsel_o <= 'b0;
       // Bi-directional signals
 
     end    

  // pragma uvmf custom interface_item_additional begin
// ****************************************************************************
   task do_write(input bit [31:0] addr, 
                 input bit [15:0] data);
      // Address Phase
          haddr_o <= addr;
          hwdata_o <= data;
          htrans_o <= 2'b10;
          hburst_o <= 3'b000;
          hsize_o <= 3'b000;
          hwrite_o <= 1'b1;
          hsel_o <= 1'b1;

      // Data Phase
      do @(posedge hclk_i) ;
      while ( hready_i == 1'b0 );
          haddr_o <= 'bx;
          hwdata_o <= 'bx;
          htrans_o <= 2'b00;
          hburst_o <= 3'b000;
          hsize_o <= 3'b000;
          hwrite_o <= 1'b0;
          hsel_o <= 1'b0;
   endtask

// ****************************************************************************
   task do_read(input bit [31:0] addr, 
                output bit [15:0] data);
      // Address Phase
          haddr_o <= addr;
          htrans_o <= 2'b10;
          hburst_o <= 3'b000;
          hsize_o <= 3'b000;
          hwrite_o <= 1'b0;
          hsel_o <= 1'b1;

      // Data Phase
      @(posedge hclk_i);
      do @(posedge hclk_i); while ( hready_i == 1'b0 );
          data = hrdata_i;
          haddr_o <= 'bx;
          hwdata_o <= 'bx;
          htrans_o <= 2'b00;
          hburst_o <= 3'b000;
          hsize_o <= 3'b000;
          hwrite_o <= 1'b0;
          hsel_o <= 1'b0;
   endtask



  // pragma uvmf custom interface_item_additional end

  //******************************************************************
  // The configure() function is used to pass agent configuration
  // variables to the driver BFM.  It is called by the driver within
  // the agent at the beginning of the simulation.  It may be called 
  // during the simulation if agent configuration variables are updated
  // and the driver BFM needs to be aware of the new configuration 
  // variables.
  //

  function void configure(ahb_configuration_s ahb_configuration_arg); // pragma tbx xtf  
    initiator_responder = ahb_configuration_arg.initiator_responder;
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
       input ahb_initiator_s ahb_initiator_struct, 
       // This argument is used to send data received from the responder
       // back to the sequence item.  The sequence item is returned to the sequence.
       output ahb_responder_s ahb_responder_struct 
       );// pragma tbx xtf  
       // 
       // Members within the ahb_initiator_struct:
       //   ahb_op_t op ;
       //   bit [15:0] data ;
       //   bit [31:0] addr ;
       // Members within the ahb_responder_struct:
       //   ahb_op_t op ;
       //   bit [15:0] data ;
       //   bit [31:0] addr ;
       //
       // Reference code;
       //    How to wait for signal value
       //      while (control_signal == 1'b1) @(posedge hclk_i);
       //    
       //    How to assign a responder struct member, named xyz, from a signal.   
       //    All available input signals listed.
       //      ahb_responder_struct.xyz = haddr_i;  //    [31:0] 
       //      ahb_responder_struct.xyz = hwdata_i;  //    [15:0] 
       //      ahb_responder_struct.xyz = htrans_i;  //    [1:0] 
       //      ahb_responder_struct.xyz = hburst_i;  //    [2:0] 
       //      ahb_responder_struct.xyz = hsize_i;  //    [2:0] 
       //      ahb_responder_struct.xyz = hwrite_i;  //     
       //      ahb_responder_struct.xyz = hsel_i;  //     
       //      ahb_responder_struct.xyz = hready_i;  //     
       //      ahb_responder_struct.xyz = hrdata_i;  //    [15:0] 
       //      ahb_responder_struct.xyz = hresp_i;  //    [1:0] 
       //    How to assign a signal, named xyz, from an initiator struct member.   
       //    All available input signals listed.
       //    Notice the _o.  Those are storage variables that allow for procedural assignment.
       //      haddr_o <= ahb_initiator_struct.xyz;  //    [31:0] 
       //      hwdata_o <= ahb_initiator_struct.xyz;  //    [15:0] 
       //      htrans_o <= ahb_initiator_struct.xyz;  //    [1:0] 
       //      hburst_o <= ahb_initiator_struct.xyz;  //    [2:0] 
       //      hsize_o <= ahb_initiator_struct.xyz;  //    [2:0] 
       //      hwrite_o <= ahb_initiator_struct.xyz;  //     
       //      hsel_o <= ahb_initiator_struct.xyz;  //     
       //      hready_o <= ahb_initiator_struct.xyz;  //     
       //      hrdata_o <= ahb_initiator_struct.xyz;  //    [15:0] 
       //      hresp_o <= ahb_initiator_struct.xyz;  //    [1:0] 
    // Initiate a transfer using the data received.
    // Wait for the responder to complete the transfer then place the responder data into 
    // ahb_responder_struct.
    @(posedge hclk_i);                                                                     
        case (ahb_initiator_struct.op)
          AHB_WRITE: do_write(ahb_initiator_struct.addr, ahb_initiator_struct.data);
          AHB_READ:  do_read(ahb_initiator_struct.addr, ahb_responder_struct.data);
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
       output ahb_initiator_s ahb_initiator_struct, 
       // This argument passes transaction variables used by a responder
       // to complete a protocol transfer.  The values come from a sequence item.       
       input ahb_responder_s ahb_responder_struct 
       );// pragma tbx xtf   
  // Variables within the ahb_initiator_struct:
  //   ahb_op_t op ;
  //   bit [15:0] data ;
  //   bit [31:0] addr ;
  // Variables within the ahb_responder_struct:
  //   ahb_op_t op ;
  //   bit [15:0] data ;
  //   bit [31:0] addr ;
        
  @(posedge hclk_i);
  if (!first_transfer) begin
    // Perform transfer response here.   
    // Reply using data recieved in the ahb_responder_struct.
    @(posedge hclk_i);
    // Reply using data recieved in the transaction handle.
    @(posedge hclk_i);
  end
    // Wait for next transfer then gather info from intiator about the transfer.
    // Place the data into the ahb_initiator_struct.
    @(posedge hclk_i);
    @(posedge hclk_i);
    first_transfer = 0;
  endtask



// pragma uvmf custom respond_and_wait_for_next_transfer end

 
endinterface
