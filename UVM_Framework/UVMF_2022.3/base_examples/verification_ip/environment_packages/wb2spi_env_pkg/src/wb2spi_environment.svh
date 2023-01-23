//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This environment contains all agents, predictors and
// scoreboards required for the block level design.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//

class wb2spi_environment #(
  int WB_DATA_WIDTH = 16,
  int WB_ADDR_WIDTH = 32
  ) extends uvmf_environment_base #(
    .CONFIG_T( wb2spi_env_configuration #(
                      .WB_DATA_WIDTH(WB_DATA_WIDTH),
                      .WB_ADDR_WIDTH(WB_ADDR_WIDTH)
                      )
  ));
  `uvm_component_param_utils( wb2spi_environment #(
                              WB_DATA_WIDTH,
                              WB_ADDR_WIDTH
                              ))





  typedef wb_agent #(
                .WB_DATA_WIDTH(WB_DATA_WIDTH),
                .WB_ADDR_WIDTH(WB_ADDR_WIDTH)
                ) wb_agent_t;
  wb_agent_t wb;

  typedef spi_agent  spi_agent_t;
  spi_agent_t spi;




  typedef wb2spi_predictor #(
                .CONFIG_T(CONFIG_T),
                .WB_DATA_WIDTH(WB_DATA_WIDTH),
                .WB_ADDR_WIDTH(WB_ADDR_WIDTH)
                ) wb2spi_pred_t;
  wb2spi_pred_t wb2spi_pred;

  typedef uvmf_in_order_scoreboard #(.T(spi_transaction))  wb2spi_sb_t;
  wb2spi_sb_t wb2spi_sb;

   // Instantiate register model adapter and predictor
   typedef wb2reg_adapter#(.WB_DATA_WIDTH(WB_DATA_WIDTH),.WB_ADDR_WIDTH(WB_ADDR_WIDTH))    reg_adapter_t;
   reg_adapter_t    reg_adapter;
   typedef uvm_reg_predictor #(wb_transaction#(.WB_DATA_WIDTH(WB_DATA_WIDTH),.WB_ADDR_WIDTH(WB_ADDR_WIDTH))) reg_predictor_t;
   reg_predictor_t    reg_predictor;

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end
  
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
    wb.set_config(configuration.wb_config);
    spi = spi_agent_t::type_id::create("spi",this);
    spi.set_config(configuration.spi_config);
    wb2spi_pred = wb2spi_pred_t::type_id::create("wb2spi_pred",this);
    wb2spi_pred.configuration = configuration;
    wb2spi_sb = wb2spi_sb_t::type_id::create("wb2spi_sb",this);
// pragma uvmf custom reg_model_build_phase begin
  // Build register model predictor if prediction is enabled
  if (configuration.enable_reg_prediction) begin
    reg_predictor = reg_predictor_t::type_id::create("reg_predictor", this);
  end

// pragma uvmf custom reg_model_build_phase end
    // pragma uvmf custom build_phase begin
    // pragma uvmf custom build_phase end
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
    // pragma uvmf custom reg_model_connect_phase begin
    // Create register model adapter if required
    if (configuration.enable_reg_prediction ||
        configuration.enable_reg_adaptation)
      reg_adapter = reg_adapter_t::type_id::create("reg_adapter");
    // Set sequencer and adapter in register model map
    if (configuration.enable_reg_adaptation)
      configuration.wb2spi_rm.bus_map.set_sequencer(wb.sequencer, reg_adapter);
    // Set map and adapter handles within uvm predictor
    if (configuration.enable_reg_prediction) begin
      reg_predictor.map     = configuration.wb2spi_rm.bus_map;
      reg_predictor.adapter = reg_adapter;
    end
      // The connection between the agent analysis_port and uvm_reg_predictor 
      // analysis_export could cause problems due to a uvm register package bug,
      // if this environment is used as a sub-environment at a higher level.
      // The uvm register package does not construct sub-maps within register
      // sub blocks.  While the connection below succeeds, the execution of the
      // write method associated with the analysis_export fails.  It fails because
      // the write method executes the get_reg_by_offset method of the register
      // map, which is null because of the uvm register package bug.
      // The call works when operating at block level because the uvm register 
      // package constructs the top level register map.  The call fails when the 
      // register map associated with this environment is a sub-map.  Construction
      // of the sub-maps must be done manually.
      //wb.monitored_ap.connect(reg_predictor.bus_in);

    // pragma uvmf custom reg_model_connect_phase end
  endfunction

endclass

