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
// Unit            : Monitor
// File            : alu_out_monitor.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This class receives alu_out transactions observed by the
//     alu_out monitor BFM and broadcasts them through the analysis port
//     on the agent. It accesses the monitor BFM through the monitor
//     task in the configuration. This UVM component captures transactions
//     for viewing in the waveform viewer if the
//     enable_transaction_viewing flag is set in the configuration.
//
// ****************************************************************************
class alu_out_monitor extends uvmf_monitor_base #(
   .CONFIG_T(alu_out_configuration),
   .BFM_BIND_T(virtual alu_out_monitor_bfm),
   .TRANS_T(alu_out_transaction)
);

  `uvm_component_utils( alu_out_monitor )

// ****************************************************************************
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

// ****************************************************************************
   virtual function void set_bfm_proxy_handle();
      bfm.proxy = this;
   endfunction

// ****************************************************************************
  virtual task run_phase(uvm_phase phase);
    // Start monitor BFM thread and don't call super.run() in order to 
    // override the default monitor proxy 'pull' behavior with the more 
    // emulation-friendly BFM 'push' approach using the notify_transaction
    // function below
    bfm.start_monitoring();
  endtask

// ****************************************************************************
  virtual function void notify_transaction(input alu_out_transaction_s trans_s);
     trans = new("trans");
     trans.from_struct(trans_s);
     trans.start_time = time_stamp + 1;
     trans.end_time = $time - 1;
     time_stamp = $time;

     analyze(trans);
  endfunction

endclass
