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
// Project         : WB to SPI Environment Example
// Unit            : Environment.
// File            : wb2spi_environment.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This environment contains the following UVM components:
//     wb agent:  Used to interface to the WB port on the DUT.
//     spi agent: Used to interface to the SPI port on the DUT.
//     wb2spi predictor: Used to predict values expected from the DUT.
//     wb2spi scoreboard: Used to compare expected with actual
//         transactions from the DUT.
//
//----------------------------------------------------------------------
//
class wb2spi_environment extends uvmf_environment_base #(.CONFIG_T(wb2spi_configuration));

  `uvm_component_utils( wb2spi_environment );

  spi_agent_t spi_agent;

  wb_agent_t wb_agent;

  spi_mem_slave_transaction_coverage spi_mem_slave_coverage;
  spi_mem_slave_transaction_viewer spi_mem_slave_viewer;

  typedef wb2spi_predictor wb2spi_predictor_t;
  wb2spi_predictor_t wb2spi_predictor;

  typedef uvmf_in_order_scoreboard #(spi_transaction) wb2spi_scoreboard_t;
  wb2spi_scoreboard_t wb2spi_scoreboard;

  wb2reg_adapter      wb2reg_adaptr;
  wb2reg_predictor    wb2reg_predict;
  
  
// ****************************************************************************
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

// ****************************************************************************
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    spi_agent     = spi_agent_t::type_id::create("spi_agent",this);
    wb_agent      = wb_agent_t::type_id::create("wb_agent",this);

    spi_mem_slave_coverage = spi_mem_slave_transaction_coverage::type_id::create("spi_mem_slave_coverage",this);
    spi_mem_slave_viewer = spi_mem_slave_transaction_viewer::type_id::create("spi_mem_slave_viewer",this);
    spi_mem_slave_viewer.configuration = configuration.spi_config;

    wb2spi_predictor  = wb2spi_predictor_t::type_id::create("wb2spi_predictor", this);
    wb2spi_scoreboard = wb2spi_scoreboard_t::type_id::create("wb2spi_scoreboard", this);
    
    if (configuration.enable_reg_prediction) begin
      wb2reg_predict = wb2reg_predictor::type_id::create("wb2reg_predict", this);
    end
  endfunction

// ****************************************************************************
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    spi_agent.monitored_ap.connect(wb2spi_scoreboard.actual_analysis_export);
    spi_agent.monitored_ap.connect(spi_mem_slave_coverage.analysis_export);
    spi_agent.monitored_ap.connect(spi_mem_slave_viewer.analysis_export);

    wb_agent.monitored_ap.connect(wb2spi_predictor.analysis_export);
    wb2spi_predictor.transformed_result_analysis_port.connect(wb2spi_scoreboard.expected_analysis_export);

    if (configuration.enable_reg_prediction ||
        configuration.enable_reg_adaptation)
      wb2reg_adaptr = wb2reg_adapter::type_id::create("wb2reg_adaptr");
      
    if (configuration.enable_reg_adaptation)
      configuration.reg_model.bus_map.set_sequencer(wb_agent.sequencer, wb2reg_adaptr);

    if (configuration.enable_reg_prediction) begin
      wb2reg_predict.map     = configuration.reg_model.bus_map;
      wb2reg_predict.adapter = wb2reg_adaptr;
    end
  endfunction

// ****************************************************************************
 virtual function void phase_ready_to_end( uvm_phase phase );
     if (phase.get_name() == "run") begin
        phase.raise_objection( this , "Waiting for SPI-Wishbone Bridge latency" );
        fork begin
          `uvm_info("PHASE_READY_TO_END", get_full_name(),UVM_HIGH)
          // Code to wait for latency goes here
          phase.drop_objection( this , "wb2spi_environment::phase_ready_to_end() complete" );
        end
        join_none
     end
 endfunction : phase_ready_to_end


endclass
