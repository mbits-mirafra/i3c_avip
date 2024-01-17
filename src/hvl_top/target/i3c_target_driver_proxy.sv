`ifndef I3C_TARGET_DRIVER_PROXY_INCLUDED_
`define I3C_TARGET_DRIVER_PROXY_INCLUDED_

class i3c_target_driver_proxy extends uvm_driver#(i3c_target_tx);
  `uvm_component_utils(i3c_target_driver_proxy)
  
  i3c_target_agent_config i3c_target_agent_cfg_h;
  virtual i3c_target_driver_bfm i3c_target_drv_bfm_h;

  extern function new(string name = "i3c_target_driver_proxy", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass : i3c_target_driver_proxy


function i3c_target_driver_proxy::new(string name = "i3c_target_driver_proxy",                                             uvm_component parent = null);
  super.new(name, parent);
endfunction : new


function void i3c_target_driver_proxy::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction : build_phase


function void i3c_target_driver_proxy::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);

  if(!uvm_config_db #(virtual i3c_target_driver_bfm)::get(this,"","i3c_target_driver_bfm",i3c_target_drv_bfm_h))begin
    `uvm_fatal("FATAL_SDP_CANNOT_GET_target_DRIVER_BFM","cannot get i3c_target_driver_bfm from the uvm_config_db. Have you set it?");
  end

  i3c_target_drv_bfm_h.i3c_target_drv_proxy_h = this;
endfunction  : end_of_elaboration_phase


task i3c_target_driver_proxy::run_phase(uvm_phase phase);
  super.run_phase(phase);
   
  i3c_target_drv_bfm_h.wait_for_system_reset();
  i3c_target_drv_bfm_h.drive_idle_state();

  forever begin
    i3c_transfer_bits_s struct_packet;
    i3c_transfer_cfg_s struct_cfg;
    acknowledge_e ack;
    operationType_e rd_wr;

    i3c_target_drv_bfm_h.wait_for_idle_state();

    seq_item_port.get_next_item(req);

    `uvm_info(get_type_name(),$sformatf("Received packet from i3c target sequencer : , \n %s",req.sprint()),UVM_HIGH)
    `uvm_info("DEBUG_MSHA", $sformatf("CFG :: i3c_transfer_cfg_s = %s",i3c_target_agent_cfg_h.sprint()), UVM_MEDIUM); 
    i3c_target_cfg_converter::from_class(i3c_target_agent_cfg_h, struct_cfg); 
    `uvm_info("DEBUG_MSHA", $sformatf("CFG :: struct_cfg = %p",struct_cfg), UVM_NONE); 
    i3c_target_seq_item_converter::from_class(req, struct_packet); 

    i3c_target_drv_bfm_h.drive_data(struct_packet,struct_cfg);
    
    i3c_target_seq_item_converter::to_class(struct_packet, req);
    `uvm_info(get_type_name(),$sformatf("Received packet from target DRIVER BFM : , \n %s",req.sprint()),UVM_HIGH)

      seq_item_port.item_done();
  end
endtask : run_phase

`endif

