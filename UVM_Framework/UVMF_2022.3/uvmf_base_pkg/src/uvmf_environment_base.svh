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
// Unit            : Environment base class
// File            : uvmf_environment_base.sv
//----------------------------------------------------------------------
// Creation Date   : 01.06.2015
//----------------------------------------------------------------------

// CLASS: uvmf_environment_base
// This class is used as the base class for the environment.  It provides 
// a handle to the configuration class.
//
// PARAMETERS:
//     CONFIG_T      - The configuration class used for this environment.
//
class uvmf_environment_base #(type CONFIG_T = uvmf_environment_configuration_base, type BASE_T = uvm_env ) extends BASE_T;

  `uvm_component_param_utils( uvmf_environment_base #(CONFIG_T, BASE_T))

  // Configuration class object handle
  CONFIG_T configuration;

  // FUNCTION : new
  function new( string name = "", uvm_component parent = null );
     super.new( name, parent );
  endfunction

  // FUNCTION : set_config
  function void set_config( CONFIG_T cfg );
      configuration = cfg;
  endfunction

endclass
