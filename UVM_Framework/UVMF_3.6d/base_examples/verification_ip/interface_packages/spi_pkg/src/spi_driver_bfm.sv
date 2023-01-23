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
// Project         : spi interface agent
// Unit            : Driver Bus Functional Model
// File            : spi_driver_bfm.sv
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This interface performs the spi signal driving.  It is
//     accessed by the uvm spi driver through a virtual interface 
//     handle in the spi configuration.  It drives the singals passed
//     in through the port connection named bus of type spi_if.
//
//     Input signals from the spi_if are assigned to an internal input 
//     signal with a _i suffix.  The _i signal should be used for sampling.  
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i 
//
//     This bfm drives signals with a _o suffix.  These signals
//     are driven onto signals within spi_if .
//
//     The output signal connections are as follows:
//        signal_o -> bus.signal
//
//      BFM interface functions and tasks used by UVM components:
//             configure(spi_configuration_s spi_cfg);
//                   This function gets configuration attributes from the 
//                   UVM driver to set any required BFM configuration  
//                   variables such as 'master_slave'.
//
//             put_spi_dout(input spi_transaction_s spi_txn);
//                   This task performs a 'write' (i.e. 'to-spi') transaction 
//                   on the SPI interface.
//
//             get_spi_din(input spi_transaction_s spi_txn, 
//                         output bit [SPI_XFER_WIDTH-1:0] spi_driver_din);
//                   This task performs a 'read' (i.e. 'from-spi') transaction 
//                   on the SPI interface.
//   
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import spi_pkg_hdl::*;

interface spi_driver_bfm(spi_if bus);
// pragma attribute spi_driver_bfm partition_interface_xif

   bit    sclock;
   wire   spi_input;
   logic  spi_output;

   spi_configuration_s cfg;

   bit put_spi_dout_active;

   assign bus.sck = ((cfg.uvmf_cfg.master_slave == MASTER) && put_spi_dout_active) ? sclock:'bz;

   assign spi_input = (cfg.uvmf_cfg.master_slave == MASTER)? bus.miso:bus.mosi;

   assign bus.mosi = (cfg.uvmf_cfg.master_slave == MASTER)? spi_output:'bz;
   assign bus.miso = (cfg.uvmf_cfg.master_slave == SLAVE)? spi_output:'bz;

  
// ****************************************************************************
   // tbx clkgen
   initial begin
      sclock = 0;
      #5ns;
      forever #10ns sclock = ~sclock;
   end

//******************************************************************
   function void configure(spi_configuration_s spi_cfg); // pragma tbx xtf
      cfg = spi_cfg;
      // Configuration fields available from spi_configuration_s and embedded
      // uvmf_parameterized_agent_configuration_base_s packed structs:
      // - uvmf_cfg.master_slave
      // - uvmf_cfg.active_passive
      // - uvmf_cfg.has_coverage
      // - SPCR_SPIE     // Serial Peripheral Interrupt Enable
      // - SPCR_SPE      // Serial Peripheral Enable
      // - SPCR_MSTR     // Master Mode Select
      // - SPCR_CPOL     // Clock Polarity
      // - SPCR_CPHA     // Clock Phase
      // - SPCR_SPR      // SPI Clock Rate Select
      // - SPER_ESPR     // Extended SPI Clock Rate Select
   endfunction

// ****************************************************************************
   bit [SPI_XFER_WIDTH-1:0] spi_driver_dout;

   function void put_spi_dout(input spi_transaction_s spi_txn); // pragma tbx xtf
      spi_driver_dout = spi_txn.spi_data;
      spi_output <= spi_driver_dout[SPI_XFER_WIDTH-1];
      put_spi_dout_active = 1;
   endfunction

   always begin
      wait(put_spi_dout_active);
      @(posedge bus.sck);
      for (int i=(SPI_XFER_WIDTH-2);i>=0;i--) begin
          spi_output <= spi_driver_dout[i]; @(posedge bus.sck);
      end
      put_spi_dout_active = 0;
   end

// ****************************************************************************
   task get_spi_din(input spi_transaction_s spi_txn, 
                    output bit [SPI_XFER_WIDTH-1:0] spi_driver_din); // pragma tbx xtf
      @(posedge bus.sck);
      spi_driver_din[SPI_XFER_WIDTH-1]=spi_input;
      for (int i=(SPI_XFER_WIDTH-2);i>=0;i--) begin
          @(posedge bus.sck) spi_driver_din[i]=spi_input;
      end
   endtask

endinterface
