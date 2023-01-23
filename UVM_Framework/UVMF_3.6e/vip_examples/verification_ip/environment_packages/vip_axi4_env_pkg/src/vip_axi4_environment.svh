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
// Unit            : vip_axi4_environment
// File            : vip_axi4_environment.svh
//----------------------------------------------------------------------
// Created by      : student
// Creation Date   : 2014/11/03
//----------------------------------------------------------------------

// DESCRIPTION: This environment contains the following UVM components:
 // axi4_agent: Used to interface to the axi4 port on the DUT.

//
class vip_axi4_environment #(int AXI4_ADDRESS_WIDTH = 32,int AXI4_RDATA_WIDTH = 32,int AXI4_WDATA_WIDTH = 32,int AXI4_ID_WIDTH = 8,int AXI4_USER_WIDTH = 2,AXI4_REGION_MAP_SIZE = 16) 
extends uvmf_environment_base #(.CONFIG_T( vip_axi4_configuration#(AXI4_ADDRESS_WIDTH, AXI4_RDATA_WIDTH,AXI4_WDATA_WIDTH,AXI4_ID_WIDTH,AXI4_USER_WIDTH,AXI4_REGION_MAP_SIZE) ));

  `uvm_component_param_utils( vip_axi4_environment #(AXI4_ADDRESS_WIDTH,AXI4_RDATA_WIDTH,AXI4_WDATA_WIDTH,AXI4_ID_WIDTH,AXI4_USER_WIDTH,AXI4_REGION_MAP_SIZE ))

`ifndef QVIP_PRE_10_4_BACKWARD_COMPATIBLE
  typedef axi4_agent #(AXI4_ADDRESS_WIDTH,AXI4_RDATA_WIDTH,AXI4_WDATA_WIDTH,AXI4_ID_WIDTH,AXI4_USER_WIDTH,AXI4_REGION_MAP_SIZE) axi4_agent_t;
`else
  typedef mvc_agent axi4_agent_t;
`endif

  typedef axi4_vip_config #(AXI4_ADDRESS_WIDTH,AXI4_RDATA_WIDTH,AXI4_WDATA_WIDTH,AXI4_ID_WIDTH,AXI4_USER_WIDTH,AXI4_REGION_MAP_SIZE) vip_config_t;

  // The string variable that uniquely identifies the master virtual interface and sequencer in the uvm_config_db
  // Variable: axi4_master_agent
  // The <mvc_agent> for the master end of the <mgc_axi4> interface connected to the wires of the AXI4 protocol.
  axi4_agent_t axi4_master_agent;

  // Variable: axi4_slave_agent
  // The <mvc_agent> for the slave end of the <mgc_axi4> interface connected to the wires of the AXI4 protocol.
  axi4_agent_t axi4_slave_agent;
				
  // Variable: axi4_monitor_agent
  // The <mvc_agent> for the slave end of the <mgc_axi4> interface connected to the wires of the AXI4 protocol as a monitor.
  axi4_agent_t axi4_monitor_agent;

  vip_config_t m_master_config, m_slave_config, m_monitor_config;

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
//
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

// ****************************************************************************
// FUNCTION: build_phase()
// This function builds all components within this environment.
//
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    axi4_master_agent  = axi4_agent_t::type_id::create("axi4_master_agent",this);
    axi4_slave_agent   = axi4_agent_t::type_id::create("axi4_slave_agent",this);
    axi4_monitor_agent = axi4_agent_t::type_id::create("axi4_monitor_agent",this);

    axi4_master_agent.set_mvc_config(configuration.m_master_config);
    axi4_slave_agent.set_mvc_config(configuration.m_slave_config);
    axi4_monitor_agent.set_mvc_config(configuration.m_monitor_config);
  endfunction


// ****************************************************************************
// FUNCTION: end_of_elaboration_phase()
// This function makes all connections within this environment.  Connections
// typically inclue agent to predictor, predictor to scoreboard and scoreboard
// to agent.
//
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

  endfunction

// ****************************************************************************
// FUNCTION: connect_phase()
// This function makes all connections within this environment.  Connections
// typically inclue agent to predictor, predictor to scoreboard and scoreboard
// to agent.
//
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    uvm_config_db #( mvc_sequencer )::set( null , UVMF_SEQUENCERS , configuration.master_interface_name , axi4_master_agent.m_sequencer );
    uvm_config_db #( mvc_sequencer )::set( null , UVMF_SEQUENCERS , configuration.slave_interface_name  , axi4_slave_agent.m_sequencer );
    uvm_config_db #( mvc_sequencer )::set( null , UVMF_SEQUENCERS , configuration.monitor_interface_name, axi4_monitor_agent.m_sequencer );

  endfunction

endclass


