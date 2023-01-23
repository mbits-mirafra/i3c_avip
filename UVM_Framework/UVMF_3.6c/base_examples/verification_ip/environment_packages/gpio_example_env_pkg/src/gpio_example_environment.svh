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
// Unit            : Environment
// File            : gpio_example_environment.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This class contains the agent used with the GPIO interface
//    as an example of using the GPIO package.  The GPIO is fully
//    parameterized.  The parameters defined at the test level are used
//    to parameterize the configuration, environment, interface and 
//    sequences used with the GPIO.
//
//----------------------------------------------------------------------
//
class gpio_example_environment  #(int READ_PORT_WIDTH=4, int WRITE_PORT_WIDTH=4)
                                extends uvmf_environment_base 
                                #(.CONFIG_T(gpio_example_configuration #(READ_PORT_WIDTH, WRITE_PORT_WIDTH)));

  `uvm_component_param_utils( gpio_example_environment  #(READ_PORT_WIDTH, WRITE_PORT_WIDTH));

  typedef gpio_transaction #(READ_PORT_WIDTH, WRITE_PORT_WIDTH) gpio_example_transaction_t;
  
  typedef gpio_configuration #(READ_PORT_WIDTH, WRITE_PORT_WIDTH) gpio_example_config_t;
  
  typedef gpio_transaction_coverage #(READ_PORT_WIDTH, WRITE_PORT_WIDTH) gpio_example_transaction_coverage_t;
  
  typedef gpio_driver #(READ_PORT_WIDTH, WRITE_PORT_WIDTH) gpio_example_driver_t;
  
  typedef gpio_monitor #(READ_PORT_WIDTH, WRITE_PORT_WIDTH) gpio_example_monitor_t;

  typedef uvmf_parameterized_agent #(gpio_example_config_t, 
                                     gpio_example_driver_t, 
                                     gpio_example_monitor_t, 
                                     gpio_example_transaction_coverage_t, 
                                     gpio_example_transaction_t) gpio_agent_t;

  gpio_agent_t gpio_agent;

// ****************************************************************************
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

// ****************************************************************************
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    gpio_agent     = gpio_agent_t::type_id::create("gpio_agent",this);
  endfunction

endclass
