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
// Project         : WB interface agent
// Unit            : Signal bundle interface
// File            : wb_if.sv
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This interface contains the wb interface singals.
//      It is instantiated once per wb bus.  Bus Functional Models, 
//      BFM's named wb_driver_bfm, are used to drive signals on the bus.
//      BFM's named wb_monitor_bfm are used to monitor signals on the 
//      bus. This interface signal bundle is passed in the port list of
//      the BFM in order to give the BFM access to the signals in this
//      interface.
//
//----------------------------------------------------------------------
//

import uvmf_base_pkg_hdl::*;
import wb_pkg_hdl::*;

interface wb_if ( clk, 
                  rst, 
                  inta, 
                  cyc, 
                  stb, 
                  adr, 
                  we, 
                  din, 
                  dout, 
                  ack, 
                  err, 
                  rty, 
                  sel, 
                  q
                );

parameter DWIDTH = 16;
parameter AWIDTH = 32;

inout tri                 clk;
inout tri                 rst;
inout tri                 inta;
inout tri                 cyc;
inout tri                 stb;
inout tri [AWIDTH   -1:0] adr;
inout tri                 we;
inout tri [DWIDTH   -1:0] din;
inout tri [DWIDTH   -1:0] dout;
inout tri                 ack;

inout tri                 err;
inout tri                 rty;
inout tri [DWIDTH/8 -1:0] sel;
inout tri [DWIDTH   -1:0] q;

endinterface
