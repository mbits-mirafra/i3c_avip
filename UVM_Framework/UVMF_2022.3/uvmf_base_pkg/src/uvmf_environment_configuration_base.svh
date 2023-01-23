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
// Unit            : Environment configuration base class
// File            : uvmf_environment_configuration_base.sv
//----------------------------------------------------------------------
// Creation Date   : 03.20.2015
//----------------------------------------------------------------------

// CLASS: uvmf_environment_configuration_base
// This class is used as the configuration base class for the uvmf 
// environment class.
//
class uvmf_environment_configuration_base #(type BASE_T = uvm_object) extends BASE_T;

  `uvm_object_param_utils( uvmf_environment_configuration_base #(BASE_T) )

  // BIT: enable_reg_prediction
  // If set: UVM register model prediction is enabled.  Reg adapter
  // is constructed and prediction connections are made.
  bit enable_reg_prediction;

  // BIT: enable_reg_adaptation
  // If set: UVM register model is used to generate stimulus through this block.
  // Reg adapter is constructed and sequencer connection is made.
  bit enable_reg_adaptation;

  // FUNCTION : new
  function new( string name = "" );
     super.new( name );
  endfunction

// ****************************************************************************
  virtual function void initialize (uvmf_sim_level_t sim_level,
                                    string environment_path,
                                    string interface_names [],
                                    uvm_reg_block register_model = null,
                                    uvmf_active_passive_t interface_activity[] = {}
                                    );

      `uvm_info("CFG", 
                $psprintf("Interfaces for the following uvm environment hierarchy %s", environment_path),
                UVM_DEBUG)

      foreach ( interface_names[if_name]) begin
         `uvm_info("CFG", 
                   $psprintf("   interface_names[%d] = %s interface_activity[%d] = %s", if_name, interface_names[if_name], if_name, interface_activity[if_name]),
                   UVM_DEBUG)
      end

  endfunction
endclass
