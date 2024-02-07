`ifndef I3C_TARGET_AGENT_INCLUDED_
`define I3C_TARGET_AGENT_INCLUDED_

class i3c_target_agent extends uvm_component;
  `uvm_component_utils(i3c_target_agent)

  i3c_target_agent_config i3c_target_agent_cfg_h;
  
  i3c_target_monitor_proxy i3c_target_mon_proxy_h;
  i3c_target_sequencer i3c_target_seqr_h;
  i3c_target_driver_proxy i3c_target_drv_proxy_h;
  i3c_target_coverage i3c_target_cov_h;

  extern function new(string name = "i3c_target_agent",uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : i3c_target_agent


function i3c_target_agent::new(string name = "i3c_target_agent",uvm_component parent = null);
  super.new(name, parent);
endfunction : new


function void i3c_target_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(i3c_target_agent_config)::get(this,"","i3c_target_agent_config",i3c_target_agent_cfg_h))
    `uvm_fatal("CONFIG","cannot get() the i3c_target_agent_cfg_h from the uvm_config_db. have you set it?")
    
  i3c_target_mon_proxy_h=i3c_target_monitor_proxy::type_id::create("i3c_target_mon_proxy_h",this);

  if(i3c_target_agent_cfg_h.isActive==UVM_ACTIVE)
  begin
    i3c_target_drv_proxy_h=i3c_target_driver_proxy::type_id::create("i3c_target_drv_proxy_h",this);
    i3c_target_seqr_h=i3c_target_sequencer::type_id::create("i3c_target_seqr_h",this);
      
  end

  if(i3c_target_agent_cfg_h.hasCoverage)begin
    i3c_target_cov_h=i3c_target_coverage::type_id::create("i3c_target_cov_h",this);
  end
endfunction : build_phase


function void i3c_target_agent::connect_phase(uvm_phase phase);

  if(i3c_target_agent_cfg_h.isActive==UVM_ACTIVE)
  begin
    i3c_target_drv_proxy_h.i3c_target_agent_cfg_h=i3c_target_agent_cfg_h;
    i3c_target_seqr_h.i3c_target_agent_cfg_h=i3c_target_agent_cfg_h;
    i3c_target_drv_proxy_h.seq_item_port.connect(i3c_target_seqr_h.seq_item_export);
  end

  i3c_target_mon_proxy_h.i3c_target_agent_cfg_h=i3c_target_agent_cfg_h;
  
  if(i3c_target_agent_cfg_h.hasCoverage) begin                                                         
    i3c_target_mon_proxy_h.target_analysis_port.connect(i3c_target_cov_h.analysis_export);
  end  
endfunction : connect_phase

`endif
