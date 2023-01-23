//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 14
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb2spi Environment 
// Unit            : ahb2spi Environment
// File            : ahb2spi_environment.svh
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This environment contains all agents, predictors and
// scoreboards required for the block level design.
//----------------------------------------------------------------------
//


class ahb2spi_environment #(int WB_ADDR_WIDTH = 32,int WB_DATA_WIDTH = 16) extends uvmf_environment_base #(.CONFIG_T( ahb2spi_env_configuration));

  `uvm_component_param_utils( ahb2spi_environment#(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH)) );


   ahb2wb_environment#(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH)) ahb2wb_env;
   wb2spi_environment#(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH)) wb2spi_env;

  ahb2reg_adapter    ahb2reg_adaptr;


  // Instantiate shared WB monitor to be used by both block level environments
  wb_monitor#(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH))         wb_mon;


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

    // Construct the shared monitor
    wb_mon = wb_monitor#(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH))::type_id::create("wb_mon",this);
    // Place the shared monitor in the uvm_config_db for access by block environments
    uvm_config_db #( wb_monitor#(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH)) )::set( this , "*" , UVMF_MONITORS ,  wb_mon );

   ahb2wb_env = ahb2wb_environment#(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH))::type_id::create("ahb2wb_env",this);
   ahb2wb_env.set_config(configuration.ahb2wb_env_config);
   wb2spi_env = wb2spi_environment#(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH))::type_id::create("wb2spi_env",this);
   wb2spi_env.set_config(configuration.wb2spi_env_config);

  endfunction

// ****************************************************************************
// FUNCTION: connect_phase()
// This function makes all connections within this environment.  Connections
// typically inclue agent to predictor, predictor to scoreboard and scoreboard
// to agent.
//
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if (configuration.enable_reg_adaptation) begin
      ahb2reg_adaptr = ahb2reg_adapter::type_id::create("ahb2reg_adaptr");
      configuration.reg_model.bus_map.set_sequencer(ahb2wb_env.ahb.sequencer, ahb2reg_adaptr);
    end

  endfunction

endclass

