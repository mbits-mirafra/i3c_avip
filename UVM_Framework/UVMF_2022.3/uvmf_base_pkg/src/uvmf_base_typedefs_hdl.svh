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
// Unit            : Typedefs
// File            : uvmf_base_typedefs_hdl.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------


// FILE: uvmf_base_typedefs_hdl
// This is the type defs used by <uvmf_base_pkg_hdl>.
//
// TYPE: uvmf_sim_level_t
// The uvmf_sim_level_t enumeration defines simulation levels from SUB_BLOCK to SYSTEM.  It is used
// to define the simulation level for appropriately configuring the environment to enable block to
// top environment reuse without environment modification.
typedef enum {NA, SUB_BLOCK, BLOCK, SUB_MODULE, MODULE, SUB_CHIP, CHIP, CIRCUIT_CARD, SYSTEM} uvmf_sim_level_t;

// TYPE: uvmf_active_passive_t
// Parameterized agent active/passive configuration
typedef enum {ACTIVE, PASSIVE} uvmf_active_passive_t;

// TYPE: uvmf_master_slave_t
// BFM master/slave configuration (DEPRECATED)
typedef enum {SLAVE, MASTER} uvmf_master_slave_t;

// TYPE: uvmf_initiator_responder_t
// BFM initiator/responder configuration
typedef enum {RESPONDER, INITIATOR} uvmf_initiator_responder_t;

// TYPE: uvmf_parameterized_agent_configuration_base_s                                             
// Parameterized agent basic configuration as a (emulation-friendly) struct
typedef struct packed {
  uvmf_active_passive_t active_passive;
  uvmf_initiator_responder_t initiator_responder;
  bit                   has_coverage;
} uvmf_parameterized_agent_configuration_base_s;

// Parameters used for resource sharing within UVMF
parameter string UVMF_VIRTUAL_INTERFACES = "VIRTUAL_INTERFACES";
parameter string UVMF_BFM_REFERENCES     = UVMF_VIRTUAL_INTERFACES; // Temporary measure because uvmf_parameterized_configuration_base::::initialize 'hard-codes' use of UVMF_VIRTUAL_INTERFACES
parameter string UVMF_SEQUENCERS         = "SEQUENCERS";
parameter string UVMF_MONITORS           = "MONITORS";
parameter string UVMF_CONFIGURATIONS     = "CONFIGURATIONS";
parameter string UVMF_AGENT_CONFIG       = "AGENT_CONFIG";
parameter string UVMF_CLOCK_APIS         = "UVMF_CLOCK_APIS";
parameter string UVMF_RESET_APIS         = "UVMF_RESET_APIS";

parameter C_BIT_ARRAY_SIZE = 4096;
typedef bit [C_BIT_ARRAY_SIZE-1:0] c_bit_array_t;


