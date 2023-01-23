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
// File            : uvmf_parameterized_2agent_environment.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------

// CLASS: uvmf_parameterized_2agent_environment
// This class defines a parameterized bi-directional environment. This environment
// supports designs where data flows in both directions: from port A to port B and
// from port B to port A.
//
// (see uvmf_parameterized_2agent_environment.jpg)
//
// PARAMETERS:
//    CONFIG_T           - Environment configuration type.
//                         Must be derived from uvmf_environment_base.
//
//    A_AGENT_T          - Interface A agent type.
//                         This agent should be derived from uvmf_parameterized_agent.
//
//    B_AGENT_T          - Interface B agent type.
//                         This agent should be derived from uvmf_parameterized_agent.
//
//    A2B_PREDICTOR_T    - Predictor for transactions moving from interface A to interface B.
//                         This predictor should be derived from uvmf_sorting_predictor_base.
//                         Port 0 transactions go the the expected side of the A2B scoreboard.
//                         Port 1 transactions go the the actual side of the B2A scoreboard.
//
//    B2A_PREDICTOR_T    - Predictor for transactions moving from interface B to interface A.
//                         This predictor should be derived from uvmf_sorting_predictor_base.
//                         Port 0 transactions go the the actual side of the A2B scoreboard.
//                         Port 1 transactions go the the expected side of the B2A scoreboard.
//
//    A2B_SCOREBOARD_T   - Scoreboard for transactions moving from interface A to interface B.
//                         This predictor should be derived from uvmf_scoreboard_base.
//
//    B2A_SCOREBOARD_T   - Scoreboard for transactions moving from interface B to interface A.
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
//  typedef uvmf_parameterized_agent #(my_a_configuration, my_a_driver_t, my_a_monitor_t, my_a_transaction_coverage_t, my_a_transaction) my_a_agent_t;
//  typedef uvmf_parameterized_agent #(my_b_configuration, my_b_driver_t, my_b_monitor_t, my_b_transaction_coverage_t, my_b_transaction) my_b_agent_t;
//
//  typedef uvmf_parameterized_agent #(my_gpio_configuration, my_gpio_driver_t, my_gpio_monitor_t, my_gpio_transaction_coverage_t, my_gpio_transaction) my_gpio_agent_t;
//
//  typedef my_a2b_predictor #(my_a_transaction, my_b_transaction, my_a_transaction) my_a2b_predictor_t;
//  typedef my_b2a_predictor #(my_b_transaction, my_b_transaction, my_a_transaction) my_b2a_predictor_t;
//
//  typedef my_scoreboard #(my_b_transaction) my_a2b_scoreboard_t;
//  typedef my_scoreboard #(my_a_transaction) my_b2a_scoreboard_t;
//
//  typedef uvmf_parameterized_2agent_environment #(
//                                 .CONFIG_T(my_environment_configuration_t),
//                                 .A_AGENT_T(my_a_agent_t),
//                                 .B_AGENT_T(my_b_agent_t),
//                                 .A2B_PREDICTOR_T(my_a2b_predictor_t),
//                                 .B2A_PREDICTOR_T(my_b2a_predictor_t),
//                                 .A2B_SCOREBOARD_T(my_a2b_scoreboard_t),
//                                 .B2A_SCOREBOARD_T(my_b2a_scoreboard_t)
//                                 .USE_GPIO_AGENT(0),
//                                 .GPIO_AGENT_T(my_gpio_agent_t),
//                                 ) my_environment_t;
// (end)

class uvmf_parameterized_2agent_environment #(
   type CONFIG_T,
   type A_AGENT_T,
   type B_AGENT_T,
   type A2B_PREDICTOR_T,
   type B2A_PREDICTOR_T,
   type A2B_SCOREBOARD_T,
   type B2A_SCOREBOARD_T,
   // Use default values for the GPIO parameters below as these would not always be used:
   bit  USE_GPIO_AGENT = 0,
   type GPIO_AGENT_T = A_AGENT_T
) extends uvmf_environment_base #(CONFIG_T);

  // Register the class with the factory
  `uvm_component_param_utils( uvmf_parameterized_2agent_environment #(
     CONFIG_T,
     A_AGENT_T,
     B_AGENT_T,
     A2B_PREDICTOR_T,
     B2A_PREDICTOR_T,
     A2B_SCOREBOARD_T,
     B2A_SCOREBOARD_T,
     USE_GPIO_AGENT,
     GPIO_AGENT_T)
   )

  // Instantiate the compnonents
  A_AGENT_T   a_agent;

  B_AGENT_T  b_agent;

  GPIO_AGENT_T    gpio_agent;

  A2B_PREDICTOR_T     a2b_predictor;
  B2A_PREDICTOR_T     b2a_predictor;

  A2B_SCOREBOARD_T    a2b_scoreboard;
  B2A_SCOREBOARD_T    b2a_scoreboard;

  // FUNCTION: new
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

  // FUNCTION: build_phase
  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    b_agent  = B_AGENT_T::type_id::create("b_agent",this);
    a_agent   = A_AGENT_T::type_id::create("a_agent",this);

    if ( USE_GPIO_AGENT )
       gpio_agent  = GPIO_AGENT_T::type_id::create("gpio_agent",this);

    a2b_predictor  = A2B_PREDICTOR_T::type_id::create("a2b_predictor", this);
    b2a_predictor  = B2A_PREDICTOR_T::type_id::create("b2a_predictor", this);

    a2b_scoreboard = A2B_SCOREBOARD_T::type_id::create("a2b_scoreboard", this);
    b2a_scoreboard = B2A_SCOREBOARD_T::type_id::create("b2a_scoreboard", this);

  endfunction : build_phase

  // FUNCTION: connect_phase
  virtual function void connect_phase(uvm_phase phase);

    super.connect_phase(phase);

    // Connect the analysis port of agent a to the a2b predictor
    a_agent.monitored_ap.connect(a2b_predictor.analysis_export);
    // Connect port 0 of the a2b sorting predictor to the expected port of the a2b scoreboard
    a2b_predictor.port_0_ap.connect(a2b_scoreboard.expected_analysis_export);
    // Connect port 1 of the a2b sorting predictor to the actual port of the b2a scoreboard
    a2b_predictor.port_1_ap.connect(b2a_scoreboard.actual_analysis_export);

    // Connect the analysis port of agent b to the b2a predictor
    b_agent.monitored_ap.connect(b2a_predictor.analysis_export);
    // Connect port 0 of the b2a sorting predictor to the actual port of the a2b scoreboard
    b2a_predictor.port_0_ap.connect(a2b_scoreboard.actual_analysis_export);
    // Connect port 1 of the b2a sorting predictor to the expected port of the b2a scoreboard
    b2a_predictor.port_1_ap.connect(b2a_scoreboard.expected_analysis_export);

  endfunction : connect_phase

endclass : uvmf_parameterized_2agent_environment
