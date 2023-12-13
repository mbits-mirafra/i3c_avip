`ifndef I3C_CONTROLLER_DRIVER_BFM_INCLUDED_
`define I3C_CONTROLLER_DRIVER_BFM_INCLUDED_

//--------------------------------------------------------------------------------------------
//Interface : i3c_controller_driver_bfm
//It connects with the HVL driver_proxy for driving the stimulus
//--------------------------------------------------------------------------------------------
import i3c_globals_pkg::*;

interface i3c_controller_driver_bfm(input pclk, 
                                input areset,
                                input scl_i,
                                output reg scl_o,
                                output reg scl_oen,
                                input sda_i,
                                output reg sda_o,
                                output reg sda_oen
                                //Illegal inout port connection
                                //inout scl,
                                //inout sda);
                              );
  i3c_fsm_state_e state;
  i3c_transfer_bits_s data_t;
  i3c_transfer_cfg_s cfg_pkt;
  bit ack;
  //-------------------------------------------------------
  // Importing UVM Package 
  //-------------------------------------------------------
  import uvm_pkg::*;
  `include "uvm_macros.svh" 
  
  //-------------------------------------------------------
  // Importing I3C Global Package and Slave package
  //-------------------------------------------------------
 // GopalS:  import i3c_controller_pkg::i3c_controller_driver_proxy;

  //Variable : controller_driver_proxy_h
  //Creating the handle for proxy driver
  i3c_controller_driver_proxy i3c_controller_drv_proxy_h;
  
  // Variable: name
  // Stores the name for this module
  string name = "I3C_controller_DRIVER_BFM";

 initial begin
   $display(name);
 end

  //-------------------------------------------------------
  // Task: wait_for_reset
  // Waiting for system reset to be active
  //-------------------------------------------------------
  task wait_for_reset();
    @(negedge areset);
 // GopalS:    `uvm_info(name, $sformatf("System reset detected"), UVM_HIGH);
 // GopalS:    @(posedge areset);
 // GopalS:    `uvm_info(name, $sformatf("System reset deactivated"), UVM_HIGH);
  endtask: wait_for_reset

  //-------------------------------------------------------
  // Task: drive_idle_state
  // Used for driving SCL=1 and SDA=1
  // TODO(mshariff): Put more comments for logic pf SCL and SDA
  //-------------------------------------------------------
  task drive_idle_state();
    @(posedge pclk);

    scl_oen <= TRISTATE_BUF_OFF;
    scl_o   <= 1;

    sda_oen <= TRISTATE_BUF_OFF;
    sda_o   <= 1;

    state=IDLE;
    `uvm_info(name, $sformatf("Successfully drove the IDLE state"), UVM_HIGH);
  endtask: drive_idle_state

  //-------------------------------------------------------
  // Task: wait_for_idle_state
  // Waits for I3C bus to be in IDLe state (SCL=1 and SDA=1)
  //-------------------------------------------------------
  task wait_for_idle_state();
    @(posedge pclk);

    while(scl_i!=1 && sda_i!=1) begin
      @(posedge pclk);
    end
      
    `uvm_info(name, $sformatf("I3C bus is free state detected"), UVM_HIGH);
  endtask: wait_for_idle_state

  // task for driving the sda_oen as high and sda as low
   task sda_tristate_buf_on();
    @(posedge pclk);
    sda_oen <= TRISTATE_BUF_ON;
    sda_o   <= 0;
   endtask

  // task for driving the scl_oen as high and scl as low
  task scl_tristate_buf_on();
    @(posedge pclk);
    scl_oen <= TRISTATE_BUF_ON;
    scl_o   <= 0;
  endtask

  // task for driving the scl_oen as high and scl as low
  task scl_tristate_buf_off();
    @(posedge pclk);
    scl_oen <= TRISTATE_BUF_OFF;
    scl_o   <= 1;
  endtask

 //-------------------------------------------------------
 // Task: drive_data
 //-------------------------------------------------------
 task drive_data(inout i3c_transfer_bits_s p_data_packet, 
                 input i3c_transfer_cfg_s p_cfg_pkt); 
// GopalS: 
// GopalS:   int idle_time_i; // local variable for idle time
// GopalS:   int tbuf_i;      // Idle time from configure
// GopalS:   bit [TARGET_ADDRESS_WIDTH -1:0] address_7b;
// GopalS:   bit rw_b;
// GopalS:   bit [7:0] writeData_8b;
// GopalS:   
// GopalS:   `uvm_info(name, $sformatf("Starting the drive data method"), UVM_MEDIUM);
// GopalS:   data_t  = p_data_packet;
// GopalS:   cfg_pkt = p_cfg_pkt;
// GopalS:   state = START;
// GopalS: 
// GopalS:   //Driving Start Condition
// GopalS:   drive_start();
// GopalS:   state = ADDRESS;
// GopalS: 
// GopalS:   //Driving Address byte
// GopalS:   {rw_b,address_7b} = {data_t.operation,data_t.targetAddress};
// GopalS:   drive_byte({rw_b,address_7b});
// GopalS:   `uvm_info("DEBUG", $sformatf("Address is sent, address = %0h, operation = %0b",address_7b, rw_b), UVM_NONE)
// GopalS:   sample_ack(ack);
// GopalS:   if(ack == 1'b1)begin
// GopalS:     stop();
// GopalS:     `uvm_info("SLAVE_ADDR_ACK", $sformatf("Received ACK as 1 and stop condition is triggered"), UVM_HIGH);
// GopalS:   end else begin
// GopalS:     `uvm_info("SLAVE_ADDR_ACK", $sformatf("Received ACK as 0"), UVM_HIGH);
// GopalS:     if(rw_b == 0) begin
// GopalS:       state = WRITE_DATA;
// GopalS:       for(int i=0; i<data_t.size;i++) begin
// GopalS:         writeData_8b = data_t.writeData[i];
// GopalS:         drive_byte(writeData_8b);
// GopalS:         `uvm_info("DEBUG", $sformatf("Driving Write data %0h",writeData_8b), UVM_NONE)
// GopalS:       end
// GopalS:       sample_ack(ack);
// GopalS:     end else begin
// GopalS:       state = READ_DATA;
// GopalS:       `uvm_info("READ_DATA", $sformatf("Moving to READ_DATA state"), UVM_HIGH);
// GopalS:       sample_read_data(cfg_pkt, ack);
// GopalS:     end
// GopalS:       if(ack == 1'b0) begin
// GopalS:         state = STOP;
// GopalS:         stop();
// GopalS:         `uvm_info(name, $sformatf("Received ACK, moving to STOP state"), UVM_MEDIUM);
// GopalS:       end else begin
// GopalS:         stop();
// GopalS:         `uvm_info(name, $sformatf("Received NACK, moving to STOP state"), UVM_MEDIUM);
// GopalS:       end
// GopalS: 
// GopalS:   end

 endtask: drive_data


  // task for driving the sda_oen as high and sda as low
   task drive_start();
     @(posedge pclk);
     scl_oen <= TRISTATE_BUF_OFF;
     scl_o   <= 1;
     sda_oen <= TRISTATE_BUF_OFF;
     sda_o   <= 1;

     @(posedge pclk);
     sda_oen <= TRISTATE_BUF_ON;
     sda_o   <= 0;

     `uvm_info(name, $sformatf("Driving start condition"), UVM_MEDIUM);
   endtask :drive_start

  // task for driving the address byte and data byte
   task drive_byte(input bit[7:0] p_data_8b);
     int bit_no;

     `uvm_info("DEBUG", $sformatf("Driving byte = %0b",p_data_8b), UVM_NONE)
     for(int k=0;k < DATA_WIDTH; k++) begin
       scl_tristate_buf_on();
       sda_oen <= TRISTATE_BUF_ON;
       sda_o   <= p_data_8b[k];
       scl_tristate_buf_off();
     end
      
   endtask :drive_byte


  // task for sampling the Acknowledge
   task sample_ack(output bit p_ack);
     @(posedge pclk);
     scl_oen <= TRISTATE_BUF_ON;
     scl_o   <= 0;

     sda_oen <= TRISTATE_BUF_OFF;
     sda_o   <= 1;
     state    = TARGET_ADDR_ACK;

     @(posedge pclk);
     // Sample the ACK from the I2C bus
     @(posedge pclk);
     scl_oen <= TRISTATE_BUF_OFF;
     scl_o   <= 1;
     p_ack    = sda_i;

     `uvm_info(name, $sformatf("Sampled ACK value %0b",p_ack), UVM_MEDIUM);
   endtask :sample_ack

 
  task stop();
   // Complete the SCL clock
   state = STOP;
   @(posedge pclk);
   scl_oen <= TRISTATE_BUF_OFF;
   scl_o   <= 1;
   sda_oen <= TRISTATE_BUF_ON;
   sda_o   <= 0;

   @(posedge pclk);
   sda_oen <= TRISTATE_BUF_OFF;
   sda_o   <= 1;

     
   // Checking for IDLE state
   @(posedge pclk);
   if(scl_i && sda_i) begin
     state = IDLE;
   end
  endtask


  task sample_read_data(input i3c_transfer_cfg_s cfg_pkt, output bit ack);
    bit [7:0] rdata;

    for(int k=0;k < DATA_WIDTH; k++) begin
      detect_posedge_scl();
      rdata[k] = sda_i;
      sda_oen <= TRISTATE_BUF_OFF;
      sda_o   <= 1;
    end

    `uvm_info(name, $sformatf("DEBUG :: Value of sampled read data = %0x", rdata[7:0]), UVM_NONE); 
   
    ack = 1'b0;

    // Driving the ACK for slave address
    detect_negedge_scl();
    drive_sda(ack); 
    state = TARGET_ADDR_ACK;
    detect_posedge_scl();

  endtask: sample_read_data


  //--------------------------------------------------------------------------------------------
  // Task: drive_sda 
  // Drive the logic sda value as '0' or '1' over the I3C inteerface using the tristate buffers
  //--------------------------------------------------------------------------------------------
  task drive_sda(input bit value);
    sda_oen <= value ? TRISTATE_BUF_OFF : TRISTATE_BUF_ON;
    sda_o   <= value;
  endtask: drive_sda

  
  //-------------------------------------------------------
  // Task: detect_posedge_scl
  // Detects the edge on scl with regards to pclk
  //-------------------------------------------------------
  task detect_posedge_scl();
    // 2bit shift register to check the edge on scl
    bit [1:0] scl_local;
    edge_detect_e scl_edge_value;

    // default value of scl_local is logic 1
    scl_local = 2'b11;

    // Detect the edge on scl
    do begin
      @(negedge pclk);
      scl_local = {scl_local[0], scl_i};
    end while(!(scl_local == POSEDGE));

    scl_edge_value = edge_detect_e'(scl_local);
    `uvm_info("controller_DRIVER_BFM", $sformatf("scl %s detected", scl_edge_value.name()), UVM_HIGH);
  
  endtask: detect_posedge_scl
  
  
  //-------------------------------------------------------
  // Task: detect_negedge_scl
  // Detects the negative edge on scl with regards to pclk
  //-------------------------------------------------------
  task detect_negedge_scl();
    // 2bit shift register to check the edge on scl
    bit [1:0] scl_local;
    edge_detect_e scl_edge_value;

    // default value of scl_local is logic 1
    scl_local = 2'b11;

    // Detect the edge on scl
    do begin

      @(negedge pclk);
      scl_local = {scl_local[0], scl_i};

    end while(!(scl_local == NEGEDGE));

    scl_edge_value = edge_detect_e'(scl_local);
    `uvm_info("controller_DRIVER_BFM", $sformatf("scl %s detected", scl_edge_value.name()), UVM_HIGH);
  
  endtask: detect_negedge_scl
  
endinterface : i3c_controller_driver_bfm
`endif
