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
// Unit            : Environment
// File            : alu_environment.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This class defines the alu_out to alu_in environment.  It 
//    instantiates the alu_out agent, alu_in agent, predictor and scoreboard.
//
//----------------------------------------------------------------------
//
//  Define the predictor type
typedef alu_predictor #(alu_in_transaction, alu_out_transaction) alu_predictor_t;

//  Define the scoreboard type
`ifdef USE_VISTA
    // Use in_order_race in case Vista predictor is slower than the DUT
    typedef uvmf_in_order_race_scoreboard #(alu_out_transaction) alu_scoreboard_t;
`else
    typedef uvmf_in_order_scoreboard #(alu_out_transaction) alu_scoreboard_t;
`endif

//  Define the environment type which is instantiated by the test or a higher level environment
typedef    uvmf_parameterized_simplex_environment #( 
                       .CONFIG_T(alu_configuration),
                       .INPUT_AGENT_T(alu_in_agent_t),
                       .OUTPUT_AGENT_T(alu_out_agent_t),
                       .PREDICTOR_T(alu_predictor_t),
                       .SCOREBOARD_T(alu_scoreboard_t)
                       ) alu_environment;

