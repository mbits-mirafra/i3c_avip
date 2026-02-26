`ifndef APB_MASTER_AGENT_INCLUDED_
`define APB_MASTER_AGENT_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: apb_master_agent
//  This agent is a configurable with respect to configuration which can create active and passive components
//  It contains testbench components like sequencer,driver_proxy and monitor_proxy for APB
//--------------------------------------------------------------------------------------------
class apb_master_agent extends uvm_agent;
  `uvm_component_utils(apb_master_agent)

  //Variable: apb_master_agent_cfg_h
  //Declaring handle for apb_master agent configuration class 
  apb_master_agent_config apb_master_agent_cfg_h;

  //Varible: apb_master_seqr_h 
  //Handle for slave seuencer
  apb_master_sequencer apb_master_seqr_h;
  
  //Variable: apb_master_drv_proxy_h
  //Creating a Handle forapb_master driver proxy 
  apb_master_driver_proxy apb_master_drv_proxy_h;

  //Variable: apb_master_mon_proxy_h
  //Declaring a handle for apb_master monitor proxy 
  apb_master_monitor_proxy apb_master_mon_proxy_h;

  // Variable: apb_master_cov_h
  // Decalring a handle for master_coverage
  apb_master_coverage apb_master_cov_h;

  // Variable: apb_reg_adapter_h
  // Declaring a handle for apb_master_adapter
  apb_master_adapter apb_reg_adapter_h;
    
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "apb_master_agent", uvm_component parent);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : apb_master_agent

//--------------------------------------------------------------------------------------------
// Construct: new
//  Initializes memory for new object
//
// Parameters:
//  name - instance name of the apb_master_agent
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function apb_master_agent::new(string name="apb_master_agent", uvm_component parent);
  super.new(name,parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
// Creates the required ports, gets the required configuration from confif_db
//
// Parameters:
// phase - uvm phase
//--------------------------------------------------------------------------------------------
function void apb_master_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if(!uvm_config_db #(apb_master_agent_config)::get(this,"","apb_master_agent_config", apb_master_agent_cfg_h)) begin
    `uvm_fatal("FATAL_MA_CANNOT_GET_APB_MASTER_AGENT_CONFIG", "cannot get apb_master_agent_cfg_h from uvm_config_db");
  end

  if(apb_master_agent_cfg_h.is_active == UVM_ACTIVE) begin
    apb_master_drv_proxy_h=apb_master_driver_proxy::type_id::create("apb_master_drv_proxy_h",this);
    apb_master_seqr_h=apb_master_sequencer::type_id::create("apb_master_seqr_h",this);
  end

  apb_master_mon_proxy_h=apb_master_monitor_proxy::type_id::create("apb_master_mon_proxy_h",this);

  if(apb_master_agent_cfg_h.has_coverage) begin
    apb_master_cov_h = apb_master_coverage::type_id::create("apb_master_cov_h",this);
  end

  apb_reg_adapter_h = apb_master_adapter::type_id::create("apb_reg_adapter_h"); 
endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Function: connect_phase 
// Connecting apb_master driver, apb_master monitor and apb_master sequencer for configuration
//
// Parameters:
// phase - uvm phase
//--------------------------------------------------------------------------------------------
function void apb_master_agent::connect_phase(uvm_phase phase);
  if(apb_master_agent_cfg_h.is_active == UVM_ACTIVE) begin
    apb_master_drv_proxy_h.apb_master_agent_cfg_h = apb_master_agent_cfg_h;
    apb_master_seqr_h.apb_master_agent_cfg_h = apb_master_agent_cfg_h;
    
    //Connecting driver_proxy port to sequencer export
    apb_master_drv_proxy_h.seq_item_port.connect(apb_master_seqr_h.seq_item_export);
  end
  apb_master_mon_proxy_h.apb_master_agent_cfg_h = apb_master_agent_cfg_h;

  if(apb_master_agent_cfg_h.has_coverage) begin
    apb_master_cov_h.apb_master_agent_cfg_h = apb_master_agent_cfg_h;
  
    //Connecting monitor_proxy port to coverage export
    apb_master_mon_proxy_h.apb_master_analysis_port.connect(apb_master_cov_h.analysis_export);
  end
    apb_master_mon_proxy_h.apb_master_agent_cfg_h = apb_master_agent_cfg_h;

endfunction : connect_phase

`endif

