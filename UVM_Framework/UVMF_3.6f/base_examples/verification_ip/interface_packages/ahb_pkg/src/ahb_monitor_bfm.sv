//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 15
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb interface agent
// Unit            : Interface Monitor BFM
// File            : ahb_monitor_bfm.sv
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
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import ahb_pkg_hdl::*;

interface ahb_monitor_bfm( ahb_if bus );
// pragma attribute ahb_monitor_bfm partition_interface_xif                                  
// The above pragma and additional ones in-lined below are for running this BFM on Veloce


   tri        hclk_i;
   tri        hresetn_i;
   tri        [31:0] haddr_i;
   tri        [15:0] hwdata_i;
   tri        [1:0] htrans_i;
   tri        [2:0] hburst_i;
   tri        [2:0] hsize_i;
   tri         hwrite_i;
   tri         hsel_i;
   tri         hready_i;
   tri        [15:0] hrdata_i;
   tri        [1:0] hresp_i;

   assign     hclk_i    =   bus.hclk;
   assign     hresetn_i    =   bus.hresetn;
   assign     haddr_i = bus.haddr;
   assign     hwdata_i = bus.hwdata;
   assign     htrans_i = bus.htrans;
   assign     hburst_i = bus.hburst;
   assign     hsize_i = bus.hsize;
   assign     hwrite_i = bus.hwrite;
   assign     hsel_i = bus.hsel;
   assign     hready_i = bus.hready;
   assign     hrdata_i = bus.hrdata;
   assign     hresp_i = bus.hresp;

   ahb_pkg::ahb_monitor proxy;
  // pragma tbx oneway proxy.notify_transaction                 

//******************************************************************                         
   task wait_for_reset(); // pragma tbx xtf                                                  
      @(posedge hclk_i) ;                                                                    
      do_wait_for_reset();                                                                   
   endtask                                                                                   

// ****************************************************************************              
   task do_wait_for_reset();                                                                 
      wait ( hresetn_i == 1 ) ;                                                              
      @(posedge hclk_i) ;                                                                    
   endtask    
   
//******************************************************************                         
   task wait_for_num_clocks( input int unsigned count); // pragma tbx xtf                           
      @(posedge hclk_i);                                                                     
      repeat (count-1) @(posedge hclk_i);                                                    
   endtask      

//******************************************************************                         
  event go;                                                                                 
  function void start_monitoring(); // pragma tbx xtf      
     -> go;                                                                                 
  endfunction                                                                               
  
  // ****************************************************************************              
  initial begin                                                                             
     @go;                                                                                   
     forever begin                                                                          
        ahb_op_t op;
        bit [15:0] data;
        bit [31:0] addr;
        @(posedge hclk_i);                                                                   

        do_monitor(
                   op,
                   data,
                   addr                  );
        proxy.notify_transaction(
                   op,
                   data,
                   addr                                );     
     end                                                                                    
  end                                                                                       

//******************************************************************
   function void configure(
          uvmf_active_passive_t active_passive,
          uvmf_master_slave_t   master_slave
); // pragma tbx xtf

   endfunction


// ****************************************************************************              
     task do_monitor(
                   output ahb_op_t op,
                   output bit [15:0] data,
                   output bit [31:0] addr                    );

      if ( !hresetn_i ) begin
         //-start_time = $time;
         op = AHB_RESET;
         do_wait_for_reset();
         //-end_time = $time;
      end
      else begin
         while ( hsel_i == 1'b0 ) @(posedge hclk_i);
         //-start_time = $time;
         // Address Phase
         addr = haddr_i;
         if ( hwrite_i == 1'b1 ) op = AHB_WRITE;
         else                    op = AHB_READ;
         do @(posedge hclk_i); while ( hready_i == 1'b0 ); //wait ( hready_i == 1'b1 ); @(posedge hclk_i); 
         // Data Phase
         if ( op == AHB_WRITE ) data = hwdata_i;
         else                   data = hrdata_i;
         //-end_time = $time;
      end                                                                                    
     endtask         
  
endinterface
