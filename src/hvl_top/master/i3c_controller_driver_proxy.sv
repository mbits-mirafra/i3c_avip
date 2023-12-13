`ifndef I3C_CONTROLLER_DRIVER_PROXY_INCLUDED_
`define I3C_CONTROLLER_DRIVER_PROXY_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: i3c_controller_driver_proxy
// <Description_here>
//--------------------------------------------------------------------------------------------
class i3c_controller_driver_proxy extends uvm_driver#(i3c_controller_tx);
  `uvm_component_utils(i3c_controller_driver_proxy)
 
 // GopalS:  i3c_controller_tx tx;

 // GopalS:  i3c_controller_agent_config i3c_controller_agent_cfg_h;
  
  virtual i3c_controller_driver_bfm i3c_controller_drv_bfm_h;
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "i3c_controller_driver_proxy", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  // GopalS: extern virtual task drive_to_bfm(inout i3c_transfer_bits_s packet, 
  // GopalS:                                  input i3c_transfer_cfg_s packet1);

endclass : i3c_controller_driver_proxy

//---------------------------------------i3c_controller_drv_proxy_h i3c_controller_drv_proxy_h -----------------------------------------------------
// Construct: new
//
// Parameters:
//  name - i3c_controller_driver_proxy
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function i3c_controller_driver_proxy::new(string name = "i3c_controller_driver_proxy",
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
function void i3c_controller_driver_proxy::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(virtual i3c_controller_driver_bfm)::get(this,"","i3c_controller_driver_bfm",i3c_controller_drv_bfm_h))
   `uvm_fatal("FATAL_MDP_CANNOT_GET_controller_DRIVER_BFM","cannot get () i3c_controller_driver_bfm from uvm_config_db")
endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Function: connect_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------

 function void i3c_controller_driver_proxy::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
 endfunction : connect_phase

//--------------------------------------------------------------------------------------------
// Function: end_of_elaboration_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void i3c_controller_driver_proxy::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  i3c_controller_drv_bfm_h.i3c_controller_drv_proxy_h = this;
endfunction  : end_of_elaboration_phase

//--------------------------------------------------------------------------------------------
// Task: run_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
task i3c_controller_driver_proxy::run_phase(uvm_phase phase);
  super.run_phase(phase);

  `uvm_info(get_type_name(), "Running the Driver", UVM_NONE)

  `uvm_info(get_type_name(), "MUNEEB :: Waiting for reset", UVM_NONE);
  //i3c_controller_drv_bfm_h.wait_for_reset();
  `uvm_info(get_type_name(), "MUNEEB :: Reset detected", UVM_NONE);

  forever begin
    seq_item_port.get_next_item(req);
    seq_item_port.item_done();
  end


// GopalS:   `uvm_info(get_type_name(), "MUNEEB :: Waiting for reset", UVM_NONE);
// GopalS:   i3c_controller_drv_bfm_h.wait_for_reset();
// GopalS:   `uvm_info(get_type_name(), "MUNEEB :: Reset detected", UVM_NONE);
// GopalS: 
// GopalS:   `uvm_info(get_type_name(), "MUNEEB :: Driving Idle", UVM_NONE);
// GopalS:   i3c_controller_drv_bfm_h.drive_idle_state();
// GopalS:   `uvm_info(get_type_name(), "MUNEEB :: Drove Idle", UVM_NONE);
// GopalS: 
// GopalS:   forever begin
// GopalS:     i3c_transfer_bits_s struct_packet;
// GopalS:     i3c_transfer_cfg_s struct_cfg;
// GopalS:   
// GopalS:     `uvm_info("DEBUG", "Inside i3c_controller_driver_proxy", UVM_NONE);
// GopalS: 
// GopalS:     i3c_controller_drv_bfm_h.wait_for_idle_state();
// GopalS: 
// GopalS:     seq_item_port.get_next_item(req);
// GopalS:     
// GopalS:     `uvm_info(get_type_name(), $sformatf("Received req\n%s",req.sprint()), UVM_HIGH)
// GopalS:     i3c_controller_seq_item_converter::from_class(req, struct_packet);
// GopalS:     `uvm_info(get_type_name(), $sformatf("Converted req struct\n%p",struct_packet), UVM_HIGH)
// GopalS: 
// GopalS:     i3c_controller_cfg_converter::from_class(i3c_controller_agent_cfg_h, struct_cfg);
// GopalS: 
// GopalS:     drive_to_bfm(struct_packet,struct_cfg);
// GopalS: 
// GopalS:     i3c_controller_seq_item_converter::to_class(struct_packet,req);
// GopalS:     `uvm_info(get_type_name(), $sformatf("After :: Received req\n%s",req.sprint()), UVM_HIGH)
// GopalS:     
// GopalS:    seq_item_port.item_done();
// GopalS: 
// GopalS:   end
endtask : run_phase
//
// GopalS:  task i3c_controller_driver_proxy::drive_to_bfm(inout i3c_transfer_bits_s packet, 
// GopalS:                                            input  i3c_transfer_cfg_s packet1);
// GopalS:    `uvm_info("DEBUG", "Inside drive to bfm", UVM_NONE);
// GopalS:    i3c_controller_drv_bfm_h.drive_data(packet,packet1); 
// GopalS:    `uvm_info(get_type_name(),$sformatf("AFTER STRUCT PACKET : , \n %p",packet1),UVM_LOW);
// GopalS:  endtask: drive_to_bfm

`endif
