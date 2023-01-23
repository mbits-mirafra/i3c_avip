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
// Unit            : Driver Bus Functional Model
// File            : ahb_driver_bfm.sv
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This interface performs the AHB signal driving.  It is
//     accessed by the uvm ahb driver through a virtual interface
//     handle in the ahb configuration.  It drives the singals passed
//     in through the port connection named bus of type ahb_if.
//
//     Input signals from the ahb_if are assigned to an internal input
//     signal with a _i suffix.  The _i signal should be used for sampling.
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i 
//
//     This bfm drives signals with a _o suffix.  These signals
//     are driven onto signals within ahb_if based on MASTER/SLAVE and/or
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
//             assert_hresetn();
//                   This task performs a reset operation on the AHB bus.
//
//             write(input bit [AHB_ADDR_WIDTH-1:0] addr, 
//                   input bit [AHB_DATA_WIDTH-1:0] data);
//                   This task performs a write operation on the AHB bus.
//
//             read(input bit [AHB_ADDR_WIDTH-1:0] addr, 
//                  output bit [AHB_DATA_WIDTH-1:0] data);
//                   This task performs a read operation on the AHB bus.
//
//             access(input ahb_op_t op,
//                    input bit [AHB_ADDR_WIDTH-1:0] addr, 
//                    input bit [AHB_DATA_WIDTH-1:0] wr_data, 
//                    output bit [AHB_DATA_WIDTH-1:0] rd_data);
//                   This task receives transaction attributes from the
//                   UVM driver and then executes the corresponding
//                   bus operation on the AHB bus. The bus operation is
//                   one of reset/write/read, which can also be invoked
//                   explicitly using the respective individual tasks above.
//
//----------------------------------------------------------------------

import uvmf_base_pkg_hdl::*;
import ahb_pkg_hdl::*;

interface ahb_driver_bfm(ahb_if bus);
// pragma attribute ahb_driver_bfm partition_interface_xif

   tri                         hclk_i;
   tri                         hresetn_i;
   tri   [AHB_ADDR_WIDTH-1:0] haddr_i;
   tri   [AHB_DATA_WIDTH-1:0] hwdata_i;
   tri   [1:0]                 htrans_i;
   tri   [2:0]                 hburst_i;
   tri   [2:0]                 hsize_i;
   tri                         hwrite_i;
   tri                         hsel_i;
   tri                         hready_i;
   tri   [AHB_DATA_WIDTH-1:0] hrdata_i;
   tri   [1:0]                 hresp_i;


   bit                hclk_o;
   bit                hresetn_o;
   logic [AHB_ADDR_WIDTH-1:0] haddr_o;
   logic [AHB_DATA_WIDTH-1:0] hwdata_o;
   bit   [1:0]        htrans_o;
   bit   [2:0]        hburst_o;
   bit   [2:0]        hsize_o;
   bit                hwrite_o;
   bit                hsel_o;
   bit                 hready_o;
   bit   [AHB_DATA_WIDTH-1:0]  hrdata_o;
   bit   [1:0]         hresp_o;

   uvmf_master_slave_t master_slave;

   // Master connections
   assign bus.hclk     = (master_slave == MASTER)?     hclk_o:'bz;
   assign bus.hresetn  = (master_slave == MASTER)?     hresetn_o:'bz;
   assign bus.haddr    = (master_slave == MASTER)?     haddr_o:'bz;
   assign bus.hwdata   = (master_slave == MASTER)?     hwdata_o:'bz;
   assign bus.htrans   = (master_slave == MASTER)?     htrans_o:'bz;
   assign bus.hburst   = (master_slave == MASTER)?     hburst_o:'bz;
   assign bus.hsize    = (master_slave == MASTER)?     hsize_o:'bz;
   assign bus.hwrite   = (master_slave == MASTER)?     hwrite_o:'bz;
   assign bus.hsel     = (master_slave == MASTER)?     hsel_o:'bz;
   assign     hready_i =                           bus.hready;
   assign     hrdata_i =                           bus.hrdata;
   assign     hresp_i  =                           bus.hresp;

   // Slave connections
   assign     hclk_i    =                           bus.hclk;
   assign     hresetn_i =                           bus.hresetn;
   assign     haddr_i   =                           bus.haddr;
   assign     hwdata_i  =                           bus.hwdata;
   assign     htrans_i  =                           bus.htrans;
   assign     hburst_i  =                           bus.hburst;
   assign     hsize_i   =                           bus.hsize;
   assign     hwrite_i  =                           bus.hwrite;
   assign     hsel_i    =                           bus.hsel;
   assign bus.hready    = (master_slave == SLAVE)?      hready_o:'bz;
   assign bus.hrdata    = (master_slave == SLAVE)?      hrdata_o:'bz;
   assign bus.hresp     = (master_slave == SLAVE)?      hresp_o:'bz;


// ****************************************************************************
   // tbx clkgen
   initial begin
      hclk_o = 0;
      #5ns;
      forever #10ns hclk_o = ~hclk_o;
   end

//******************************************************************
   function void configure(uvmf_master_slave_t mst_slv); // pragma tbx xtf
      master_slave = mst_slv;
   endfunction

   //Alternative: using a packed struct argument instead, requiring (possibly 
   //less efficient) class-struct conversion methods (see ahb_driver_bfm_api.svh)
   //function void configure(ahb_configuration_s cfg); // pragma tbx xtf
   //   master_slave = cfg.master_slave;
   //endfunction

// ****************************************************************************
   task assert_hresetn(); // pragma tbx xtf
      @(posedge hclk_i);
      do_assert_hresetn();
   endtask

// ****************************************************************************
   task write(input bit [AHB_ADDR_WIDTH-1:0] addr, 
              input bit [AHB_DATA_WIDTH-1:0] data); // pragma tbx xtf
      @(posedge hclk_i);
      do_write(addr, data);
   endtask

// ****************************************************************************
   task read(input bit [AHB_ADDR_WIDTH-1:0] addr, 
             output bit [AHB_DATA_WIDTH-1:0] data); // pragma tbx xtf
      @(posedge hclk_i);
      do_read(addr, data);
   endtask

// ****************************************************************************
  task access(input ahb_op_t op,
              input bit [AHB_ADDR_WIDTH-1:0] addr, 
              input bit [AHB_DATA_WIDTH-1:0] wr_data, 
              output bit [AHB_DATA_WIDTH-1:0] rd_data); // pragma tbx xtf
      @(posedge hclk_i);
      case (op)
        AHB_WRITE: do_write(addr, wr_data);
        AHB_READ:  do_read(addr, rd_data);
        AHB_RESET: do_assert_hresetn();
      endcase
  endtask

  //Alternative: using a packed struct argument instead, requiring (possibly less efficient)
  //class-struct conversion methods (see ahb_driver_bfm_api.svh)
  //task access(input ahb_transaction_s txn, 
  //            output bit [AHB_DATA_WIDTH-1:0] rd_data); // pragma tbx xtf
  //    @(posedge hclk_i);
  //    case (txn.op)
  //      AHB_WRITE: do_write(txn.addr, txn.data);
  //      AHB_READ:  do_read(txn.addr, rd_data);
  //      AHB_RESET: do_assert_hresetn();
  //    endcase
  //endtask

// ****************************************************************************
   task do_assert_hresetn();
        hresetn_o <= 1'b0;
        repeat (10) @(posedge hclk_i);
        hresetn_o <= 1'b1;
        repeat (5) @(posedge hclk_i);
   endtask

// ****************************************************************************
   task do_write(input bit [AHB_ADDR_WIDTH-1:0] addr, 
                 input bit [AHB_DATA_WIDTH-1:0] data);
      // Address Phase
          haddr_o <= addr;
          hwdata_o <= data;
          htrans_o <= 2'b10;
          hburst_o <= 3'b000;
          hsize_o <= 3'b000;
          hwrite_o <= 1'b1;
          hsel_o <= 1'b1;

      // Data Phase
      do @(posedge hclk_i) ; while ( hready_i == 1'b0 );
          haddr_o <= 'bx;
          hwdata_o <= 'bx;
          htrans_o <= 2'b00;
          hburst_o <= 3'b000;
          hsize_o <= 3'b000;
          hwrite_o <= 1'b0;
          hsel_o <= 1'b0;
   endtask

// ****************************************************************************
   task do_read(input bit [AHB_ADDR_WIDTH-1:0] addr, 
                output bit [AHB_DATA_WIDTH-1:0] data);
      // Address Phase
          haddr_o <= addr;
          htrans_o <= 2'b10;
          hburst_o <= 3'b000;
          hsize_o <= 3'b000;
          hwrite_o <= 1'b0;
          hsel_o <= 1'b1;

      // Data Phase
      @(posedge hclk_i);
      do @(posedge hclk_i); while ( hready_i == 1'b0 );
          data = hrdata_i;
          haddr_o <= 'bx;
          hwdata_o <= 'bx;
          htrans_o <= 2'b00;
          hburst_o <= 3'b000;
          hsize_o <= 3'b000;
          hwrite_o <= 1'b0;
          hsel_o <= 1'b0;
   endtask

endinterface
