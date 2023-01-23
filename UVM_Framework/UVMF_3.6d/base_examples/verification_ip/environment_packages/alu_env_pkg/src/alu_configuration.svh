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
// Project         : alu Block Level Environment
// Unit            : Configuration
// File            : alu_configuration.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This class defines the configuration for the alu_out to alu_in
//    environment.  It instantiates the configuration for the alu_out agent
//    and alu_in agent.
//
//----------------------------------------------------------------------
//
class alu_configuration extends uvmf_environment_configuration_base;

  `uvm_object_utils( alu_configuration );

  alu_out_configuration alu_out_config;
  alu_in_configuration  alu_in_config;

// ****************************************************************************
  function new( string name = "" );
    super.new( name );

    alu_out_config = alu_out_configuration::type_id::create("alu_out_config");
    alu_in_config  = alu_in_configuration::type_id::create("alu_in_config");

  endfunction

// ****************************************************************************
  virtual function string convert2string();
     return {"\nalu_out_config:", alu_out_config.convert2string(),"\nalu_in_config:",alu_in_config.convert2string()};
  endfunction

// ****************************************************************************
  function void initialize(uvmf_sim_level_t sim_level,
                           string environment_path,
                           string interface_names[],
                           uvm_reg_block register_model = null ,
                           uvmf_active_passive_t interface_activity[] = null
                           );

    if ( sim_level == BLOCK ) begin
       alu_out_config.initialize( ACTIVE, {environment_path,".out_agent"}, interface_names[0]);
       alu_in_config.initialize( ACTIVE, {environment_path,".in_agent"}, interface_names[1]);
    end else begin
       alu_out_config.initialize( PASSIVE, {environment_path,".out_agent"}, interface_names[0]);
       alu_in_config.initialize( PASSIVE, {environment_path,".in_agent"}, interface_names[1]);
    end
  endfunction

endclass
