//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Nov 30
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : gpio_example Environment 
// Unit            : gpio_example Environment
// File            : gpio_example_environment.svh
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This environment contains all agents, predictors and
// scoreboards required for the block level design.
//----------------------------------------------------------------------
//



class gpio_example_environment 
extends uvmf_environment_base #(.CONFIG_T( gpio_example_env_configuration
                             ));

  `uvm_component_utils( gpio_example_environment );




   typedef gpio_agent #(.WRITE_PORT_WIDTH(32),.READ_PORT_WIDTH(16)) gpio_a_agent_t;
   gpio_a_agent_t gpio_a;

   typedef gpio_agent #(.WRITE_PORT_WIDTH(16),.READ_PORT_WIDTH(32)) gpio_b_agent_t;
   gpio_b_agent_t gpio_b;





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
  gpio_b = gpio_b_agent_t::type_id::create("gpio_b",this);




  endfunction

// ****************************************************************************
// FUNCTION: connect_phase()
// This function makes all connections within this environment.  Connections
// typically inclue agent to predictor, predictor to scoreboard and scoreboard
// to agent.
//
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);




  endfunction

endclass

