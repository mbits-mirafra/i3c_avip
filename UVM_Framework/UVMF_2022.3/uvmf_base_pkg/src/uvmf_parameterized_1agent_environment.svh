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
// Unit            : Parameterized Bi-directional Environment
// File            : uvmf_parameterized_1agent_environment.svh
//----------------------------------------------------------------------
// Creation Date   : 03.30.2015
//----------------------------------------------------------------------

// CLASS: uvmf_parameterized_1agent_environment
// This class defines a parameterized for use with designs with one 
// port.  Data flows into and out of the design through the port.
//
// (see uvmf_parameterized_1agent_environment.jpg)
//
// PARAMETERS:
//    CONFIG_T           - Environment configuration type.
//                         Must be derived from uvmf_environment_configuration_base.
//
//    AGENT_T            - Interface A agent type.
//                         This agent should be derived from uvmf_parameterized_agent.
//
//    PREDICTOR_T        - Predictor 
//                         This predictor should be derived from uvmf_sorting_predictor_base.
//                         Port 0 transactions go the the expected side of the scoreboard.
//                         Port 1 transactions go the the actual side of the scoreboard.
//
//    SCOREBOARD_T       - Scoreboard for comparing actual against expected transactions 
//                         This predictor should be derived from uvmf_scoreboard_base.
//
//    USE_GPIO_AGENT     - Bit flag that indicates use of gpio agent.
//
//    GPIO_AGENT_T       - Agent used for GPIO
//                         .USE_GPIO_AGENT(0),
//                         .GPIO_AGENT_T(my_gpio_agent_t),
//
//  CODE EXAMPLES:
// (start code)
//  typedef uvmf_parameterized_agent #(my_configuration, my_driver_t, my_monitor_t, my_transaction_coverage_t, my_transaction) my_agent_t;
//
//  typedef uvmf_parameterized_agent #(my_gpio_configuration, my_gpio_driver_t, my_gpio_monitor_t, my_gpio_transaction_coverage_t, my_gpio_transaction) my_gpio_agent_t;
//
//  typedef my_predictor #(my_transaction, my_transaction, my_transaction) my_predictor_t;
//
//  typedef my_scoreboard #(my_transaction) my_scoreboard_t;
//
//  typedef uvmf_parameterized_1agent_environment #(
//                                 .CONFIG_T(my_environment_configuration_t),
//                                 .AGENT_T(my_agent_t),
//                                 .PREDICTOR_T(my_predictor_t),
//                                 .SCOREBOARD_T(my_scoreboard_t)
//                                 .USE_GPIO_AGENT(0),
//                                 .GPIO_AGENT_T(my_gpio_agent_t),
//                                 ) my_environment_t;
// (end)

class uvmf_parameterized_1agent_environment #(
   type CONFIG_T,
   type AGENT_T,
   type PREDICTOR_T,
   type SCOREBOARD_T,
   // Use default values for the GPIO parameters below as these would not always be used:
   bit  USE_GPIO_AGENT = 0,
   type GPIO_AGENT_T = AGENT_T
) extends uvmf_environment_base #(CONFIG_T);

  // Register the class with the factory
  `uvm_component_param_utils( uvmf_parameterized_1agent_environment #(
     CONFIG_T,
     AGENT_T,
     PREDICTOR_T,
     SCOREBOARD_T,
     USE_GPIO_AGENT,
     GPIO_AGENT_T)
   )

  // Instantiate the compnonents
  AGENT_T         agent;

  PREDICTOR_T     predictor;

  SCOREBOARD_T    scoreboard;

  GPIO_AGENT_T    gpio_agent;

  // FUNCTION: new
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

  // FUNCTION: build_phase
  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    agent      = AGENT_T::type_id::create("agent",this);
    predictor  = PREDICTOR_T::type_id::create("predictor", this);
    scoreboard = SCOREBOARD_T::type_id::create("scoreboard", this);

    if ( USE_GPIO_AGENT )
       gpio_agent  = GPIO_AGENT_T::type_id::create("gpio_agent",this);

  endfunction : build_phase

  // FUNCTION: connect_phase
  virtual function void connect_phase(uvm_phase phase);

    super.connect_phase(phase);

    // Connect the analysis port of agent a to the predictor
    agent.monitored_ap.connect(predictor.analysis_export);

    // Connect port 0 of the sorting predictor to the expected port of the scoreboard
    predictor.port_0_ap.connect(scoreboard.expected_analysis_export);

    // Connect port 1 of the sorting predictor to the actual port of the scoreboard
    predictor.port_1_ap.connect(scoreboard.actual_analysis_export);

  endfunction : connect_phase

endclass : uvmf_parameterized_1agent_environment
