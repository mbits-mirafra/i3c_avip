//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface performs the ahb signal monitoring.
//      It is accessed by the uvm ahb monitor through a virtual
//      interface handle in the ahb configuration.  It monitors the
//      signals passed in through the port connection named bus of
//      type ahb_if.
//
//     Input signals from the ahb_if are assigned to an internal input
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
//                   blocks until an operation on the ahb bus is complete.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import ahb_pkg_hdl::*;

`include "src/ahb_macros.svh"

interface ahb_monitor_bfm 
  ( ahb_if  bus );
  // The pragma below and additional ones in-lined further down are for running this BFM on Veloce
  // pragma attribute ahb_monitor_bfm partition_interface_xif                                  

  // Structure used to pass transaction data from monitor BFM to monitor class in agent.
`ahb_MONITOR_STRUCT
  ahb_monitor_s ahb_monitor_struct;

  // Structure used to pass configuration data from monitor class to monitor BFM.
 `ahb_CONFIGURATION_STRUCT
 

  // Config value to determine if this is an initiator or a responder 
  uvmf_initiator_responder_t initiator_responder;
  // Custom configuration variables.  
  // These are set using the configure function which is called during the UVM connect_phase

  tri hclk_i;
  tri hresetn_i;
  tri [31:0] haddr_i;
  tri [15:0] hwdata_i;
  tri [1:0] htrans_i;
  tri [2:0] hburst_i;
  tri [2:0] hsize_i;
  tri  hwrite_i;
  tri  hsel_i;
  tri  hready_i;
  tri [15:0] hrdata_i;
  tri [1:0] hresp_i;
  assign hclk_i = bus.hclk;
  assign hresetn_i = bus.hresetn;
  assign haddr_i = bus.haddr;
  assign hwdata_i = bus.hwdata;
  assign htrans_i = bus.htrans;
  assign hburst_i = bus.hburst;
  assign hsize_i = bus.hsize;
  assign hwrite_i = bus.hwrite;
  assign hsel_i = bus.hsel;
  assign hready_i = bus.hready;
  assign hrdata_i = bus.hrdata;
  assign hresp_i = bus.hresp;

  // Proxy handle to UVM monitor
  ahb_pkg::ahb_monitor  proxy;
  // pragma tbx oneway proxy.notify_transaction                 

  // pragma uvmf custom interface_item_additional begin
  // pragma uvmf custom interface_item_additional end
  
  //******************************************************************                         
  task wait_for_reset();// pragma tbx xtf  
    @(posedge hclk_i) ;                                                                    
    do_wait_for_reset();                                                                   
  endtask                                                                                   

  // ****************************************************************************              
  task do_wait_for_reset();                                                                 
    wait ( hresetn_i == 1 ) ;                                                              
    @(posedge hclk_i) ;                                                                    
  endtask    

  //******************************************************************                         
 
  task wait_for_num_clocks(input int unsigned count); // pragma tbx xtf 
    @(posedge hclk_i);  
                                                                   
    repeat (count-1) @(posedge hclk_i);                                                    
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
      @(posedge hclk_i);  
      do_monitor( ahb_monitor_struct );
                                                                 
 
      proxy.notify_transaction( ahb_monitor_struct );
 
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
    function void configure(ahb_configuration_s ahb_configuration_arg); // pragma tbx xtf  
    initiator_responder = ahb_configuration_arg.initiator_responder;
  // pragma uvmf custom configure begin
  // pragma uvmf custom configure end
  endfunction   


  // ****************************************************************************  
            
  task do_monitor(output ahb_monitor_s ahb_monitor_struct);
    // UVMF_CHANGE_ME : Implement protocol monitoring.  The commented reference code 
    // below are examples of how to capture signal values and assign them to 
    // structure members.  All available input signals are listed.  The 'while' 
    // code example shows how to wait for a synchronous flow control signal.  This
    // task should return when a complete transfer has been observed.  Once this task is
    // exited with captured values, it is then called again to wait for and observe 
    // the next transfer. One clock cycle is consumed between calls to do_monitor.
    //
    // Available struct members:
    //     //    ahb_monitor_struct.op
    //     //    ahb_monitor_struct.data
    //     //    ahb_monitor_struct.addr
    //     //
    // Reference code;
    //    How to wait for signal value
    //      while (control_signal == 1'b1) @(posedge hclk_i);
    //    
    //    How to assign a struct member, named xyz, from a signal.   
    //    All available input signals listed.
    //      ahb_monitor_struct.xyz = haddr_i;  //    [31:0] 
    //      ahb_monitor_struct.xyz = hwdata_i;  //    [15:0] 
    //      ahb_monitor_struct.xyz = htrans_i;  //    [1:0] 
    //      ahb_monitor_struct.xyz = hburst_i;  //    [2:0] 
    //      ahb_monitor_struct.xyz = hsize_i;  //    [2:0] 
    //      ahb_monitor_struct.xyz = hwrite_i;  //     
    //      ahb_monitor_struct.xyz = hsel_i;  //     
    //      ahb_monitor_struct.xyz = hready_i;  //     
    //      ahb_monitor_struct.xyz = hrdata_i;  //    [15:0] 
    //      ahb_monitor_struct.xyz = hresp_i;  //    [1:0] 
    // pragma uvmf custom do_monitor begin
      if ( !hresetn_i ) begin
         //-start_time = $time;
         ahb_monitor_struct.op = AHB_RESET;
         do_wait_for_reset();
         //-end_time = $time;
      end
      else begin
         while ( hsel_i == 1'b0 ) @(posedge hclk_i);
         //-start_time = $time;
         // Address Phase
         ahb_monitor_struct.addr = haddr_i;
         if ( hwrite_i == 1'b1 ) ahb_monitor_struct.op = AHB_WRITE;
         else                    ahb_monitor_struct.op = AHB_READ;
         do @(posedge hclk_i); while ( hready_i == 1'b0 ); //wait ( hready_i == 1'b1 ); @(posedge hclk_i); 
         // Data Phase
         if ( ahb_monitor_struct.op == AHB_WRITE ) ahb_monitor_struct.data = hwdata_i;
         else                   ahb_monitor_struct.data = hrdata_i;
         //-end_time = $time;
      end 



    // pragma uvmf custom do_monitor end
  endtask         
  
 
endinterface
