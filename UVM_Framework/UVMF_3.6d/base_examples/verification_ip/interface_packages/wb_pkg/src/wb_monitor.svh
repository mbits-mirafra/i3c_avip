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
// Unit            : Monitor
// File            : wb_monitor.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This class receives wb transactions observed by the
//     wb monitor BFM and broadcasts them through the analysis port
//     on the agent. It accesses the monitor BFM through the monitor
//     task in the configuration. This UVM component captures transactions
//     for viewing in the waveform viewer if the
//     enable_transaction_viewing flag is set in the configuration.
//
//----------------------------------------------------------------------
class wb_monitor extends uvmf_monitor_base #(
      .CONFIG_T(wb_configuration),
      .BFM_BIND_T(virtual wb_monitor_bfm),
      .TRANS_T(wb_transaction)
      );

  `uvm_component_utils(wb_monitor)

// ****************************************************************************
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

// ****************************************************************************
   virtual function void configure(CONFIG_T cfg);
      // Currently empty
   endfunction

// ****************************************************************************
   virtual function void set_bfm_proxy_handle();
      bfm.proxy = this; //bfm.proxy = bfm_proxy_map[bfm];
   endfunction

// // ****************************************************************************
   // virtual task monitor(inout TRANS_T txn);
      // txn.start_time = $time; // This is accurate for resets but not reads and writes, 
                              // // where ack_i assertion determines start time (this is within the BFM task)
      // bfm.monitor(txn.op, txn.addr, txn.data); //, start_time/duration);
      // txn.end_time = $time; // This is not accurate for writes due to extra 2 cycles at end of the BFM transaction
   // endtask

// ****************************************************************************
  virtual task run_phase(uvm_phase phase);
    // Start monitor BFM thread and don't call super.run() in order to 
    // override the default monitor proxy 'pull' behavior with the more 
    // emulation-friendly BFM 'push' approach using the notify_transaction
    // function below
    bfm.start_monitoring();
  endtask

// ****************************************************************************
  virtual function void notify_transaction(wb_op_t op, bit[WB_ADDR_WIDTH-1:0] addr, bit[WB_DATA_WIDTH-1:0] data);
     trans = new("trans");
     trans.op = op;
     trans.addr = addr;
     trans.data = data;
     trans.start_time = time_stamp;
     trans.end_time = $time;
     time_stamp = trans.end_time;

     analyze(trans);
  endfunction

endclass
