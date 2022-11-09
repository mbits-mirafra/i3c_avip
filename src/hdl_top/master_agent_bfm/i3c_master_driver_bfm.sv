`ifndef I3C_MASTER_DRIVER_BFM_INCLUDED_
`define I3C_MASTER_DRIVER_BFM_INCLUDED_

//--------------------------------------------------------------------------------------------
//Interface : i3c_master_driver_bfm
//It connects with the HVL driver_proxy for driving the stimulus
//--------------------------------------------------------------------------------------------
import i3c_globals_pkg::*;

interface i3c_master_driver_bfm(input pclk, 
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
  import i3c_master_pkg::i3c_master_driver_proxy;

  //Variable : master_driver_proxy_h
  //Creating the handle for proxy driver
  i3c_master_driver_proxy i3c_master_drv_proxy_h;
  
  // Variable: name
  // Stores the name for this module
  string name = "I3C_MASTER_DRIVER_BFM";

 initial begin
   $display(name);
 end

  //-------------------------------------------------------
  // Task: wait_for_reset
  // Waiting for system reset to be active
  //-------------------------------------------------------
  task wait_for_reset();
    @(negedge areset);
    `uvm_info(name, $sformatf("System reset detected"), UVM_HIGH);
    @(posedge areset);
    `uvm_info(name, $sformatf("System reset deactivated"), UVM_HIGH);
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

  //-------------------------------------------------------
  // Task: stop
  // Send the stop signal (SCL=1 and SDA -> (Low to High))
  //-------------------------------------------------------
 task stop();
  @(posedge pclk);
    sda_oen <= TRISTATE_BUF_ON;
    sda_o   <= 0;
    state = STOP;

  @(posedge pclk);
    sda_oen <= TRISTATE_BUF_OFF;
    sda_o   <= 1;
    
  // Checking for IDLE state
  @(posedge pclk);
    if(scl_i && sda_i) begin
      state = IDLE;
  end
  endtask

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

  int idle_time_i; // local variable for idle time
  int tbuf_i;      // Idle time from configure
  bit [SLAVE_ADDRESS_WIDTH:0] address_7b;
  bit rw_b;
  bit [7:0] wr_data_8b;
  
  data_t  = p_data_packet;
  cfg_pkt = p_cfg_pkt;
  state   = IDLE;
  `uvm_info(name, $sformatf("Starting the drive data method"), UVM_MEDIUM);
  while(1) begin
    if(areset == 0) begin // if active low reset is detected 
      state       = IDLE;
      sda_o       = 1;
      scl_o       = 1;
      idle_time_i = 0;
      tbuf_i      = 0;
      @(posedge areset);
    end else begin // else start the fsm
      case(state)
        IDLE: begin
          tbuf_i = BUS_IDLE_TIME;
          if(idle_time_i >= tbuf_i) begin // If idle time is reached move to FREE state
            state = FREE;
            idle_time_i = 0;
            `uvm_info(name, $sformatf("Idle period is completed moving to FREE state"), UVM_MEDIUM);
          end else begin // else wait for idle time count
            idle_time_i ++;
            @(posedge pclk);
          `uvm_info("DEBUG", $sformatf("Waiting for idle count %0h",idle_time_i), UVM_NONE)
          end
        end
        FREE:begin
         tbuf_i = BUS_FREE_TIME;
          if(idle_time_i >= tbuf_i) begin // If idle time is reached move to FREE state
            state = START;
            idle_time_i = 0;
            `uvm_info(name, $sformatf("FREE period is completed moving to START state"), UVM_MEDIUM);
          end else begin // else wait for idle time count
            idle_time_i ++;
            @(posedge pclk);
          end
        end
        START:begin
          drive_start();
          state = ADDRESS;
        end
        ADDRESS:begin
          {rw_b,address_7b} = {data_t.read_write,data_t.slave_address};
          drive_byte({rw_b,address_7b});
          `uvm_info("DEBUG", $sformatf("Address is sent, address = %0h, read_write = %0b",address_7b, rw_b), UVM_NONE)
          sample_ack(ack);
          if(ack == 0) begin
            if(rw_b == WRITE) begin
              state = WRITE_DATA;
              `uvm_info(name, $sformatf("moving to WRITE_DATA state"), UVM_MEDIUM);
            end else begin
              state = READ_DATA;
              `uvm_info(name, $sformatf("moving to READ_DATA state"), UVM_MEDIUM);
            end
          end else begin
            `uvm_info(name, $sformatf("Received NACK, moving to STOP state"), UVM_MEDIUM);
            state = STOP;
          end
        end
        WRITE_DATA:begin
          for(int i=0; i<data_t.size;i++) begin
            wr_data_8b = data_t.wr_data[i];
            drive_byte(wr_data_8b);
            `uvm_info("DEBUG", $sformatf("Driving Write data %0h",wr_data_8b), UVM_NONE)
            sample_ack(ack);
            if(ack == 0) begin
              state = WRITE_DATA;
            end else begin
              state = STOP;
              `uvm_info(name, $sformatf("Received NACK, moving to STOP state"), UVM_MEDIUM);
            end
          end
          state = STOP;
          `uvm_info(name, $sformatf("moving to STOP state"), UVM_MEDIUM);
        end
        STOP:begin
          stop();
          `uvm_info(name, $sformatf("moving to IDLE state from STOP state"), UVM_MEDIUM);
          state = IDLE;
        end
      endcase
    end
  end
  
 endtask: drive_data


  // task for driving the sda_oen as high and sda as low
   task drive_start();
     @(posedge pclk);
     sda_oen <= TRISTATE_BUF_ON;
     sda_o   <= 0;
     `uvm_info(name, $sformatf("Driving start condition"), UVM_MEDIUM);
   endtask :drive_start

  // task for driving the address byte and data byte
   task drive_byte(input bit[7:0] p_data_8b);
     int bit_no;

     `uvm_info("DEBUG", $sformatf("Driving byte = %0b",p_data_8b), UVM_NONE)
     for(int k=0;k <= 7; k++) begin
       scl_tristate_buf_on();
       sda_oen <= TRISTATE_BUF_ON;
       sda_o   <= p_data_8b[k];
       scl_tristate_buf_off();
     end
      
   endtask :drive_byte


  // task for sampling the Acknowledge
   task sample_ack(output bit p_ack);
     scl_tristate_buf_on();
     p_ack = sda_i;
     scl_tristate_buf_off();
     `uvm_info(name, $sformatf("Sampled ACK value %0b",p_ack), UVM_MEDIUM);
   endtask :sample_ack

endinterface : i3c_master_driver_bfm
`endif
