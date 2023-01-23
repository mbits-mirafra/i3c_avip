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
// File            : alu_out_if.sv
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This interface contains the ALU_IN interface singals.
//      It is instantiated once per ALU_IN bus.  Bus Functional Models, 
//      BFM's named alu_out_driver_bfm, are used to drive signals on the bus.
//      BFM's named alu_out_monitor_bfm are used to monitor signals on the 
//      bus. This interface signal bundle is passed in the port list of
//      the BFM in order to give the BFM access to the signals in this
//      interface.
//
// ****************************************************************************

import uvmf_base_pkg_hdl::*;
import alu_out_pkg_hdl::*;

interface alu_out_if( clk, 
                  rst, 
                  done, 
                  result 
                );

    inout tri clk; 
    inout tri rst; 
    inout tri done; 
    inout tri [ALU_OUT_RESULT_WIDTH-1:0]result; 

endinterface
