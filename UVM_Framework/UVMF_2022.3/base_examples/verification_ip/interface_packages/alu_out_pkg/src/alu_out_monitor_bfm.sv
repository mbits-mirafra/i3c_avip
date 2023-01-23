//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface performs the alu_out signal monitoring.
//      It is accessed by the uvm alu_out monitor through a virtual
//      interface handle in the alu_out configuration.  It monitors the
//      signals passed in through the port connection named bus of
//      type alu_out_if.
//
//     Input signals from the alu_out_if are assigned to an internal input
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
//                   blocks until an operation on the alu_out bus is complete.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import alu_out_pkg_hdl::*;

`include "src/alu_out_macros.svh"

interface alu_out_monitor_bfm #(
  int ALU_OUT_RESULT_WIDTH = 16
  )
  ( alu_out_if  bus );
  // The pragma below and additional ones in-lined further down are for running this BFM on Veloce
  // pragma attribute alu_out_monitor_bfm partition_interface_xif                                  

  // Structure used to pass transaction data from monitor BFM to monitor class in agent.
`alu_out_MONITOR_STRUCT
  alu_out_monitor_s alu_out_monitor_struct;

  // Structure used to pass configuration data from monitor class to monitor BFM.
 `alu_out_CONFIGURATION_STRUCT
 

  // Config value to determine if this is an initiator or a responder 
  uvmf_initiator_responder_t initiator_responder;
  // Custom configuration variables.  
  // These are set using the configure function which is called during the UVM connect_phase

  tri clk_i;
  tri rst_i;
  tri  done_i;
  tri [ALU_OUT_RESULT_WIDTH-1:0] result_i;
  assign clk_i = bus.clk;
  assign rst_i = bus.rst;
  assign done_i = bus.done;
  assign result_i = bus.result;

  // Proxy handle to UVM monitor
  alu_out_pkg::alu_out_monitor #(
    .ALU_OUT_RESULT_WIDTH(ALU_OUT_RESULT_WIDTH)
    ) proxy;
  // pragma tbx oneway proxy.notify_transaction                 

  // pragma uvmf custom interface_item_additional begin
  // pragma uvmf custom interface_item_additional end
  
  //******************************************************************                         
  task wait_for_reset();// pragma tbx xtf  
    @(posedge clk_i) ;                                                                    
    do_wait_for_reset();                                                                   
  endtask                                                                                   

  // ****************************************************************************              
  task do_wait_for_reset();                                                                 
    wait ( rst_i == 1 ) ;                                                              
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
      do_monitor( alu_out_monitor_struct );
                                                                 
 
      proxy.notify_transaction( alu_out_monitor_struct );
 
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
    function void configure(alu_out_configuration_s alu_out_configuration_arg); // pragma tbx xtf  
    initiator_responder = alu_out_configuration_arg.initiator_responder;
  // pragma uvmf custom configure begin
  // pragma uvmf custom configure end
  endfunction   


  // ****************************************************************************  
            
  task do_monitor(output alu_out_monitor_s alu_out_monitor_struct);
    // UVMF_CHANGE_ME : Implement protocol monitoring.  The commented reference code 
    // below are examples of how to capture signal values and assign them to 
    // structure members.  All available input signals are listed.  The 'while' 
    // code example shows how to wait for a synchronous flow control signal.  This
    // task should return when a complete transfer has been observed.  Once this task is
    // exited with captured values, it is then called again to wait for and observe 
    // the next transfer. One clock cycle is consumed between calls to do_monitor.
    //
    // Available struct members:
    //     //    alu_out_monitor_struct.result
    //     //
    // Reference code;
    //    How to wait for signal value
    //      while (control_signal == 1'b1) @(posedge clk_i);
    //    
    //    How to assign a struct member, named xyz, from a signal.   
    //    All available input signals listed.
    //      alu_out_monitor_struct.xyz = done_i;  //     
    //      alu_out_monitor_struct.xyz = result_i;  //    [ALU_OUT_RESULT_WIDTH-1:0] 
    // pragma uvmf custom do_monitor begin
      //-start_time = $time + 1;
      while ( done_i == 1'b0 ) @(posedge clk_i);
      alu_out_monitor_struct.result = result_i;
      //-end_time = $time - 1;


    // pragma uvmf custom do_monitor end
  endtask         
  
 
endinterface
