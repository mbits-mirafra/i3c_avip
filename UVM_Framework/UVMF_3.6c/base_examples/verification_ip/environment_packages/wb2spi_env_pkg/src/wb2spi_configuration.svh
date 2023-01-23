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
// Project         : WB to SPI Environment Example
// Unit            : Configuration
// File            : wb2spi_configuration.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This configuration class contains a configuration
//   object for each agent in the environment.  An agents configuration
//   configures the agent according to how it will be used within the
//   simulation.  This configuration also has a function,
//   configure_interfaces, which tells each agent configuration the
//   string name of the virtual interface it will use and the string
//   path of where the environment resides in the simulation.  This
//   allows for the agent configurations to get their own virtual
//   interfaces and make themselves available to their own agent.
//
//----------------------------------------------------------------------
//
class wb2spi_configuration extends uvmf_environment_configuration_base;

  `uvm_object_utils( wb2spi_configuration );

  spi_configuration spi_config;
  wb_configuration  wb_config;

  wb2spi_reg_block  reg_model;

// ****************************************************************************
  function new( string name = "" );
    super.new( name );

    spi_config = spi_configuration::type_id::create("spi_config");
    spi_config.master_slave = SLAVE;
    wb_config  = wb_configuration::type_id::create("wb_config");
    wb_config.master_slave = MASTER;

  endfunction

// ****************************************************************************
  virtual function string convert2string();
     return {"\nspi_config:", spi_config.convert2string(),"\nwb_config:",wb_config.convert2string()};
  endfunction
// ****************************************************************************
  function void initialize(uvmf_sim_level_t sim_level,
                           string environment_path,
                           string interface_names[],
                           uvm_reg_block register_model = null,
                           uvmf_active_passive_t interface_activity[] = null
                           );

    if ( sim_level == BLOCK ) begin
       wb_config.initialize( ACTIVE, {environment_path,".wb_agent"}, interface_names[0]);
       spi_config.initialize( ACTIVE, {environment_path,".spi_agent"}, interface_names[1]);
    end else if ( sim_level == CHIP ) begin
       wb_config.initialize( PASSIVE, {environment_path,".wb_agent"}, interface_names[0]);
       spi_config.initialize( ACTIVE, {environment_path,".spi_agent"}, interface_names[1]);
    end else if ( sim_level == SYSTEM ) begin
       wb_config.initialize( PASSIVE, {environment_path,".wb_agent"}, interface_names[0]);
       spi_config.initialize( PASSIVE, {environment_path,".spi_agent"}, interface_names[1]);
    end else begin
      `uvm_fatal("CONFIGURATION", "Unknown sim_level in wb2spi_configuration::set_activity()")
    end

    if (register_model == null) begin
      reg_model = wb2spi_reg_block::type_id::create("reg_model");
      reg_model.build();

      enable_reg_adaptation = 1;
      enable_reg_prediction = 1;
    end else begin
      $cast(reg_model,register_model);
      
      enable_reg_prediction = 1;
    end
  endfunction

endclass
