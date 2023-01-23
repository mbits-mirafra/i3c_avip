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
// Project         : UVMF_Templates
// Unit            : qvip_axi4_bench_test_pkg
// File            : qvip_axi4_bench_test_pkg.svh
//----------------------------------------------------------------------
// Created by      : student
// Creation Date   : 2014/11/03
//----------------------------------------------------------------------

// DESCRIPTION: This package contains all tests currently written for
//     the simulation project.  Once compiled, any test can be selected
//     from the vsim command line using +UVM_TESTNAME=yourTestNameHere
//
// CONTAINS:
//     -<test_top>
//     -<example_derived_test.svh>
//
package qvip_axi4_bench_test_pkg;

   import uvm_pkg::*;
   
   import uvmf_base_pkg::*;
   import qvip_axi4_bench_parameters_pkg::*;
   import vip_axi4_env_pkg::*;
   import qvip_axi4_bench_sequences_pkg::*;
   `include "uvm_macros.svh"

typedef vip_axi4_configuration #(TEST_AXI4_ADDRESS_WIDTH, TEST_AXI4_RDATA_WIDTH,TEST_AXI4_WDATA_WIDTH,TEST_AXI4_ID_WIDTH,TEST_AXI4_USER_WIDTH,TEST_AXI4_REGION_MAP_SIZE) vip_axi4_configuration_t;
typedef vip_axi4_environment   #(TEST_AXI4_ADDRESS_WIDTH, TEST_AXI4_RDATA_WIDTH,TEST_AXI4_WDATA_WIDTH,TEST_AXI4_ID_WIDTH,TEST_AXI4_USER_WIDTH,TEST_AXI4_REGION_MAP_SIZE) vip_axi4_environment_t;
typedef qvip_axi4_bench_sequence_base #(TEST_AXI4_ADDRESS_WIDTH, TEST_AXI4_RDATA_WIDTH,TEST_AXI4_WDATA_WIDTH,TEST_AXI4_ID_WIDTH,TEST_AXI4_USER_WIDTH,TEST_AXI4_REGION_MAP_SIZE) qvip_axi4_bench_sequence_base_t;
typedef example_derived_test_sequence #(TEST_AXI4_ADDRESS_WIDTH, TEST_AXI4_RDATA_WIDTH,TEST_AXI4_WDATA_WIDTH,TEST_AXI4_ID_WIDTH,TEST_AXI4_USER_WIDTH,TEST_AXI4_REGION_MAP_SIZE) example_derived_test_sequence_t;

   `include "src/test_top.svh"
   `include "src/example_derived_test.svh"

endpackage

