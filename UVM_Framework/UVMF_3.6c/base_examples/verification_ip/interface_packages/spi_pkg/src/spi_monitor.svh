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
// Unit            : Monitor
// File            : spi_monitor.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This class receives spi transactions observed by the
//     spi monitor BFM and broadcasts them through the analysis port
//     on the agent. It accesses the monitor BFM through the monitor
//     task in the configuration. This UVM component captures transactions
//     for viewing in the waveform viewer if the
//     enable_transaction_viewing flag is set in the configuration.
//
//----------------------------------------------------------------------
//
class spi_monitor extends uvmf_monitor_base #(
   .CONFIG_T(spi_configuration),
   .BFM_BIND_T(virtual spi_monitor_bfm),
   .TRANS_T(spi_transaction)
);

  `uvm_component_utils( spi_monitor )

  TRANS_T mosi_transaction;
  TRANS_T miso_transaction;

// ****************************************************************************
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

// ****************************************************************************
  virtual task run_phase(uvm_phase phase);
    // override the default monitor proxy 'pull' behavior with the more 
    // emulation-friendly BFM 'push' approach using the notify_transaction
    // function below
    // For emulation-friendly BFM 'push' semantics:
    bfm.start_monitoring();

    // For alternative 'conventional' approach yielding BFM 'pull' semantics:
    //run();
  endtask

// ****************************************************************************
  local task run();
      forever begin

         mosi_transaction=TRANS_T::type_id::create("mosi_transaction");
         miso_transaction=TRANS_T::type_id::create("miso_transaction");

         monitor_spi(mosi_transaction, miso_transaction);

         mosi_transaction.unpack_fields();
         miso_transaction.unpack_fields();
         mosi_transaction.dir = MOSI;
         miso_transaction.dir = MISO;

         analyze(mosi_transaction);
         analyze(miso_transaction);

      end
  endtask

// ****************************************************************************
   virtual function void configure(input CONFIG_T cfg);
      bfm.configure(cfg.to_struct());
   endfunction

// ****************************************************************************
   virtual function void set_bfm_proxy_handle();
      bfm.proxy = this;
   endfunction

// ****************************************************************************
   virtual task monitor(inout TRANS_T txn);
      //Not implemented; 2-argument monitor_spi(...) task below used instead
   endtask

// ****************************************************************************
   virtual task monitor_spi(inout TRANS_T mosi_txn, inout TRANS_T miso_txn);
      spi_transaction spi_mosi_txn;
      spi_transaction spi_miso_txn;
      $cast(spi_mosi_txn, mosi_txn);
      $cast(spi_miso_txn, miso_txn);
      spi_mosi_txn.dir = MOSI;
      spi_miso_txn.dir = MISO;

      spi_mosi_txn.start_time = $time;
      spi_miso_txn.start_time = $time;
      bfm.monitor(spi_mosi_txn.spi_data, spi_miso_txn.spi_data);
      spi_mosi_txn.end_time = $time;
      spi_miso_txn.end_time = $time;

      /* Alternative: mosi and miso in parallel per original code
      fork
        begin
          spi_mosi_txn.start_time = $time;
          bfm.monitor_mosi(spi_mosi_txn.spi_data);
          spi_mosi_txn.end_time = $time;
        end
        begin
          spi_miso_txn.start_time = $time;
          bfm.monitor_miso(spi_miso_txn.spi_data);
          spi_miso_txn.end_time = $time;
        end
      join
      */
   endtask

// ****************************************************************************
  virtual function void notify_transaction(bit [SPI_XFER_WIDTH-1:0] mosi_data, 
                                           bit [SPI_XFER_WIDTH-1:0] miso_data);

     TRANS_T mosi_transaction=TRANS_T::type_id::create("mosi_transaction");
     TRANS_T miso_transaction=TRANS_T::type_id::create("miso_transaction");

     mosi_transaction.spi_data = mosi_data;
     miso_transaction.spi_data = miso_data;

     mosi_transaction.unpack_fields();
     miso_transaction.unpack_fields();
     mosi_transaction.dir = MOSI;
     miso_transaction.dir = MISO;

     mosi_transaction.start_time = time_stamp;
     miso_transaction.start_time = time_stamp;
     mosi_transaction.end_time = $time;
     miso_transaction.end_time = $time;
     time_stamp = $time;

     analyze(mosi_transaction);
     analyze(miso_transaction);

  endfunction

endclass
