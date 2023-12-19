`ifndef I3C_TARGET_DRIVER_PROXY_INCLUDED_
`define I3C_TARGET_DRIVER_PROXY_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: i3c_target_driver_proxy
// <Description_here>
//--------------------------------------------------------------------------------------------
class i3c_target_driver_proxy extends uvm_driver#(i3c_target_tx);
  `uvm_component_utils(i3c_target_driver_proxy)
  
  // Variable: i3c_target_drv_bfm_h;
  // Handle for target driver bfm
  virtual i3c_target_driver_bfm i3c_target_drv_bfm_h;

  // Variable: i3c_target_agent_cfg_h;
  // Handle for target agent configuration
  i3c_target_agent_config i3c_target_agent_cfg_h;
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "i3c_target_driver_proxy", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
//  extern virtual task drive_to_bfm(inout i3c_transfer_bits_s packet, 
 //                                  input i3c_transfer_cfg_s struct_cfg);
  //extern virtual function void reset_detected(); 

endclass : i3c_target_driver_proxy

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - i3c_target_driver_proxy
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function i3c_target_driver_proxy::new(string name = "i3c_target_driver_proxy",
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
function void i3c_target_driver_proxy::build_phase(uvm_phase phase);
  super.build_phase(phase);

endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Function: end_of_elaboration_phase
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void i3c_target_driver_proxy::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);

  if(!uvm_config_db #(virtual i3c_target_driver_bfm)::get(this,"",$sformatf("i3c_target_driver_bfm_%0d",i3c_target_agent_cfg_h.target_id),i3c_target_drv_bfm_h))begin
    `uvm_fatal("FATAL_SDP_CANNOT_GET_target_DRIVER_BFM","cannot get i3c_target_driver_bfm from the uvm_config_db. Have you set it?");
  end

  i3c_target_drv_bfm_h.i3c_target_drv_proxy_h = this;
// GopalS:   i3c_target_drv_bfm_h.target_id = i3c_target_agent_cfg_h.target_id;
endfunction  : end_of_elaboration_phase

//--------------------------------------------------------------------------------------------
// Task: run_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
task i3c_target_driver_proxy::run_phase(uvm_phase phase);

  super.run_phase(phase);
  
  // Wait for system reset
  i3c_target_drv_bfm_h.wait_for_system_reset();

  // Leave the bus in idle state
  i3c_target_drv_bfm_h.drive_idle_state();

  // Driving logic
  forever begin
    i3c_transfer_bits_s struct_packet;
    i3c_transfer_cfg_s struct_cfg;
    acknowledge_e ack;
    operationType_e rd_wr;

    // Wait for the IDLE state of i3c interface
    i3c_target_drv_bfm_h.wait_for_idle_state();

    // Converting the config object to struct
    i3c_target_cfg_converter::from_class(i3c_target_agent_cfg_h, struct_cfg); 
    `uvm_info("DEBUG_MSHA", $sformatf("CFG :: struct_cfg = %p",struct_cfg), UVM_NONE); 

    i3c_target_drv_bfm_h.start_sim(struct_cfg);
    //wait for the statrt condition
    //i3c_target_drv_bfm_h.detect_start()

    //// Sample the target address from I3C bus
    //i3c_target_drv_bfm_h.sample_target_address(struct_cfg, ack, rd_wr);
    //`uvm_info("DEBUG_MUKUL", $sformatf("target address %0x :: Received ACK %0s", 
    //                                   struct_cfg.target_address, ack.name()), UVM_NONE); 

    // Proceed further only if the I3C packet is addressed to this target                                       
    //if(ack == POS_ACK) begin

    //  seq_item_port.get_next_item(req);
    //  `uvm_info(get_type_name(),$sformatf("Received packet from i3c target sequencer : , \n %s",
    //                                      req.sprint()),UVM_HIGH)

    //  i3c_target_seq_item_converter::from_class(req, struct_packet); 
    //  struct_packet.target_address = struct_cfg.target_address;
    //  struct_packet.read_write = rd_wr; 
    //  struct_packet.target_addr_ack = ack;

    //  i3c_target_drv_bfm_h.sample_reg_address(struct_packet, struct_cfg);

    //  i3c_target_seq_item_converter::to_class(struct_packet, req);
    //  `uvm_info(get_type_name(),$sformatf("Received packet from target DRIVER BFM : , \n %s",
    //                                      req.sprint()),UVM_HIGH)

    //  seq_item_port.item_done();
    //end

  end
  
endtask : run_phase

`endif

