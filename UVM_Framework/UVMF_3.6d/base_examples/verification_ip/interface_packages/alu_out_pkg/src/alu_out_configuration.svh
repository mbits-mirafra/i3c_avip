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
// Project         : AHB interface agent
// Unit            : alu_out interface configuration
// File            : alu_out_configuration.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This class contains all variables and functions used
//      to configure the alu_out agent and its bfm's.  It makes the
//      bfm's available to the agent through the uvm_config_db.  The
//      configuration serves as a proxy to the tasks contained in the
//      bfm for the agent.  
//
//      Configuration utility function:
//             initialize:
//                   This function causes the configuration to retrieve
//                   its virtual interface handle from the uvm_config_db.
//                   This function also makes itself available to its
//                   agent through the uvm_config_db.
//
//                Arguments:
//                   uvmf_active_passive_t activity:
//                        This argument identifies the simulation level
//                        as either BLOCK, CHIP, SIMULATION, etc.
//
//                   agent_path:
//                        This argument identifies the path to this
//                        configurations agent.  This configuration
//                        makes itself available to the agent specified
//                        by agent_path by placing itself into the
//                        uvm_config_db.
//
//                   interface_name:
//                        This argument identifies the string name of
//                        this configuration's driver and monitor BFMs.
//                        This string name is used to retrieve these 
//                        BFMs from the uvm_config_db.
//
// ****************************************************************************
class alu_out_configuration extends uvmf_parameterized_agent_configuration_base#(
      .DRIVER_BFM_BIND_T(virtual alu_out_driver_bfm),
      .MONITOR_BFM_BIND_T(virtual alu_out_monitor_bfm)
      );

   `uvm_object_utils( alu_out_configuration )

// ****************************************************************************
  function new( string name = "" );
    super.new( name );
  endfunction

// ****************************************************************************
   virtual function void initialize(uvmf_active_passive_t activity,
                                         string agent_path,
                                         string interface_name);

    super.initialize( activity, agent_path, interface_name);

    uvm_config_db #( alu_out_configuration )::set( null ,agent_path,       UVMF_AGENT_CONFIG, this );
    uvm_config_db #( alu_out_configuration )::set( null ,UVMF_CONFIGURATIONS, interface_name, this );

   endfunction

// ****************************************************************************
   virtual task wait_for_reset();
      monitor_bfm.wait_for_reset();
   endtask

// ****************************************************************************
   virtual task wait_for_num_clocks(int clocks);
      monitor_bfm.wait_for_clk(clocks);
   endtask

endclass
