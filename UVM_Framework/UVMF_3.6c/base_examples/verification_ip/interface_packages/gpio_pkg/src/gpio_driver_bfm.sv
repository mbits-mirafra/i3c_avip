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
// Unit            : Driver Bus Functional Model
// File            : gpio_driver_bfm.sv
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This interface performs the gpio signal driving.  It is
//     accessed by the uvm gpio driver through a virtual interface 
//     handle in the gpio configuration.  It drives the singals passed
//     in through the port connection named bus of type gpio_if.
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i
//
//     The output signal connections are as follows:
//        signal_o -> bus.signal
//
//      BFM interface functions and tasks used by UVM components:
//             write(input bit [WRITE_PORT_WIDTH-1:0] data);
//                   This task performs a write port write on the GPIO bus.
//
//             start_read_daemon();
//                   This task initiates read port reading on the GPIO bus.
//
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import gpio_pkg_hdl::*;

interface gpio_driver_bfm #(int READ_PORT_WIDTH=4, int WRITE_PORT_WIDTH=4) (gpio_if bus);
// pragma attribute gpio_driver_bfm partition_interface_xif

   wire                  clk_i;
   bit  [WRITE_PORT_WIDTH-1:0] write_port_o;
   wire [READ_PORT_WIDTH-1:0] read_port_i;

   assign bus.write_port  = write_port_o;
   assign clk_i            = bus.clk;
   assign read_port_i      = bus.read_port;

   gpio_pkg::gpio_driver #(READ_PORT_WIDTH, WRITE_PORT_WIDTH) proxy; 
   // pragma tbx oneway proxy.notify_read_port_change


// ****************************************************************************
  //task write(input bit [WRITE_PORT_WIDTH-1:0] data); // pragma tbx xtf
  function void write(input bit [WRITE_PORT_WIDTH-1:0] data); // pragma tbx xtf
     //@(posedge clk_i);
     write_port_o <= data;
  endfunction
  //endtask

// ****************************************************************************
  event do_start_read_daemon;
  bit [READ_PORT_WIDTH-1:0] read_port_reg;

  function void start_read_daemon(); // pragma tbx xtf
     read_port_reg = read_port_i;
     proxy.notify_read_port_change(read_port_reg);
     -> do_start_read_daemon;
  endfunction

  initial begin
     @do_start_read_daemon;
     forever begin
        @(posedge clk_i);
        while (read_port_reg == read_port_i) // Wait until any bit in read bus changes
          @(posedge clk_i);
        read_port_reg = read_port_i;
        proxy.notify_read_port_change(read_port_reg);
     end
  end

endinterface
