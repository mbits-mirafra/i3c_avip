//----------------------------------------------------------------------
//   Copyright 2020 Mentor Graphics Corporation
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
// Project         : QVIP Agent Adapter
// Unit            : Adapter component
// File            : qvip_agent_adapter.svh
//----------------------------------------------------------------------
// Creation Date   : 15.21.2013
//----------------------------------------------------------------------
// Description: This class instantiates the QVIP protocol-specific agent and
//   provides translation from QVIP sequence_items to custom sequence_items.
//   The translation is performed by the translator component.  This
//   component is derived from the uvmf_predictor_base class in the uvmf_base_pkg
//   library.  The translator class is identified to the agent adapter
//   class through a parameter on the agent adapter class.  This adapter
//   automatically connects the translator to all analysis ports on the
//   mvc_agent.  The analysis port on the translator is available for 
//   connection to subscribers in the environment.
//
//   Parameters used:
//      Name                type   default               Description
//      USE_EXTERNAL_AGENT  bit    0                     Set when mvc_agent is external 
//                                                       to this component.
//      EXTERNAL_AGENT_NAME string "no_name"             Value used by uvm_config_db
//                                                       to retrieve the handle to 
//                                                       the external agent.
//      AGENT_TYPE          type   mvc_agent             The class type that provides 
//                                                       for specification of the 
//                                                       QVIP protocol-specific agent
//      TRANSLATOR_TYPE     type   uvmf_predictor_base   The class type that provides
//                                                       the translation from QVIP
//                                                       sequence_item types to 
//                                                       custom sequence_item types.
//      TRANSACTION_TYPE    type   uvmf_transaction_base The transaction type
//                                                       broadcasted from the agent
//                                                       adapters analysis_port.
//
//   Connecting to this agent adapter:
//      Connect to the analysis_port named monitored_ap.
//      Connect using to this component using the following command:
// instance_name_of_this_object.monitored_ap.connect(instance_name_of_subscriber.analysis_export);
//
//----------------------------------------------------------------------
class qvip_agent_adapter #(bit    USE_EXTERNAL_AGENT=0,
                           string EXTERNAL_AGENT_NAME="no_name",
                           type   AGENT_TYPE=mvc_agent,
                           type   TRANSLATOR_TYPE=uvmf_predictor_base#(uvm_transaction,uvm_transaction),
                           type   TRANSACTION_TYPE=uvmf_transaction_base)
                           extends uvm_component;

  `uvm_component_param_utils( qvip_agent_adapter #( USE_EXTERNAL_AGENT,
                                                    EXTERNAL_AGENT_NAME,
                                                    AGENT_TYPE,
                                                    TRANSLATOR_TYPE,
                                                    TRANSACTION_TYPE));

   AGENT_TYPE      qvip_agent;

   TRANSLATOR_TYPE translator;

   typedef uvm_analysis_port #(TRANSACTION_TYPE) analysis_port_t;
   analysis_port_t monitored_ap;

// ****************************************************************************
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

// ****************************************************************************
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if ( USE_EXTERNAL_AGENT ) 
       if( !uvm_config_db #(AGENT_TYPE)::get( null,"*",EXTERNAL_AGENT_NAME,qvip_agent))
           `uvm_error("CFG" , {"uvm_config_db #(AGENT_TYPE)::get cannot find resource",EXTERNAL_AGENT_NAME})
       else
           `uvm_info("CFG" , {"uvm_config_db #(AGENT_TYPE)::get found resource",EXTERNAL_AGENT_NAME},UVM_MEDIUM)
    else
       qvip_agent = AGENT_TYPE::type_id::create("qvip_agent",this);

    translator    = TRANSLATOR_TYPE::type_id::create("translator",this);
    monitored_ap  = new("monitored_ap",this);

  endfunction

// ****************************************************************************
  virtual function void connect_phase(uvm_phase phase);
    string agent_ap_name;

    super.connect_phase(phase);

    // Connect all mvc_agent analysis ports to the translator
    // If a first analysis_port exists then connect to it and parse all other
    // analysis_ports.
    if ( qvip_agent.ap.first(agent_ap_name) ) begin
       qvip_agent.ap[agent_ap_name].connect(translator.analysis_export);
       while ( qvip_agent.ap.next(agent_ap_name) ) begin
          qvip_agent.ap[agent_ap_name].connect(translator.analysis_export);
       end
    end

    // Connect analysis_port between translator and agent adapter analysis_port
    translator.transformed_result_analysis_port.connect(monitored_ap);

  endfunction

endclass
