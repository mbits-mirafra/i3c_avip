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
// Project         : AHB to WB Block Level Environment
// Unit            : Configuration
// File            : ahb2wb_configuration.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This class defines the configuration for the ahb to wb
//    environment.  It instantiates the configuration for the ahb agent
//    and wb agent.
//
//----------------------------------------------------------------------
//
class ahb2wb_configuration extends uvmf_environment_configuration_base;

  `uvm_object_utils( ahb2wb_configuration );

  ahb_configuration ahb_config;
  wb_configuration  wb_config;

// ****************************************************************************
  function new( string name = "" );
    super.new( name );

    ahb_config = ahb_configuration::type_id::create("ahb_config");
    ahb_config.master_slave = MASTER;
    wb_config  = wb_configuration::type_id::create("wb_config");
    wb_config.master_slave = SLAVE;

  endfunction

// ****************************************************************************
  virtual function string convert2string();
     return {"\nahb_config:", ahb_config.convert2string(),"\nwb_config:",wb_config.convert2string()};
  endfunction

// ****************************************************************************
  function void initialize(uvmf_sim_level_t sim_level,
                           string environment_path,
                           string interface_names [],
                           uvm_reg_block register_model = null,
                           uvmf_active_passive_t interface_activity[] = null);

    if ( sim_level == BLOCK ) begin
       ahb_config.initialize( ACTIVE, {environment_path,".a_agent"}, interface_names[0]);
       wb_config.initialize ( ACTIVE, {environment_path,".b_agent"}, interface_names[1]);
    end else if ( sim_level == CHIP ) begin
       ahb_config.initialize( ACTIVE, {environment_path,".a_agent"}, interface_names[0]);
       wb_config.initialize ( PASSIVE,{environment_path,".b_agent"}, interface_names[1]);
    end else if ( sim_level == SYSTEM ) begin
       ahb_config.initialize( PASSIVE, {environment_path,".a_agent"}, interface_names[0]);
       wb_config.initialize ( PASSIVE, {environment_path,".b_agent"}, interface_names[1]);
    end else begin
      `uvm_fatal("CONFIGURATION", "Unknown sim_level in ahb2wb_configuration::set_activity()")
    end
  endfunction

endclass
