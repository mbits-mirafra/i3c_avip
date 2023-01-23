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
// Unit            : Environment
// File            : ahb2wb_environment.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This class defines the ahb to wb environment.  It 
//    instantiates the ahb agent, wb agent, predictor and scoreboard.
//    It utilizes the parameterized bidirectional environment.
//
//----------------------------------------------------------------------
//


  typedef ahb2wb_predictor #(ahb_transaction, wb_transaction, ahb_transaction) ahb2wb_predictor_t;
  typedef wb2ahb_predictor #(wb_transaction, wb_transaction, ahb_transaction)  wb2ahb_predictor_t;

  typedef uvmf_in_order_scoreboard #(wb_transaction)  ahb2wb_scoreboard_t;
  typedef uvmf_in_order_scoreboard #(ahb_transaction) wb2ahb_scoreboard_t;

  typedef uvmf_parameterized_2agent_environment #(
                                 .CONFIG_T(ahb2wb_configuration),
                                 .A_AGENT_T(ahb_agent_t),
                                 .B_AGENT_T(wb_agent_t),
                                 .A2B_PREDICTOR_T(ahb2wb_predictor_t),
                                 .B2A_PREDICTOR_T(wb2ahb_predictor_t),
                                 .A2B_SCOREBOARD_T(ahb2wb_scoreboard_t),
                                 .B2A_SCOREBOARD_T(wb2ahb_scoreboard_t)
                                 ) ahb2wb_environment;
