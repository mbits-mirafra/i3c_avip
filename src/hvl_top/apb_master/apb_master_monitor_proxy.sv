`ifndef APB_MASTER_MONITOR_PROXY_INCLUDED_
`define APB_MASTER_MONITOR_PROXY_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: apb_master_monitor_proxy
//  This is the HVL side apb_master_monitor_proxy
//  It gets the sampled data from the HDL master monitor and converts them into transaction items
//--------------------------------------------------------------------------------------------
class apb_master_monitor_proxy extends uvm_monitor; 
  `uvm_component_utils(apb_master_monitor_proxy)
  
  // Variable: apb_master_mon_bfm_h
  // Declaring handle for apb monitor bfm
  virtual apb_master_monitor_bfm apb_master_mon_bfm_h;
   
  // Variable: apb_master_agent_cfg_h
  // Declaring handle for apb_master agent config class 
  apb_master_agent_config apb_master_agent_cfg_h;
    
  // Variable: apb_master_analysis_port
  // Declaring analysis port for the monitor port
  uvm_analysis_port#(apb_master_tx) apb_master_analysis_port;
  
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "apb_master_monitor_proxy", uvm_component parent);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass : apb_master_monitor_proxy

//--------------------------------------------------------------------------------------------
// Construct: new
//  Initializes memory for new object
//
// Parameters:
//  name   - apb_master_monitor_proxy
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function apb_master_monitor_proxy::new(string name = "apb_master_monitor_proxy",uvm_component parent);
  super.new(name, parent);
  apb_master_analysis_port = new("apb_master_analysis_port",this);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
//  Creates the required ports, gets the required configuration from confif_db
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void apb_master_monitor_proxy::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(virtual apb_master_monitor_bfm)::get(this,"","apb_master_monitor_bfm", apb_master_mon_bfm_h)) begin
    `uvm_fatal("FATAL_MDP_CANNOT_GET_APB_MASTER_MONITOR_BFM","cannot get() apb_master_mon_bfm_h");
  end
endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Function: end_of_elaboration_phase
//  Pointing handle of monitor proxy in HDL BFM to this proxy method in HVL part
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void apb_master_monitor_proxy::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  apb_master_mon_bfm_h.apb_master_mon_proxy_h = this;
endfunction : end_of_elaboration_phase

//--------------------------------------------------------------------------------------------
// Task: run_phase
//  This task calls the monitor logic written in the monitor BFM at HDL side
//  Receives data packet from slave monitor bfm and converts into the transaction objects
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
task apb_master_monitor_proxy::run_phase(uvm_phase phase);
  apb_master_tx apb_master_packet;

  `uvm_info(get_type_name(), $sformatf("Inside the master_monitor_proxy"), UVM_LOW);
  apb_master_packet = apb_master_tx::type_id::create("master_packet");
  
  apb_master_mon_bfm_h.wait_for_preset_n();

  forever begin
    apb_transfer_char_s struct_data_packet;
    apb_transfer_cfg_s  struct_cfg_packet; 
    apb_master_tx       apb_master_clone_packet;
    
    apb_master_cfg_converter :: from_class (apb_master_agent_cfg_h, struct_cfg_packet);
    apb_master_mon_bfm_h.sample_data (struct_data_packet, struct_cfg_packet);
    apb_master_seq_item_converter :: to_class (struct_data_packet, apb_master_packet);

    `uvm_info(get_type_name(),$sformatf("Received packet from master monitor bfm: , \n %s", apb_master_packet.sprint()),UVM_HIGH)

    //Clone and publish the cloned item to the subscribers
    $cast(apb_master_clone_packet, apb_master_packet.clone());
    `uvm_info(get_type_name(),$sformatf("Sending packet via analysis_port: , \n %s", apb_master_clone_packet.sprint()),UVM_HIGH)
    apb_master_analysis_port.write(apb_master_clone_packet);
  end

endtask : run_phase

`endif

