//----------------------------------------------------------------------
// Created with uvmf_gen version 2021.1
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

class scatter_gather_dma_environment #(
  int dma_done_rsc_WIDTH = 1
  ) extends uvmf_environment_base #(
    .CONFIG_T( scatter_gather_dma_env_configuration #(
                      .dma_done_rsc_WIDTH(dma_done_rsc_WIDTH)
                      )
  ));
  `uvm_component_param_utils( scatter_gather_dma_environment #(
                              dma_done_rsc_WIDTH
                              ))


  scatter_gather_dma_qvip_environment #()  scatter_gather_dma_qvip_subenv;



  uvm_analysis_port #( mvc_sequence_item_base ) scatter_gather_dma_qvip_subenv_mgc_axi4_m0_ap [string];
  uvm_analysis_port #( mvc_sequence_item_base ) scatter_gather_dma_qvip_subenv_mgc_axi4_s0_ap [string];

  typedef ccs_agent #(
                .WIDTH(1)
                ) dma_done_rsc_agent_t;
  dma_done_rsc_agent_t dma_done_rsc;







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
    scatter_gather_dma_qvip_subenv = scatter_gather_dma_qvip_environment#()::type_id::create("scatter_gather_dma_qvip_subenv",this);
    scatter_gather_dma_qvip_subenv.set_config(configuration.scatter_gather_dma_qvip_subenv_config);
    dma_done_rsc = dma_done_rsc_agent_t::type_id::create("dma_done_rsc",this);
    dma_done_rsc.set_config(configuration.dma_done_rsc_config);
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
    scatter_gather_dma_qvip_subenv_mgc_axi4_m0_ap = scatter_gather_dma_qvip_subenv.mgc_axi4_m0.ap; 
    scatter_gather_dma_qvip_subenv_mgc_axi4_s0_ap = scatter_gather_dma_qvip_subenv.mgc_axi4_s0.ap; 
    if ( configuration.scatter_gather_dma_qvip_subenv_interface_activity[0] == ACTIVE )
       uvm_config_db #(mvc_sequencer)::set(null,UVMF_SEQUENCERS,configuration.scatter_gather_dma_qvip_subenv_interface_names[0],scatter_gather_dma_qvip_subenv.mgc_axi4_m0.m_sequencer  );
    if ( configuration.scatter_gather_dma_qvip_subenv_interface_activity[1] == ACTIVE )
       uvm_config_db #(mvc_sequencer)::set(null,UVMF_SEQUENCERS,configuration.scatter_gather_dma_qvip_subenv_interface_names[1],scatter_gather_dma_qvip_subenv.mgc_axi4_s0.m_sequencer  );
    // pragma uvmf custom reg_model_connect_phase begin
    // pragma uvmf custom reg_model_connect_phase end
  endfunction

endclass

