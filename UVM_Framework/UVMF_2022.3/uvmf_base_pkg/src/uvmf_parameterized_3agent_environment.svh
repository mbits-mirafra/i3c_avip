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
// Unit            : Parameterized 3 agent Environment
// File            : uvmf_parameterized_3agent_environment.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------

// CLASS: uvmf_parameterized_3agent_environment
// This class defines a parameterized 3 agent environment. This environment
// supports designs where data flows in any direction between port A and B0
// as well as between port A and B1
//
// (see uvmf_parameterized_2agent_env.jpg)
//
// PARAMETERS:
//    CONFIG_T           - Environment configuration type.
//                         Must be derived from uvmf_environment_base.
//
//    A_AGENT_T          - Interface A agent type.
//                         This agent should be derived from agent_wrapper.
//
//    B0_AGENT_T         - Interface B0 agent type.
//                         This agent should be derived from agent_wrapper.
//
//    B1_AGENT_T         - Interface B1 agent type.
//                         This agent should be derived from agent_wrapper.
//
//    A_PREDICTOR_T      - Predictor for transactions moving between interface A and interface B0 and/or B1.
//                         This predictor should be derived from uvmf_sorting_predictor_base.
//                         Port 0 transactions go the the expected side of the A2B scoreboard.
//                         Port 1 transactions go the the actual side of the B2A scoreboard.
//
//    B0_PREDICTOR_T     - Predictor for transactions moving between interface B0 and interface A.
//                         This predictor should be derived from uvmf_sorting_predictor_base.
//                         Port 0 transactions go the the expected side of the A2B scoreboard.
//                         Port 1 transactions go the the actual side of the B2A scoreboard.
//
//    B1_PREDICTOR_T     - Predictor for transactions moving between interface B1 and interface A.
//                         This predictor should be derived from uvmf_sorting_predictor_base.
//                         Port 0 transactions go the the expected side of the A2B scoreboard.
//                         Port 1 transactions go the the actual side of the B2A scoreboard.
//
//    A2B_SCOREBOARD_T   - Scoreboard for transactions moving from interface A to interface B0 and/or B1.
//                         This predictor should be derived from uvmf_scoreboard_base.
//
//    B2A_SCOREBOARD_T   - Scoreboard for transactions moving from interface B0 and/or B1 to interface A.
//                         This predictor should be derived from uvmf_scoreboard_base.
//
//    USE_GPIO_AGENT     - Bit flag that indicates use of gpio agent.
//
//    GPIO_AGENT_T       - Agent used for GPIO
//                         .USE_GPIO_AGENT(1),
//                         .GPIO_AGENT_T(my_gpio_agent_t),

class uvmf_parameterized_3agent_environment #(
   type CONFIG_T,
   type A_AGENT_T,
   type B0_AGENT_T,
   type B1_AGENT_T,
   type A_PREDICTOR_T,
   type B0_PREDICTOR_T,
   type B1_PREDICTOR_T,
   type A2B_SCOREBOARD_T,
   type B2A_SCOREBOARD_T,
   // Use default values for the GPIO parameters below as these would not always be used:
   bit  USE_GPIO_AGENT = 0,
   type GPIO_AGENT_T = A_AGENT_T
) extends uvmf_environment_base #(CONFIG_T);

  // Register the class with the factory
  `uvm_component_param_utils( uvmf_parameterized_3agent_environment #( A_AGENT_T,
     CONFIG_T,
     B0_AGENT_T,
     B1_AGENT_T,
     A_PREDICTOR_T,
     B0_PREDICTOR_T,
     B1_PREDICTOR_T,
     A2B_SCOREBOARD_T,
     B2A_SCOREBOARD_T,
     USE_GPIO_AGENT,
     GPIO_AGENT_T)
  )

  // Instantiate the compnonents

  GPIO_AGENT_T     gpio_agent;

  A_AGENT_T        a_agent;
  B0_AGENT_T       b0_agent;
  B1_AGENT_T       b1_agent;

  A_PREDICTOR_T    a_predictor;
  B0_PREDICTOR_T   b0_predictor;
  B1_PREDICTOR_T   b1_predictor;

  A2B_SCOREBOARD_T a2b_scoreboard;
  B2A_SCOREBOARD_T b2a_scoreboard;


  // FUNCTION: new
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

  // FUNCTION: build_phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if ( USE_GPIO_AGENT )
       gpio_agent  = GPIO_AGENT_T::type_id::create("gpio_agent",this);

    a_agent   = A_AGENT_T::type_id::create("a_agent",this);
    b0_agent  = B0_AGENT_T::type_id::create("b0_agent",this);
    b1_agent  = B1_AGENT_T::type_id::create("b1_agent",this);

    a_predictor  = A_PREDICTOR_T::type_id::create("a_predictor", this);
    b0_predictor  = B0_PREDICTOR_T::type_id::create("b0_predictor", this);
    b1_predictor  = B1_PREDICTOR_T::type_id::create("b1_predictor", this);

    a2b_scoreboard = A2B_SCOREBOARD_T::type_id::create("a2b_scoreboard", this);
    b2a_scoreboard = B2A_SCOREBOARD_T::type_id::create("b2a_scoreboard", this);

  endfunction : build_phase

  // FUNCTION: connect_phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect the analysis port of agent a to the a2b predictor
    a_agent.monitored_ap.connect(a_predictor.analysis_export);
    // Connect port 0 of the a sorting predictor to the expected port of the a2b scoreboard
    a_predictor.port_0_ap.connect(a2b_scoreboard.expected_analysis_export);
    // Connect port 1 of the a2b sorting predictor to the actual port of the b2a scoreboard
    a_predictor.port_1_ap.connect(b2a_scoreboard.actual_analysis_export);

    // Connect the analysis port of agent b to the b0 predictor
    b0_agent.monitored_ap.connect(b0_predictor.analysis_export);
    // Connect port 0 of the b0 sorting predictor to the actual port of the a2b scoreboard
    b0_predictor.port_0_ap.connect(a2b_scoreboard.actual_analysis_export);
    // Connect port 1 of the b0 sorting predictor to the expected port of the b2a scoreboard
    b0_predictor.port_1_ap.connect(b2a_scoreboard.expected_analysis_export);

    // Connect the analysis port of agent b to the b1 predictor
    b1_agent.monitored_ap.connect(b1_predictor.analysis_export);
    // Connect port 0 of the b1 sorting predictor to the actual port of the a2b scoreboard
    b1_predictor.port_0_ap.connect(a2b_scoreboard.actual_analysis_export);
    // Connect port 1 of the b1 sorting predictor to the expected port of the b2a scoreboard
    b1_predictor.port_1_ap.connect(b2a_scoreboard.expected_analysis_export);

  endfunction : connect_phase

endclass : uvmf_parameterized_3agent_environment
