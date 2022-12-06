`ifndef I3C_SLAVE_DRIVER_PROXY_INCLUDED_
`define I3C_SLAVE_DRIVER_PROXY_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: i3c_slave_driver_proxy
// <Description_here>
//--------------------------------------------------------------------------------------------
class i3c_slave_driver_proxy extends uvm_driver#(i3c_slave_tx);
  `uvm_component_utils(i3c_slave_driver_proxy)
  
  // Variable: i3c_slave_drv_bfm_h;
  // Handle for slave driver bfm
  virtual i3c_slave_driver_bfm i3c_slave_drv_bfm_h;

  // Variable: i3c_slave_agent_cfg_h;
  // Handle for slave agent configuration
  i3c_slave_agent_config i3c_slave_agent_cfg_h;
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "i3c_slave_driver_proxy", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
//  extern virtual task drive_to_bfm(inout i3c_transfer_bits_s packet, 
 //                                  input i3c_transfer_cfg_s struct_cfg);
  //extern virtual function void reset_detected(); 

endclass : i3c_slave_driver_proxy

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - i3c_slave_driver_proxy
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function i3c_slave_driver_proxy::new(string name = "i3c_slave_driver_proxy",
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
function void i3c_slave_driver_proxy::build_phase(uvm_phase phase);
  super.build_phase(phase);

endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Function: end_of_elaboration_phase
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void i3c_slave_driver_proxy::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);

  if(!uvm_config_db #(virtual i3c_slave_driver_bfm)::get(this,"",$sformatf("i3c_slave_driver_bfm_%0d",i3c_slave_agent_cfg_h.slave_id),i3c_slave_drv_bfm_h))begin
    `uvm_fatal("FATAL_SDP_CANNOT_GET_SLAVE_DRIVER_BFM","cannot get i3c_slave_driver_bfm from the uvm_config_db. Have you set it?");
  end

  i3c_slave_drv_bfm_h.i3c_slave_drv_proxy_h = this;
  i3c_slave_drv_bfm_h.slave_id = i3c_slave_agent_cfg_h.slave_id;
endfunction  : end_of_elaboration_phase

//--------------------------------------------------------------------------------------------
// Task: run_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
task i3c_slave_driver_proxy::run_phase(uvm_phase phase);

  super.run_phase(phase);
  
  // Wait for system reset
  i3c_slave_drv_bfm_h.wait_for_system_reset();

  // Wait for the IDLE state of i3c interface
  i3c_slave_drv_bfm_h.wait_for_idle_state();

  // Driving logic
  forever begin
    i3c_transfer_bits_s struct_packet;
    i3c_transfer_cfg_s struct_cfg;
    acknowledge_e ack;
    read_write_e rd_wr;

    // Converting the config object to struct
    i3c_slave_cfg_converter::from_class(i3c_slave_agent_cfg_h, struct_cfg); 
    `uvm_info("DEBUG_MSHA", $sformatf("CFG :: struct_cfg = %p",struct_cfg), UVM_NONE); 

    i3c_slave_drv_bfm_h.start_sim(struct_cfg);
    //wait for the statrt condition
    //i3c_slave_drv_bfm_h.detect_start()

    //// Sample the slave address from I3C bus
    //i3c_slave_drv_bfm_h.sample_slave_address(struct_cfg, ack, rd_wr);
    //`uvm_info("DEBUG_MUKUL", $sformatf("Slave address %0x :: Received ACK %0s", 
    //                                   struct_cfg.slave_address, ack.name()), UVM_NONE); 

    // Proceed further only if the I3C packet is addressed to this slave                                       
    //if(ack == POS_ACK) begin

    //  seq_item_port.get_next_item(req);
    //  `uvm_info(get_type_name(),$sformatf("Received packet from i3c slave sequencer : , \n %s",
    //                                      req.sprint()),UVM_HIGH)

    //  i3c_slave_seq_item_converter::from_class(req, struct_packet); 
    //  struct_packet.slave_address = struct_cfg.slave_address;
    //  struct_packet.read_write = rd_wr; 
    //  struct_packet.slave_addr_ack = ack;

    //  i3c_slave_drv_bfm_h.sample_reg_address(struct_packet, struct_cfg);

    //  i3c_slave_seq_item_converter::to_class(struct_packet, req);
    //  `uvm_info(get_type_name(),$sformatf("Received packet from SLAVE DRIVER BFM : , \n %s",
    //                                      req.sprint()),UVM_HIGH)

    //  seq_item_port.item_done();
    //end

  end
  
endtask : run_phase

`endif

