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
//----------------------------------------------------------------------
//                   Mentor Graphics Inc
//----------------------------------------------------------------------
// Project         : UVM Framework
// Unit            : Virtual sequencer base
// File            : uvmf_virtual_sequencer_base.svh
//----------------------------------------------------------------------
// Creation Date   : 06.21.2022
//----------------------------------------------------------------------
// Description: This file contains the uvmf extension to the uvm sequencer
// for virtual sequencers.  An instance of this virtual sequencer, 
// parameterized with the environment configuration class type, is placed
// in the environment.  A handle to the virtual sequencer is placed in
// the environments configuration object.  A handle to each sequencer in 
// and under the environment, and any sub-environments, is available 
// through the configuration hiarchy.  This is because each agent configuration
// has a handle to the agent's sequencer.
//
//----------------------------------------------------------------------
class uvmf_virtual_sequencer_base #(type CONFIG_T, type BASE_T = uvm_sequencer #(.REQ(uvm_sequence_item), .RSP(uvm_sequence_item)) ) extends BASE_T;

  `uvm_component_param_utils( uvmf_virtual_sequencer_base #(CONFIG_T, BASE_T))

  CONFIG_T            configuration;

  function new( string name ="", uvm_component parent = null );
    super.new( name, parent );
  endfunction

  virtual function CONFIG_T get_config();
    return configuration;
  endfunction : get_config

  virtual function void set_config(CONFIG_T configuration);
    this.configuration = configuration;
  endfunction : set_config

endclass : uvmf_virtual_sequencer_base
