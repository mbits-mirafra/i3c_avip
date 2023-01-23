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
// Project         : wb interface agent
// Unit            : Monitor Bus Functional Model
// File            : wb_monitor_bfm.sv
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This interface performs the wb signal monitoring.
//      It is accessed by the uvm wb monitor through a virtual
//      interface handle in the wb configuration.  It monitors the
//      signals passed in through the port connection named bus of
//      type wb_if.
//
//     Input signals from the wb_if are assigned to an internal input
//     signal with a _i suffix.  
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i 
//
//      Interface functions and tasks used by UVM components:
//             wait_for_reset();
//                   This task blocks until the reset is release.  It
//                   returns immediately if reset is deasserted.
//
//             wait_for_num_clocks(int clocks);
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
//             monitor(output wb_op_t op,
//                     output bit [AWIDTH-1:0] addr, 
//                     output bit [DWIDTH-1:0] data);
//                   This task populates transaction attributes for the
//                   UVM monitor from values observed on bus activity.  
//                   The task blocks until an operation on the WB bus is complete.
//                   It provides a 'pull' alternative to using the preferred
//                   'push' variant with start_monitoring()/run() above.
//
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import wb_pkg_hdl::*;

interface wb_monitor_bfm ( wb_if bus );
// pragma attribute wb_monitor_bfm partition_interface_xif

parameter DWIDTH = WB_DATA_WIDTH;
parameter AWIDTH = WB_ADDR_WIDTH;

tri                  clk_i;
tri                  rst_i;
tri [AWIDTH   -1:0]  adr_i;
tri [DWIDTH   -1:0]  dout_i;
tri                  cyc_i;
tri                  stb_i;
tri                  we_i;
tri [DWIDTH/8 -1:0]  sel_i;
tri [DWIDTH   -1:0]  q_i;

tri                 ack_i, err_i, rty_i,inta_i;
tri [DWIDTH   -1:0] din_i;

assign clk_i = bus.clk;
assign rst_i = bus.rst;
assign adr_i = bus.adr;
assign dout_i = bus.dout;
assign cyc_i = bus.cyc;
assign stb_i = bus.stb;
assign we_i = bus.we;
assign sel_i = bus.sel;
assign q_i = bus.q;
assign ack_i = bus.ack;
assign err_i = bus.err;
assign rty_i = bus.rty;
assign inta_i = bus.inta;
assign din_i = bus.din;


   import wb_pkg::wb_monitor;
   wb_monitor proxy; // pragma tbx oneway proxy.notify_transaction

  uvmf_master_slave_t master_slave;

//******************************************************************
  function void configure(uvmf_master_slave_t mst_slv); // pragma tbx xtf
     master_slave = mst_slv;
  endfunction


//******************************************************************
   task wait_for_reset(); // pragma tbx xtf
      @(posedge clk_i) ;
      do_wait_for_reset();
   endtask

//******************************************************************
   task wait_for_num_clocks(int unsigned count); // pragma tbx xtf
      @(posedge clk_i) ;
      repeat ( count-1 ) @(posedge clk_i) ;
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
        bit [AWIDTH-1:0] addr;
        bit [DWIDTH-1:0] data;

        @(posedge clk_i);
        do_monitor(op, addr, data);
        proxy.notify_transaction(op, addr, data);
      end
   end

//******************************************************************
//   task run(); // pragma tbx xtf
//      //@(posedge clk_i);
//      forever begin
//        wb_op_t op;
//        bit [AWIDTH-1:0] addr;
//        bit [DWIDTH-1:0] data;
//
//        @(posedge clk_i);
//        do_monitor(op, addr, data);
//        proxy.notify_transaction(op, addr, data);
//      end
//   endtask

// ****************************************************************************
   task monitor(output wb_op_t op,
                output bit [AWIDTH-1:0] addr, 
                output bit [DWIDTH-1:0] data); // pragma tbx xtf
      @(posedge clk_i) ;
      do_monitor(op, addr, data);
   endtask

// ****************************************************************************
   task do_wait_for_reset();
      wait ( rst_i == 1 ) ;
      @(posedge clk_i) ;
   endtask

//********************************************************************
  task do_monitor(output wb_op_t op, 
                  output bit[AWIDTH-1:0] addr, 
                  output bit[DWIDTH-1:0] data);
     begin :monitor_bus
         if ( !rst_i ) begin
            //-start_time = $time;
            op = WB_RESET;
            do_wait_for_reset();
            //-end_time = $time;
         end 
         else begin
            while(!ack_i) @(posedge clk_i); //-start_time = $time;
            begin : in_transaction
               if (we_i) begin :write_txn
                  op = WB_WRITE;
                  data = dout_i;
                  addr = adr_i;
               end : write_txn
               else begin : read_txn
                  op = WB_READ;
                  data = din_i;
                  addr = adr_i;
               end :read_txn
               //-end_time = $time;
            end : in_transaction
         end
         if (op == WB_WRITE) repeat (2) @(posedge clk_i);
     end : monitor_bus
  endtask

endinterface
