//----------------------------------------------------------------------
// Created with uvmf_gen version 2020.2
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface performs the ALU_in signal monitoring.
//      It is accessed by the uvm ALU_in monitor through a virtual
//      interface handle in the ALU_in configuration.  It monitors the
//      signals passed in through the port connection named bus of
//      type ALU_in_if.
//
//     Input signals from the ALU_in_if are assigned to an internal input
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
//                   blocks until an operation on the ALU_in bus is complete.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import ALU_in_pkg_hdl::*;

`include "src/ALU_in_macros.svh"

interface ALU_in_monitor_bfm #(
  int ALU_IN_OP_WIDTH = 8
  )
  ( ALU_in_if  bus );
  // The pragma below and additional ones in-lined further down are for running this BFM on Veloce
  // pragma attribute ALU_in_monitor_bfm partition_interface_xif                                  

  // Structure used to pass transaction data from monitor BFM to monitor class in agent.
`ALU_in_MONITOR_STRUCT
  ALU_in_monitor_s ALU_in_monitor_struct;

  // Structure used to pass configuration data from monitor class to monitor BFM.
 `ALU_in_CONFIGURATION_STRUCT
 

  // Config value to determine if this is an initiator or a responder 
  uvmf_initiator_responder_t initiator_responder;
  // Custom configuration variables.  
  // These are set using the configure function which is called during the UVM connect_phase

  tri clk_i;
  tri rst_i;
  tri  alu_rst_i;
  tri  ready_i;
  tri  valid_i;
  tri [2:0] op_i;
  tri [ALU_IN_OP_WIDTH-1:0] a_i;
  tri [ALU_IN_OP_WIDTH-1:0] b_i;
  assign clk_i = bus.clk;
  assign rst_i = bus.rst;
  assign alu_rst_i = bus.alu_rst;
  assign ready_i = bus.ready;
  assign valid_i = bus.valid;
  assign op_i = bus.op;
  assign a_i = bus.a;
  assign b_i = bus.b;

  // Proxy handle to UVM monitor
  ALU_in_pkg::ALU_in_monitor #(
    .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)
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
      do_monitor( ALU_in_monitor_struct );
                                                                 
 
      proxy.notify_transaction( ALU_in_monitor_struct );
 
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
    function void configure(ALU_in_configuration_s ALU_in_configuration_arg); // pragma tbx xtf  
    initiator_responder = ALU_in_configuration_arg.initiator_responder;
  // pragma uvmf custom configure begin
  // pragma uvmf custom configure end
  endfunction   


  // ****************************************************************************  
            
  task do_monitor(
          output ALU_in_monitor_s ALU_in_monitor_struct);
    // UVMF_CHANGE_ME : Implement protocol monitoring.          The commented reference code 
    // below are examples of how to capture signal values and assign them to 
    // structure members.  All available input signals are listed.  The 'while' 
    // code example shows how to wait for a synchronous flow control signal.  This
    // task should return when a complete transfer has been observed.  Once this task is
    // exited with captured values, it is then called again to wait for and observe 
    // the next transfer. One clock cycle is consumed between calls to do_monitor.
    //
    // Available struct members:
    //     //    ALU_in_monitor_struct.op
    //     //    ALU_in_monitor_struct.a
    //     //    ALU_in_monitor_struct.b
    //     //
    // Reference code;
    //    How to wait for signal value
    //      while (control_signal == 1'b1) @(posedge clk_i);
    //    
    //    How to assign a struct member, named xyz, from a signal.   
    //    All available input signals listed.
    //      ALU_in_monitor_struct.xyz = alu_rst_i;  //     
    //      ALU_in_monitor_struct.xyz = ready_i;  //     
    //      ALU_in_monitor_struct.xyz = valid_i;  //     
    //      ALU_in_monitor_struct.xyz = op_i;  //    [2:0] 
    //      ALU_in_monitor_struct.xyz = a_i;  //    [ALU_IN_OP_WIDTH-1:0] 
    //      ALU_in_monitor_struct.xyz = b_i;  //    [ALU_IN_OP_WIDTH-1:0] 
    // pragma uvmf custom do_monitor begin
      // Hold here until signal event happens to capture bus values
      while (valid_i == 1'b0 && alu_rst_i == 1'b1) begin
        @(posedge clk_i);
      end
      ALU_in_monitor_struct.op = alu_in_op_t'(op_i);
      ALU_in_monitor_struct.a  = a_i;
      ALU_in_monitor_struct.b  = b_i;

      if (alu_rst_i == 1'b0) begin
        while (alu_rst_i == 1'b0) begin
          @(posedge clk_i);
          ALU_in_monitor_struct.op  = rst_op;
        end
      end 

  endtask         
  
 
endinterface
