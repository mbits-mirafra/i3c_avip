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

//`define SLAVE_DEBUG_MEMORY

module ahb_verilog_target(
        HCLK,   
        HRESETn,
        HADDR,  
        HTRANS, 
        HWRITE, 
        HSIZE,
        HWDATA, 
        HBURST, 
        HRDATA, 
        HSEL,   
        HREADYi,
        HREADYo,
        HRESP,
        HSPLIT
) ;
    
  parameter AHB_NUM_MASTERS     = 1;
  parameter AHB_NUM_MASTER_BITS = 1;
  parameter AHB_NUM_SLAVES      = 1;
  parameter AHB_ADDRESS_WIDTH   = 32;
  parameter AHB_WDATA_WIDTH     = 32;
  parameter AHB_RDATA_WIDTH     = 32;
  parameter AHB_SLAVE_INDEX     = 0;

input                        HCLK;
input                        HRESETn;
input  [(AHB_ADDRESS_WIDTH-1):0]  HADDR;
input  [1:0]                 HTRANS;
input                        HWRITE;
input  [2:0]                 HSIZE;
input                        HSEL;
  input  [2:0]                     HBURST;
input  [(AHB_RDATA_WIDTH-1):0]    HWDATA;
input                             HREADYi;
output [(AHB_RDATA_WIDTH-1):0]    HRDATA;
output                           HREADYo;
output [1:0]                     HRESP;
output [(AHB_NUM_MASTERS - 1):0] HSPLIT;

reg [7:0] data_memory[4095:0];

reg [(AHB_RDATA_WIDTH-1):0]   HRDATA  ;
reg                      HREADYo ;
reg [1:0]                HRESP   ;
reg [(AHB_ADDRESS_WIDTH-1):0] temp_addr;

reg [(AHB_RDATA_WIDTH-1):0]  rdata_out;
integer                 bytes_per_transfer;

integer i;
integer init_index;

assign HSPLIT = {AHB_NUM_MASTERS{1'b0}};

initial
begin
  HRDATA   = 0;
  HREADYo  = 0;
  HRESP    = 0;
  for(init_index=0;init_index<4096;init_index=init_index+1)
    data_memory[init_index] = init_index;
end

integer count =0;
reg wait_state_1 = 0;
reg wait_state_2 = 0;
reg temp_write = 0;

    always @(posedge HCLK)
    begin
        if(HRESETn == 1'b1)
        begin
            if(HSEL && HREADYi)
            begin
                if(HTRANS[1] == 1)
                begin
                    temp_write <= HWRITE;
                    bytes_per_transfer <= (1 << HSIZE);
                end
                else
                begin
                    temp_write <= 1'b0;
                end

                if(HTRANS == 2'b00)
                    count = 0;                
                if(HTRANS == 2'b11)
                begin
                    if(count == 5)
                    begin
                        HREADYo <= 1'b0;
                        wait_state_1 <= 1'b1;
                    end    
                    else  
                        HREADYo <= 1'b1;
                    count = ( count == 10) ? 0 : count+1;
                    HRESP <= 2'b00;
                end
                else
                begin
                    HREADYo <= 1'b1;
                    HRESP <= 2'b00;
                end    
                temp_addr <= HADDR % (1024 * (AHB_SLAVE_INDEX + 1));
            end
            else
            begin
                HREADYo <= 1'b1;
                HRESP <= 2'b00;
                temp_write <= 1'b0;
            end
        end
        else
        begin
            HREADYo    <= 1'b1;
            HRESP      <= 2'b00;
            temp_addr  <= 'b0;
            count       = 0;
            temp_write <= 1'b0;
        end
    end

    // valid data will come 1 clk after valid address
    always @(posedge HCLK)
    begin
        if(HRESETn == 1'b1)
        begin
            if(temp_write == 1'b1)
            begin
                for (i=0; i<bytes_per_transfer; i=i+1)
                begin
                  data_memory[(temp_addr[11:0] + i)]= HWDATA[((i + (temp_addr[11:0]%(AHB_WDATA_WIDTH/8)))*8)+7 -:8];
`ifdef SLAVE_DEBUG_MEMORY
                    $display("%d Writing to data_memory[%h] = %h", $time, temp_addr[11:0] + i, data_memory[(temp_addr[11:0] + i)]);
`endif
                end
            end

            if((HWRITE == 1'b0) && (HSEL && HREADYi) && (HTRANS[1] == 1))
            begin
                temp_addr = HADDR % (1024 * (AHB_SLAVE_INDEX + 1));
                rdata_out= 0;
                for (i=0; i<(1 << HSIZE); i=i+1)
                begin
                    rdata_out[((i + (temp_addr[11:0]%(AHB_WDATA_WIDTH/8)))*8)+7 -:8]= data_memory[(temp_addr[11:0] + i)];
`ifdef SLAVE_DEBUG_MEMORY
                    $display("%d Reading from data_memory[%h] = %h", $time, temp_addr[11:0] + i, data_memory[temp_addr[11:0] + i]);
`endif
                end
                HRDATA= rdata_out;
            end
        end
    end
    always @(posedge HCLK)
    begin
        if(HRESETn == 1'b1)
        begin
           if(wait_state_1 == 1'b1)
           begin
               wait_state_1 <= 1'b0;
               wait_state_2 <= 1'b1;
           end
           if(wait_state_2 == 1'b1)
           begin
               wait_state_2 <= 1'b0;
           end
        end
    end

endmodule
