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
// Unit            : Signal bundle interface
// File            : ahb_if.sv
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This interface contains the AHB interface singals.
//      It is instantiated once per AHB bus.  Bus Functional Models, 
//      BFM's named ahb_driver_bfm, are used to drive signals on the bus.
//      BFM's named ahb_monitor_bfm are used to monitor signals on the 
//      bus. This interface signal bundle is passed in the port list of
//      the BFM in order to give the BFM access to the signals in this
//      interface.
//
//----------------------------------------------------------------------

import uvmf_base_pkg_hdl::*;
import ahb_pkg_hdl::*;

interface ahb_if( hclk, 
                  hresetn, 
                  haddr, 
                  hwdata, 
                  htrans, 
                  hburst, 
                  hsize, 
                  hwrite, 
                  hsel, 
                  hready, 
                  hrdata, 
                  hresp
                );

    inout tri hclk; 
    inout tri hresetn; 
    inout tri [AHB_ADDR_WIDTH-1:0] haddr; 
    inout tri [AHB_DATA_WIDTH-1:0] hwdata; 
    inout tri [1:0] htrans; 
    inout tri [2:0] hburst; 
    inout tri [2:0] hsize; 
    inout tri hwrite; 
    inout tri hsel; 
    inout tri hready; 
    inout tri [AHB_DATA_WIDTH-1:0] hrdata; 
    inout tri [1:0] hresp;

property ahb_hready_follows_hsel;
@(posedge hclk) disable iff (!hresetn) $rose(hsel)  |=> (hsel & !hready)[*1:4] ##1 (hsel & hready) ##1 (!hsel & !hready);
endproperty

property ahb_address_stable_throughout_transfer;
@(posedge hclk) disable iff (!hresetn) $rose(hsel)  |=> $stable(haddr)[*1:4] ##1 !hsel;
endproperty

property ahb_wdata_stable_throughout_write;
@(posedge hclk) disable iff (!hresetn) $rose(hwrite)  |=> $stable(hwdata)[*1:4] ##1 !hwrite;
endproperty

assert property(ahb_hready_follows_hsel) else $error("The AHB hsel was not terminated with a hready");
assert property(ahb_address_stable_throughout_transfer) else $error("The AHB address did not remain stable throughout the transfer");
assert property(ahb_wdata_stable_throughout_write) else $error("The AHB write data did not remain stable throughout the write transfer");

cover property(ahb_hready_follows_hsel);
cover property(ahb_address_stable_throughout_transfer);
cover property(ahb_wdata_stable_throughout_write);

endinterface
