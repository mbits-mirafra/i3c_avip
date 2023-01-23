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
// Project         : ALU_IN interface agent
// Unit            : Signal bundle interface
// File            : alu_in_if.sv
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This interface contains the ALU_IN interface singals.
//      It is instantiated once per ALU_IN bus.  Bus Functional Models, 
//      BFM's named alu_in_driver_bfm, are used to drive signals on the bus.
//      BFM's named alu_in_monitor_bfm are used to monitor signals on the 
//      bus. This interface signal bundle is passed in the port list of
//      the BFM in order to give the BFM access to the signals in this
//      interface.
//
// ****************************************************************************

import uvmf_base_pkg_hdl::*;
import alu_in_pkg_hdl::*;

interface alu_in_if( clk, 
                  rst, 
                  valid, 
                  ready, 
                  op, 
                  a, 
                  b, foo
                );

    inout tri clk; 
    inout tri rst; 
    inout tri valid; 
    inout tri ready; 
    inout tri [2:0]                 op; 
    inout tri [ALU_IN_OP_WIDTH-1:0] a; 
    inout tri [ALU_IN_OP_WIDTH-1:0] b; 

    inout tri [128:0] foo;

endinterface
