//----------------------------------------------------------------------
// Created with uvmf_gen version 2020.1
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

class alu_environment #(
  int ALU_IN_OP_WIDTH = 8,
  int ALU_OUT_RESULT_WIDTH = 16,
  int APB_ADDR_WIDTH = 32,
  int APB_WDATA_WIDTH = 32,
  int APB_RDATA_WIDTH = 32
  ) extends uvmf_environment_base #(
    .CONFIG_T( alu_env_configuration #(
                      .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH),
                      .ALU_OUT_RESULT_WIDTH(ALU_OUT_RESULT_WIDTH),
                      .APB_ADDR_WIDTH(APB_ADDR_WIDTH),
                      .APB_WDATA_WIDTH(APB_WDATA_WIDTH),
                      .APB_RDATA_WIDTH(APB_RDATA_WIDTH)
                      )
  ));
  `uvm_component_param_utils( alu_environment #(
                              ALU_IN_OP_WIDTH,
                              ALU_OUT_RESULT_WIDTH,
                              APB_ADDR_WIDTH,
                              APB_WDATA_WIDTH,
                              APB_RDATA_WIDTH
                              ))


  qvip_agents_environment #()  qvip_agents_env;



  uvm_analysis_port #( mvc_sequence_item_base ) qvip_agents_env_apb_master_0_ap [string];

  typedef alu_in_agent #(
                .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)
                ) alu_in_agent_agent_t;
  alu_in_agent_agent_t alu_in_agent;

  typedef alu_out_agent #(
                .ALU_OUT_RESULT_WIDTH(ALU_OUT_RESULT_WIDTH)
                ) alu_out_agent_agent_t;
  alu_out_agent_agent_t alu_out_agent;




  typedef alu_predictor #(
                .CONFIG_T(CONFIG_T)
                ) alu_pred_t;
  alu_pred_t alu_pred;

  typedef uvmf_in_order_scoreboard #(.T(alu_out_transaction #(.ALU_OUT_RESULT_WIDTH(ALU_OUT_RESULT_WIDTH))))  alu_sb_t;
  alu_sb_t alu_sb;

   // Instantiate register model adapter and predictor
//  typedef alu_in2reg_adapter#(.ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH))    reg_adapter_t;
//  reg_adapter_t    reg_adapter;
//  typedef uvm_reg_predictor #(alu_in_transaction#(.ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH))) reg_predictor_t;
//  reg_predictor_t    reg_predictor;
  typedef apb3_host_apb3_transaction #(1,
                                       APB_ADDR_WIDTH,
                                       APB_WDATA_WIDTH,
                                       APB_RDATA_WIDTH) apb3_host_apb3_transaction_t;

  typedef reg2apb_adapter #(apb3_host_apb3_transaction_t,
                            1,
                            APB_ADDR_WIDTH,
                            APB_WDATA_WIDTH,
                            APB_RDATA_WIDTH) reg2apb_adapter_t;
                            
  typedef apb_reg_predictor #(apb3_host_apb3_transaction_t,
                            1,
                            APB_ADDR_WIDTH,
                            APB_WDATA_WIDTH,
                            APB_RDATA_WIDTH) apb_reg_predictor_t;

  reg2apb_adapter_t   reg_adapter;
  apb_reg_predictor_t reg_predictor;

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
    qvip_agents_env = qvip_agents_environment#()::type_id::create("qvip_agents_env",this);
    qvip_agents_env.set_config(configuration.qvip_agents_env_config);
    alu_in_agent = alu_in_agent_agent_t::type_id::create("alu_in_agent",this);
    alu_in_agent.set_config(configuration.alu_in_agent_config);
    alu_out_agent = alu_out_agent_agent_t::type_id::create("alu_out_agent",this);
    alu_out_agent.set_config(configuration.alu_out_agent_config);
    alu_pred = alu_pred_t::type_id::create("alu_pred",this);
    alu_pred.configuration = configuration;
    alu_sb = alu_sb_t::type_id::create("alu_sb",this);
// pragma uvmf custom reg_model_build_phase begin
  // Build register model predictor if prediction is enabled
  if (configuration.enable_reg_prediction) begin
    reg_predictor = apb_reg_predictor_t::type_id::create("reg_predictor", this);
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
    alu_in_agent.monitored_ap.connect(alu_pred.alu_in_agent_ae);
    alu_pred.alu_sb_ap.connect(alu_sb.expected_analysis_export);
    alu_out_agent.monitored_ap.connect(alu_sb.actual_analysis_export);
    qvip_agents_env_apb_master_0_ap = qvip_agents_env.apb_master_0.ap; 
    if ( configuration.qvip_agents_env_interface_activity[0] == ACTIVE )
       uvm_config_db #(mvc_sequencer)::set(null,UVMF_SEQUENCERS,configuration.qvip_agents_env_interface_names[0],qvip_agents_env.apb_master_0.m_sequencer  );
    // pragma uvmf custom reg_model_connect_phase begin
    // Create register model adapter if required
    if (configuration.enable_reg_prediction ||
        configuration.enable_reg_adaptation)
      reg_adapter = reg2apb_adapter_t::type_id::create("reg_adapter");
    // Set sequencer and adapter in register model map
    if (configuration.enable_reg_adaptation)
      configuration.alu_rm.apb_map.set_sequencer(qvip_agents_env.apb_master_0.m_sequencer, reg_adapter);
    // Set map and adapter handles within uvm predictor
    if (configuration.enable_reg_prediction) begin
      reg_predictor.map     = configuration.alu_rm.apb_map;
      reg_predictor.adapter = reg_adapter;
      qvip_agents_env_apb_master_0_ap["trans_ap"].connect(reg_predictor.bus_item_export);
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
      //alu_in_agent.monitored_ap.connect(reg_predictor.bus_in);
    end
    // pragma uvmf custom reg_model_connect_phase end
  endfunction

endclass

