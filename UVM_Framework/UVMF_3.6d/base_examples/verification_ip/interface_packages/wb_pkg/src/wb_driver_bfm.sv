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
// Unit            : Driver Bus Functional Model
// File            : wb_driver_bfm.sv
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This interface performs the wb signal driving.  It is
//     accessed by the uvm wb driver through a virtual interface 
//     handle in the wb configuration.  It drives the singals passed
//     in through the port connection named bus of type wb_if.
//
//     Input signals from the wb_if are assigned to an internal input 
//     signal with a _i suffix.  The _i signal should be used for sampling.
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i 
//
//     This bfm drives signals with a _o suffix.  These signals
//     are driven onto signals within wb_if based on MASTER/SLAVE and/or
//     ARBITRATION/GRANT status.  The _o signal should be assigned by 
//     tasks or functions.
//
//     The output signal connections are as follows:
//        signal_o -> bus.signal
//
//      Interface functions and tasks used by UVM components:
//             configure(uvmf_master_slave_t mst_slv);
//                   This function gets configuration attributes from the 
//                   UVM driver to set any required BFM configuration  
//                   variables such as 'master_slave'.
//
//             reset();
//                   This task performs a reset operation on the wishbone bus.
//
//             write(input bit[WB_ADDR_WIDTH-1:0] addr, 
//                   input bit[WB_DATA_WIDTH-1:0] data /*, input int delay*/);
//                   This task performs a write operation on the wishbone bus.
//   
//             read(input  bit[WB_ADDR_WIDTH-1:0] addr, 
//                  output bit[WB_DATA_WIDTH-1:0] data /*, input int delay*/);
//                   This task performs a read operation on the wishbone bus.
//
//             slave(output wb_op_t op, 
//                   output bit[WB_ADDR_WIDTH-1:0] addr, 
//                   output bit[WB_DATA_WIDTH-1:0] data);
//                   This task performs a slave operation on the wishbone bus.
//   
//----------------------------------------------------------------------
//

import uvmf_base_pkg_hdl::*;
import wb_pkg_hdl::*;

interface wb_driver_bfm (wb_if bus);
// pragma attribute wb_driver_bfm partition_interface_xif

tri                  clk_i;
tri                  rst_i;
tri [WB_ADDR_WIDTH-1:0]  adr_i;
tri [WB_DATA_WIDTH-1:0]  dout_i;
tri                  cyc_i;
tri                  stb_i;
tri                  we_i;
tri [WB_DATA_WIDTH/8-1:0]  sel_i;
tri [WB_DATA_WIDTH-1:0]  q_i;

tri                 ack_i;
tri                 err_i;
tri                 rty_i;
tri                inta_i;
tri [WB_DATA_WIDTH-1:0] din_i;

bit                  clk_o;
bit                  rst_o;
reg [WB_ADDR_WIDTH-1:0]  adr_o;
reg [WB_DATA_WIDTH-1:0]  dout_o;
bit                  cyc_o;
bit                  stb_o;
bit                  we_o;
bit [WB_DATA_WIDTH/8-1:0]  sel_o;
reg [WB_DATA_WIDTH-1:0]  q_o;

bit                 ack_o;
bit                 err_o;
bit                 rty_o;
bit                inta_o;
reg [WB_DATA_WIDTH-1:0] din_o;

uvmf_master_slave_t master_slave;

// Master connections
assign bus.clk  = (master_slave == MASTER)?  clk_o:'bz;
assign bus.rst  = (master_slave == MASTER)?  rst_o:'bz;
assign bus.adr  = (master_slave == MASTER)?  adr_o:'bz;
assign bus.dout = (master_slave == MASTER)?  dout_o:'bz;
assign bus.cyc  = (master_slave == MASTER)?  cyc_o:'bz;
assign bus.stb  = (master_slave == MASTER)?  stb_o:'bz;
assign bus.we   = (master_slave == MASTER)?  we_o:'bz;
assign bus.sel  = (master_slave == MASTER)?  sel_o:'bz;
assign bus.q    = (master_slave == MASTER)?  q_o:'bz;

assign ack_i    =                          bus.ack;
assign err_i    =                          bus.err;
assign rty_i    =                          bus.rty;
assign inta_i    =                          bus.inta;
assign din_i    =                          bus.din;

// Slave connections
assign clk_i       =                           bus.clk;
assign rst_i       =                           bus.rst;
assign adr_i       =                           bus.adr;
assign dout_i      =                           bus.dout;
assign cyc_i       =                           bus.cyc;
assign stb_i       =                           bus.stb;
assign we_i        =                           bus.we;
assign sel_i        =                           bus.sel;
assign q_i        =                           bus.q;

assign bus.ack    = (master_slave == SLAVE)?  ack_o:'bz;
assign bus.din    = (master_slave == SLAVE)?  din_o:'bz;
assign bus.err    = (master_slave == SLAVE)?  err_o:'bz;
assign bus.rty    = (master_slave == SLAVE)?  rty_o:'bz;
assign bus.inta    = (master_slave == SLAVE)? inta_o:'bz;


// tbx clkgen
initial begin
   clk_o = 0; 
   forever #5 clk_o = ~clk_o;
end

//******************************************************************
  function void configure(uvmf_master_slave_t mst_slv); // pragma tbx xtf
     master_slave = mst_slv;
  endfunction


//******************************************************************
  task reset(); // pragma tbx xtf
     @(posedge clk_i);
     rst_o = 1;
     @(posedge clk_i);
     rst_o = 0;
     repeat (3) @(posedge clk_i);
     rst_o = 1;
  endtask :reset

//******************************************************************
  task write(bit[WB_ADDR_WIDTH-1:0] addr, bit[WB_DATA_WIDTH-1:0] data /*, int delay*/); // pragma tbx xtf
     // wait initial delay
     @(posedge clk_i);

     // assert wishbone signal
     adr_o  <= addr;
     dout_o <= data;
     cyc_o  <= 1'b1;
     stb_o  <= 1'b1;
     we_o   <= 1'b1;
     sel_o  <= '1;
     // @(posedge clk_i);

     // wait for acknowledge from slave
     while(!ack_i) @(posedge clk_i);

     // negate wishbone signals
     cyc_o  <= 1'b0;
     stb_o  <= 1'b0;
     adr_o  <= 'bx;
     dout_o <= 'bx;
     we_o   <= 1'b0;
     sel_o  <= 1'b0;

     @(posedge clk_i);
     @(posedge clk_i);
  endtask

//******************************************************************
  task read(bit[WB_ADDR_WIDTH-1:0] addr, output bit[WB_DATA_WIDTH-1:0] data ); // pragma tbx xtf
     // wait initial delay
     @(posedge clk_i);

     // assert wishbone signals
     adr_o  <= addr;
     dout_o <= 'x;
     cyc_o  <= 1'b1;
     stb_o  <= 1'b1;
     we_o   <= 1'b0;
     sel_o  <= '1;
     @(posedge clk_i);

     // wait for acknowledge from slave
     while(!ack_i) @(posedge clk_i);

     // negate wishbone signals
     cyc_o  <= 1'b0;
     stb_o  <= 1'b0;
     adr_o  <= 'bx;
     dout_o <= 'bx;
     we_o   <= 1'h0;
     sel_o  <= 1'b0;
     data= din_i;
  endtask

//******************************************************************
  // Writes with 2 callees (slave(...),                   slave_complete()); 
  // Reads  with 3 callees (slave(...), slave_read_ack(), slave_complete()):
  task slave(output wb_op_t op, output bit[WB_ADDR_WIDTH-1:0] addr, output bit[WB_DATA_WIDTH-1:0] data); // pragma tbx xtf
     @(posedge clk_i);
     while(!cyc_i && !stb_i) @(posedge clk_i);
     addr = adr_i;
     data = dout_i;
     if (we_i) begin
        op = WB_WRITE;
        ack_o <= 1'b1; // Can ack immediately
        //Await slave_complete() invocation from TB
     end
     else begin
        op = WB_READ;
        //... await slave_read_ack() & slave_complete() invocation from TB
     end
  endtask

  function void slave_read_ack(bit [WB_DATA_WIDTH-1:0] data); // pragma tbx xtf
     din_o <= data;
     ack_o <= 1'b1;
  endfunction

  task slave_complete(); // pragma tbx xtf
     @(posedge clk_i);
     do_slave_complete();
  endtask

  task do_slave_complete();
     ack_o <= 1'b0;
     din_o <= 'bx;
     do @(posedge clk_i); while(cyc_i || stb_i);
  endtask

//******************************************************************
/* Do we care about exact cycle at which slave_op_started is triggered for writes? 
   If not can treat writes separately in one go, saving 1 callee (slave_complete()) - test indeed still runs fine
   In fact, do we even care about this for reads, and do we really need to wait for slave_op_completed?
   If not can treat reads also separately in one go, saving 2 callees (slave_read_ack(), slave_complete()) - test indeed still runs fine

   That is, these work too:

  // Writes with 1 callee (slave(...)); 
  // Reads with 3 callees (slave(...), slave_read_ack(), slave_complete()) :
  task slave(output wb_op_t op, 
             output bit[WB_ADDR_WIDTH-1:0] addr, 
             output bit[WB_DATA_WIDTH-1:0] data); // pragma tbx xtf
     @(posedge clk_i);
     while(!cyc_i && !stb_i) @(posedge clk_i);
     addr = adr_i;
     data = dout_i;
     if (we_i) begin
        op = WB_WRITE;
        ack_o <= 1'b1;
        @(posedge clk_i);
        do_slave_complete();
     end
     else begin
        op = WB_READ;
        //... await explicit slave_read_ack() & slave_complete() invocation from TB
     end
  endtask

  // Both writes and reads with 1 callee (slave(...)) :
  task slave(output wb_op_t op, 
             output bit[WB_ADDR_WIDTH-1:0] addr, 
             output bit[WB_DATA_WIDTH-1:0] data); // pragma tbx xtf
     @(posedge clk_i);
     while(!cyc_i && !stb_i) @(posedge clk_i);
     addr = adr_i;
     data = dout_i;
     if (we_i) begin
        op = WB_WRITE;
     end
     else begin
        op = WB_READ;
        din_o <= data;
     end
     ack_o <= 1'b1;
     @(posedge clk_i);
     do_slave_complete();
  endtask
*/

endinterface
