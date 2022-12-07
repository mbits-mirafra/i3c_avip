`ifndef I3C_SLAVE_DRIVER_BFM_INCLUDED_
`define I3C_SLAVE_DRIVER_BFM_INCLUDED_
//--------------------------------------------------------------------------------------------
// Class    :i3c_slave_driver_bfm
// Description  : Connects with the HVL driver_proxy for driving the stimulus
//--------------------------------------------------------------------------------------------
import i3c_globals_pkg::*;
interface i3c_slave_driver_bfm #(parameter string NAME = "I3C_SLAVE_DRIVER_BFM")
                               (input pclk, 
                               input areset,
                               input scl_i,
                               output reg scl_o,
                               output reg scl_oen,
                               input sda_i,
                               output reg sda_o,
                               output reg sda_oen);
  
  i3c_fsm_state_e state;
  i3c_transfer_cfg_s cfg_pkt;

  int slave_id;

  string name;

  //-------------------------------------------------------
  // Importing UVM Package 
  //-------------------------------------------------------
  import uvm_pkg::*;
  `include "uvm_macros.svh" 
  
  //-------------------------------------------------------
  // Importing I3C Global Package and Slave package
  //-------------------------------------------------------
  import i3c_slave_pkg::i3c_slave_driver_proxy;
  
  //Variable : slave_driver_proxy_h
  //Creating the handle for proxy driver
  i3c_slave_driver_proxy i3c_slave_drv_proxy_h;
  
  
  initial begin
    $display(name);
  end
  
  //-------------------------------------------------------
  // Task: wait_for_system_reset
  // Waiting for system reset to be active
  //-------------------------------------------------------
   task wait_for_system_reset();
     `uvm_info("DEBUG", $sformatf("slave_id = %0d", slave_id), UVM_NONE); 
     name = {NAME, "_", $sformatf("%0d",slave_id)};

     @(negedge areset);
     `uvm_info(name, $sformatf("System reset detected"), UVM_HIGH);
     @(posedge areset);
     `uvm_info(name , $sformatf("System reset deactivated"), UVM_HIGH);
   endtask: wait_for_system_reset

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
  
  //-------------------------------------------------------
  // Task: detect_start
  // Detects the START condition over I3C bus
  //-------------------------------------------------------
  task detect_start();
    // 2bit shift register to check the edge on sda and stability on scl
    bit [1:0] scl_local;
    bit [1:0] sda_local;

    // Detect the edge on scl
    do begin
      @(negedge pclk);
      scl_local = {scl_local[0], scl_i};
      sda_local = {sda_local[0], sda_i};
    end while(!(sda_local == NEGEDGE && scl_local == 2'b11) );
    state = START;
    `uvm_info(name, $sformatf("Start condition is detected"), UVM_HIGH);
  endtask: detect_start
  
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
    `uvm_info("SLAVE_DRIVER_BFM", $sformatf("scl %s detected", scl_edge_value.name()), UVM_HIGH);
  
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
    `uvm_info("SLAVE_DRIVER_BFM", $sformatf("scl %s detected", scl_edge_value.name()), UVM_HIGH);
  
  endtask: detect_negedge_scl
  
  //--------------------------------------------------------------------------------------------
  // Task: sample_slave_address
  // Samples the slave address from the I3C bus 
  //
  // Parameters:
  //  address - The slave address value (7bit or 10bit value)
  //
  // Returns:
  //  ack - Returns positive ack when the address matches with its slave address, otherwise 
  //  returns negative ack
  //--------------------------------------------------------------------------------------------
  task sample_slave_address(input i3c_transfer_cfg_s cfg_pkt, output acknowledge_e ack, output read_write_e rd_wr);
    bit [7:0] local_addr;

    state = ADDRESS;
    for(int k=0;k <= 7; k++) begin
      //for(int i=0, bit_no=0; i<REGISTER_ADDRESS_WIDTH; i++) begin 
      //  // Logic for MSB first or LSB first 
      //  bit_no = cfg_pkt.msb_first ? ((REGISTER_ADDRESS_WIDTH - 1) - i) : i;
      detect_posedge_scl();
      local_addr[k] = sda_i;
    end

    `uvm_info(name, $sformatf("DEBUG :: Value of local_addr = %0x", local_addr[6:0]), UVM_NONE); 
    `uvm_info(name, $sformatf("DEBUG :: Value of slave_address = %0x", cfg_pkt.slave_address), UVM_NONE); 
   
    // Check if the sampled address belongs to this slave
    if(local_addr[6:0] != cfg_pkt.slave_address) begin
      ack = NEG_ACK;
    end
    else begin
      ack = POS_ACK;
    end
 
    if(local_addr[7] == 1'b0) begin
      rd_wr = WRITE;
    end else begin
      rd_wr = READ;
    end
    // Driving the ACK for slave address
    detect_negedge_scl();
    drive_sda(ack); 
    state = SLAVE_ADDR_ACK;

  endtask: sample_slave_address

  //--------------------------------------------------------------------------------------------
  // Task: drive_sda 
  // Drive the logic sda value as '0' or '1' over the I3C inteerface using the tristate buffers
  //--------------------------------------------------------------------------------------------
  task drive_sda(input bit value);
    sda_oen <= value ? TRISTATE_BUF_OFF : TRISTATE_BUF_ON;
    sda_o   <= value;
    @(posedge pclk);
    scl_oen <= TRISTATE_BUF_OFF;
    scl_o   <= 1;

  endtask: drive_sda


  //--------------------------------------------------------------------------------------------
  // Task: start_sim 
  // Drive the logic sda value as '0' or '1' over the I3C inteerface using the tristate buffers
  //--------------------------------------------------------------------------------------------
  task start_sim(input i3c_transfer_cfg_s cfg_pkt);

    acknowledge_e ack;
    read_write_e rd_wr;
    bit[7:0] rdata;

    //wait for the statrt condition
    detect_start();

    sample_slave_address(cfg_pkt, ack, rd_wr);
    `uvm_info("DEBUG", $sformatf("Slave address %0x :: Received ACK %0s", 
                                       cfg_pkt.slave_address, ack.name()), UVM_NONE); 

    // Proceed further only if the I3C packet is addressed to this slave                                       
    if(ack == POS_ACK) begin
      if(rd_wr == WRITE) begin
        sample_write_data(cfg_pkt, ack);
      end else begin
        rdata = cfg_pkt.slave_memory[cfg_pkt.slave_address];
        drive_read_data(rdata);
        sample_ack(ack);
      end
    end else begin
      detect_stop();
    end
    
  endtask: start_sim

  task sample_write_data(input i3c_transfer_cfg_s cfg_pkt, output acknowledge_e ack);
    bit [7:0] wdata;

    state = SAMPLE_WRITE_DATA;
    for(int k=0;k < DATA_WIDTH; k++) begin
      detect_posedge_scl();
      wdata[k] = sda_i;
    end

    `uvm_info(name, $sformatf("DEBUG :: Value of sampled write data = %0x", wdata[7:0]), UVM_NONE); 
   
    ack = POS_ACK;

    // Driving the ACK for slave address
    detect_negedge_scl();
    drive_sda(ack); 
    state = SLAVE_ADDR_ACK;
    detect_posedge_scl();

  endtask: sample_write_data


  // task for driving the address byte and data byte
   task drive_read_data(input bit[7:0] p_data_8b);
     int bit_no;

     `uvm_info("DEBUG", $sformatf("Driving byte = %0b",p_data_8b), UVM_NONE)
     for(int k=0;k < DATA_WIDTH; k++) begin
       scl_tristate_buf_on();
       sda_oen <= TRISTATE_BUF_ON;
       sda_o   <= p_data_8b[k];
       scl_tristate_buf_off();
     end
      
   endtask :drive_read_data


  // task for sampling the Acknowledge
   task sample_ack(output acknowledge_e p_ack);
     bit ack;
     scl_tristate_buf_on();

     sda_oen <= TRISTATE_BUF_OFF;
     sda_o   <= 1;
     state    = SLAVE_ADDR_ACK;
     ack = sda_i;

     if(ack == 1'b0) begin
       p_ack = POS_ACK;
     end else begin
       p_ack = NEG_ACK;
     end
     scl_tristate_buf_off();
     `uvm_info(name, $sformatf("Sampled ACK value %0b",ack), UVM_MEDIUM);
   endtask :sample_ack

  
  //-------------------------------------------------------
  // Task: detect_stop
  // Detects the STOP condition over I3C bus
  //-------------------------------------------------------
  task detect_stop();
    // 2bit shift register to check the edge on sda and stability on scl
    bit [1:0] scl_local;
    bit [1:0] sda_local;

    // Detect the edge on scl
    do begin
      @(negedge pclk);
      scl_local = {scl_local[0], scl_i};
      sda_local = {sda_local[0], sda_i};
    end while(!(sda_local == POSEDGE && scl_local == 2'b11) );
    state = STOP;
    `uvm_info(name, $sformatf("Stop condition is detected"), UVM_HIGH);
  endtask: detect_stop
  

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


`endif
endinterface : i3c_slave_driver_bfm
