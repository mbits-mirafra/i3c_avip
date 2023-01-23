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
// Project         : gpio interface agent
// Unit            : Monitor Bus Functional Model
// File            : gpio_monitor_bfm.sv
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This interface performs the gpio signal monitoring.
//      It is accessed by the uvm gpio monitor through a virtual 
//      interface handle in the gpio configuration.  It monitors the
//      signals passed in through the port connection named bus of
//      type gpio_if.
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i
//
//      BFM interface functions and tasks used by UVM components:
//             wait_for_num_clocks(int clocks);
//                   This task waits for the number of clock events
//                   specified by the clocks argument.
//
//             start_monitoring();
//                   This function kicks off an autonomous monitor 
//                   thread to observe bus activity and pass sampled 
//                   bus transaction attributes to the associated 
//                   UVM monitor (the proxy) where they are used to
//                   populate transaction objects.
//
//             monitor(output bit [WRITE_PORT_WIDTH-1:0] write_port,
//                     output bit [READ_PORT_WIDTH-1:0] read_port);
//                   This task populates transaction attributes for the
//                   UVM monitor from values observed on bus activity.  
//                   The task blocks until an operation on the AHB bus is complete.
//                   It provides a 'pull' alternative to using the preferred
//                   'push' variant with start_monitoring()/run() above.
//
//
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import gpio_pkg_hdl::*;

interface gpio_monitor_bfm #(int READ_PORT_WIDTH=4, int WRITE_PORT_WIDTH=4) (gpio_if bus);
// pragma attribute gpio_monitor_bfm partition_interface_xif

   wire                  clk_i;
   wire [WRITE_PORT_WIDTH-1:0] write_port_i;
   wire [READ_PORT_WIDTH-1:0] read_port_i;

   assign clk_i            = bus.clk;
   assign read_port_i      = bus.read_port;
   assign write_port_i     = bus.write_port;

   bit [WRITE_PORT_WIDTH-1:0] write_port_reg = '1;
   bit [READ_PORT_WIDTH-1:0] read_port_reg = '1;

   gpio_pkg::gpio_monitor #(READ_PORT_WIDTH, WRITE_PORT_WIDTH) proxy; 
   // pragma tbx oneway proxy.notify_transaction


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
      // Initialize write_port_reg and read_port_reg to be different from  resp.
      // write_port_i and read_port_i to 'catch' initial write_port_i and read_port_i 
      // values as 'value changes' in the first line of the 'do_monitor' task.
      write_port_reg = '1;
      read_port_reg = '1;

      @go;

      forever begin
        bit [WRITE_PORT_WIDTH-1:0] write_port;
        bit [READ_PORT_WIDTH-1:0] read_port;

        @(posedge clk_i);
        do_monitor(write_port, read_port);
        proxy.notify_transaction(write_port, read_port);
      end
   end

// ****************************************************************************
   task monitor(output bit [WRITE_PORT_WIDTH-1:0] write_port,
                output bit [READ_PORT_WIDTH-1:0] read_port); // pragma tbx xtf
      @(posedge clk_i);
      do_monitor(write_port, read_port);
   endtask

// ****************************************************************************
   task do_monitor(output bit [WRITE_PORT_WIDTH-1:0] write_port,
                   output bit [READ_PORT_WIDTH-1:0] read_port);
      while ((read_port_reg == read_port_i) && (write_port_reg == write_port_i))
        @(posedge clk_i);
      //-start_time = $time;
      write_port_reg = write_port_i;
      read_port_reg = read_port_i;
      write_port = write_port_i;
      read_port = read_port_i;
      //-end_time = $time + 1;
   endtask

endinterface
