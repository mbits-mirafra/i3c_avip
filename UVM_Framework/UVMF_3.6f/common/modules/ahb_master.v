//----------------------------------------------------------------------
////   Copyright 2013 Mentor Graphics Corporation
////   All Rights Reserved Worldwide
////
////   Licensed under the Apache License, Version 2.0 (the
////   "License"); you may not use this file except in
////   compliance with the License.  You may obtain a copy of
////   the License at
////
////       http://www.apache.org/licenses/LICENSE-2.0
////
////   Unless required by applicable law or agreed to in
////   writing, software distributed under the License is
////   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
////   CONDITIONS OF ANY KIND, either express or implied.  See
////   the License for the specific language governing
////   permissions and limitations under the License.
////----------------------------------------------------------------------
////----------------------------------------------------------------------

module ahb_verilog_master(
                            HCLK,
                            HRESETn,
                            HADDR,
                            HTRANS,
                            HWRITE,
                            HSIZE,
                            HWDATA,
                            HBURST,
                            HPROT,
                            HRDATA,
                            HREADY,
                            HRESP,
                            HGRANT,
                            HMASTLOCK,
                            HBUSREQ,
                            HLOCK
                          );
    
  parameter AHB_NUM_MASTERS = 1;
  parameter AHB_NUM_MASTER_BITS = 1;
  parameter AHB_NUM_SLAVES = 1;
  parameter AHB_ADDRESS_WIDTH = 32;
  parameter AHB_WDATA_WIDTH = 32;
  parameter AHB_RDATA_WIDTH = 32;
  parameter AHB_MASTER_INDEX = 0;
  parameter AGENT_NAME = "";

input                       HCLK;
input                       HRESETn;
input  [(AHB_RDATA_WIDTH-1):0]   HRDATA;
input                       HREADY;
input  [1:0]                HRESP;
input                       HGRANT;
input                       HMASTLOCK;
output                      HBUSREQ;
output                      HLOCK;
output [(AHB_ADDRESS_WIDTH-1):0] HADDR;
output [1:0]                HTRANS;
output                      HWRITE;
output [2:0]                HSIZE;
output [2:0]                HBURST;
output [3:0]                HPROT;
output [(AHB_WDATA_WIDTH-1):0]   HWDATA;

reg                         HBUSREQ=0;
reg                         HLOCK;
reg    [1:0]                HTRANS;
reg                         HWRITE;
reg    [2:0]                HSIZE;
reg    [2:0]                HBURST;
reg    [3:0]                HPROT;
reg    [(AHB_WDATA_WIDTH-1):0]   HWDATA;

reg [(AHB_WDATA_WIDTH-1):0] wdata_memory[0:1023];

integer i;

initial
begin
    HTRANS  = 2'b0;
    HWRITE  = 1'b1;
    HSIZE   = 2'b0;
    HBURST  = 3'b0;
    HPROT   = 4'b0;
    HWDATA  = 'b0;
    for(i=0;i<1024;i=i+1)
    begin
        wdata_memory[i] = i+1;
    end
end
integer count  = 0;
reg cntr_phase = 0;
reg sngl_tnfr  = 0;
reg idle_off   = 0;
reg burst_tnfr = 0;
reg sequential = 0;
reg [2:0]incr4 = 0;

reg [(AHB_ADDRESS_WIDTH-1):0] address = 0;

assign HADDR = address;

    always @(posedge HCLK)
    begin
        if(HRESETn == 1'b1)
        begin
            if(HREADY == 1'b1)
              count <= count + 1;
            if(count == 10)
            begin                     // do single transfers 
                idle_off <= 1'b1;
                sngl_tnfr  <= 1'b1;
            end                       
            if(count == 20)
            begin                     // do an idle cycle before burst
                idle_off <= 1'b0;
                sngl_tnfr  <= 1'b0;
            end
            if(count == 22)
            begin                     // do burst transfers
                idle_off <= 1'b1;
                burst_tnfr <= 1'b1;
                if(HREADY == 1'b1)
                    HWRITE     = ~HWRITE;
            end
            if(count == 30)
              count <= 0;
        end
    end

    always @(posedge HCLK)
    begin
        if(HRESETn == 1'b1 && idle_off == 1'b0)
        begin
            if(HREADY == 1'b1)
            begin
                HTRANS     <= 2'b0;
                HSIZE      <= 2'b0;
                HBURST     <= 3'b0;
                HPROT      <= 4'b0;
                HWDATA     <= 'b0;
                address    <= address % 1024;
                HBUSREQ    <= 1'b0;
                HLOCK      <= 1'b0;
            end
        end
    // SINGLE TRANSFERS
       else if((HRESETn == 1'b1) && (sngl_tnfr == 1'b1) && (burst_tnfr == 1'b0) && (HGRANT == 1'b1))
        begin
            if(HREADY == 1'b1)
            begin
                HTRANS       <= 2'b10;
                HWRITE       <= 1'b1;
                HSIZE        <= 2'b0;
                HBURST       <= 3'b0;
                HPROT        <= 4'b0;
                HWDATA       <= 'b0;
                HBUSREQ      <= 1'b1;
                HLOCK        <= 1'b1;
                address      <= (address + 10)  % 1024;
                cntr_phase   <= 1'b1;
            end    
        end    
    // BURST TRANSFERS
        else if((HRESETn == 1'b1) && (burst_tnfr == 1'b1) && (HGRANT == 1'b1))
        begin
            if(HREADY == 1'b1)
            begin
                if(incr4 < 2'b11)
                  incr4        <= incr4 + 1;
                if(sequential == 1'b0)
                begin
                    HTRANS       <= 2'b10;
                    HSIZE        <= 2'b0;
                    HBURST       <= 3'b011;
                    HPROT        <= 4'b0;
                    HWDATA       <= 'b0;
                    HBUSREQ      <= 1'b1;
                    HLOCK        <= 1'b1;
                    address      <= (((address + 15) % 1024) >= 4 ? (((address + 15) % 1024) - 4) : 100);
                    cntr_phase   <= 1'b1;
                    sngl_tnfr    <= 1'b0;
                    sequential   <= 1'b1;
                end
                else
                begin
                    HTRANS       <= 2'b11;
                    address      <= address + 1;
                end    
            end    
        end
        else if(HRESETn == 1'b0)
        begin
            HTRANS    <= 2'b0;
            HSIZE     <= 2'b0;
            HBURST    <= 3'b0;
            HPROT     <= 4'b0;
            HWDATA    <=  'b0;
            HBUSREQ   <= 1'b0;
            HLOCK     <= 1'b0;
            HWRITE    <= 1'b0;
            HLOCK     <= 1'b0;
            address   <=  'b0;
            burst_tnfr <= 1'b0;
            idle_off   <= 1'b0;
            sequential <= 1'b0;
            incr4      <= 2'b00;
        end
        if (((incr4 == 2'b11) || (HGRANT == 1'b0)) && (HREADY == 1'b1))
        begin
            burst_tnfr <= 1'b0;
            idle_off   <= 1'b0;
            sequential <= 1'b0;
            incr4      <= 2'b00;
        end
    // valid data will go 1 clk after address
        if(cntr_phase == 1'b1 && HREADY == 1'b1 && HWRITE == 1'b1)
        begin
            HWDATA <= wdata_memory[address];
        end    
    end
   
endmodule
