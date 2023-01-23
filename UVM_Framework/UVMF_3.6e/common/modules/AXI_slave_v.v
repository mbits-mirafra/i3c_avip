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

module AXI_slave_v(ACLK, ARESETn,
                        AWVALID, AWADDR, AWLEN, AWSIZE, AWBURST, AWLOCK, AWCACHE, AWPROT, AWID, AWREADY,
                        ARVALID, ARADDR, ARLEN, ARSIZE, ARBURST, ARLOCK, ARCACHE, ARPROT, ARID, ARREADY,
                        RVALID, RLAST, RDATA, RRESP, RID, RREADY,
                        WVALID, WLAST, WDATA, WSTRB, WID, WREADY,
                        BVALID, BRESP, BID, BREADY) ;

    parameter G_SLAVE_ADDR_SIZE   = 1024 ;
    parameter G_AXI_ADDRESS_WIDTH = 32 ;
    parameter G_AXI_RDATA_WIDTH   = 32 ;
    parameter G_AXI_WDATA_WIDTH   = 32 ;
    parameter G_AXI_WSTRB_WIDTH   = 4 ;
    parameter G_AXI_ID_WIDTH      = 2 ;
    parameter G_AXI_HOLD_TIME     = 1 ; // ns

    // System signals
    input ACLK ;
    input ARESETn ;

    // address channel signals
    input                           AWVALID ;
    input [G_AXI_ADDRESS_WIDTH-1:0] AWADDR ;
    input [3:0]                     AWLEN ;
    input [2:0]                     AWSIZE ;
    input [1:0]                     AWBURST ;
    input [1:0]                     AWLOCK ;
    input [3:0]                     AWCACHE ;
    input [2:0]                     AWPROT ;
    input [G_AXI_ID_WIDTH-1:0]      AWID ;
    output                          AWREADY ;

    input                           ARVALID ;
    input [G_AXI_ADDRESS_WIDTH-1:0] ARADDR ;
    input [3:0]                     ARLEN ;
    input [2:0]                     ARSIZE ;
    input [1:0]                     ARBURST ;
    input [1:0]                     ARLOCK ;
    input [3:0]                     ARCACHE ;
    input [2:0]                     ARPROT ;
    input [G_AXI_ID_WIDTH-1:0]      ARID ;
    output                          ARREADY ;

    // read channel signals
    output                          RVALID ;
    output                          RLAST ;
    output [G_AXI_RDATA_WIDTH-1:0]  RDATA ;
    output [1:0]                    RRESP ;
    output [G_AXI_ID_WIDTH-1:0]     RID ;
    input                           RREADY ;

    // write channel signals
    input                           WVALID ;
    input                           WLAST ;
    input [G_AXI_WDATA_WIDTH-1:0]   WDATA ;
    input [G_AXI_WSTRB_WIDTH-1:0]   WSTRB ;
    input [G_AXI_ID_WIDTH-1:0]      WID ;
    output                          WREADY ;

    // write response channel signals
    output                          BVALID ;
    output [1:0]                    BRESP ;
    output [G_AXI_ID_WIDTH-1:0]     BID ;
    input                           BREADY ;

    // ---------------
    // input registers
    // ---------------

    // address channels
    reg                             AWVALID_reg ;
    reg [G_AXI_ADDRESS_WIDTH-1:0]   AWADDR_reg ;
    reg [3:0]                       AWLEN_reg ;
    reg [2:0]                       AWSIZE_reg ;
    reg [1:0]                       AWBURST_reg ;
    reg [1:0]                       AWLOCK_reg ;
    reg [3:0]                       AWCACHE_reg ;
    reg [2:0]                       AWPROT_reg ;
    reg [G_AXI_ID_WIDTH-1:0]        AWID_reg ;

    reg                             ARVALID_reg ;
    reg [G_AXI_ADDRESS_WIDTH-1:0]   ARADDR_reg ;
    reg [3:0]                       ARLEN_reg ;
    reg [2:0]                       ARSIZE_reg ;
    reg [1:0]                       ARBURST_reg ;
    reg [1:0]                       ARLOCK_reg ;
    reg [3:0]                       ARCACHE_reg ;
    reg [2:0]                       ARPROT_reg ;
    reg [G_AXI_ID_WIDTH-1:0]        ARID_reg ;

    // read channel
    reg                             RREADY_reg ;

    // write channel
    reg                             WVALID_reg ;
    reg                             WLAST_reg ;
    reg [G_AXI_WDATA_WIDTH-1:0]     WDATA_reg ;
    reg [G_AXI_WSTRB_WIDTH-1:0]     WSTRB_reg ;
    reg [G_AXI_ID_WIDTH-1:0]        WID_reg ;

    // write response channel
    reg                             BREADY_reg ;

    // ----------------
    // output registers
    // ----------------

    reg                         RVALID;
    reg [G_AXI_RDATA_WIDTH-1:0] RDATA;
    reg                         RLAST;
    reg [G_AXI_ID_WIDTH-1:0]    RID;
    reg [1:0]                   RRESP;

    reg                         BVALID;
    reg [G_AXI_ID_WIDTH-1:0]    BID;
    reg [1:0]                   BRESP;

    reg                         WREADY ;

    reg                         RVALID_reg ;
    reg [G_AXI_ID_WIDTH-1:0]    RID_reg ;

    reg                         BVALID_reg ;
    reg [G_AXI_ID_WIDTH-1:0]    BID_reg ;

    // declare the memory array
    reg [31:0] ram[1023:0] ;

    // State variables for state machine
    integer write_states[3:0];
    integer read_states[3:0];
    integer write_addr[3:0];
    integer write_count[3:0];
    integer write_count_first[3:0];
    integer read_count_first[3:0];
    integer incr;
    integer incr_read;
    integer write_count_incr[3:0];
    integer read_count_incr[3:0];
    integer read_addr[3:0];
    integer read_count[3:0];
    integer read_length[3:0];
    integer read_length_sent[3:0];
    integer mem_loop;
    reg [2:0]     ARSIZE_reg_val;
    reg [2:0]     AWSIZE_reg_val;

    // Output assignments

    assign  AWREADY = 1 ;
    assign  ARREADY = 1 ;

    always @(posedge ACLK or negedge ARESETn)
    begin
        if (!ARESETn)
        begin
            AWVALID_reg <= 0 ;
            AWADDR_reg  <= 0 ;
            AWLEN_reg   <= 0 ;
            AWSIZE_reg  <= 0 ;
            AWBURST_reg <= 0 ;
            AWLOCK_reg  <= 0 ;
            AWCACHE_reg <= 0 ;
            AWPROT_reg  <= 0 ;
            AWID_reg    <= 0 ;

            ARVALID_reg <= 0 ;
            ARADDR_reg  <= 0 ;
            ARLEN_reg   <= 0 ;
            ARSIZE_reg  <= 0 ;
            ARBURST_reg <= 0 ;
            ARLOCK_reg  <= 0 ;
            ARCACHE_reg <= 0 ;
            ARPROT_reg  <= 0 ;
            ARID_reg    <= 0 ;

            RREADY_reg  <= 0 ;
            RVALID_reg  <= 0;
            RID_reg     <= 0;

            WVALID_reg  <= 0 ;
            WLAST_reg   <= 0 ;
            WDATA_reg   <= 0 ;
            WSTRB_reg   <= 0 ;
            WID_reg     <= 0 ;

            BREADY_reg  <= 0;
            BVALID_reg  <= 0;
            BID_reg     <= 0;
            WREADY      <= 0;

            write_states[0] <= 0;
            read_states[0]  <= 0;
            write_states[1] <= 0;
            read_states[1]  <= 0;
            write_states[2] <= 0;
            read_states[2]  <= 0;
            write_states[3] <= 0;
            read_states[3]  <= 0;

            for (mem_loop=0;mem_loop<1024;mem_loop=mem_loop+1) ram[mem_loop] <= 'b0;
        end
        else
        begin : state_machine
            integer     i,j;

            // Register inputs and previous outputs
            AWVALID_reg <= AWVALID ;
            AWADDR_reg  <= AWADDR ;
            AWLEN_reg   <= AWLEN ;
            AWSIZE_reg  <= AWSIZE ;
            AWBURST_reg <= AWBURST ;
            AWLOCK_reg  <= AWLOCK ;
            AWCACHE_reg <= AWCACHE ;
            AWPROT_reg  <= AWPROT ;
            AWID_reg    <= AWID ;

            ARVALID_reg <= ARVALID ;
            ARADDR_reg  <= ARADDR ;
            ARLEN_reg   <= ARLEN ;
            ARSIZE_reg  <= ARSIZE ;
            ARBURST_reg <= ARBURST ;
            ARLOCK_reg  <= ARLOCK ;
            ARCACHE_reg <= ARCACHE ;
            ARPROT_reg  <= ARPROT ;
            ARID_reg    <= ARID ;

            RREADY_reg  <= RREADY ;
            RVALID_reg  <= RVALID;
            RID_reg     <= RID;

            WVALID_reg  <= WVALID ;
            WLAST_reg   <= WLAST ;
            WDATA_reg   <= WDATA ;
            WSTRB_reg   <= WSTRB ;
            WID_reg     <= WID ;

            BREADY_reg  <= BREADY;
            BVALID_reg  <= BVALID;
            BID_reg     <= BID;
           for (i=0;i<4;i=i+1)
             begin: id_for_loop
                case (write_states[i])
                  0: begin    // Wait for write address
                     if ((AWVALID==1) && (AWREADY==1) && (AWID==i))
                       begin
                          write_addr[i]   <= AWADDR;

                          write_count[i]  <= 0;
                          write_count_incr[i]  <= 0;
                          write_count_first[i]  <= 1;
                          write_states[i] <= 1;
                          AWSIZE_reg_val <= AWSIZE;
                          WREADY <= 1;
                       end
                  end
                  1: begin    // Wait for write data
                     if ((WVALID==1) && (WREADY==1) && (WID==i))
                       begin
                          // Set the data in the RAM
                          for (j=0; j<4; j=j+1)
                            begin
                               if (WSTRB[j] == 1'b1)
                                 ram[(write_addr[i]>>2)+write_count[i]][((j+1)*8)-1 -: 8] <= WDATA[((j+1)*8)-1 -: 8];
                            end
                          if (WLAST==1)
                            begin
                               write_states[i] <= 2;
                               WREADY <= 0;
                            end
                          else
                            begin
                               // write_count[i]  <= write_count[i]+1;
                               // write_count_incr[i]  <= write_count_incr[i]+1;
                               incr =(AWSIZE_reg_val==3'b00)?3:(AWSIZE_reg_val==3'b01)?1:0;
                               if(write_count_first[i]==1)
                                 begin
                                    if( (write_count_incr[i] + (write_addr[i] % 4))>= incr)
                                      begin
                                         write_count[i]  <= write_count[i]+1;
                                         write_count_incr[i]  <= 0;
                                         write_count_first[i]<=0;
                                      end
                                    else
                                      write_count_incr[i]  <= write_count_incr[i]+1;
                                 end // if (write_count_first[i]==1)
                               else
                                 begin
                                    if(write_count_incr[i]>= incr)
                                      begin
                                         write_count[i]  <= write_count[i]+1;
                                         write_count_incr[i]  <= 0;
                                      end
                                    else
                                      write_count_incr[i]  <= write_count_incr[i]+1;
                                 end // else: !if(write_count_first[i]==1)
                            end // else: !if(WLAST==1)
                       end // if ((WVALID==1) && (WREADY==1) && (WID==i))
                  end // case: 1

                  2: begin    // Write response state
                     if ((BVALID==1) && (BREADY==1) && (BID==i))
                       begin
                          write_states[i]     <= 0;
                       end
                  end
                endcase // write
                case (read_states[i])
                  0: begin    // Wait for read address
                     if ((ARVALID==1) && (ARREADY==1) && (ARID==i))
                       begin
                          read_addr[i]    <= ARADDR;
                          read_length[i]  <= ARLEN;
                          read_length_sent[i]  <= 0;
                          read_count[i]   <= 0;

                          read_states[i]  <= 1;
                          read_count_incr[i]  <= 0;
                          read_count_first[i]  <= 1;
                          ARSIZE_reg_val <= ARSIZE;

                       end
                  end
                  1: begin    // Read data state
                     if ((RVALID==1) && (RREADY==1) && (RID==i))
                       begin
                          read_length_sent[i]  <= read_length_sent[i] + 1;
                          if (RLAST==1)
                            begin
                               read_states[i]  <= 0;
                            end
                          else
                            begin
                               incr_read =(ARSIZE_reg_val==3'b00)?3:(ARSIZE_reg_val==3'b01)?1:0;
                               if(read_count_first[i]==1)
                                 begin
                                    if( (read_count_incr[i] + (read_addr[i] % 4))>= incr)
                                      begin
                                         read_count[i]  <= read_count[i]+1;
                                         read_count_incr[i]  <= 0;
                                         read_count_first[i]<=0;
                                      end
                                    else
                                      read_count_incr[i]  <= read_count_incr[i]+1;
                                 end // if (read_count_first[i]==1)
                               else
                                 begin
                                    if(read_count_incr[i]>= incr)
                                      begin
                                         read_count[i]  <= read_count[i]+1;
                                         read_count_incr[i]  <= 0;
                                      end
                                    else
                                      read_count_incr[i]  <= read_count_incr[i]+1;
                                 end // else: !if(read_count_first[i]==1)
                          //     read_count[i]   <= read_count[i]+1;
                            end // else: !if(read_count[i]==read_length[i])
                       end
                  end
                endcase // read
             end // id_for_loop
        end
    end

    // Output signals are set using the state which an id is in
   // For each channel we find  the next id that wants servicing by starting
    // at the one last used and cycling round looking for the next one in
    // the appropriate state. Note this relies on wrapping of id round the
    // 4 possibilities used.

    always @(*)
    begin : output_drivers

        reg [1:0] id;

        // Read data

        RVALID  = 0;
        RDATA   = 0;
        RLAST   = 0;
        RID     = 0;
        RRESP   = 0;
        if ((RREADY_reg==1) || (RVALID_reg==0)) // Previous one accepted or no pevious one
        begin
            id  = RID_reg+1;
            if ((id!=RID_reg) && (read_states[id]!=1))
            begin
                id  = id+1;
                if ((id!=RID_reg) && (read_states[id]!=1))
                begin
                    id  = id+1;
                    if ((id!=RID_reg) && (read_states[id]!=1))
                    begin
                        id  = id+1;
                    end
                end
            end
           if(read_count_incr[id])
           begin
           end
            if (read_states[id]==1) // Read data to go
            begin
               RVALID  = 1;
               RDATA   = ram[(read_addr[id]>>2)+read_count[id]];
               RLAST   = (read_length_sent[id]>=read_length[id])?1:0;
               RRESP   = 0;
               RID     = id;
            end
        end

        // Write response

        BVALID  = 0;
        BID     = 0;
        BRESP   = 0;

        if ((BREADY_reg==1) || (BVALID_reg==0)) // Previous one accepted or no pevious one
        begin
            id  = BID_reg+1;
            if ((id!=BID_reg) && (write_states[id]!=2))
            begin
                id  = id+1;
                if ((id!=BID_reg) && (write_states[id]!=2))
                begin
                    id  = id+1;
                    if ((id!=BID_reg) && (write_states[id]!=2))
                    begin
                        id  = id+1;
                    end
                end
            end

            if (write_states[id]==2)    // Write response to go
            begin
                BVALID  = 1;
                BID     = id;
                BRESP   = 0;
            end
        end
    end

endmodule


