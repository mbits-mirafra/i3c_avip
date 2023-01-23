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
// Unit            : Signal bundle interface
// File            : gpio_if.sv
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This interface contains the gpio interface singals.
//      It is instantiated once per gpio bus.  Bus Functional Models, 
//      BFM's named gpio_driver_bfm, are used to drive signals on the bus.
//      BFM's named gpio_monitor_bfm are used to monitor signals on the 
//      bus. This interface signal bundle is passed in the port list of
//      the BFM in order to give the BFM access to the signals in this
//      interface.
//
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import gpio_pkg_hdl::*;

interface gpio_if#(int READ_PORT_WIDTH = 4, int WRITE_PORT_WIDTH=4) (clk, rst, write_port, read_port);

   input wire                  clk;
   input wire                  rst;
   inout wire [WRITE_PORT_WIDTH-1:0] write_port;
   inout wire [READ_PORT_WIDTH-1:0] read_port;

endinterface
