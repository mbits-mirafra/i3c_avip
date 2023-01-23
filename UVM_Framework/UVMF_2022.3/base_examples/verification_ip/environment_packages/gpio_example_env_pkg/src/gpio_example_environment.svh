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

class gpio_example_environment  extends uvmf_environment_base #(
    .CONFIG_T( gpio_example_env_configuration 
  ));
  `uvm_component_utils( gpio_example_environment )





  typedef gpio_agent #(
                .WRITE_PORT_WIDTH(32),
                .READ_PORT_WIDTH(16)
                ) gpio_a_agent_t;
  gpio_a_agent_t gpio_a;

  typedef gpio_agent #(
                .WRITE_PORT_WIDTH(16),
                .READ_PORT_WIDTH(32)
                ) gpio_b_agent_t;
  gpio_b_agent_t gpio_b;




  typedef gpio_predictor #(
                .CONFIG_T(CONFIG_T)
                ) gpio_reporter_t;
  gpio_reporter_t gpio_reporter;



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
    gpio_a = gpio_a_agent_t::type_id::create("gpio_a",this);
    gpio_a.set_config(configuration.gpio_a_config);
    gpio_b = gpio_b_agent_t::type_id::create("gpio_b",this);
    gpio_b.set_config(configuration.gpio_b_config);
    gpio_reporter = gpio_reporter_t::type_id::create("gpio_reporter",this);
    gpio_reporter.configuration = configuration;
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
    gpio_a.monitored_ap.connect(gpio_reporter.gpio_a_ae);
    gpio_b.monitored_ap.connect(gpio_reporter.gpio_b_ae);
    // pragma uvmf custom reg_model_connect_phase begin
    // pragma uvmf custom reg_model_connect_phase end
  endfunction

endclass

