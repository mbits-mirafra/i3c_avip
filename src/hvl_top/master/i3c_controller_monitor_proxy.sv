`ifndef I3C_CONTROLLER_MONITOR_PROXY_INCLUDED_
`define I3C_CONTROLLER_MONITOR_PROXY_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: i3c_controller_monitor_proxy
// <Description_here>
//--------------------------------------------------------------------------------------------
class i3c_controller_monitor_proxy extends uvm_component;
  `uvm_component_utils(i3c_controller_monitor_proxy)

  i3c_controller_agent_config i3c_controller_agent_cfg_h;

  uvm_analysis_port #(i3c_controller_tx)controller_analysis_port;
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "i3c_controller_monitor_proxy", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  //extern virtual function void connect_phase(uvm_phase phase);
  //extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  //extern virtual function void start_of_simulation_phase(uvm_phase phase);
  //extern virtual task run_phase(uvm_phase phase);

endclass : i3c_controller_monitor_proxy

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - i3c_controller_monitor_proxy
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function i3c_controller_monitor_proxy::new(string name = "i3c_controller_monitor_proxy",
                                 uvm_component parent = null);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void i3c_controller_monitor_proxy::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(i3c_controller_agent_config)::get(this,"","i3c_controller_agent_config",i3c_controller_agent_cfg_h))begin
    `uvm_fatal("CONFIG","cannot get the i3c_controller_agent_cfg_h () . have you set it?")
  end
    controller_analysis_port=new("controller_analysis_port",this);
endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Function: connect_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
/*
function void i3c_controller_monitor_proxy::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

//--------------------------------------------------------------------------------------------
// Function: end_of_elaboration_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void i3c_controller_monitor_proxy::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
endfunction  : end_of_elaboration_phase

//--------------------------------------------------------------------------------------------
// Function: start_of_simulation_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void i3c_controller_monitor_proxy::start_of_simulation_phase(uvm_phase phase);
  super.start_of_simulation_phase(phase);
endfunction : start_of_simulation_phase

//--------------------------------------------------------------------------------------------
// Task: run_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
task i3c_controller_monitor_proxy::run_phase(uvm_phase phase);

  phase.raise_objection(this, "i3c_controller_monitor_proxy");

  super.run_phase(phase);

  // Work here
  // ...

  phase.drop_objection(this);

endtask : run_phase
*/
`endif

