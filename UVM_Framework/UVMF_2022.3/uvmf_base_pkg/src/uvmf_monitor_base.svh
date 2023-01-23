//----------------------------------------------------------------------
//   Copyright 2013-2021 Siemens Corporation
//   Digital Industries Software
//   Siemens EDA
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
//                   Mentor Graphics Inc
//----------------------------------------------------------------------
// Project         : UVM Framework
// Unit            : Monitor base class
// File            : uvmf_monitor_base.sv
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------

// CLASS: uvmf_monitor_base
// This class is used as the base class for the monitor used in the <uvmf_parameterized_agent>.
// It provides a handle to the configuration used by the monitor. The monitor acceses the
// interface through the configuration.
//
// PARAMETERS:
//     CONFIG_T   - The configuration class used for agent/monitor.
//                  Must be derived from parameterized_agent_configuration_base.
//
//     BFM_BIND_T - The monitor BFM binding type.
//                  This type must be a virtual interface when using native SV VIF-based proxy-BFM communication. 
//                  This type must be a chandle when using DPI-C based proxy-BFM communication.                
//                  This type can also be a class for an 'indirect' class-based use model like 2-kingdoms (or MCD DPI).
//
//     TRANS_T    - The 'analysis' transaction type.  This is the sequence item
//                  broadcast from the analysis_port connected to the monitor.
//                  Must be derived from uvmf_transaction_base.
//

class uvmf_monitor_base #(
   type CONFIG_T, 
   type BFM_BIND_T,
   type TRANS_T,
   type BASE_T = uvm_monitor
) extends BASE_T;

  typedef uvmf_monitor_base #(CONFIG_T, BFM_BIND_T, TRANS_T, BASE_T) uvmf_monitor_base_t;

  // Analysis_port used to broadcast monitored transactions
  uvm_analysis_port #(TRANS_T) monitored_ap;

  // Configuration object handle
  CONFIG_T configuration;

  // Monitor HDL BFM reference 
  // Typically a virtual interface for the VIF-based use model, but can
  // also be a chandle for the DPI-C based use model, or even an object 
  // handle for a class-based use model like  2-kingdoms
  BFM_BIND_T bfm;

  // Static associative array of back-references to instances derived from
  // this UVMF monitor class, from corresponding monitor HDL BFM instances 
  // as referenced by the 'bfm' field
`ifdef QUESTA
  static uvmf_monitor_base_t bfm_proxy_map[BFM_BIND_T];
`endif // QUESTA

  // Convenience variable for storing timestamps.
  // (For instance for tracking previous transaction end_times for 'push' approach ...).
  protected time time_stamp = 0;

  // Transaction handle
  TRANS_T trans;

  // Handle used for transaction viewing
  int transaction_viewing_stream;

// ****************************************************************************
  // FUNCTION : new
  function new( string name = "", uvm_component parent = null );
     super.new( name, parent );
  endfunction

// ****************************************************************************
  // FUNCTION: build_phase
  // Construct the analysis port in the build phase.
  virtual function void build_phase(uvm_phase phase);
     monitored_ap=new( "monitored_ap", this );
  endfunction

// ****************************************************************************
  // FUNCTION: connect_phase
  // Make local assignment to monitor BFM
  // Set the proxy handle in the BFM
  // Configure the BFM
  virtual function void connect_phase(uvm_phase phase);
     super.connect_phase(phase);
     bfm = configuration.monitor_bfm;
     if (bfm == null) begin
        $stacktrace;
        `uvm_fatal("MON", $sformatf("BFM handle with interface_name %s is null",configuration.interface_name));
     end
  `ifdef QUESTA
     bfm_proxy_map[bfm] = this;
  `endif
     set_bfm_proxy_handle();
     configure(configuration);
  endfunction

// ****************************************************************************
  // FUNCTION: start_of_simulation_phase
  virtual function void start_of_simulation_phase(uvm_phase phase);
  `ifdef QUESTA
     if (configuration.enable_transaction_viewing) begin
       transaction_viewing_stream = $create_transaction_stream({"..",get_full_name(),".","txn_stream"},"TVM");
     end
  `endif // QUESTA   
  endfunction

// ****************************************************************************
  // TASK: monitor
  // *[Required]* The monitor task is used to populate transaction attributes in the uvm monitor
  // from the monitor HDL BFM, which assigns values to the transaction attributes based
  // on observed bus activity. This task only returns when the observed transaction is complete.
  // *[Example implementation]*
  //     virtual task monitor(inout TRANS_T txn);
  //         bfm.monitor(txn.op, txn.addr, txn.data);
  //     endtask
  virtual task monitor(inout TRANS_T txn);
  endtask

// ****************************************************************************
  // TASK: run_phase
  // Run an indefinite thread to pull sampled transactions from the monitor BFM 
  // and 'analyze' the transactions (see local function 'analyze')
  task run_phase(uvm_phase phase);
  TRANS_T txn;
      forever begin
         txn = new("txn");
         monitor(txn);
         analyze(txn);
      end
  endtask

// ****************************************************************************
  protected virtual function void analyze(TRANS_T trans);
     if ( configuration.enable_transaction_viewing )
      trans.add_to_wave(transaction_viewing_stream);
     monitored_ap.write(trans);

     `uvm_info("MON",trans.convert2string(),UVM_HIGH);
  endfunction

// ****************************************************************************
  // FUNCTION: configure
  // *[Optional]* The configure function is used to pass relevant configuration 
  // data from the uvm monitor to the monitor HDL BFM, which configures itself in 
  // accordance with data provided in the configuration descriptor.
  // *[Example implementation]*
  //     virtual function void configure(input CONFIG_T cfg);
  //         bfm.configure(cfg.mode, ...);
  //     endfunction
  virtual function void configure(input CONFIG_T cfg);
  endfunction

// ****************************************************************************
  // FUNCTION: set_bfm_proxy_handle
  // *[Optional]* The set_bfm_proxy_handle function can be used to set a proxy 
  // handle in a monitor HDL BFM, i.e. the class 'backpointer' from the BFM back 
  // to the given proxy object, for the VIF-based proxy-BFM communication model.
  // Though optional, HDL BFM interface proxy backpointers are highly recommended
  // to implement a so-called transaction 'push' approach from BFM to proxy, which 
  // can yield significant emulation performance benefits with Veloce.
  // (Note: this is enforced by standard for the DPI-C based communication model,
  // and implemented using the above static associative array 'bfm_proxy_map' field). 
  // *[Example implementation]*
  //     virtual function void set_bfm_proxy_handle();
  //         bfm.proxy = this; // when bfm is a virtual interface handle
  //     endfunction
  virtual function void set_bfm_proxy_handle();
  endfunction

// ****************************************************************************
  // FUNCTION : set_config
  // This function used by the <uvmf_parameterized_agent> to set the configuration class handle.
  // The <uvmf_parameterized_agent> gets the configuration from the uvm_config_db.
 virtual function void set_config( CONFIG_T configuration );
   this.configuration = configuration;
 endfunction

endclass

