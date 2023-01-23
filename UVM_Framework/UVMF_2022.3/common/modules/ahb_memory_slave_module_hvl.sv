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
// Project         : Self contained AHB memory slave
// Unit            : AHB Memory slave
// File            : ahb_memory_slave.svh
//----------------------------------------------------------------------
// Creation Date   : 01.09.2013
//----------------------------------------------------------------------
// Description: 
// This module is a self-contained MVC slave module for AHB. The user 
// can connect this module to an AHB bus and use it to stimulate the 
// bus for the slave side. 
//
// This module creates an AHB MVC interface and connects the interface 
// to the ports of the module.  It also creates the mvc_agent and the 
// ahb_vip_config for the agent.
//
// This module automatically starts the ahb_slave_sequence on the 
// sequencer in the agent to model memory slave behavior.
//
//----------------------------------------------------------------------
//

`include "mvc_macros.svh"

module ahb_memory_slave_module_hvl();

  import uvm_pkg::*;
  import mvc_pkg::*;
  import mgc_ahb_v2_0_pkg::*;

  parameter AHB_NUM_MASTERS     = 1;
  parameter AHB_NUM_MASTER_BITS = 1;
  parameter AHB_NUM_SLAVES      = 1;
  parameter AHB_ADDRESS_WIDTH   = 32;
  parameter AHB_WDATA_WIDTH     = 32;
  parameter AHB_RDATA_WIDTH     = 32;
  parameter AHB_SLAVE_INDEX     = 0;

  mgc_ahb_slave_hvl #(
    .NUM_MASTERS(AHB_NUM_MASTERS),
    .NUM_MASTER_BITS(AHB_NUM_MASTER_BITS),
    .NUM_SLAVES(AHB_NUM_SLAVES),
    .ADDRESS_WIDTH(AHB_ADDRESS_WIDTH),
    .WDATA_WIDTH(AHB_WDATA_WIDTH),
    .RDATA_WIDTH(AHB_RDATA_WIDTH),
    .VIP_IF_UVM_NAME(""/*VIP_AHB_BFM_SLV*/),
    .VIP_IF_UVM_CONTEXT(""/*UVMF_VIRTUAL_INTERFACES*/),
    .VIP_IF_HDL_PATH("hdl_top.DUT.slave")
  ) slave ();


  // Sequence item types to be broadcasted from the analysis_port on the slave agent
   typedef ahb_slave_slave_control_phase #(AHB_NUM_MASTERS, AHB_NUM_MASTER_BITS, 
                                           AHB_NUM_SLAVES, AHB_ADDRESS_WIDTH, 
                                           AHB_WDATA_WIDTH, AHB_RDATA_WIDTH) slave_control_ph_t;

   typedef ahb_slave_slave_response_phase #(AHB_NUM_MASTERS, AHB_NUM_MASTER_BITS, 
                                           AHB_NUM_SLAVES, AHB_ADDRESS_WIDTH, 
                                           AHB_WDATA_WIDTH, AHB_RDATA_WIDTH) slave_response_ph_t;

   typedef ahb_slave_slave_rd_data_phase #(AHB_NUM_MASTERS, AHB_NUM_MASTER_BITS, 
                                           AHB_NUM_SLAVES, AHB_ADDRESS_WIDTH, 
                                           AHB_WDATA_WIDTH, AHB_RDATA_WIDTH) slave_rd_data_phase_t;

   typedef ahb_slave_slave_wr_data_phase #(AHB_NUM_MASTERS, AHB_NUM_MASTER_BITS, 
                                           AHB_NUM_SLAVES, AHB_ADDRESS_WIDTH, 
                                           AHB_WDATA_WIDTH, AHB_RDATA_WIDTH) slave_wr_data_phase_t;

   typedef ahb_slave_slave_hsplit_cycle #(AHB_NUM_MASTERS, AHB_NUM_MASTER_BITS, 
                                           AHB_NUM_SLAVES, AHB_ADDRESS_WIDTH, 
                                           AHB_WDATA_WIDTH, AHB_RDATA_WIDTH) slave_split_cycle_t;

    // Slave configuration
    typedef ahb_vip_config   #(AHB_NUM_MASTERS, AHB_NUM_MASTER_BITS, 
                               AHB_NUM_SLAVES, AHB_ADDRESS_WIDTH, 
                               AHB_WDATA_WIDTH, AHB_RDATA_WIDTH) slave_config_t;

    slave_config_t slave_config;

    // Slave agent
    mvc_agent memory_slave_agent;

    // String name of the slave agent
    // The path to this module is used to ensure name uniqueness if there are 
    //     multiple instances of this module.
    string agent_name; // = $psprintf("%m");

    // ahb slave sequence that operates as a memory slave
    ahb_slave_sequence #(AHB_NUM_MASTERS, AHB_NUM_MASTER_BITS , 
                         AHB_NUM_SLAVES , AHB_ADDRESS_WIDTH , 
                         AHB_WDATA_WIDTH , AHB_RDATA_WIDTH ) slave_sequence;

  // *******************************************************************************
  // Task: initialize() 
  //    This task constructs and initializes the configuration.  The configuration
  //         is then made available to the agent.  The agent is also constructed in
  //         this task. The agent is made available to the rest of the simulation
  //         environment through the uvm_config_db.  The name of the agent is given
  //         as an argument to this task and must be unique to support multiple 
  //         instances of this module. For instance, using its hierarchical instance path.
  //         A slave sequence is then started on this agent's sequencer.
  //
  task initialize(string name = "");
  begin
    // Set the (unique) string name of this agent
    if (name != "") agent_name = name;

    // Construct the agent
    memory_slave_agent = mvc_agent::type_id::create(agent_name, null);

    // Construct then initialize the slave configuration
    slave_config = slave_config_t::type_id::create("slave_config");
`ifndef XRTL
    slave_config.m_bfm = hdl_top.DUT.slave.vip_if;
`else
    slave_config.m_bfm = slave.vip_if;
`endif

    // Master is RTL
     for(int i=0; i< AHB_NUM_MASTERS; i++)
      slave_config.m_bfm.ahb_set_master_abstraction_level(i, 1, 0);

    // Master is RTL, slave is TLM
    for(int i=0; i< AHB_NUM_SLAVES; i++)
      slave_config.m_bfm.ahb_set_slave_abstraction_level(i, 0, 1);
    // Set the structural index for master
    slave_config.set_structural_index(AHB_SLAVE_INDEX);

    // Arbiter is RTL
    slave_config.m_bfm.ahb_set_arbiter_abstraction_level(1, 0);

    // RTL generates clock and reset        
    slave_config.m_bfm.ahb_set_clock_source_abstraction_level(0,1);
    slave_config.m_bfm.ahb_set_reset_source_abstraction_level(0,1);

		slave_config.m_bfm.set_config_slave_start_address_range_index1(0, 0);
		slave_config.m_bfm.set_config_slave_end_address_range_index1(0,1023);

    // Add analysis ports for prediction, scoreboarding, and coverage
    void '(slave_config.set_monitor_item( "control_ph" ,  slave_control_ph_t::type_id::get() ));
    void '(slave_config.set_monitor_item( "response_ph" , slave_response_ph_t::type_id::get() ));
    void '(slave_config.set_monitor_item( "rd_data_ph" ,  slave_rd_data_phase_t::type_id::get() ));
    void '(slave_config.set_monitor_item( "wr_data_ph" ,  slave_wr_data_phase_t::type_id::get() ));
    void '(slave_config.set_monitor_item( "split_cycle" , slave_split_cycle_t::type_id::get() ));

    // Make the configuration available to the agent through the uvm_config_db
    uvm_config_db#(uvm_object)::set(null, {agent_name,"*"},mvc_config_base_id, slave_config);

    // Make the agent available to other UVM Environments for prediction and scoreboarding
    uvm_config_db #(mvc_agent)::set(null, "*", agent_name, memory_slave_agent);
    `uvm_info("CFG", 
             {"mvc_agent placed in uvm_config_db using field_name:",agent_name},UVM_MEDIUM)

    // Allow time sufficient to ensure environment is constructed then construct and start slave sequence
    repeat (2) slave_config.wait_for_clock();
    slave_sequence = new("slave_seq");
    slave_sequence.start(memory_slave_agent.m_sequencer);
  end
  endtask

endmodule
