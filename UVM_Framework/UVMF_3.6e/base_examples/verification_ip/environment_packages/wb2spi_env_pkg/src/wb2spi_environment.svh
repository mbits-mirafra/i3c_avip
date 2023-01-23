//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 09
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : wb2spi Environment 
// Unit            : wb2spi Environment
// File            : wb2spi_environment.svh
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This environment contains all agents, predictors and
// scoreboards required for the block level design.
//----------------------------------------------------------------------
//


class wb2spi_environment extends uvmf_environment_base #(.CONFIG_T( wb2spi_env_configuration));

  `uvm_component_utils( wb2spi_environment );





   wb_agent_t wb;
   spi_agent_t spi;

   wb2spi_predictor wb2spi_pred;
   spi_mem_slave_transaction_coverage spi_mem_slave_coverage;
   spi_mem_slave_transaction_viewer spi_mem_slave_viewer;

   typedef uvmf_in_order_scoreboard #(spi_transaction)  wb2spi_sb_t;
   wb2spi_sb_t wb2spi_sb;

   wb2reg_adapter      wb2reg_adaptr;
   wb2reg_predictor    wb2reg_predict;

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




  wb = wb_agent_t::type_id::create("wb",this);
  spi = spi_agent_t::type_id::create("spi",this);

  wb2spi_pred = wb2spi_predictor::type_id::create("wb2spi_pred",this);
  spi_mem_slave_coverage = spi_mem_slave_transaction_coverage::type_id::create("spi_mem_slave_coverage",this);
  spi_mem_slave_viewer = spi_mem_slave_transaction_viewer::type_id::create("spi_mem_slave_viewer",this);
  spi_mem_slave_viewer.configuration = configuration.spi_config;

  wb2spi_sb = wb2spi_sb_t::type_id::create("wb2spi_sb",this);

  if (configuration.enable_reg_prediction) begin
    wb2reg_predict = wb2reg_predictor::type_id::create("wb2reg_predict", this);
  end

  endfunction

// ****************************************************************************
// FUNCTION: connect_phase()
// This function makes all connections within this environment.  Connections
// typically inclue agent to predictor, predictor to scoreboard and scoreboard
// to agent.
//
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

   wb.monitored_ap.connect(wb2spi_pred.wb_ae);
   wb2spi_pred.wb2spi_sb_ap.connect(wb2spi_sb.expected_analysis_export);
   spi.monitored_ap.connect(wb2spi_sb.actual_analysis_export);
   spi.monitored_ap.connect(spi_mem_slave_coverage.analysis_export);
   spi.monitored_ap.connect(spi_mem_slave_viewer.analysis_export);

    if (configuration.enable_reg_prediction ||
        configuration.enable_reg_adaptation)
      wb2reg_adaptr = wb2reg_adapter::type_id::create("wb2reg_adaptr");
      
    if (configuration.enable_reg_adaptation)
      configuration.reg_model.bus_map.set_sequencer(wb.sequencer, wb2reg_adaptr);

    if (configuration.enable_reg_prediction) begin
      wb2reg_predict.map     = configuration.reg_model.bus_map;
      wb2reg_predict.adapter = wb2reg_adaptr;
    end

  endfunction

endclass

