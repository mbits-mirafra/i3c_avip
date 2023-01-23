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
// Project         : alu_in to WB Simulation Bench
// Unit            : Sequence base
// File            : alu_sequence_base.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: this class defines the base top level sequence used
//    for alu_in to wb block level simulations. It is used as the top
//    level sequence for test_top. It is extended to create
//    specific test scenarios.
//
//----------------------------------------------------------------------
//
//
class alu_sequence_base extends uvm_sequence #(uvm_sequence_item);

  `uvm_object_utils( alu_sequence_base );

  uvm_sequencer #(alu_in_transaction) alu_in_sequencer;

  alu_in_configuration alu_in_config;

// ****************************************************************************
  function new( string name = "" );
     super.new( name );

    if( !uvm_config_db #( uvm_sequencer #(alu_in_transaction) )::get( null , UVMF_SEQUENCERS , ALU_IN_BFM , alu_in_sequencer ) )
            `uvm_error("CFG" , "uvm_config_db #( uvm_sequencer#(alu_in_mem_slave_transaction) )::get cannot find resource alu_in_sequencer" )
    if( !uvm_config_db #( alu_in_configuration )::get( null ,UVMF_CONFIGURATIONS, ALU_IN_BFM, alu_in_config ) )
            `uvm_error("CFG" , "uvm_config_db #( alu_in_configuration )::get cannot find resource alu_in_config" )

  endfunction

endclass
