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
// Project         : GPIO Example
// Unit            : Configuration
// File            : gpio_example_configuration.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This configuration contains the configuration object
//    for the gpio agent used in the gpio example. 
//
//----------------------------------------------------------------------
//
class gpio_example_configuration #(int READ_PORT_WIDTH = 4, int WRITE_PORT_WIDTH=4 ) extends uvmf_environment_configuration_base;

  `uvm_object_param_utils( gpio_example_configuration #(READ_PORT_WIDTH, WRITE_PORT_WIDTH));

  typedef gpio_configuration #(READ_PORT_WIDTH, WRITE_PORT_WIDTH) gpio_config_t;
  gpio_config_t gpio_config;

// ****************************************************************************
  function new( string name = "" );
    super.new( name );

    gpio_config = gpio_config_t::type_id::create("gpio_config");

  endfunction

// ****************************************************************************
  virtual function string convert2string();
     return {"\n"};
  endfunction
// ****************************************************************************
  function void initialize(uvmf_sim_level_t sim_level, 
                           string environment_path,
                           string interface_names[],
                           uvm_reg_block register_model = null,
                           uvmf_active_passive_t interface_activity[] = null
                           );

    if ( sim_level == BLOCK ) begin
       gpio_config.initialize( ACTIVE, {environment_path,".gpio_agent"}, interface_names[0]);
    end else if ( sim_level == CHIP ) begin
       gpio_config.initialize( PASSIVE, {environment_path,".gpio_agent"}, interface_names[0]);
    end else if ( sim_level == SYSTEM ) begin
       gpio_config.initialize( PASSIVE, {environment_path,".gpio_agent"}, interface_names[0]);
    end else begin
      `uvm_fatal("CONFIGURATION", "Unknown sim_level in gpio_example_configuration::configure_environment()")
    end
  endfunction

endclass
