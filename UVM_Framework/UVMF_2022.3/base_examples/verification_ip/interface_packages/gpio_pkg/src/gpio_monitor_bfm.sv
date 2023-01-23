//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface performs the gpio signal monitoring.
//      It is accessed by the uvm gpio monitor through a virtual
//      interface handle in the gpio configuration.  It monitors the
//      signals passed in through the port connection named bus of
//      type gpio_if.
//
//     Input signals from the gpio_if are assigned to an internal input
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
//                   blocks until an operation on the gpio bus is complete.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import gpio_pkg_hdl::*;

`include "src/gpio_macros.svh"

interface gpio_monitor_bfm #(
  int READ_PORT_WIDTH = 4,
  int WRITE_PORT_WIDTH = 4
  )
  ( gpio_if  bus );
  // The pragma below and additional ones in-lined further down are for running this BFM on Veloce
  // pragma attribute gpio_monitor_bfm partition_interface_xif                                  

  // Structure used to pass transaction data from monitor BFM to monitor class in agent.
`gpio_MONITOR_STRUCT
  gpio_monitor_s gpio_monitor_struct;

  // Structure used to pass configuration data from monitor class to monitor BFM.
 `gpio_CONFIGURATION_STRUCT
 

  // Config value to determine if this is an initiator or a responder 
  uvmf_initiator_responder_t initiator_responder;
  // Custom configuration variables.  
  // These are set using the configure function which is called during the UVM connect_phase

  tri clk_i;
  tri rst_i;
  tri [READ_PORT_WIDTH-1:0] read_port_i;
  tri [WRITE_PORT_WIDTH-1:0] write_port_i;
  assign clk_i = bus.clk;
  assign rst_i = bus.rst;
  assign read_port_i = bus.read_port;
  assign write_port_i = bus.write_port;

  // Proxy handle to UVM monitor
  gpio_pkg::gpio_monitor #(
    .READ_PORT_WIDTH(READ_PORT_WIDTH),
    .WRITE_PORT_WIDTH(WRITE_PORT_WIDTH)
    ) proxy;
  // pragma tbx oneway proxy.notify_transaction                 

  // pragma uvmf custom interface_item_additional begin
   bit [WRITE_PORT_WIDTH-1:0] write_port_reg = '1;
   bit [READ_PORT_WIDTH-1:0] read_port_reg = '1;
  // pragma uvmf custom interface_item_additional end
  
  //******************************************************************                         
  task wait_for_reset();// pragma tbx xtf  
    @(posedge clk_i) ;                                                                    
    do_wait_for_reset();                                                                   
  endtask                                                                                   

  // ****************************************************************************              
  task do_wait_for_reset();                                                                 
    wait ( rst_i == 0 ) ;                                                              
    @(posedge clk_i) ;                                                                    
  endtask    

  //******************************************************************                         
 
  task wait_for_num_clocks(input int unsigned count); // pragma tbx xtf 
    @(posedge clk_i);  
                                                                   
    repeat (count-1) @(posedge clk_i);                                                    
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
      @(posedge clk_i);  
      do_monitor( gpio_monitor_struct );
                                                                 
 
      proxy.notify_transaction( gpio_monitor_struct );
 
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
    function void configure(gpio_configuration_s gpio_configuration_arg); // pragma tbx xtf  
    initiator_responder = gpio_configuration_arg.initiator_responder;
  // pragma uvmf custom configure begin
  // pragma uvmf custom configure end
  endfunction   


  // ****************************************************************************  
            
  task do_monitor(output gpio_monitor_s gpio_monitor_struct);
    // UVMF_CHANGE_ME : Implement protocol monitoring.  The commented reference code 
    // below are examples of how to capture signal values and assign them to 
    // structure members.  All available input signals are listed.  The 'while' 
    // code example shows how to wait for a synchronous flow control signal.  This
    // task should return when a complete transfer has been observed.  Once this task is
    // exited with captured values, it is then called again to wait for and observe 
    // the next transfer. One clock cycle is consumed between calls to do_monitor.
    //
    // Available struct members:
    //     //    gpio_monitor_struct.op
    //     //    gpio_monitor_struct.read_port
    //     //    gpio_monitor_struct.write_port
    //     //
    // Reference code;
    //    How to wait for signal value
    //      while (control_signal == 1'b1) @(posedge clk_i);
    //    
    //    How to assign a struct member, named xyz, from a signal.   
    //    All available input signals listed.
    //      gpio_monitor_struct.xyz = read_port_i;  //    [READ_PORT_WIDTH-1:0] 
    //      gpio_monitor_struct.xyz = write_port_i;  //    [WRITE_PORT_WIDTH-1:0] 
    // pragma uvmf custom do_monitor begin
      while ((read_port_reg == read_port_i) && (write_port_reg == write_port_i))
        @(posedge clk_i);
      write_port_reg = write_port_i;
      read_port_reg = read_port_i;
      gpio_monitor_struct.write_port = write_port_i;
      gpio_monitor_struct.read_port = read_port_i;
    // pragma uvmf custom do_monitor end
  endtask         
  
 
endinterface
