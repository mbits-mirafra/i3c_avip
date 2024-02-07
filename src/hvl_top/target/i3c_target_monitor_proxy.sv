`ifndef I3C_TARGET_MONITOR_PROXY_INCLUDED_
`define I3C_TARGET_MONITOR_PROXY_INCLUDED_

class i3c_target_monitor_proxy extends uvm_component;
  `uvm_component_utils(i3c_target_monitor_proxy)

  i3c_target_tx tx;
  i3c_target_agent_config i3c_target_agent_cfg_h;
  virtual i3c_target_monitor_bfm i3c_target_mon_bfm_h;
  uvm_analysis_port #(i3c_target_tx)target_analysis_port;

  extern function new(string name = "i3c_target_monitor_proxy", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass : i3c_target_monitor_proxy

function i3c_target_monitor_proxy::new(string name = "i3c_target_monitor_proxy",
                                 uvm_component parent = null);
  super.new(name, parent);
  target_analysis_port = new("target_analysis_port",this);
tx = new();
endfunction : new


function void i3c_target_monitor_proxy::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(virtual i3c_target_monitor_bfm)::get(this,"","i3c_target_monitor_bfm",i3c_target_mon_bfm_h))begin
  `uvm_fatal("FATAL_MDP_CANNOT_GET_target_MONITOR_BFM","cannot get () i3c_target_monitor_bfm from uvm_config_db")
  end

endfunction : build_phase


function void i3c_target_monitor_proxy::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase


function void i3c_target_monitor_proxy::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  i3c_target_mon_bfm_h.i3c_target_mon_proxy_h = this;
endfunction  : end_of_elaboration_phase


function void i3c_target_monitor_proxy::start_of_simulation_phase(uvm_phase phase);
  super.start_of_simulation_phase(phase);
endfunction : start_of_simulation_phase


task i3c_target_monitor_proxy::run_phase(uvm_phase phase);

  i3c_target_tx tx_packet;

  tx_packet = i3c_target_tx::type_id::create("tx_packet");

  `uvm_info(get_type_name(),"Running the Monitor Proxy", UVM_HIGH)

  `uvm_info(get_type_name(), "Waiting for reset", UVM_HIGH);
  i3c_target_mon_bfm_h.wait_for_reset();
  i3c_target_mon_bfm_h.sample_idle_state();
 
  forever begin
    i3c_transfer_bits_s struct_packet;
    i3c_transfer_cfg_s struct_cfg;

    i3c_target_mon_bfm_h.wait_for_idle_state();
  
    i3c_target_seq_item_converter::from_class(tx_packet, struct_packet);
    i3c_target_cfg_converter::from_class(i3c_target_agent_cfg_h, struct_cfg);
    `uvm_info(get_type_name(), $sformatf("Converted cfg struct\n%p",struct_cfg), UVM_HIGH)

    i3c_target_mon_bfm_h.sample_data(struct_packet,struct_cfg);

    i3c_target_seq_item_converter::to_class(struct_packet,tx);
   
    $cast(tx_packet, tx.clone());
    `uvm_info(get_type_name(),$sformatf("Packet received from sample_data clone packet is \n %s",tx_packet.sprint()),UVM_HIGH)   

    target_analysis_port.write(tx_packet);
  end

endtask : run_phase

`endif

