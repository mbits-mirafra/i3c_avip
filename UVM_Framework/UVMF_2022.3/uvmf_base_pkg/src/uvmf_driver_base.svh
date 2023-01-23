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
// Unit            : Driver base class
// File            : uvmf_driver_base.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// CLASS: uvmf_driver_base
// This class is used as the base class for the driver used in the <uvmf_parameterized_agent>. It provides a handle to the
// configuration used by the driver.  The driver acesses the interface through the configuration. It has a
// <uvmf_parameterized_agent_configuration_base> component that needs to be configured.
//
// PARAMETERS:
//     CONFIG_T     - The configuration class used for agent/driver.
//                    Must be derived from parameterized_agent_configuration_base
//                
//     BFM_BIND_T   - The driver BFM binding type.
//                    This type is a virtual interface when using native SV VIF-based proxy-BFM communication. 
//                    This type is a chandle when using DPI-C based proxy-BFM communication.                
//                    This type can also be a class for an 'indirect' class-based use model like 2-kingdoms (or MCD DPI).
//
//     REQ          - The request transaction type.  This is the sequence item 
//                    sent from the sequence to the driver through the sequencer.
//                    Must be derived from uvmf_transaction_base
//
//     RSP          - The response transaction type.  This is the sequence item 
//                    sent from the driver to the sequence through the sequencer.
//                    Must be derived from uvmf_transaction_base
class uvmf_driver_base #(
   type CONFIG_T, 
   type BFM_BIND_T,
   type REQ, 
   type RSP,
   type BASE_T = uvm_driver#(REQ, RSP )
) extends BASE_T;

  typedef uvmf_driver_base #(CONFIG_T, BFM_BIND_T, REQ, RSP, BASE_T) uvmf_driver_base_t;

  // Agent configuration class
  CONFIG_T configuration;

  // Driver transaction object (class member for debug)
  REQ txn;

  // Driver HDL BFM reference 
  // Typically a virtual interface for the VIF-based use model, but can
  // also be a chandle for the DPI-C based use model, or even an object 
  // handle for a class-based use model like 2-kingdoms
  BFM_BIND_T bfm;

  // Static associative array of back-references to instances derived from
  // this UVMF driver class, from corresponding driver HDL BFM instances 
  // as referenced by the 'bfm' field
`ifdef QUESTA
  static uvmf_driver_base_t bfm_proxy_map[BFM_BIND_T];
`endif // QUESTA

  // Event used to communicate with BFM when configured to operate in RESPONDER mode
  event new_responder_transaction;

  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

// ****************************************************************************
  // FUNCTION: connect_phase
  // Make local assignment to driver BFM
  // Set the proxy handle in the BFM
  // Configure the BFM
  virtual function void connect_phase(uvm_phase phase);
     super.connect_phase(phase);
     bfm = configuration.driver_bfm;
     if (bfm == null) begin
        $stacktrace;
        `uvm_fatal("DRV", $sformatf("BFM handle with interface_name %s is null",configuration.interface_name) );
     end
  `ifdef QUESTA
     bfm_proxy_map[bfm] = this;
  `endif // QUESTA
     set_bfm_proxy_handle();
     configure(configuration);
  endfunction

  //**********************************************************************
  // TASK: access
  // *[Required]* The access task is used to pass a transaction from the uvm driver to the
  // driver HDL BFM ('bfm'), which performs the bus operation in accordance with the 
  // transaction attributes.  The transaction can represent one of the following
  // operations: reset, write, read, etc.
  // *[Example implementation]*
  //     virtual task access(inout REQ txn);
  //        if (txn.op == WRITE) begin
  //           bfm.write(txn.addr, txn.data);
  //        end
  //        else if ...
  //        ...
  //     endtask
  virtual task access(inout REQ txn);
  endtask
  
  //**********************************************************************
  // TASK: get_driver();
  // This task is called by run_phase when the driver will not be 
  // providing transaction responses back to the sequence. 
  virtual task get_driver();
     `uvm_fatal("DEPRECATED","get_driver() is replaced by functionality within run_phase()")
  endtask

  //**********************************************************************
  // TASK: get_put_driver();
  // This task is called by run_phase when the driver will be 
  // providing transaction responses back to the sequence.  RESPONDER mode
  // is not supported with get_put_driver, a fatal error will be raised
  // if this configuration combination is detected.
  virtual task get_put_driver();
     `uvm_fatal("DEPRECATED","get_put_driver() is replaced by functionality within run_phase()")
  endtask

  //**********************************************************************
  // TASK: pipeline_driver();
  // This task is a placeholder for a default pipeline driver 
  // implementation.
  virtual task pipeline_driver();
  endtask


  //**********************************************************************
  // TASK: run_phase();
  // return_transaction_response within configuration class determines 
  // whether transaction is returned to sequence.  If return_transaction_response
  // is set then process a response transaction for each transaction sent to 
  // sequencer.  This behavior replaces the get_driver() and get_put_driver()
  // functionality.
  virtual task run_phase(uvm_phase phase);
    forever
      begin : forever_loop
       seq_item_port.get_next_item(txn);
       access(txn);
       if (configuration.return_transaction_response) 
          seq_item_port.item_done(txn);
       else
          seq_item_port.item_done();
    end : forever_loop
  endtask


// ****************************************************************************
  // FUNCTION: configure
  // *[Optional]* The configure function is used to pass relevant configuration 
  // data from the uvm driver to the driver HDL BFM, which configures itself in 
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
  // handle in a driver HDL BFM, i.e. the class 'backpointer' from the BFM back 
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

  // FUNCTION : set_config
  // This function used by the <uvmf_parameterized_agent> to set the configuration class handle.
  // The <uvmf_parameterized_agent> gets the configuration from the uvm_config_db.
 virtual function void set_config( CONFIG_T configuration );
   this.configuration = configuration;
 endfunction

endclass : uvmf_driver_base


