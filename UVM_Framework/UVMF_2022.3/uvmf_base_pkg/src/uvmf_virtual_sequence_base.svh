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
// Unit            : Virtual sequence base
// File            : uvmf_virtual_sequence_base.svh
//----------------------------------------------------------------------
// Creation Date   : 06.21.2022
//----------------------------------------------------------------------
// Description: This file contains the uvmf extension to the uvm sequence
// for virtual sequences.  UVMF generated environment packages contain
// an extension of this sequence for environment level virtual sequences.
// The generated environment virtual sequence base contains comments 
// that indicate the path to each sequencer within the environment and 
// any sub-environment.
//
//----------------------------------------------------------------------
class uvmf_virtual_sequence_base#(type CONFIG_T, type BASE_T = uvm_sequence #(.REQ(uvm_sequence_item), .RSP(uvm_sequence_item))) extends BASE_T;

  `uvm_object_param_utils( uvmf_virtual_sequence_base #(CONFIG_T, BASE_T))

  typedef uvmf_virtual_sequencer_base#(CONFIG_T) vsqr_t;
  vsqr_t    vsqr;

  CONFIG_T  configuration;

  function new( string name ="");
    super.new( name );
  endfunction

// ****************************************************************************
// TASK: pre_body()
// When this sequence's start task is executed, the sequence's pre_body and 
// post_body tasks are automatically called if the call_pre_post argument of 
// start is set to 1. The default value for call_pre_post argument in start is 1.  
// This pre_body task casts the m_sequencer, type uvm_sequencer_base, to the 
// uvmf_virtual_sequencer_base type which includes a handle to the environments 
// configuration object and the get_config method to retrieve a handle to the 
// environment configuration.  The purpose of this task is to give the environment
// level virtual sequence access to the environments configuration.  In addition 
// to providing access to all environment configuration variables, the environment
// configuration has a handle to each sequencer within and below the environment.
  virtual task pre_body();
    if (m_sequencer != null) begin
      if($cast(vsqr,m_sequencer)) begin
        configuration = vsqr.get_config();
      end
    end
  endtask

endclass : uvmf_virtual_sequence_base
