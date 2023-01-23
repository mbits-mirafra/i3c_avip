//----------------------------------------------------------------------
//   Copyright 2013 Mentor Graphics Corporation
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//                   Mentor Graphics Inc
//----------------------------------------------------------------------
// Project         : AHB interface agent
// Unit            : Monitor Bus Functional Model
// File            : ahb_monitor_bfm.sv
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This interface performs the AHB signal monitoring.
//      It is accessed by the uvm ahb monitor through a virtual
//      interface handle in the ahb configuration.  It monitors the
//      signals passed in through the port connection named bus of
//      type ahb_if.
//
//     Input signals from the ahb_if are assigned to an internal input
//     signal with a _i suffix.  
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i 
//
//      BFM interface functions and tasks used by UVM components:
//
//             configure(uvmf_master_slave_t mst_slv);
//                   This function gets configuration attributes from the
//                   UVM driver to set any required BFM configuration 
//                   variables such as 'master_slave'.
//
//             wait_for_reset();
//                   This task blocks until the reset is release.  It
//                   returns immediately if reset is deasserted.
//
//             wait_for_clk(int clocks);
//                   This task waits for the number of clock events
//                   specified by the clocks argument.
//
//             start_monitoring()/run();
//                   This function/task kicks off an autonomous monitor 
//                   thread to observe bus activity and pass sampled 
//                   bus transaction attributes to the associated 
//                   UVM monitor (the proxy) where they are used to
//                   populate transaction objects.
//
//             monitor(output ahb_op_t op,
//                     output bit [AHB_ADDR_WIDTH-1:0] addr, 
//                     output bit [AHB_DATA_WIDTH-1:0] data);
//                   This task populates transaction attributes for the
//                   UVM monitor from values observed on bus activity.  
//                   The task blocks until an operation on the AHB bus is complete.
//                   It provides a 'pull' alternative to using the preferred
//                   'push' variant with start_monitoring()/run() above.
//
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import ahb_pkg_hdl::*;

interface ahb_monitor_bfm( ahb_if bus );
// pragma attribute ahb_monitor_bfm partition_interface_xif

   tri               hclk_i;
   tri               hresetn_i;
   tri  [AHB_ADDR_WIDTH-1:0] haddr_i;
   tri  [AHB_DATA_WIDTH-1:0] hwdata_i;
   tri  [1:0]        htrans_i;
   tri  [2:0]        hburst_i;
   tri  [2:0]        hsize_i;
   tri               hwrite_i;
   tri               hsel_i;

   tri                hready_i;
   tri  [AHB_DATA_WIDTH-1:0]  hrdata_i;
   tri  [1:0]         hresp_i;

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


   ahb_pkg::ahb_monitor proxy; // pragma tbx oneway proxy.notify_transaction

   uvmf_master_slave_t master_slave;

//******************************************************************
   function void configure(uvmf_master_slave_t mst_slv); // pragma tbx xtf
      master_slave = mst_slv;
   endfunction


//******************************************************************
   task wait_for_reset(); // pragma tbx xtf
      @(posedge hclk_i) ;
      do_wait_for_reset();
   endtask

//******************************************************************
   task wait_for_clk( input int unsigned count); // pragma tbx xtf
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
        bit [AHB_ADDR_WIDTH-1:0] addr;
        bit [AHB_DATA_WIDTH-1:0] data;

        @(posedge hclk_i);
        do_monitor(op, addr, data);
        proxy.notify_transaction(op, addr, data);
      end
   end

//******************************************************************
//   task run(); // pragma tbx xtf
//      //@(posedge hclk_i);
//      forever begin
//        ahb_op_t op;
//        bit [AHB_ADDR_WIDTH-1:0] addr;
//        bit [AHB_DATA_WIDTH-1:0] data;
//
//        @(posedge hclk_i);
//        do_monitor(op, addr, data);
//        proxy.notify_transaction(op, addr, data);
//      end
//   endtask

// ****************************************************************************
   task monitor(output ahb_op_t op,
                output bit [AHB_ADDR_WIDTH-1:0] addr, 
                output bit [AHB_DATA_WIDTH-1:0] data); // pragma tbx xtf
      @(posedge hclk_i);
      do_monitor(op, addr, data);
   endtask

// ****************************************************************************
   task do_wait_for_reset();
      wait ( hresetn_i == 1 ) ;
      @(posedge hclk_i) ;
   endtask

// ****************************************************************************
   task do_monitor(output ahb_op_t op,
                   output bit [AHB_ADDR_WIDTH-1:0] addr, 
                   output bit [AHB_DATA_WIDTH-1:0] data);
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
