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
// Unit            : Parameterized agent
// File            : uvmf_parameterized_agent.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------

// CLASS: uvmf_parameterized_agent
// This class defines an agent whose internal components are defined in its parameters.
// The configuration class defines the active/passive state of the agent and the presence
// of a coverage collection component in the agent.
//
// (see uvmf_parameterized_agent.jpg)
//
// PARAMETERS:
//   CONFIG_T   - The configuration class used for the agent/driver. This class must be 
//                derived from parameterized_agent_configiuration_base.
//
//   DRIVER_T   - The driver class to be used. This class must be derived from
//                uvmf_driver_base.
//
//   MONITOR_T  - The monitor class to be used. This class must be derived from
//                uvmf_monitor_base.
//
//   COVERAGE_T - The transaction coverage class to be used. This class must be
//                be derived from uvm_subscriber.
//
//   TRANS_T   - The transaction type. This is the sequence item used within the agent.
//               This class must be derived from uvmf_transaction_base.
//
// HOW TO:
// (start code)
//     - How to connect to the analysis port on this agent:
//       this_agent_instance_name.monitored_ap.connect(your_subscriber.analysis_export);
//
//     - If the configuration handle is null then this agent gets its configration from the 
//         uvm_config_db using the following:
//         scope:      The agents hierarchical path
//         field name: UVMF_AGENT_CONFIG
//
//     - This agent sets its sequencer in the uvm_config_db using the following if the agent is in active mode:
//         scope:      UVMF_SEQUENCERS
//         field name: The string name used to place the virtual interface used by this agent in the uvm_config_db
//
//     - To retrieve the sequencer from this agent:
//        uvm_config_db #( uvm_sequencer #(transaction_type_class) )::get( null , UVMF_SEQUENCERS ,
//                                             string_name_of_the_interface_in_uvm_config_db , sequencer_handle_to_be_populated )
// (end)

class uvmf_parameterized_agent #(
   type CONFIG_T,
   type DRIVER_T,
   type MONITOR_T,
   type COVERAGE_T,
   type TRANS_T,
   type SEQUENCER_T = uvm_sequencer#(TRANS_T),
   type BASE_T = uvm_agent
   ) extends BASE_T;

  // Register this component with the factory
  `uvm_component_param_utils(uvmf_parameterized_agent #(
     CONFIG_T,
     DRIVER_T,
     MONITOR_T,
     COVERAGE_T,
     TRANS_T,
     SEQUENCER_T
  ))

  // Instantiation of the components
  CONFIG_T    configuration;
  SEQUENCER_T sequencer;
  DRIVER_T    driver;
  MONITOR_T   monitor;
  COVERAGE_T  coverage;

  uvm_analysis_port #(TRANS_T) monitored_ap;

  // FUNCTION: new
  function new( string name = "", uvm_component parent = null );
     super.new( name, parent );
  endfunction: new

  // FUNCTION: set_config(CONFIG_T cfg)
  // This function can be used by the environment instantiating this 
  // agent to set the configuration handle instead of using the uvm_config_db.
  function void set_config(CONFIG_T cfg);
      this.configuration = cfg;
  endfunction

  // FUNCTION: build_phase
  virtual function void build_phase(uvm_phase phase);
     // agent_name used to create the name of the driver and monitor
     string agent_name;
     agent_name = get_name();

     // Agent configuration
     // Get the configuration for this agent from the uvm_config_db if not already set
     if ( configuration == null ) begin : config_null_check
        if( !uvm_config_db #( CONFIG_T )::get( this , "" , UVMF_AGENT_CONFIG ,  configuration ) ) begin : config_config_db_check
            $stacktrace;
            `uvm_fatal("CFG" , "uvm_config_db #( CONFIG_T )::get cannot find resource UVMF_AGENT_CONFIG" )
        end : config_config_db_check
     end : config_null_check

     // Monitor and analysis_port
     // Always construct a monitor and analysis_port regarless of active/passive configuration unless monitor handle already set
     if ( monitor == null ) begin : monitor_null_check
       if( !uvm_config_db #( MONITOR_T )::get( this , "" , UVMF_MONITORS ,  monitor ) ) begin : monitor_config_db_check
         monitor = MONITOR_T::type_id::create({agent_name,"_monitor"},this);
         monitor.set_config(configuration);
       end : monitor_config_db_check
     end : monitor_null_check
     if ( monitored_ap == null ) begin : monitored_ap_null_check
       monitored_ap=new("monitored_ap",this);
     end : monitored_ap_null_check

     // Coverage component
     // Construct a coverage collector if configured to do so
     if (configuration.has_coverage) begin : build_coverage
       coverage = COVERAGE_T::type_id::create({agent_name,"_coverage"},this);
     end : build_coverage

     // Sequencer
     // Construct a sequencer and driver only if agent is in active mode
     if (configuration.active_passive == ACTIVE) begin : is_active
       sequencer = SEQUENCER_T::type_id::create("sequencer",this);
       // Automatically place the agents sequencer in the uvm_config_db with the UVMF_SEQUENCERS scope using the
       // same field name as the driver bfm interface used by this agent.
       uvm_config_db #( SEQUENCER_T )::set( null , UVMF_SEQUENCERS , configuration.interface_name, sequencer );
       // Driver
       if ( driver == null ) begin : driver_null_check
         driver = DRIVER_T::type_id::create({agent_name,"_driver"},this);
         driver.set_config(configuration);
       end : driver_null_check
     end : is_active
  endfunction

  // FUNCTION: connect_phase
  virtual function void connect_phase(uvm_phase phase);
     super.connect_phase(phase);
     // Always connect the monitor to the analysis_port
     monitor.monitored_ap.connect(monitored_ap);
     // Connect the coverage block to the monitor if there is a coverage block
     if (configuration.has_coverage) begin : coverage_connection
       monitor.monitored_ap.connect(coverage.analysis_export);
     end : coverage_connection
     // Connect the driver to the sequencer if the agent is in passive mode
     if (configuration.active_passive == ACTIVE) begin : seq_drv_connection
        driver.seq_item_port.connect(sequencer.seq_item_export);
        driver.rsp_port.connect(sequencer.rsp_export);
     end : seq_drv_connection

  endfunction

endclass: uvmf_parameterized_agent
