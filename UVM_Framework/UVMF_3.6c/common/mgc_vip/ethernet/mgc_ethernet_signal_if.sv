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
//
// *****************************************************************************
// SystemVerilog           Version: 20150219
// *****************************************************************************

//-------------------------------------------------------------------------
//
// Section: mgc_ethernet
//
//-------------------------------------------------------------------------
interface mgc_ethernet_signal_if
    (input wire iclk_0, input wire iclk_1, input wire ian_clk_0, input wire ian_clk_1, input wire iMDC, input wire ireset);

    //-------------------------------------------------------------------------
    //
    // Group: ETHERNET Signals
    //
    //-------------------------------------------------------------------------



    //------------------------------------------------------------------------------
    // 
    // 
    // Wires: Clock and Reset
    // 
    // Clocks and Reset Wires of various Interfaces
    // 
    //------------------------------------------------------------------------------
    // clk_0              - Common Clock for Device End 0
    //                      
    // clk_1              - Common Clock for Device End 1
    //                      
    // an_clk_0           - Autoneg Clock for Device End 0
    //                      
    // an_clk_1           - Autoneg Clock for Device End 1
    //                      
    // MDC                - Management Interface Clock Wire 
    //                      
    // reset              - Common Reset Wire (Active High)
    //                      
    // (begin inline source)
    wire clk_0;
    wire clk_1;
    wire an_clk_0;
    wire an_clk_1;
    wire MDC;
    wire reset;
    // (end inline source)



    //------------------------------------------------------------------------------
    // 
    // Wires: XGMII/XLGMII/CGMII
    // 
    // XGMII/XLGMII/CGMII Interface Wires
    // 
    //------------------------------------------------------------------------------
    // XD                 - XGMII/XLGMII/CGMII Data Wire 
    //                      
    // XC                 - XGMII/XLGMII/CGMII Control Wire 
    //                      
    // (begin inline source)
    wire [7:0] XD[2][8];
    wire XC[2][8];
    // (end inline source)



    //------------------------------------------------------------------------------
    // 
    // Wires: XAUI/XSBI/XLAUI/CAUI Serial
    // 
    // XAUI/XSBI/XLAUI/CAUI Serial Interface Wires
    // 
    //------------------------------------------------------------------------------
    // lane_bit           - XAUI/XSBI/XLAUI/CAUI Serial Interfaces Wire. 
    //                         This wire will act as Positive pin when differential signaling is enabled.
    //                      
    // lane_bit_n         - XAUI/XSBI/XLAUI/CAUI Serial Interfaces Wire used only in differential signaling. 
    //                         This wire will act as Negative pin when differential signaling is enabled.
    //                      
    // (begin inline source)
    wire lane_bit[2][20];
    wire lane_bit_n[2][20];
    // (end inline source)



    //------------------------------------------------------------------------------
    // 
    // Wires: XAUI Parallel
    // 
    // XAUI Parallel Interface Wires
    // 
    //------------------------------------------------------------------------------
    // L_10b              - XAUI Parallel Interface Wire
    //                      
    // (begin inline source)
    wire [9:0] L_10b[2][4];
    // (end inline source)



    //------------------------------------------------------------------------------
    // 
    // Wires: XSBI Parallel
    // 
    // XSBI Parallel Interface Wire
    // 
    //------------------------------------------------------------------------------
    // XSBI_DATA_PARALLEL - XSBI Parallel Interface Wire  
    //                      
    // (begin inline source)
    wire [15:0] XSBI_DATA_PARALLEL[2];
    // (end inline source)



    //------------------------------------------------------------------------------
    // 
    // Wires: 40G/100G BASE-R Parallel
    // 
    // 40G/100G BASE-R Parallel Interface Wire
    // 
    //------------------------------------------------------------------------------
    // pcs_baser_66b      - 40G/100G BASE-R Parallel Interface Wire 
    //                      
    // (begin inline source)
    wire [65:0] pcs_baser_66b[2][20];
    // (end inline source)



    //------------------------------------------------------------------------------
    // 
    // Wires: MDIO
    // 
    // MDIO Interface Wires
    // 
    //------------------------------------------------------------------------------
    // MDIO_OUT           - Management Interface Output Wire 
    //                      
    // MDIO_IN            - Management Interface Input Wire 
    //                      
    // (begin inline source)
    wire MDIO_OUT;
    wire MDIO_IN;
    // (end inline source)


    // Propagate global signals onto interface wires
    assign clk_0 = iclk_0;
    assign clk_1 = iclk_1;
    assign an_clk_0 = ian_clk_0;
    assign an_clk_1 = ian_clk_1;
    assign MDC = iMDC;
    assign reset = ireset;

endinterface


