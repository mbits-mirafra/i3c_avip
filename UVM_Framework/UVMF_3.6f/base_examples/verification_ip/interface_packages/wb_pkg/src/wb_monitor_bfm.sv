//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : jcraft
// Creation Date   : 2016 Nov 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : wb interface agent
// Unit            : Interface Monitor BFM
// File            : wb_monitor_bfm.sv
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
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import wb_pkg_hdl::*;

interface wb_monitor_bfm       #(
      int WB_ADDR_WIDTH = 32,                                
      int WB_DATA_WIDTH = 16                                
      )
( wb_if bus );
// pragma attribute wb_monitor_bfm partition_interface_xif                                  
// The above pragma and additional ones in-lined below are for running this BFM on Veloce


   tri        clk_i;
   tri        rst_i;
   tri         inta_i;
   tri         cyc_i;
   tri         stb_i;
   tri        [WB_ADDR_WIDTH-1:0] adr_i;
   tri         we_i;
   tri        [WB_DATA_WIDTH-1:0] dout_i;
   tri        [WB_DATA_WIDTH-1:0] din_i;
   tri         err_i;
   tri         rty_i;
   tri        [(WB_DATA_WIDTH/8)-1:0] sel_i;
   tri        [WB_DATA_WIDTH-1:0] q_i;

   assign     clk_i    =   bus.clk;
   assign     rst_i    =   bus.rst;
   assign     inta_i = bus.inta;
   assign     cyc_i = bus.cyc;
   assign     stb_i = bus.stb;
   assign     adr_i = bus.adr;
   assign     we_i = bus.we;
   assign     dout_i = bus.dout;
   assign     din_i = bus.din;
   assign     err_i = bus.err;
   assign     rty_i = bus.rty;
   assign     sel_i = bus.sel;
   assign     q_i = bus.q;
   assign     ack_i = bus.ack;

   wb_pkg::wb_monitor  #(
              .WB_ADDR_WIDTH(WB_ADDR_WIDTH),                                
              .WB_DATA_WIDTH(WB_DATA_WIDTH)                                
                    )  proxy;
  // pragma tbx oneway proxy.notify_transaction                 

//******************************************************************                         
   task wait_for_reset(); // pragma tbx xtf                                                  
      @(posedge clk_i) ;                                                                    
      do_wait_for_reset();                                                                   
   endtask                                                                                   

// ****************************************************************************              
   task do_wait_for_reset();                                                                 
      wait ( rst_i == 1 ) ;                                                              
      @(posedge clk_i) ;                                                                    
   endtask    
   
//******************************************************************                         
   task wait_for_num_clocks( input int unsigned count); // pragma tbx xtf                           
      @(posedge clk_i);                                                                     
      repeat (count-1) @(posedge clk_i);                                                    
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
        wb_op_t op;
        bit [WB_DATA_WIDTH-1:0] data;
        bit [WB_ADDR_WIDTH-1:0] addr;
        bit [(WB_DATA_WIDTH/8)-1:0] byte_select;
        @(posedge clk_i);                                                                   

        do_monitor(
                   op,
                   data,
                   addr,
                   byte_select                  );
        proxy.notify_transaction(
                   op,
                   data,
                   addr,
                   byte_select                                );     
     end                                                                                    
  end                                                                                       

//******************************************************************
   function void configure(
          uvmf_active_passive_t active_passive,
          uvmf_initiator_responder_t   initiator_responder
); // pragma tbx xtf

   endfunction


// ****************************************************************************              
     task do_monitor(
                   output wb_op_t op,
                   output bit [WB_DATA_WIDTH-1:0] data,
                   output bit [WB_ADDR_WIDTH-1:0] addr,
                   output bit [(WB_DATA_WIDTH/8)-1:0] byte_select                    );
        if ( !rst_i ) begin  
           op = WB_RESET;                                                              
           do_wait_for_reset();                                                                
        end                                                                                    
        else begin                                                                             
          while (!ack_i) @(posedge clk_i);
          if (we_i) begin
            op = WB_WRITE;
            data = dout_i;
            addr = adr_i;
          end else begin
            op = WB_READ;
            data = din_i;
            addr = adr_i;
          end
        end  
        if (op == WB_WRITE) repeat (2) @(posedge clk_i);                                                                                  
     endtask         
  
endinterface
