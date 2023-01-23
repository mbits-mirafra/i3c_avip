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
// Project         : AHB 2 SPI Example
// Unit            : Environment
// File            : ahb2spi_environment.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This environment is for the AHB to SPI example.  It is
//     created by instantiating the AHB to WB environment and the WB to
//     SPI environment. The AHB to WB environment creates AHB stimulus
//     and performs transaction prediction and scoreboarding between
//     the AHB and WB ports.  The WB to SPI enviornment creates SPI 
//     responses and performs transaction prediction and scoreboarding 
//     between the WB and SPI ports.
//
//----------------------------------------------------------------------
//
class ahb2spi_environment extends uvmf_environment_base #(.CONFIG_T(ahb2spi_configuration));

  `uvm_component_utils( ahb2spi_environment );

  ahb2wb_environment ahb2wb_env;

  wb2spi_environment wb2spi_env;
  
  ahb2reg_adapter    ahb2reg_adaptr;


  // Instantiate shared WB monitor to be used by both block level environments
  wb_monitor         wb_mon;

// ****************************************************************************
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

// ****************************************************************************
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Construct the shared monitor
    wb_mon = wb_monitor::type_id::create("wb_mon",this);
    // Place the shared monitor in the uvm_config_db for access by block environments
    uvm_config_db #( wb_monitor )::set( this , "*" , UVMF_MONITORS ,  wb_mon );

    ahb2wb_env = ahb2wb_environment::type_id::create("ahb2wb_env",this);
    ahb2wb_env.set_config( configuration.ahb2wb_config ); 

    wb2spi_env = wb2spi_environment::type_id::create("wb2spi_env",this);
    wb2spi_env.set_config( configuration.wb2spi_config );

  endfunction

  
// ****************************************************************************
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (configuration.enable_reg_adaptation) begin
      ahb2reg_adaptr = ahb2reg_adapter::type_id::create("ahb2reg_adaptr");
      configuration.reg_model.bus_map.set_sequencer(ahb2wb_env.a_agent.sequencer, ahb2reg_adaptr);
    end
  endfunction

endclass
