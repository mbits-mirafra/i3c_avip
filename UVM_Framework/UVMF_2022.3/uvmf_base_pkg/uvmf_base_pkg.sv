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
// Unit            : Base class library
// File            : uvmf_base_hvl_pkg.sv
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------



// PACKAGE: uvmf_base_pkg
// This package contains classes used as a base class library. It facilitates
// component level reuse and environment level reuse.  This package is used
// when using Veloce.  It contains the classes that are compiled for use on
// the host server.  The uvmf_base_hdl_pkg contains the types compiled for
// use on Veloce.
//
// CONTAINS:
//    - <uvmf_standard_port_debug_policy>
//    - <uvmf_standard_port_debug_policy>
//    - <uvmf_analysis_debug>
//    - <uvmf_base_hdl_typedefs>
//    - <uvmf_base_hvl_typedefs>
//    - <uvmf_transaction_base>
//    - <uvmf_scoreboard_base>
//    - <uvmf_in_order_scoreboard>
//    - <uvmf_in_order_race_scoreboard>
//    - <uvmf_out_of_order_scoreboard>
//    - <uvmf_in_order_scoreboard_array>
//    - <uvmf_catapult_scoreboard>
//    - <uvmf_predictor_base>
//    - <uvmf_sorting_predictor_base>
//    - <uvmf_parameterized_agent_configuration_base>
//    - <uvmf_driver_base>
//    - <uvmf_monitor_base>
//    - <uvmf_parameterized_agent>
//    - <uvmf_parameterized_simplex_environment>
//    - <uvmf_parameterized_1agent_environment>
//    - <uvmf_parameterized_2agent_environment>
//    - <uvmf_parameterized_3agent_environment>
//    - <uvmf_test_base>


package uvmf_base_pkg;

   import uvm_pkg::*;
   import uvmf_base_pkg_hdl::*;
   `include "uvm_macros.svh"

   `uvm_analysis_imp_decl(_expected)
   `uvm_analysis_imp_decl(_actual)

   //export uvmf_base_pkg_hdl::*;
   export uvmf_base_pkg_hdl::uvmf_sim_level_t;
   export uvmf_base_pkg_hdl::NA;
   export uvmf_base_pkg_hdl::SUB_BLOCK;
   export uvmf_base_pkg_hdl::BLOCK;
   export uvmf_base_pkg_hdl::SUB_MODULE;
   export uvmf_base_pkg_hdl::MODULE;
   export uvmf_base_pkg_hdl::SUB_CHIP;
   export uvmf_base_pkg_hdl::CHIP;
   export uvmf_base_pkg_hdl::CIRCUIT_CARD;
   export uvmf_base_pkg_hdl::SYSTEM;
   export uvmf_base_pkg_hdl::uvmf_active_passive_t;
   export uvmf_base_pkg_hdl::ACTIVE;
   export uvmf_base_pkg_hdl::PASSIVE;
   export uvmf_base_pkg_hdl::uvmf_master_slave_t;
   export uvmf_base_pkg_hdl::MASTER;
   export uvmf_base_pkg_hdl::SLAVE;
   export uvmf_base_pkg_hdl::INITIATOR;
   export uvmf_base_pkg_hdl::RESPONDER;
   export uvmf_base_pkg_hdl::UVMF_VIRTUAL_INTERFACES;
   export uvmf_base_pkg_hdl::UVMF_BFM_REFERENCES;
   export uvmf_base_pkg_hdl::UVMF_SEQUENCERS;
   export uvmf_base_pkg_hdl::UVMF_MONITORS;
   export uvmf_base_pkg_hdl::UVMF_CONFIGURATIONS;
   export uvmf_base_pkg_hdl::UVMF_AGENT_CONFIG;
   export uvmf_base_pkg_hdl::UVMF_CLOCK_APIS;
   export uvmf_base_pkg_hdl::UVMF_RESET_APIS;

   // UVMF Version Banner Class
   `include "src/uvmf_version.svh"

   // Utility classes  (commented out for P1800.2)
   //`include "src/uvmf_standard_port_debug_policy.svh"
   //`include "src/uvmf_analysis_debug.svh"

   // Transaction base class
   `include "src/uvmf_base_typedefs.svh"
   `include "src/uvmf_transaction_base.svh"
   `include "src/uvmf_sequence_base.svh"

   // Scoreboard base classes
   `include "src/uvmf_scoreboard_base.svh"
   `include "src/uvmf_in_order_scoreboard.svh"
   `include "src/uvmf_in_order_race_scoreboard.svh"
   `include "src/uvmf_in_order_race_scoreboard_array.svh"
   `include "src/uvmf_out_of_order_scoreboard.svh"
   `include "src/uvmf_out_of_order_race_scoreboard.svh"
   `include "src/uvmf_in_order_scoreboard_array.svh"
   `include "src/uvmf_catapult_scoreboard.svh"

   // Predictor base classes
   `include "src/uvmf_predictor_base.svh"
   `include "src/uvmf_sorting_predictor_base.svh"

   // Parameterized agent and related base classes
   `include "src/uvmf_parameterized_agent_configuration_base.svh"
   `include "src/uvmf_driver_base.svh"
   `include "src/uvmf_monitor_base.svh"
   `include "src/uvmf_parameterized_agent.svh"

   // Parameterized environments
   `include "src/uvmf_virtual_sequencer_base.svh"
   `include "src/uvmf_virtual_sequence_base.svh"
   `include "src/uvmf_environment_configuration_base.svh"
   `include "src/uvmf_environment_base.svh"
   `include "src/uvmf_parameterized_simplex_environment.svh"
   `include "src/uvmf_parameterized_1agent_environment.svh"
   `include "src/uvmf_parameterized_2agent_environment.svh"
   `include "src/uvmf_parameterized_3agent_environment.svh"

   // Test base class
   `include "src/uvmf_test_base.svh"

endpackage : uvmf_base_pkg
