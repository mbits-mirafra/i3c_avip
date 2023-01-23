//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface performs the wb signal monitoring.
//      It is accessed by the uvm wb monitor through a virtual
//      interface handle in the wb configuration.  It monitors the
//      signals passed in through the port connection named bus of
//      type wb_if.
//
//     Input signals from the wb_if are assigned to an internal input
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
//                   blocks until an operation on the wb bus is complete.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import wb_pkg_hdl::*;

`include "src/wb_macros.svh"

interface wb_monitor_bfm #(
  int WB_ADDR_WIDTH = 32,
  int WB_DATA_WIDTH = 16
  )
  ( wb_if  bus );
  // The pragma below and additional ones in-lined further down are for running this BFM on Veloce
  // pragma attribute wb_monitor_bfm partition_interface_xif                                  

  // Structure used to pass transaction data from monitor BFM to monitor class in agent.
`wb_MONITOR_STRUCT
  wb_monitor_s wb_monitor_struct;

  // Structure used to pass configuration data from monitor class to monitor BFM.
 `wb_CONFIGURATION_STRUCT
 

  // Config value to determine if this is an initiator or a responder 
  uvmf_initiator_responder_t initiator_responder;
  // Custom configuration variables.  
  // These are set using the configure function which is called during the UVM connect_phase

  tri clk_i;
  tri rst_i;
  tri  inta_i;
  tri  cyc_i;
  tri  stb_i;
  tri [WB_ADDR_WIDTH-1:0] adr_i;
  tri  we_i;
  tri [WB_DATA_WIDTH-1:0] dout_i;
  tri [WB_DATA_WIDTH-1:0] din_i;
  tri  err_i;
  tri  rty_i;
  tri [WB_DATA_WIDTH/8-1:0] sel_i;
  tri [WB_DATA_WIDTH-1:0] q_i;
  tri  ack_i;
  assign clk_i = bus.clk;
  assign rst_i = bus.rst;
  assign inta_i = bus.inta;
  assign cyc_i = bus.cyc;
  assign stb_i = bus.stb;
  assign adr_i = bus.adr;
  assign we_i = bus.we;
  assign dout_i = bus.dout;
  assign din_i = bus.din;
  assign err_i = bus.err;
  assign rty_i = bus.rty;
  assign sel_i = bus.sel;
  assign q_i = bus.q;
  assign ack_i = bus.ack;

  // Proxy handle to UVM monitor
  wb_pkg::wb_monitor #(
    .WB_ADDR_WIDTH(WB_ADDR_WIDTH),
    .WB_DATA_WIDTH(WB_DATA_WIDTH)
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
      do_monitor( wb_monitor_struct );
                                                                 
 
      proxy.notify_transaction( wb_monitor_struct );
 
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
    function void configure(wb_configuration_s wb_configuration_arg); // pragma tbx xtf  
    initiator_responder = wb_configuration_arg.initiator_responder;
  // pragma uvmf custom configure begin
  // pragma uvmf custom configure end
  endfunction   


  // ****************************************************************************  
            
  task do_monitor(output wb_monitor_s wb_monitor_struct);
    // UVMF_CHANGE_ME : Implement protocol monitoring.  The commented reference code 
    // below are examples of how to capture signal values and assign them to 
    // structure members.  All available input signals are listed.  The 'while' 
    // code example shows how to wait for a synchronous flow control signal.  This
    // task should return when a complete transfer has been observed.  Once this task is
    // exited with captured values, it is then called again to wait for and observe 
    // the next transfer. One clock cycle is consumed between calls to do_monitor.
    //
    // Available struct members:
    //     //    wb_monitor_struct.op
    //     //    wb_monitor_struct.data
    //     //    wb_monitor_struct.addr
    //     //    wb_monitor_struct.byte_select
    //     //
    // Reference code;
    //    How to wait for signal value
    //      while (control_signal == 1'b1) @(posedge clk_i);
    //    
    //    How to assign a struct member, named xyz, from a signal.   
    //    All available input signals listed.
    //      wb_monitor_struct.xyz = inta_i;  //     
    //      wb_monitor_struct.xyz = cyc_i;  //     
    //      wb_monitor_struct.xyz = stb_i;  //     
    //      wb_monitor_struct.xyz = adr_i;  //    [WB_ADDR_WIDTH-1:0] 
    //      wb_monitor_struct.xyz = we_i;  //     
    //      wb_monitor_struct.xyz = dout_i;  //    [WB_DATA_WIDTH-1:0] 
    //      wb_monitor_struct.xyz = din_i;  //    [WB_DATA_WIDTH-1:0] 
    //      wb_monitor_struct.xyz = err_i;  //     
    //      wb_monitor_struct.xyz = rty_i;  //     
    //      wb_monitor_struct.xyz = sel_i;  //    [WB_DATA_WIDTH/8-1:0] 
    //      wb_monitor_struct.xyz = q_i;  //    [WB_DATA_WIDTH-1:0] 
    //      wb_monitor_struct.xyz = ack_i;  //     
    // pragma uvmf custom do_monitor begin
       if ( !rst_i ) begin  
           wb_monitor_struct.op = WB_RESET;                                                              
           do_wait_for_reset();                                                                
        end                                                                                    
        else begin                                                                             
          while (!ack_i) @(posedge clk_i);
          if (we_i) begin
            wb_monitor_struct.op = WB_WRITE;
            wb_monitor_struct.data = dout_i;
            wb_monitor_struct.addr = adr_i;
          end else begin
            wb_monitor_struct.op = WB_READ;
            wb_monitor_struct.data = din_i;
            wb_monitor_struct.addr = adr_i;
          end
        end  
        if (wb_monitor_struct.op == WB_WRITE) repeat (2) @(posedge clk_i);                                                                                  





    // pragma uvmf custom do_monitor end
  endtask         
  
 
endinterface
