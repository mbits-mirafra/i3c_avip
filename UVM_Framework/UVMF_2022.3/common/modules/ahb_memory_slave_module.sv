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

`include "uvm_macros.svh"

module ahb_memory_slave_module(
                             HCLK,   
                             HRESETn,
                             HADDR,  
                             HTRANS, 
                             HWRITE, 
                             HSIZE,
                             HWDATA, 
                             HBURST,
                             HPROT,
                             HRDATA, 
                             HREADYi,
                             HREADYo,
                             HRESP,
                             HSPLIT
                           );

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

  input                            HCLK;
  input                            HRESETn;
  input  [(AHB_ADDRESS_WIDTH-1):0] HADDR;
  input  [1:0]                     HTRANS;
  input                            HWRITE;
  input  [2:0]                     HSIZE;
  input  [(AHB_WDATA_WIDTH-1):0]   HWDATA;
  input  [2:0]                     HBURST;
  input  [3:0]                     HPROT;
  output [(AHB_RDATA_WIDTH-1):0]   HRDATA;
  input                            HREADYi;
  output                           HREADYo;
  output [1:0]                     HRESP;
  output [(AHB_NUM_MASTERS - 1):0] HSPLIT;
 
  mgc_ahb            #(AHB_NUM_MASTERS, AHB_NUM_MASTER_BITS, AHB_NUM_SLAVES, 
                       AHB_ADDRESS_WIDTH, AHB_WDATA_WIDTH, AHB_RDATA_WIDTH) 
                      ahb_if (HCLK, HRESETn);

  assign HRDATA  = ahb_if.slave_HRDATA[AHB_SLAVE_INDEX];
  assign HREADYo = ahb_if.slave_HREADY[AHB_SLAVE_INDEX];

  assign HRESP   = ahb_if.slave_HRESP[AHB_SLAVE_INDEX];
  assign HSPLIT  = ahb_if.slave_HSPLIT[AHB_SLAVE_INDEX];

  assign  ahb_if.master_HADDR[AHB_SLAVE_INDEX]   = HADDR;
  assign  ahb_if.master_HTRANS[AHB_SLAVE_INDEX]  = HTRANS;
  assign  ahb_if.master_HWRITE[AHB_SLAVE_INDEX]  = HWRITE;
  assign  ahb_if.master_HSIZE[AHB_SLAVE_INDEX]   = HSIZE;
  assign  ahb_if.master_HBURST[AHB_SLAVE_INDEX]  = HBURST;
  assign  ahb_if.master_HPROT[AHB_SLAVE_INDEX]   = HPROT;
  assign  ahb_if.master_HWDATA[AHB_SLAVE_INDEX]  = HWDATA;

  assign ahb_if.decoder_HSEL[AHB_SLAVE_INDEX] = 1'b1;

`ifdef AHB_MEMORY_SLAVE_QVL_MONITOR

  qvl_ahb_target_monitor #(0, AHB_WDATA_WIDTH, 1, 0)  tar_mon_0
  (
    .hselx(ahb_if.slave_HSEL[AHB_SLAVE_INDEX]),
    .haddr(ahb_if.slave_HADDR[AHB_SLAVE_INDEX]),
    .hwrite(ahb_if.slave_HWRITE[AHB_SLAVE_INDEX]),
    .htrans(ahb_if.slave_HTRANS[AHB_SLAVE_INDEX]),
    .hsize(ahb_if.slave_HSIZE[AHB_SLAVE_INDEX]),
    .hburst(ahb_if.slave_HBURST[AHB_SLAVE_INDEX]),
    .hwdata(ahb_if.slave_HWDATA[AHB_SLAVE_INDEX]),
    .hresetn(ahb_if.HRESETn),
    .hclk(ahb_if.HCLK),
    .hmaster({3'b000, ahb_if.HMASTER}),
    .hmastlock(ahb_if.HMASTLOCK),
    .hready_in(ahb_if.HREADY),
    .hready_out(ahb_if.slave_HREADY[AHB_SLAVE_INDEX]),
    .hresp(ahb_if.slave_HRESP[AHB_SLAVE_INDEX]),
    .hrdata(ahb_if.slave_HRDATA[AHB_SLAVE_INDEX]),
    .hsplitx(ahb_if.slave_HSPLIT[AHB_SLAVE_INDEX]) 
  );

`endif

  assign ahb_if.master_HBUSREQ[AHB_SLAVE_INDEX] = 1;
  assign ahb_if.master_HLOCK[AHB_SLAVE_INDEX]   = 0;
  assign ahb_if.arbiter_HGRANT    = 1;
  assign ahb_if.arbiter_HGRANT    = 1;
  assign ahb_if.HMASTER           = 0;
  assign ahb_if.arbiter_HMASTLOCK = 0;

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
    string agent_name; // = $psprintf("%m");

    // ahb slave sequence that operates as a memory slave
    ahb_slave_sequence #(AHB_NUM_MASTERS, AHB_NUM_MASTER_BITS , 
                         AHB_NUM_SLAVES , AHB_ADDRESS_WIDTH , 
                         AHB_WDATA_WIDTH , AHB_RDATA_WIDTH ) slave_sequence;

  // *******************************************************************************
  // Task: initialize_slave(string name) 
  //    This task constructs and initializes the configuration.  The configuration
  //         is then made available to the agent.  The agent is also constructed in
  //         this task. The agent is made available to the rest of the simulation
  //         environment through the uvm_config_db.  The name of the agent is given
  //         as an argument to this task and must be unique to support multiple 
  //         instances of this module. For instance, using its hierarchical instance path.
  //         A slave sequence is then started on this agent's sequencer.
  //
  task initialize_slave(string name = "");
  begin
    // Set the (unique) string name of this agent
    if (name != "") agent_name = name;

    // Construct the agent
    memory_slave_agent = mvc_agent::type_id::create(agent_name, null);

    // Construct then initialize the slave configuration
    slave_config = slave_config_t::type_id::create("slave_config");
    slave_config.m_bfm = ahb_if;

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

    // Decoder is RTL
    slave_config.m_bfm.ahb_set_decoder_abstraction_level(1, 0);

    // RTL generates clock and reset        
    slave_config.m_bfm.ahb_set_clock_source_abstraction_level(0,1);
    slave_config.m_bfm.ahb_set_reset_source_abstraction_level(0,1);

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
    slave_sequence = new("ahb_slave_mem_sequence");
    slave_sequence.start(memory_slave_agent.m_sequencer);
  end
  endtask

endmodule
