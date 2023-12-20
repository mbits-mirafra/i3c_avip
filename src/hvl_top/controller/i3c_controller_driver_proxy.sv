`ifndef I3C_CONTROLLER_DRIVER_PROXY_INCLUDED_
`define I3C_CONTROLLER_DRIVER_PROXY_INCLUDED_

class i3c_controller_driver_proxy extends uvm_driver#(i3c_controller_tx);
  `uvm_component_utils(i3c_controller_driver_proxy)
 
  i3c_controller_tx tx;
  i3c_controller_agent_config i3c_controller_agent_cfg_h;
  virtual i3c_controller_driver_bfm i3c_controller_drv_bfm_h;

  extern function new(string name = "i3c_controller_driver_proxy", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task drive_to_bfm(inout i3c_transfer_bits_s packet, 
                                   input i3c_transfer_cfg_s packet1);
endclass : i3c_controller_driver_proxy


function i3c_controller_driver_proxy::new(string name = "i3c_controller_driver_proxy",
                                 uvm_component parent = null);
  super.new(name, parent);
endfunction : new


function void i3c_controller_driver_proxy::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(virtual i3c_controller_driver_bfm)::get(this,"","i3c_controller_driver_bfm",i3c_controller_drv_bfm_h))
  `uvm_fatal("FATAL_MDP_CANNOT_GET_controller_DRIVER_BFM","cannot get () i3c_controller_driver_bfm from uvm_config_db")
endfunction : build_phase


function void i3c_controller_driver_proxy::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase


function void i3c_controller_driver_proxy::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  i3c_controller_drv_bfm_h.i3c_controller_drv_proxy_h = this;
endfunction  : end_of_elaboration_phase


task i3c_controller_driver_proxy::run_phase(uvm_phase phase);
  super.run_phase(phase);

  `uvm_info(get_type_name(), "Running the Driver", UVM_HIGH)

  `uvm_info(get_type_name(), "MUNEEB :: Waiting for reset", UVM_HIGH);
  i3c_controller_drv_bfm_h.wait_for_reset();
  `uvm_info(get_type_name(), "MUNEEB :: Reset detected", UVM_HIGH);

  `uvm_info(get_type_name(), "MUNEEB :: Driving Idle", UVM_HIGH);
  i3c_controller_drv_bfm_h.drive_idle_state();
  `uvm_info(get_type_name(), "MUNEEB :: Drove Idle", UVM_HIGH);

  forever begin
    i3c_transfer_bits_s struct_packet;
    i3c_transfer_cfg_s struct_cfg;

    `uvm_info("DEBUG", "Inside i3c_controller_driver_proxy", UVM_HIGH);

    i3c_controller_drv_bfm_h.wait_for_idle_state();

    seq_item_port.get_next_item(req);

    `uvm_info(get_type_name(), $sformatf("Received req\n%s",req.sprint()), UVM_HIGH)
    i3c_controller_seq_item_converter::from_class(req, struct_packet);
    `uvm_info(get_type_name(), $sformatf("Converted req struct\n%p",struct_packet), UVM_HIGH)
    i3c_controller_cfg_converter::from_class(i3c_controller_agent_cfg_h, struct_cfg);

    drive_to_bfm(struct_packet,struct_cfg);
 
    i3c_controller_seq_item_converter::to_class(struct_packet,req);
    `uvm_info(get_type_name(), $sformatf("After :: Received req\n%s",req.sprint()), UVM_HIGH)

    seq_item_port.item_done();
  end
endtask : run_phase

task i3c_controller_driver_proxy::drive_to_bfm(inout i3c_transfer_bits_s packet, 
                                            input  i3c_transfer_cfg_s packet1);
  `uvm_info("DEBUG", "Inside drive to bfm", UVM_NONE);
  i3c_controller_drv_bfm_h.drive_data(packet,packet1); 
  `uvm_info(get_type_name(),$sformatf("AFTER STRUCT PACKET : , \n %p",packet1),UVM_LOW);
endtask: drive_to_bfm

`endif
