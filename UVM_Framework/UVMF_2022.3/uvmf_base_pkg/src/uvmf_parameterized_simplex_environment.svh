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
// Unit            : Parameterized Environment
// File            : uvmf_parameterized_simplex_environment.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------



// CLASS: uvmf_parameterized_simplex_environment
// This class defines a parameterized environment.  This environment
// supports designs where data flows in one direction.
//
// (see uvmf_parameterized_simplex_environment.jpg)
//
// PARAMETERS:
//    CONFIG_T       - Environment configuration type.
//                     Must be derived from uvmf_environment_base.
//
//    INPUT_AGENT_T  - Input interface agent type.
//                     Must be derived from uvmf_parameterized_agent.
//
//    OUTPUT_AGENT_T - Output interface agent type.
//                     Must be derived from uvmf_parameterized_agent.
//
//    PREDICTOR_T    - Predictor for transactions moving from input interface to
//                     output interface.
//                     Must be derived from uvmf_predictor_base.
//
//    SCOREBOARD_T   - Scoreboard for transactions moving from input interface to
//                     output interface.
//                     Must be derived from uvmf_scoreboard_base.
//
//    USE_GPIO_AGENT - Bit flag that indicates use of GPIO agent.
//
//    GPIO_AGENT_T   - GPIO agent type, if used.
//                     Must be derived from uvmf_parameterized_agent.
//
// EXAMPLE:
// (start code)
//  typedef uvmf_parameterized_agent #(my_input_configuration, my_input_driver_t, my_input_monitor_t, my_input_transaction_coverage_t, my_input_transaction) my_input_agent_t;
//  typedef uvmf_parameterized_agent #(my_output_configuration, my_output_driver_t, my_output_monitor_t, my_output_transaction_coverage_t, my_output_transaction) my_output_agent_t;
//  typedef uvmf_parameterized_agent #(my_gpio_configuration, my_gpio_driver_t, my_gpio_monitor_t, my_gpio_transaction_coverage_t, my_gpio_transaction) my_gpio_agent_t;
//
//  typedef my_predictor #(my_input_transaction, my_output_transaction, my_input_transaction) my_predictor_t;
//
//  typedef my_scoreboard #(my_output_transaction) my_scoreboard_t;
//
//  typedef uvmf_parameterized_simplex_environment #(
//                                 .CONFIG_T(my_environment_configuration_t),
//                                 .INPUT_AGENT_T(my_input_agent_t),
//                                 .OUTPUT_AGENT_T(my_output_agent_t),
//                                 .PREDICTOR_T(my_predictor_t),
//                                 .SCOREBOARD_T(my_scoreboard_t),
//                                 .USE_GPIO_AGENT(1),
//                                 .GPIO_AGENT_T(my_gpio_agent_t),
//                                 ) my_environment_t;
// (end)

class uvmf_parameterized_simplex_environment #(
   type CONFIG_T,
   type INPUT_AGENT_T,
   type OUTPUT_AGENT_T,
   type PREDICTOR_T,
   type SCOREBOARD_T,
   // Use default values for the GPIO parameters below as these would not always be used:
   bit  USE_GPIO_AGENT = 0,
   type GPIO_AGENT_T = INPUT_AGENT_T
) extends uvmf_environment_base #(CONFIG_T);

  // Register the class with the factory
  `uvm_component_param_utils( uvmf_parameterized_simplex_environment #(
     CONFIG_T,
     INPUT_AGENT_T,
     OUTPUT_AGENT_T,
     PREDICTOR_T,
     SCOREBOARD_T,
     USE_GPIO_AGENT,
     GPIO_AGENT_T
  ) );

  // Instantiate the components
  INPUT_AGENT_T   in_agent;

  OUTPUT_AGENT_T  out_agent;

  GPIO_AGENT_T    gpio_agent;

  PREDICTOR_T     predictor;

  SCOREBOARD_T    scoreboard;


// FUNCTION: new
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

// FUNCTION: build_phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    out_agent  = OUTPUT_AGENT_T::type_id::create("out_agent",this);
    in_agent   = INPUT_AGENT_T::type_id::create("in_agent",this);

    if ( USE_GPIO_AGENT )
       gpio_agent  = GPIO_AGENT_T::type_id::create("gpio_agent",this);

    predictor  = PREDICTOR_T::type_id::create("predictor", this);
    scoreboard = SCOREBOARD_T::type_id::create("scoreboard", this);

  endfunction

  // FUNCTION: connect_phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect the analysis port of the input agent to the predictor
    in_agent.monitored_ap.connect(predictor.analysis_export);
    // Connect the analysis port of the predictor to the expected side of the scoreboard
    predictor.transformed_result_analysis_port.connect(scoreboard.expected_analysis_export);

    // Connect the analysis port of the output agent to the actual side of the scoreboard
    out_agent.monitored_ap.connect(scoreboard.actual_analysis_export);

  endfunction

endclass : uvmf_parameterized_simplex_environment
