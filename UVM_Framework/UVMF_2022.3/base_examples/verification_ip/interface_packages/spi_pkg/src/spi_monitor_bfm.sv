//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface performs the spi signal monitoring.
//      It is accessed by the uvm spi monitor through a virtual
//      interface handle in the spi configuration.  It monitors the
//      signals passed in through the port connection named bus of
//      type spi_if.
//
//     Input signals from the spi_if are assigned to an internal input
//     signal with a _i suffix.  The _i signal should be used for sampling.
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i 
//
//      Interface functions and tasks used by UVM components:
//             monitor(inout TRANS_T txn);
//                   This task receives the transaction, txn, from the
//                   UVM monitor and then populates variables in txn
//                   from values observed on bus activity.  This task
//                   blocks until an operation on the spi bus is complete.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import spi_pkg_hdl::*;

`include "src/spi_macros.svh"

interface spi_monitor_bfm 
  ( spi_if  bus );
  // The pragma below and additional ones in-lined further down are for running this BFM on Veloce
  // pragma attribute spi_monitor_bfm partition_interface_xif                                  

  // Structure used to pass transaction data from monitor BFM to monitor class in agent.
`spi_MONITOR_STRUCT
  spi_monitor_s spi_monitor_struct;

  // Structure used to pass configuration data from monitor class to monitor BFM.
 `spi_CONFIGURATION_STRUCT
 

  // Config value to determine if this is an initiator or a responder 
  uvmf_initiator_responder_t initiator_responder;
  // Custom configuration variables.  
  // These are set using the configure function which is called during the UVM connect_phase

  tri sck_i;
  tri rst_i;
  tri  mosi_i;
  tri  miso_i;
  assign sck_i = bus.sck;
  assign rst_i = bus.rst;
  assign mosi_i = bus.mosi;
  assign miso_i = bus.miso;

  // Proxy handle to UVM monitor
  spi_pkg::spi_monitor  proxy;
  // pragma tbx oneway proxy.notify_transaction                 

  // pragma uvmf custom interface_item_additional begin
  // pragma uvmf custom interface_item_additional end
  
  //******************************************************************                         
  task wait_for_reset();// pragma tbx xtf  
    @(posedge sck_i) ;                                                                    
    do_wait_for_reset();                                                                   
  endtask                                                                                   

  // ****************************************************************************              
  task do_wait_for_reset();                                                                 
    wait ( rst_i == 0 ) ;                                                              
    @(posedge sck_i) ;                                                                    
  endtask    

  //******************************************************************                         
 
  task wait_for_num_clocks(input int unsigned count); // pragma tbx xtf 
    @(posedge sck_i);  
                                                                   
    repeat (count-1) @(posedge sck_i);                                                    
  endtask      

  //******************************************************************                         
  event go;                                                                                 
  function void start_monitoring();// pragma tbx xtf    
    -> go;
  endfunction                                                                               
  
  // ****************************************************************************              
  initial begin                                                                             
    @go;                                                                                   
    forever begin                                                                        
      @(posedge sck_i);  
      do_monitor( spi_monitor_struct );
                                                                 
 
      proxy.notify_transaction( spi_monitor_struct );
 
    end                                                                                    
  end                                                                                       

  //******************************************************************
  // The configure() function is used to pass agent configuration
  // variables to the monitor BFM.  It is called by the monitor within
  // the agent at the beginning of the simulation.  It may be called 
  // during the simulation if agent configuration variables are updated
  // and the monitor BFM needs to be aware of the new configuration 
  // variables.
  //
    function void configure(spi_configuration_s spi_configuration_arg); // pragma tbx xtf  
    initiator_responder = spi_configuration_arg.initiator_responder;
  // pragma uvmf custom configure begin
  // pragma uvmf custom configure end
  endfunction   


  // ****************************************************************************  
            
  task do_monitor(output spi_monitor_s spi_monitor_struct);
    // UVMF_CHANGE_ME : Implement protocol monitoring.  The commented reference code 
    // below are examples of how to capture signal values and assign them to 
    // structure members.  All available input signals are listed.  The 'while' 
    // code example shows how to wait for a synchronous flow control signal.  This
    // task should return when a complete transfer has been observed.  Once this task is
    // exited with captured values, it is then called again to wait for and observe 
    // the next transfer. One clock cycle is consumed between calls to do_monitor.
    //
    // Available struct members:
    //     //    spi_monitor_struct.dir
    //     //    spi_monitor_struct.mosi_data
    //     //    spi_monitor_struct.miso_data
    //     //
    // Reference code;
    //    How to wait for signal value
    //      while (control_signal == 1'b1) @(posedge sck_i);
    //    
    //    How to assign a struct member, named xyz, from a signal.   
    //    All available input signals listed.
    //      spi_monitor_struct.xyz = mosi_i;  //     
    //      spi_monitor_struct.xyz = miso_i;  //     
    // pragma uvmf custom do_monitor begin
    spi_monitor_struct.mosi_data[7] = mosi_i;
    spi_monitor_struct.miso_data[7] = miso_i;
    for (int i=6;i>=0;i--) begin
       @(posedge sck_i);
       spi_monitor_struct.mosi_data[i] = mosi_i;
       spi_monitor_struct.miso_data[i] = miso_i;
    end



    // pragma uvmf custom do_monitor end
  endtask         
  
 
endinterface
