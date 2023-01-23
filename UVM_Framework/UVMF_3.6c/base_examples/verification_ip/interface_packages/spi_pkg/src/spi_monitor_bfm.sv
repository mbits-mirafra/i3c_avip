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
// Unit            : Monitor Bus Functional Model
// File            : spi_monitor_bfm.sv
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This interface performs the spi signal monitoring.
//      It is accessed by the uvm spi monitor through a virtual
//      interface handle in the spi configuration.  It monitors the
//      signals passed in through the port connection named bus of
//      type spi_if.
//
//     Input signals from the spi_if are assigned to an internal input
//     signal with a _i suffix.  The _i signal should be used for sampling.
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i 
//
//      BFM interface functions and tasks used by UVM components:
//             configure(spi_configuration_s spi_cfg);
//                   This function gets configuration attributes from the 
//                   UVM driver to set any required BFM configuration  
//                   variables such as 'master_slave'.
//
//             wait_for_sck(int clocks);
//                   This task waits for the number of clock events
//                   specified by the clocks argument.
//
//             start_monitoring()/run();
//                   This function/task kicks off an autonomous monitor 
//                   thread to observe interface activity and pass sampled 
//                   bus transaction attributes to the associated 
//                   UVM monitor (the proxy) where they are used to
//                   populate transaction objects.
//
//             monitor(output bit [SPI_XFER_WIDTH-1:0] mosi_data, 
//                     output bit [SPI_XFER_WIDTH-1:0] miso_data);
//             monitor_mosi(output bit [SPI_XFER_WIDTH-1:0] data);
//             monitor_miso(output bit [SPI_XFER_WIDTH-1:0] data);
//                   A 'pull' alternative to using the preferred 'push' 
//                   variant with start_monitoring()/run() above.
//
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import spi_pkg_hdl::*;

interface spi_monitor_bfm( spi_if bus );
// pragma attribute spi_monitor_bfm partition_interface_xif

   spi_configuration_s cfg;

   spi_pkg::spi_monitor proxy; // pragma tbx oneway proxy.notify_transaction

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
   task wait_for_sck(input int unsigned count); // pragma tbx xtf
      @(posedge bus.sck);
      repeat (count-1) @(posedge bus.sck);
   endtask

//******************************************************************
   event go;
   function void start_monitoring(); // pragma tbx xtf
      -> go;
   endfunction

// ****************************************************************************
   initial begin
      @go;
      forever begin
        bit [SPI_XFER_WIDTH-1:0] mosi_data;
        bit [SPI_XFER_WIDTH-1:0] miso_data;

        @(posedge bus.sck);
        do_monitor(mosi_data, miso_data);
        proxy.notify_transaction(mosi_data, miso_data);
      end
   end

// ****************************************************************************
   task monitor(output bit [SPI_XFER_WIDTH-1:0] mosi_data,
                output bit [SPI_XFER_WIDTH-1:0] miso_data); // pragma tbx xtf
      @(posedge bus.sck);
      do_monitor(mosi_data, miso_data);
   endtask

// ****************************************************************************
   task do_monitor(output bit [SPI_XFER_WIDTH-1:0] mosi_data,
                   output bit [SPI_XFER_WIDTH-1:0] miso_data);
      //-start_time = $time;
      mosi_data[SPI_XFER_WIDTH-1]=bus.mosi;
      miso_data[SPI_XFER_WIDTH-1]=bus.miso;
      for (int i=(SPI_XFER_WIDTH-2);i>=0;i--) begin
          @(posedge bus.sck);
          mosi_data[i]=bus.mosi;
          miso_data[i]=bus.miso;
      end
      //-end_time = $time;
   endtask

// ****************************************************************************
   task monitor_mosi(output bit [SPI_XFER_WIDTH-1:0] data); // pragma tbx xtf
      @(posedge bus.sck);
      do_monitor_mosi(data);
   endtask

// ****************************************************************************
   task monitor_miso(output bit [SPI_XFER_WIDTH-1:0] data); // pragma tbx xtf
      @(posedge bus.sck);
      do_monitor_miso(data);
   endtask

// ****************************************************************************
   task do_monitor_mosi(output bit [SPI_XFER_WIDTH-1:0] data);
      //-start_time = $time;
      data[SPI_XFER_WIDTH-1]=bus.mosi;
      for (int i=(SPI_XFER_WIDTH-2);i>=0;i--) begin
          @(posedge bus.sck) data[i]=bus.mosi;
      end
      //-end_time = $time;
   endtask

// ****************************************************************************
   task do_monitor_miso(output bit [SPI_XFER_WIDTH-1:0] data);
      //-start_time = $time;
      data[SPI_XFER_WIDTH-1]=bus.miso;
      for (int i=(SPI_XFER_WIDTH-2);i>=0;i--) begin
          @(posedge bus.sck) data[i]=bus.miso;
      end
      //-end_time = $time;
   endtask

endinterface
