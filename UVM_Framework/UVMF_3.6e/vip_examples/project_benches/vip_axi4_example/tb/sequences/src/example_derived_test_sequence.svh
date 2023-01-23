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
// Unit            : QVIP AXI4 example
// File            : example_derived_test_sequence.svh
//----------------------------------------------------------------------
// Created by      : student
// Creation Date   : 2014/11/03
//----------------------------------------------------------------------

// DESCRIPTION: This file contains the top level sequence used in  example_derived_test.
// It is an example of a sequence that is extended from vip_axi4_bench_sequence_base
// and can override vip_axi4_bench_sequence_base.
//
class example_derived_test_sequence #(int AXI4_ADDRESS_WIDTH = 32, int AXI4_RDATA_WIDTH = 32,int AXI4_WDATA_WIDTH = 32,int AXI4_ID_WIDTH = 8,int AXI4_USER_WIDTH = 2,int AXI4_REGION_MAP_SIZE = 16) extends vip_axi4_bench_sequence_base #(AXI4_ADDRESS_WIDTH, AXI4_RDATA_WIDTH ,AXI4_WDATA_WIDTH ,AXI4_ID_WIDTH ,AXI4_USER_WIDTH ,AXI4_REGION_MAP_SIZE );

  `uvm_object_utils( example_derived_test_sequence );

  function new(string name = "" );
    super.new(name);
  endfunction

endclass

