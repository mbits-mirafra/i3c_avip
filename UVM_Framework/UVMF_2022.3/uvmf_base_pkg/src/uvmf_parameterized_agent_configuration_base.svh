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
// Unit            : Parameterized agent configuration base
// File            : uvmf_parameterized_agent_configuration_base.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------

// CLASS: uvmf_parameterized_agent_configuration_base
// This class is used to configure an agent that is based on the <parameterized_agent>.
// It is also used as a proxy to the tasks contained in the driver bfm and monitor bfm.
// The tasks and functions are used to provide access to tasks and functions within
// the interfaces used by the driver and/or monitor within the agent. Some are required
// and other are optional based on the nature of the agent.  Extensions to this class
// should contain virtual interface handles to the monitor bfm interface and driver bfm
// interface.  Extensions to this class should also include any protocol specific variables.
//
// PARAMETERS:
//     DRIVER_BFM_BIND_T -  The driver BFM binding type.
//                          This type is a virtual interface when using native SV VIF-based proxy-BFM communication. 
//                          This type is a chandle when using DPI-C based proxy-BFM communication.                
//                          This type can also be a class for an 'indirect' class-based use model like 2-kingdoms (or MCD DPI).
//                           
//     MONITOR_BFM_BIND_T - The monitor BFM binding type.
//                          This type is a virtual interface when using native SV VIF-based proxy-BFM communication. 
//                          This type is a chandle when using DPI-C based proxy-BFM communication.                
//                          This type can also be a class for an 'indirect' class-based use model like 2-kingdoms (or MCD DPI).
//                           

virtual class uvmf_parameterized_agent_configuration_base #( 
   type DRIVER_BFM_BIND_T,
   type MONITOR_BFM_BIND_T,
   type BASE_T = uvm_object
) extends BASE_T;

  // VARIABLE: driver_bfm
  // VARIABLE: monitor_bfm
  // Driver and monitor HDL BFM reference
  // Typically a virtual interface for the VIF-based use model, but can
  // also be a chandle for the DPI-C based use model, or even an object 
  // handle for a class-based use model like 2-kingdoms
  DRIVER_BFM_BIND_T  driver_bfm;
  MONITOR_BFM_BIND_T monitor_bfm;

  // STRING: driver_bfm_hdl_path
  // STRING: monitor_bfm_hdl_path
  // Driver and monitor HDL BFM hierarchical path
  // HDL scope hierarchical string path for the driver and monitor HDL 
  // BFM instances corresponding to above BFM references
  // (relevant only for DPI-C based use model, i.e. when the bind type parameters are chandles)
  string driver_bfm_hdl_path;
  string monitor_bfm_hdl_path;

  // STRING: report_id
  // Used for uvm reporting id
  string report_id;

  // BIT: enable_transaction_viewing
  // *DEFAULT OFF* It is used to turn on transaction viewing for the agent. Transaction
  // viewing performed by the monitor in the agent.
  bit enable_transaction_viewing = 0;

  // VARIABLE: active_passive
  // Type <uvmf_active_passive_t>. Define active/passive configuration of the agent
  uvmf_active_passive_t  active_passive;

  // VARIABLE: initiator_responder
  // Type <uvmf_initiator_responder_t>. Define the initiator/responder configuation of the agent
  uvmf_initiator_responder_t    initiator_responder;

  // VARIABLE: master_slave
  // Type <uvmf_master_slave_t>. Define the master/slave configuration of the agent
  uvmf_master_slave_t  master_slave;

  // BIT: has_coverage
  // *DEFAULT ON* Determines if a coverage collection component is to be constructed
  // in the agent.
  bit has_coverage = 0;

  // STRING: interface_name
  // String name of the driver and monitor bfm virtual interface used by this driver.
  // It is also used as the field_name when the agents sequencer is placed in the uvm_config_db.
  string interface_name;

  // BIT: return_transaction_response
  // When set,   this flag causes UVM driver to always return a response transaction to the sequence.
  // When clear, this flag causes UVM driver to not    return a response transaction to the sequence.
  bit return_transaction_response;

  // FUNCTION: new
  function new( string name = "" );
    super.new(name);
    report_id = name;
  endfunction

  // FUNCTION: initialize
  // This function is used to set the interfaces used by the agent. Executed by super.initialize
  // executed by classes derived by this class. It also looks in the config_db to determine if this agent
  // should enable transaction viewing in the waveform.
  //
  // ARGUMENTS:
  //    activity -         Set the <uvmf_active_passive_t> of the agent
  //    agent_path -       Set the uvm hierarchical path down to this agent
  //    interface_name -   Set the string name of the bfm virtual interface
   virtual function void initialize(
                                              uvmf_active_passive_t activity,
                                              string agent_path,
                                              string interface_name);
      active_passive      = activity;
      this.interface_name = interface_name;

    `uvm_info("CFG", 
              $psprintf("The agent at '%s' is using interface named %s and is configured as %s", agent_path, interface_name, activity),
              UVM_DEBUG)

      // Checking the config_db
      void'(uvm_config_db #(uvm_bitstream_t)::get(null,interface_name,"enable_transaction_viewing",enable_transaction_viewing));
    if( !uvm_config_db #( MONITOR_BFM_BIND_T )::get( null , UVMF_VIRTUAL_INTERFACES , interface_name , monitor_bfm ) ) begin
            $stacktrace;
            `uvm_fatal("CFG" , $sformatf("uvm_config_db #( MONITOR_BFM_BIND_T )::get cannot find monitor bfm resource with interface_name %s",interface_name) )
       end

    if ( activity == ACTIVE ) begin
       if( !uvm_config_db #( DRIVER_BFM_BIND_T )::get( null , UVMF_VIRTUAL_INTERFACES , interface_name , driver_bfm ) ) begin
            $stacktrace;
            `uvm_fatal("CFG" , $sformatf("uvm_config_db #( DRIVER_BFM_BIND_T )::get cannot find driver bfm resource with interface_name %s",interface_name) )
       end
    end

   endfunction

  // FUNCTION: convert2string
  // Displays the information in this configuration. Should be defined in a derived class
  // if more information is defined.
  virtual function string convert2string();
     string msg;
     $sformat(msg,"enable_transaction_viewing:%d active_passive:%s has_coverage:%d",
           enable_transaction_viewing, active_passive, has_coverage);
     return msg;

   endfunction

// ****************************************************************************
  // TASK: wait_for_reset
  // *[Required]*  Blocks until reset is released.  The wait_for_reset FSM 
  // is typically modeled in the monitor bfm.
  // *[Example implementation]*
  //     virtual task wait_for_reset();
  //         monitor_bfm.wait_for_reset();
  //     endtask
  virtual task wait_for_reset();
  endtask

// ****************************************************************************
  // TASK: wait_for_num_clocks
  // *[Required]* Blocks until specified number of clocks have elapsed. The 
  // wait_for_num_clocks FSM is typically modeled in the monitor bfm.
  // *[Example implementation]*
  //     virtual task wait_for_num_clocks(int clocks);
  //         monitor_bfm.wait_for_num_clocks(clocks);
  //     endtask
  virtual task wait_for_num_clocks(int clocks);
  endtask

// ****************************************************************************
   function uvmf_parameterized_agent_configuration_base_s to_struct();
     uvmf_parameterized_agent_configuration_base_s s;
     {s.active_passive, s.initiator_responder, s.has_coverage} =
        {this.active_passive, this.initiator_responder, this.has_coverage};
     return s;
   endfunction
 
// ****************************************************************************
   function void from_struct(uvmf_parameterized_agent_configuration_base_s s);
     {this.active_passive, this.initiator_responder, this.has_coverage} =
        {s.active_passive, s.initiator_responder, s.has_coverage};
   endfunction

endclass : uvmf_parameterized_agent_configuration_base
