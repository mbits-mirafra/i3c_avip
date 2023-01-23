//----------------------------------------------------------------------
// Created with uvmf_gen version 2021.1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface performs the ccs signal monitoring.
//      It is accessed by the uvm ccs monitor through a virtual
//      interface handle in the ccs configuration.  It monitors the
//      signals passed in through the port connection named bus of
//      type ccs_if.
//
//     Input signals from the ccs_if are assigned to an internal input
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
//                   blocks until an operation on the ccs bus is complete.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import ccs_pkg_hdl::*;
`include "src/ccs_macros.svh"


interface ccs_monitor_bfm #(
  int WIDTH = 32
  )
  ( ccs_if  bus );
  // The pragma below and additional ones in-lined further down are for running this BFM on Veloce
  // pragma attribute ccs_monitor_bfm partition_interface_xif                                  

  // Structure used to pass transaction data from monitor BFM to monitor class in agent.
`ccs_MONITOR_STRUCT
  ccs_monitor_s ccs_monitor_struct;

  // Structure used to pass configuration data from monitor class to monitor BFM.
 `ccs_CONFIGURATION_STRUCT
 

  // Config value to determine if this is an initiator or a responder 
  uvmf_initiator_responder_t initiator_responder;
  // Custom configuration variables.  
  // These are set using the configure function which is called during the UVM connect_phase
  bit [2:0] protocol_kind;
  bit reset_polarity;

  tri clk_i;
  tri rst_i;
  tri  rdy_i;
  tri  vld_i;
  tri [WIDTH-1:0] dat_i;
  assign clk_i = bus.clk;
  assign rst_i = bus.rst;
  assign rdy_i = bus.rdy;
  assign vld_i = bus.vld;
  assign dat_i = bus.dat;

  // Proxy handle to UVM monitor
  ccs_pkg::ccs_monitor #(
    .WIDTH(WIDTH)
    ) proxy;
  // pragma tbx oneway proxy.notify_transaction                 

  // pragma uvmf custom interface_item_additional begin
  event dma_done;

  task wait_for_dma_done();
    @dma_done;
  endtask
  // pragma uvmf custom interface_item_additional end
  
  //******************************************************************                         
  task wait_for_reset();// pragma tbx xtf  
    @(posedge clk_i) ;                                                                    
    do_wait_for_reset();                                                                   
  endtask                                                                                   

  // ****************************************************************************              
  task do_wait_for_reset(); 
  // pragma uvmf custom reset_condition begin
        wait ( rst_i == reset_polarity );
        @(posedge clk_i);
  // pragma uvmf custom reset_condition end                                                                
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
      do_monitor( ccs_monitor_struct );
                                                                 
 
      proxy.notify_transaction( ccs_monitor_struct );
 
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
    function void configure(ccs_configuration_s ccs_configuration_arg); // pragma tbx xtf  
    initiator_responder = ccs_configuration_arg.initiator_responder;
    protocol_kind = ccs_configuration_arg.protocol_kind;
    reset_polarity = ccs_configuration_arg.reset_polarity;
  // pragma uvmf custom configure begin
  // pragma uvmf custom configure end
  endfunction   


  // ****************************************************************************  
            
  task do_monitor(output ccs_monitor_s ccs_monitor_struct);
    //
    // Available struct members:
    //     //    ccs_monitor_struct.rtl_data
    //     //    ccs_monitor_struct.wait_cycles
    //     //    ccs_monitor_struct.iteration_count
    //     //    ccs_monitor_struct.empty
    //     //
    // Reference code;
    //    How to wait for signal value
    //      while (control_signal == 1'b1) @(posedge clk_i);
    //    
    //    How to assign a struct member, named xyz, from a signal.   
    //    All available input signals listed.
    //      ccs_monitor_struct.xyz = rdy_i;  //     
    //      ccs_monitor_struct.xyz = vld_i;  //     
    //      ccs_monitor_struct.xyz = dat_i;  //    [WIDTH-1:0] 
    // pragma uvmf custom do_monitor begin
  // ****************************************************************************
  /*
    @(posedge clk_i);
    @(posedge clk_i);
    @(posedge clk_i);
    @(posedge clk_i);
  */
 
  if ( rst_i == reset_polarity ) begin
    while ( rst_i == reset_polarity ) @(posedge clk_i);
  end
 
  case (protocol_kind)
    CCS : begin // capture data
      //@(posedge clk_i);
      ccs_monitor_struct.rtl_data = dat_i;
    end
    CCS_RDY : begin // capture data when rdy=1
      while ( !rdy_i ) @(posedge clk_i);
      ccs_monitor_struct.rtl_data = dat_i;
    end
    CCS_VLD : begin // capture data when vld=1
      while ( !vld_i ) @(posedge clk_i);
      ccs_monitor_struct.rtl_data = dat_i;
    end
    CCS_WAIT : begin // capture data off RTL when vld=rdy=1
      while ( !vld_i || !rdy_i ) @(posedge clk_i);
      ccs_monitor_struct.rtl_data = dat_i;
    end
    CCS_SYNC : begin // capture data off RTL when vld=rdy=1
      while ( !vld_i || !rdy_i ) @(posedge clk_i);
      ccs_monitor_struct.rtl_data = vld_i;
    end
  endcase

  ->dma_done;
    // pragma uvmf custom do_monitor end
  endtask         
  
 
endinterface
