//----------------------------------------------------------------------
// Created with uvmf_gen version 2022.3
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface performs the i3c_m signal monitoring.
//      It is accessed by the uvm i3c_m monitor through a virtual
//      interface handle in the i3c_m configuration.  It monitors the
//      signals passed in through the port connection named bus of
//      type i3c_m_if.
//
//     Input signals from the i3c_m_if are assigned to an internal input
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
//                   blocks until an operation on the i3c_m bus is complete.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import i3c_m_pkg_hdl::*;
import i3c_m_pkg::*;


interface i3c_m_monitor_bfm 
  ( i3c_m_if  bus );

`ifndef XRTL
// This code is to aid in debugging parameter mismatches between the BFM and its corresponding agent.
// Enable this debug by setting UVM_VERBOSITY to UVM_DEBUG
// Setting UVM_VERBOSITY to UVM_DEBUG causes all BFM's and all agents to display their parameter settings.
// All of the messages from this feature have a UVM messaging id value of "CFG"
// The transcript or run.log can be parsed to ensure BFM parameter settings match its corresponding agents parameter settings.
import uvm_pkg::*;
`include "uvm_macros.svh"
initial begin : bfm_vs_agent_parameter_debug
  `uvm_info("CFG", 
      $psprintf("The BFM at '%m' has the following parameters: ", ),
      UVM_DEBUG)
end
`endif


 i3c_m_transaction  
                      monitored_trans;
 

  // Config value to determine if this is an initiator or a responder 
  uvmf_initiator_responder_t initiator_responder;
  // Custom configuration variables.  
  // These are set using the configure function which is called during the UVM connect_phase
  uvm_active_passive_enum is_active ;
  int no_of_slaves ;
  shift_direction_e shift_dir ;
  bit [SLAVE_ADDRESS_WIDTH-1:0] slave_address_array [];
  bit [7:0] slave_register_address_array [];
  bit [2:0] primary_prescalar ;
  bit [2:0] secondary_prescalar ;
  int baudrate_divisor ;
  bit has_coverage ;

  tri clock_i;
  tri reset_i;
  tri  scl_i_i;
  tri  scl_o_i;
  tri  sda_o_i;
  tri  sda_i_i;
  tri  scl_oen_i;
  tri  sda_oen_i;
  assign clock_i = bus.clock;
  assign reset_i = bus.reset;
  assign scl_i_i = bus.scl_i;
  assign scl_o_i = bus.scl_o;
  assign sda_o_i = bus.sda_o;
  assign sda_i_i = bus.sda_i;
  assign scl_oen_i = bus.scl_oen;
  assign sda_oen_i = bus.sda_oen;

  // Proxy handle to UVM monitor
  i3c_m_pkg::i3c_m_monitor  proxy;

  // pragma uvmf custom interface_item_additional begin
  // pragma uvmf custom interface_item_additional end
  
  //******************************************************************                         
  task wait_for_reset(); 
    @(posedge clock_i) ;                                                                    
    do_wait_for_reset();                                                                   
  endtask                                                                                   

  // ****************************************************************************              
  task do_wait_for_reset(); 
  // pragma uvmf custom reset_condition begin
    wait ( reset_i === 0 ) ;                                                              
    @(posedge clock_i) ;                                                                    
  // pragma uvmf custom reset_condition end                                                                
  endtask    

  //******************************************************************                         
 
  task wait_for_num_clocks(input int unsigned count); 
    @(posedge clock_i);  
                                                                   
    repeat (count-1) @(posedge clock_i);                                                    
  endtask      

  //******************************************************************                         
  event go;                                                                                 
  function void start_monitoring();  
    -> go;
  endfunction                                                                               
  
  // ****************************************************************************              
  initial begin                                                                             
    @go;                                                                                   
    forever begin                                                                        
      @(posedge clock_i);  
      monitored_trans = new("monitored_trans");
      do_monitor( );
                                                                 
 
      proxy.notify_transaction( monitored_trans ); 
 
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
    function void configure(i3c_m_configuration 
                          
                         i3c_m_configuration_arg
                         );  
    initiator_responder = i3c_m_configuration_arg.initiator_responder;
    is_active = i3c_m_configuration_arg.is_active;
    no_of_slaves = i3c_m_configuration_arg.no_of_slaves;
    shift_dir = i3c_m_configuration_arg.shift_dir;
    slave_address_array = i3c_m_configuration_arg.slave_address_array;
    slave_register_address_array = i3c_m_configuration_arg.slave_register_address_array;
    primary_prescalar = i3c_m_configuration_arg.primary_prescalar;
    secondary_prescalar = i3c_m_configuration_arg.secondary_prescalar;
    baudrate_divisor = i3c_m_configuration_arg.baudrate_divisor;
    has_coverage = i3c_m_configuration_arg.has_coverage;
  // pragma uvmf custom configure begin
  // pragma uvmf custom configure end
  endfunction   


  // ****************************************************************************  
  task do_monitor();
    //
    // Available struct members:
    //     //    monitored_trans.read_write
    //     //    monitored_trans.scl
    //     //    monitored_trans.sda
    //     //    monitored_trans.wr_data
    //     //    monitored_trans.rd_data
    //     //    monitored_trans.slave_address
    //     //    monitored_trans.register_address
    //     //    monitored_trans.size
    //     //    monitored_trans.ack
    //     //    monitored_trans.index
    //     //    monitored_trans.raddr
    //     //    monitored_trans.slave_add_ack
    //     //    monitored_trans.reg_add_ack
    //     //    monitored_trans.wr_data_ack
    //     //
    // Reference code;
    //    How to wait for signal value
    //      while (control_signal === 1'b1) @(posedge clock_i);
    //    
    //    How to assign a transaction variable, named xyz, from a signal.   
    //    All available input signals listed.
    //      monitored_trans.xyz = scl_i_i;  //     
    //      monitored_trans.xyz = scl_o_i;  //     
    //      monitored_trans.xyz = sda_o_i;  //     
    //      monitored_trans.xyz = sda_i_i;  //     
    //      monitored_trans.xyz = scl_oen_i;  //     
    //      monitored_trans.xyz = sda_oen_i;  //     
    // pragma uvmf custom do_monitor begin
    // UVMF_CHANGE_ME : Implement protocol monitoring.  The commented reference code 
    // below are examples of how to capture signal values and assign them to 
    // structure members.  All available input signals are listed.  The 'while' 
    // code example shows how to wait for a synchronous flow control signal.  This
    // task should return when a complete transfer has been observed.  Once this task is
    // exited with captured values, it is then called again to wait for and observe 
    // the next transfer. One clock cycle is consumed between calls to do_monitor.
    monitored_trans.start_time = $time;
    @(posedge clock_i);
    @(posedge clock_i);
    @(posedge clock_i);
    @(posedge clock_i);
    monitored_trans.end_time = $time;
    // pragma uvmf custom do_monitor end
  endtask         
  
 
endinterface

// pragma uvmf custom external begin
// pragma uvmf custom external end

