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
// Project         : AHB 2 SPI Example
// Unit            : Configuration
// File            : ahb2spi_configuration.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This configuration contains a configuration object for
//     the AHB to WB environment and a configuration for the WB to SPI
//     environment.  The initialize function is used to setup
//     the agents within these environments for either BLOCK, CHIP, or
//     SYSTEM level simulations.  It also provies the names of all the
//     interfaces to be retreieved from the uvm_config_db and the path
//     to where the environment resides within the simulation.
//
//----------------------------------------------------------------------
//
class ahb2spi_configuration extends uvmf_environment_configuration_base;

  `uvm_object_utils( ahb2spi_configuration );

  ahb2wb_configuration  ahb2wb_config;
  wb2spi_configuration  wb2spi_config;

  ahb2spi_reg_block     reg_model;

// ****************************************************************************
  function new( string name = "" );
    super.new( name );

    ahb2wb_config = ahb2wb_configuration::type_id::create("ahb2wb_config");
    wb2spi_config = wb2spi_configuration::type_id::create("wb2spi_config");

  endfunction

// ****************************************************************************
  function void initialize(uvmf_sim_level_t sim_level,
                                     string environment_path,
                                     string interface_names [],
                                     uvm_reg_block register_model = null,
                                     uvmf_active_passive_t interface_activity[] = null);

    super.initialize(sim_level, environment_path, interface_names, register_model, interface_activity);

    if (register_model == null) begin
      reg_model = ahb2spi_reg_block::type_id::create("reg_model");
      reg_model.build();

      enable_reg_adaptation = 1;
      wb2spi_config.enable_reg_prediction = 1;
    end
    
    ahb2wb_config.initialize(sim_level, {environment_path, ".ahb2wb_env"},
                             { interface_names[0], interface_names[1]} );
    wb2spi_config.initialize(sim_level, {environment_path, ".wb2spi_env"},
                             { interface_names[1], interface_names[2]},
                             reg_model.wb2spi);

  endfunction

// ****************************************************************************
  virtual function string convert2string();
     return {"\nahb2wb_config:", ahb2wb_config.convert2string(),"\nwb2spi_config:",wb2spi_config.convert2string()};
  endfunction

endclass
